//
//  AudioSwitch.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//  Adapted from https://github.com/deweller/switchaudio-osx/tree/20dafea1c8c1f1db73ee757587ede111e28167bc
//

import CoreServices
import CoreAudio
import Combine

enum DeviceType {
  case input
  case output
  case systemOutput
  
  var mSelector: UInt32 {
    switch self {
    case .input:
      return kAudioHardwarePropertyDefaultInputDevice
    case .output:
      return kAudioHardwarePropertyDefaultOutputDevice
    case .systemOutput:
      return kAudioHardwarePropertyDefaultSystemOutputDevice
    }
  }
}

class Device: Identifiable, Equatable, Hashable {
  static func == (lhs: Device, rhs: Device) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  let id: AudioObjectID
  init(id: AudioObjectID) {
    self.id = id
  }
  
  var name: String? {
    return read(property: kAudioDevicePropertyDeviceNameCFString, from: id, defaultValue: "" as CFString) as String?
  }
  
  var isOutput: Bool {
    sizeOf(property: kAudioDevicePropertyStreams, from: id, in: .output) != nil
  }
  var isInput: Bool {
    sizeOf(property: kAudioDevicePropertyStreams, from: id, in: .input) != nil
  }
  
  func activate(for type: DeviceType) {
    _ = set(property: type.mSelector, in: .global, to: id)
  }
}

extension Device {
  static func selected(for type: DeviceType) -> Device? {
    guard let id = read(property: type.mSelector, defaultValue: AudioDeviceID(kAudioDeviceUnknown)) else { return nil }
    return Device(id: id)
  }
  
  static func named(_ name: String) -> Device? {
    Device.all.first { $0.name == name }
  }
  
  static var all: [Device] {
    var length: UInt32 = sizeOf(property: kAudioHardwarePropertyDevices)!
    var err: OSStatus = 0
    let devices = [AudioDeviceID](unsafeUninitializedCapacity: Int(length)) { (ptr, len) in
      len = Int(length)
      var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: AudioObjectProperty.Scope.global.rawValue,
        mElement: kAudioObjectPropertyElementMaster
      )
      
      err = AudioObjectGetPropertyData(
        /* inObjectId */ AudioObjectID(kAudioObjectSystemObject),
        /* inAddress */ &address,
        /* inQualifierDataSize */ 0,
        /* inQualifierData */ nil,
        /* ioDataSize */ &length,
        /* outData */ ptr.baseAddress!
      )
    }
    if err != kAudioHardwareNoError {
      return []
    }
    return devices.map(Device.init(id:))
  }
  
  static var named: [Device] {
    all.filter { $0.name != nil }
  }
}

func read<Value>(
  property: AudioObjectPropertySelector,
  from object: AudioObjectID = AudioObjectID(kAudioObjectSystemObject),
  in scope: AudioObjectProperty.Scope = .global,
  defaultValue: Value
) -> Value? {
  var val = defaultValue
  var err: OSStatus!
  withUnsafeMutablePointer(to: &val) { ptr in
    var valueSize = UInt32(MemoryLayout<Value>.size)
    var address = AudioObjectPropertyAddress(
      mSelector: property,
      mScope: scope.rawValue,
      mElement: kAudioObjectPropertyElementMaster
    )

    err = AudioObjectGetPropertyData(
      /* inObjectId */ object,
      /* inAddress */ &address,
      /* inQualifierDataSize */ 0,
      /* inQualifierData */ nil,
      /* ioDataSize */ &valueSize,
      /* outData */ ptr
    )
  }
  if err != kAudioHardwareNoError {
    return nil
  }
  return val
}

func set<Value>(
  property: AudioObjectPropertySelector,
  from object: AudioObjectID = AudioObjectID(kAudioObjectSystemObject),
  in scope: AudioObjectProperty.Scope = .global,
  to value: Value
) -> Bool {
  var val = value
  var err: OSStatus!
  withUnsafeMutablePointer(to: &val) { ptr in
    let valueSize = UInt32(MemoryLayout<Value>.size)
    var address = AudioObjectPropertyAddress(
      mSelector: property,
      mScope: scope.rawValue,
      mElement: kAudioObjectPropertyElementMaster
    )
    
    err = AudioObjectSetPropertyData(
      /* inObjectId */ object,
      /* inAddress */ &address,
      /* inQualifierDataSize */ 0,
      /* inQualifierData */ nil,
      /* inDataSize */ valueSize,
      /* inData */ ptr
    )
  }
  return err == kAudioHardwareNoError
}

func sizeOf(
  property: AudioObjectPropertySelector,
  from object: AudioObjectID = AudioObjectID(kAudioObjectSystemObject),
  in scope: AudioObjectProperty.Scope = .global
) -> UInt32? {
  var dataSize: UInt32 = 0
  var err: OSStatus!
  var address = AudioObjectPropertyAddress(
    mSelector: property,
    mScope: scope.rawValue,
    mElement: kAudioObjectPropertyElementMaster
  )
  
  err = AudioObjectGetPropertyDataSize(
    /* inObjectID */ object,
    /* inAddress */ &address,
    /* inQualifierDataSize */ 0,
    /* inQualifierData */ nil,
    &dataSize
  )
  
  if err == kAudioHardwareNoError {
    return dataSize
  }
  return nil
}

enum AudioObjectProperty {
  enum Scope: AudioObjectPropertyScope {
    case wildcard
    
    case global
    case input
    case output
    case playThrough
    
    var rawValue: AudioObjectPropertyScope {
      switch self {
      case .wildcard: return kAudioObjectPropertyScopeWildcard
      case .global: return kAudioObjectPropertyScopeGlobal
      case .input: return kAudioObjectPropertyScopeInput
      case .output: return kAudioObjectPropertyScopeOutput
      case .playThrough: return kAudioObjectPropertyScopePlayThrough
      }
    }
  }
}

class AudioDeviceList: ObservableObject {
  @Published var devices: [Device]
  static var shared = AudioDeviceList()
  private var onChange: AudioHardwarePropertyListener
  init() {
    self.devices = Device.named
    self.onChange = { _ in noErr }
    self.onChange = { [weak self] id in
      DispatchQueue.main.async {
        self?.devices = Device.named
      }
      return noErr
    }
    myAudioHardwareAddPropertyListener(kAudioHardwarePropertyDevices, onChange)
  }
  deinit {
    myAudioHardwareRemovePropertyListener(kAudioHardwarePropertyDevices, onChange)
  }
}

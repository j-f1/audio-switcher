//
//  AudioSwitch.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//  Adapted from https://github.com/deweller/switchaudio-osx/tree/20dafea1c8c1f1db73ee757587ede111e28167bc
//

import CoreServices
import CoreAudio

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

class Device: Identifiable, Equatable {
    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.id == rhs.id
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

    static var all: [Device]? {
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
            return nil
        }
        return devices.map(Device.init(id:))
    }
}

func read<Data>(
    property: AudioObjectPropertySelector,
    from object: AudioObjectID = AudioObjectID(kAudioObjectSystemObject),
    in scope: AudioObjectProperty.Scope = .global,
    defaultValue: Data
) -> Data? {
    var val = defaultValue
    var err: OSStatus!
    withUnsafeMutablePointer(to: &val) { ptr in
        var dataSize = UInt32(MemoryLayout<Data>.size)
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
            /* ioDataSize */ &dataSize,
            /* outData */ ptr
        )
    }
    if err != kAudioHardwareNoError {
        return nil
    }
    return val
}

func set<Data>(
    property: AudioObjectPropertySelector,
    from object: AudioObjectID = AudioObjectID(kAudioObjectSystemObject),
    in scope: AudioObjectProperty.Scope = .global,
    to value: Data
) -> Bool {
    var val = value
    var err: OSStatus!
    withUnsafeMutablePointer(to: &val) { ptr in
        let dataSize = UInt32(MemoryLayout<Data>.size)
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
            /* inDataSize */ dataSize,
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


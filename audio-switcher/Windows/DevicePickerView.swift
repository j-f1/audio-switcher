//
//  DevicePickerView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI
import Defaults

public struct DevicePickerView: View {
  @Binding var selectedDevice: String?
  let alreadySelected: String?

  @State var isCustomDevice: Bool
  @ObservedObject var devices = AudioDeviceList.shared

  init(selectedDevice: Binding<String?>, alreadySelected: String?) {
    self._selectedDevice = selectedDevice
    self.alreadySelected = alreadySelected

    let isCustomDevice: Bool
    if let selectedDevice = selectedDevice.wrappedValue {
      isCustomDevice = Device.named(selectedDevice) == nil
    } else {
      isCustomDevice = false
    }

    self._isCustomDevice = State(initialValue: isCustomDevice)
  }

  public var body: some View {
    Picker(selection: $isCustomDevice, label: EmptyView()) {
      Text("Connected Device").tag(false)
      Text("Other Device").tag(true)
    }.offset(y: -3).pickerStyle(SegmentedPickerStyle())
    if isCustomDevice {
      TextField("Custom Name", text: .init(get: { selectedDevice ?? "" }, set: { selectedDevice = $0 }))
        .textFieldStyle(RoundedBorderTextFieldStyle())
      Text("This name must exactly match the device’s name.")
        .foregroundColor(.secondary)
    } else {
      List(selection: $selectedDevice) {
        ForEach(devices.devices) { device in
          if let name = device.name {
            HStack {
              Text(name)
              if name == alreadySelected && name == selectedDevice {
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill")
                  .foregroundColor(.primary)
                  .help("This output is already being used as the other output device")
              }
            }.tag(name)
          }
        }
      }
      .cornerRadius(9)
      .frame(minHeight: 100)
    }
  }
}

struct DevicePickerView_Previews: PreviewProvider {
  struct TestView: View {
    @State var device: String?
    var body: some View {
      DevicePickerView(selectedDevice: $device, alreadySelected: nil)
    }
  }
  static var previews: some View {
    TestView()
  }
}

//
//  GeneralSettings.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 3/18/21.
//

import SwiftUI
import Defaults
import LaunchAtLogin
import Preferences

struct DeviceSettings: View {
  @Default(.deviceName) var selectedDevice
  @Default(.secondaryDeviceName) var secondarySelectedDevice
  @Default(.effectOutputBehavior) var effectOutputBehavior
  @State var secondDeviceEnabled: Bool

  init() {
    self._secondDeviceEnabled = .init(initialValue: false)
    self._secondDeviceEnabled = .init(initialValue: secondarySelectedDevice != nil)
  }

  var body: some View {
    Preferences.Container(contentWidth: 450) {
      Preferences.Section(title: "Device to Activate") {
        DevicePickerView(selectedDevice: $selectedDevice, alreadySelected: secondDeviceEnabled ? secondarySelectedDevice : nil)
      }
      Preferences.Section(title: "Secondary Device") {
        Toggle(isOn: $secondDeviceEnabled) {
          Text("Alternate with a second device")
        }
        .padding(.vertical, 8)
        .onChange(of: secondDeviceEnabled, perform: { value in
          if !value {
            secondarySelectedDevice = nil
          }
        })
        if secondDeviceEnabled {
          DevicePickerView(selectedDevice: $secondarySelectedDevice, alreadySelected: selectedDevice)
        }
      }
      Preferences.Section(title: "Sound Effects") {
        Picker(selection: $effectOutputBehavior, label: EmptyView()) {
          Text("Change the sound effects output to match the selected audio output when it matches the previous audio output").tag(EffectOutputBehavior.auto)
          Text("Always change the sound effect output to match the standard output").tag(EffectOutputBehavior.always)
          Text("Never change the sound effect output").tag(EffectOutputBehavior.never)
        }.pickerStyle(RadioGroupPickerStyle())
      }
    }.fixedSize()
  }
}

struct DeviceSettings_Previews: PreviewProvider {
  static var previews: some View {
    DeviceSettings()
  }
}

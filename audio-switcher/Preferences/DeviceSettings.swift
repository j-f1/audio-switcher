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
  @Default(.deviceName) private var selectedDevice
  @Default(.secondaryDeviceName) private var secondarySelectedDevice
  @Default(.effectOutputBehavior) private var effectOutputBehavior
  @Default(.switchInputToo) private var switchInputToo
  @State private var secondDeviceEnabled = Defaults[.secondaryDeviceName] != nil

  private func shouldDisableInputToggle(for name: String?) -> Bool {
    guard let name = name, let device = Device.named(name) else { return false }
    return !device.isInput
  }

  var body: some View {
    Preferences.Container(contentWidth: 450) {
      Preferences.Section(title: "Device to Activate") {
        DevicePickerView(selectedDevice: $selectedDevice, alreadySelected: secondDeviceEnabled ? secondarySelectedDevice : nil)
        Toggle("Also select this device as input when activating it", isOn: $switchInputToo)
          .disabled(shouldDisableInputToggle(for: selectedDevice))
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

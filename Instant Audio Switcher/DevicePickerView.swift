//
//  DevicePickerView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI
import Defaults

import Preferences

public struct DevicePickerView: View {
    @Default(.deviceName) var selectedDevice
    @State var isCustomDevice: Bool
    init() {
        let isCustomDevice: Bool
        if let selectedDevice = Defaults[.deviceName] {
            isCustomDevice = Device.named(selectedDevice) == nil
        } else {
            isCustomDevice = false
        }

        self._isCustomDevice = State(initialValue: isCustomDevice)
    }
    public var body: some View {
        Preferences.Container(contentWidth: 350) {
            Preferences.Section(title: "") {
                Text("Select device to activate when clicking menu bar").font(.headline)
                Picker(selection: $isCustomDevice, label: EmptyView()) {
                    Text("Connected Device").tag(false)
                    Text("Other Device").tag(true)
                }.pickerStyle(SegmentedPickerStyle())
                if isCustomDevice {
                    TextField(
                        "Custom Name",
                        text: .init(
                            get: { selectedDevice ?? "" },
                            set: { selectedDevice = $0 }
                        )
                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("This name must exactly match the device’s name.")
                        .foregroundColor(.secondary)
                } else {
                    List(selection: $selectedDevice) {
                        ForEach(Device.named) { device in
                            Text(device.name!).tag(device.name!)
                        }
                    }
                    .cornerRadius(5)
                    .padding(.horizontal, -10)
                    .frame(minHeight: 100)
                }
//                .toolbar {
//                    Button {
//                        if let name = selectedDevice,
//                           let device = Device.named(name) {
//                            device.activate(for: .output)
//                        }
//                    } label: {
//                        Image(systemName: "checkmark")
//                    }
//                }
            }
        }
    }
}

struct DevicePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePickerView()
    }
}

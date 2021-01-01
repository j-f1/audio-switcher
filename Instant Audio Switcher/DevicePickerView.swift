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
    @Binding var selectedDevice: String?
    @State var isCustomDevice: Bool
    init(selectedDevice: Binding<String?>) {
        self._selectedDevice = selectedDevice
        
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
        }.pickerStyle(SegmentedPickerStyle())
        .offset(y: -3)
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
            .frame(minHeight: 100)
        }
    }
}

struct DevicePickerView_Previews: PreviewProvider {
    struct TestView: View {
        @State var device: String?
        var body: some View {
            DevicePickerView(selectedDevice: $device)
        }
    }
    static var previews: some View {
        TestView()
    }
}

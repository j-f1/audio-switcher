//
//  DevicePickerView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI
import Defaults

import Preferences

let icons = [
    [
        "sparkles",
        "earpods",
        "airpods",
        "airpod.right",
        "airpodpro.right",
        "headphones",
        "headphones.circle",
        "headphones.circle.fill"
    ],
    [
        "link",
        "waveform",
        "airpodspro",
        "airpod.left",
        "airpodpro.left",
        "speaker.wave.2.fill",
        "speaker.wave.2.circle",
        "speaker.wave.2.circle.fill"
    ],
    [
        "hands.sparkles",
        "waveform.circle",
        "homepod.2",
        "homepod",
        "hifispeaker.and.homepod",
        "hifispeaker.2",
        "hifispeaker",
        "tv"
    ],
    [
        "hands.sparkles.fill",
        "waveform.circle.fill",
        "homepod.2.fill",
        "homepod.fill",
        "hifispeaker.and.homepod.fill",
        "hifispeaker.2.fill",
        "hifispeaker.fill",
        "tv.fill"
    ]
]

public struct DevicePickerView: View {
    @Default(.deviceName) var selectedDevice
    @State var isCustomDevice: Bool
    @Default(.iconName) var selectedIcon
    @Default(.iconSize) var iconSize
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
        VStack(alignment: .leading) {
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
            Divider().padding(.vertical, 8)
            Text("Icon").font(.headline)
            HStack {
                VStack {
                    ForEach(icons, id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                }) {
                                    let img = Image(systemName: icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .padding(5)
                                    if selectedIcon == icon {
                                        img.background(
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color.accentColor)
                                        )
                                        .foregroundColor(.white)
                                    } else {
                                        img
                                    }
                                }.buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }

                }
            }
        }.padding().frame(width: 328)
    }
}

struct DevicePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePickerView()
    }
}

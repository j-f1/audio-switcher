//
//  SettingsView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI
import Defaults

struct SettingsView: View {
    @Default(.deviceName) var selectedDevice
    @Default(.iconName) var selectedIcon
    var body: some View {
        VStack(alignment: .leading) {
            DevicePickerView(selectedDevice: $selectedDevice)
            Divider().padding(.vertical, 8)
            IconPickerView(selectedIcon: $selectedIcon)
        }.padding().frame(width: 328)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

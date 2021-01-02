//
//  SettingsView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI
import Defaults

struct SettingsView: View {
  @Default(.showInDock) var showInDock
  @Default(.clickToActivate) var clickToActivate
  
  @Default(.deviceName) var selectedDevice
  @Default(.iconName) var selectedIcon
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("General").font(.headline)
      Toggle("Show in Dock", isOn: $showInDock).padding(.vertical, 5)
      Toggle(isOn: $clickToActivate) {
        VStack(alignment: .leading) {
          Text("Click menu item to activate “\(selectedDevice ?? "")\u{202d}”")
          (
            Text("")
              + Text("When enabled, click the ") + Text(Image(systemName: selectedIcon)) + Text(" ")
              + Text("icon in the menu bar to send music, videos, and sounds to “\(selectedDevice ?? "<unknown device>")\u{202d}.” ")
              + Text("Option-click, control-click, or right-click the menu item to open the menu and change your settings.")
          ).foregroundColor(.secondary)
           .imageScale(.small)
        }
      }
      
      Divider().padding(.vertical, 8)
      Text("Device to Activate").font(.headline)
      DevicePickerView(selectedDevice: $selectedDevice)
      
      Divider().padding(.vertical, 8)
      Text("Menu Bar Icon").font(.headline)
      IconPickerView(selectedIcon: $selectedIcon)
    }
    .padding()
    .frame(width: 368)
    .fixedSize(horizontal: false, vertical: true)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

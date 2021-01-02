//
//  SettingsView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI
import Defaults
import LaunchAtLogin

struct SettingsView: View {
  @Default(.showInDock) var showInDock
  @Default(.clickToActivate) var clickToActivate
  
  @Default(.deviceName) var selectedDevice
  @Default(.iconName) var selectedIcon
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("General").font(.headline)
      Toggle("Show in Dock", isOn: $showInDock)
      LaunchAtLogin.Toggle()
      Toggle(isOn: $clickToActivate) {
        VStack(alignment: .leading, spacing: 2) {
          HStack(spacing: 0) {
            Text("Click menu item to activate “").fixedSize()
            Text(selectedDevice ?? "")
              .lineLimit(1)
              .truncationMode(.tail)
            Text("”").fixedSize()
          }
          (
            Text("")
              + Text("When enabled, click the ") + Text(Image(systemName: selectedIcon)) + Text(" ")
              + Text("icon in the menu bar to send music, videos, and sounds to “\(selectedDevice ?? "<unknown device>")\u{202d}.”\n")
              + Text("Option-click, control-click, or right-click the menu item to open the menu and change your settings.")
          ).foregroundColor(.secondary)
           .imageScale(.small)
           .font(.body)
           .fixedSize(horizontal: false, vertical: true)
        }
      }
      
      Divider().padding(.vertical, 8)
      Text("Device to Activate").font(.headline)
      DevicePickerView(selectedDevice: $selectedDevice)
      
      Divider().padding(.vertical, 8)
      Text("Menu Bar Icon").font(.headline)
      IconPickerView(selectedIcon: $selectedIcon)
    }
    .padding(16)
    .frame(width: 368)
    .fixedSize(horizontal: false, vertical: true)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

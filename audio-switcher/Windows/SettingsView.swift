//
//  SettingsView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI
import Defaults
import LaunchAtLogin

let openMenuText = Text("open the menu and change your settings.")
let setOutputText = { (name: String?) in Text("send music, videos, and sounds to “\(name ?? "<unknown device>")\u{202d}.”") }

let clickIconToText = { (icon: String) in Text("Click the ") + Text(Image(systemName: icon)) + Text(" icon in the menu bar to ") }
let altClickIconToText = Text("Option-click, control-click, or right-click the menu item to ")

struct SettingsView: View {
  @Default(.showInDock) var showInDock
  @Default(.clickToActivate) var clickToActivate
  @Default(.playSound) var playSound

  @Default(.deviceName) var selectedDevice
  @Default(.iconName) var selectedIcon
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("General").font(.headline)
      Toggle("Show in Dock", isOn: $showInDock)
      Toggle("Play sound after connecting", isOn: $playSound)
      LaunchAtLogin.Toggle()
      Toggle(isOn: $clickToActivate) {
        VStack(alignment: .leading, spacing: 5) {
          HStack(spacing: 0) {
            Text("Click menu item to activate “").fixedSize()
            Text(selectedDevice ?? "")
              .lineLimit(1)
              .truncationMode(.tail)
            Text("”").fixedSize()
          }
          ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 5) {
              clickIconToText(selectedIcon) + setOutputText(selectedDevice)
              altClickIconToText + openMenuText
            }.opacity(clickToActivate ? 1 : 0)
            VStack(alignment: .leading, spacing: 5) {
              clickIconToText(selectedIcon) + openMenuText
              altClickIconToText + setOutputText(selectedDevice)
            }.opacity(clickToActivate ? 0 : 1)
          }.foregroundColor(.secondary)
           .imageScale(.small)
           .font(.body)
           .fixedSize(horizontal: false, vertical: true)
        }
      }.padding(.bottom, -4)

      Group {
        Divider().padding(.vertical, 8)
        Text("Device to Activate").font(.headline)
        DevicePickerView(selectedDevice: $selectedDevice)
      }

      Group {
        Divider().padding(.vertical, 8)
        Text("Menu Bar Icon").font(.headline)
        IconPickerView(selectedIcon: $selectedIcon)
      }
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

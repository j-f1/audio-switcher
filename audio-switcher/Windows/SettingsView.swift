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
let setOutputText = { (name: String?) in Text("send music, videos, and sounds to “\(name ?? "<choose device>")\u{202d}.”") }

let clickIconToText = { (icon: String) in Text("Click the ") + Text(Image(systemName: icon)) + Text(" icon in the menu bar to ") }
let altClickIconToText = { (icon: String) in Text("Option-click, control-click, or right-click the ") + Text(Image(systemName: icon)) + Text(" icon to ") }

struct SettingsView: View {
  @Default(.showInDock) var showInDock
  @Default(.clickToActivate) var clickToActivate
  @Default(.playSound) var playSound

  @Default(.deviceName) var selectedDevice
  @Default(.secondaryDeviceName) var secondarySelectedDevice
  @Default(.iconName) var selectedIcon
  
  @State var secondDeviceEnabled: Bool

  init() {
    self._secondDeviceEnabled = .init(initialValue: false)
    self._secondDeviceEnabled = .init(initialValue: secondarySelectedDevice != nil)
  }

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
            Text(selectedDevice ?? "<choose device>")
              .lineLimit(1)
              .truncationMode(.tail)
            Text("”").fixedSize()
          }
          ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 5) {
              clickIconToText(selectedIcon) + setOutputText(selectedDevice)
              altClickIconToText(selectedIcon) + openMenuText
            }.opacity(clickToActivate ? 1 : 0)
            VStack(alignment: .leading, spacing: 5) {
              clickIconToText(selectedIcon) + openMenuText
              altClickIconToText(selectedIcon) + setOutputText(selectedDevice)
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
        Toggle(isOn: $secondDeviceEnabled) {
          Text("Alternate with Second Device").font(.headline)
        }.padding(.top, 8)
        if secondDeviceEnabled {
          DevicePickerView(selectedDevice: $secondarySelectedDevice)
        }
      }.onChange(of: secondDeviceEnabled, perform: { value in
        if !value {
          secondarySelectedDevice = nil
        }
      })

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

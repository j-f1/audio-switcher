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
import KeyboardShortcuts

fileprivate let openMenuText = Text("open the menu and change your settings.")
fileprivate let setOutputText = { (name: String?) in Text("send music, videos, and sounds to “\(name ?? "<choose device>")\u{202d}.”") }
fileprivate let toggleOutputText = { (name1: String?, name2: String?) in Text("toggle between sending music, videos, and sounds to “\(name1 ?? "<choose device>")\u{202d}” and “\(name2 ?? "<choose device>")\u{202d}.”") }

fileprivate let clickIconToText = { (icon: String) in Text("Click the ") + Text(Image(systemName: icon)) + Text(" icon in the menu bar to ") }
fileprivate let altClickIconToText = { (icon: String) in Text("Option-click, control-click, or right-click the ") + Text(Image(systemName: icon)) + Text(" icon to ") }


struct GeneralSettings: View {
  @Default(.showInDock) var showInDock
  @Default(.clickToActivate) var clickToActivate
  @Default(.playSound) var playSound

  @Default(.deviceName) var selectedDevice
  @Default(.secondaryDeviceName) var secondarySelectedDevice
  @Default(.iconName) var selectedIcon

  var body: some View {
    let secondDeviceEnabled = secondarySelectedDevice != nil
    Preferences.Container(contentWidth: 450) {
      Preferences.Section(title: "App Behavior") {
        Toggle("Hide from Dock", isOn: .init(get: { !showInDock }, set: { showInDock = !$0 }))
        LaunchAtLogin.Toggle()
      }
      Preferences.Section(title: "Keyboard Shortcut") {
        HStack {
          KeyboardShortcuts.Recorder(for: .activateDevice)
          Text((secondDeviceEnabled ? "Toggle output devices" : "Activate your selected device"))
            .preferenceDescription()
        }
      }
      Preferences.Section(title: "Menu Behavior") {
        Toggle("Play sound after connecting", isOn: $playSound)
        Toggle(isOn: $clickToActivate) {
          VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 0) {
              Text("Click menu item to ").fixedSize()
              if secondDeviceEnabled {
                Text("toggle output devices")
              } else {
                Text("activate “")
                Text(selectedDevice ?? "<choose device>")
                  .lineLimit(1)
                  .truncationMode(.tail)
                Text("”").fixedSize()
              }
            }
            ZStack(alignment: .topLeading) {
              VStack(alignment: .leading, spacing: 5) {
                clickIconToText(selectedIcon) + (secondDeviceEnabled ? toggleOutputText(selectedDevice, secondarySelectedDevice) : setOutputText(selectedDevice))
                altClickIconToText(selectedIcon) + openMenuText
              }.opacity(clickToActivate ? 1 : 0)
              VStack(alignment: .leading, spacing: 5) {
                clickIconToText(selectedIcon) + openMenuText
                altClickIconToText(selectedIcon) + (secondDeviceEnabled ? toggleOutputText(selectedDevice, secondarySelectedDevice) : setOutputText(selectedDevice))
              }.opacity(clickToActivate ? 0 : 1)
            }.foregroundColor(.secondary)
            .imageScale(.small)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
          }
        }
      }
    }.fixedSize()
  }
}

struct GeneralSettings_Previews: PreviewProvider {
  static var previews: some View {
    GeneralSettings()
  }
}

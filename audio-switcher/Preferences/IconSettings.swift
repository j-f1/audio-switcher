//
//  SettingsView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI
import Defaults
import Preferences

struct IconSettings: View {
  @Default(.iconName) var selectedIcon

  var body: some View {
    Preferences.Container(contentWidth: 450) {
      Preferences.Section(title: "Menu Bar Icon") {
        VStack(spacing: 0) {
          Text("").frame(height: 0)
          IconPickerView(selectedIcon: $selectedIcon)
        }
      }
    }.fixedSize()
  }
}

struct IconSettings_Previews: PreviewProvider {
  static var previews: some View {
    IconSettings()
  }
}

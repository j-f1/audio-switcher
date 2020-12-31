//
//  SettingsView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import SwiftUI
import Preferences
import Defaults

struct SettingsView: View {
    @Default(.showInDock) var showInDock
    @Default(.clickToActivate) var clickToActivate
    var body: some View {
        Preferences.Container(contentWidth: 350) {
            Preferences.Section(title: "Appearance") {
                Toggle("Show in Dock", isOn: $showInDock)
                Toggle("Click menu item to activate", isOn: $clickToActivate)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

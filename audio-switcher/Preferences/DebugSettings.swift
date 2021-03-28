//
//  GeneralSettings.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 3/18/21.
//

import SwiftUI
import Defaults
import Preferences

#if DEBUG
struct DebugSettings: View {
  @Default(.latestRunVersion) var latestRunVersion

  var body: some View {
    Preferences.Container(contentWidth: 450) {
      Preferences.Section(title: "latestRunVersion") {
        Picker("", selection: $latestRunVersion) {
          ForEach(Version.allVersions) { v in
            Text(v.rawValue).tag(v.rawValue as String?)
          }
          Text("nil").tag(nil as String?)
        }
      }
    }.fixedSize()
  }
}

struct DebugSettings_Previews: PreviewProvider {
  static var previews: some View {
    DebugSettings()
  }
}
#endif

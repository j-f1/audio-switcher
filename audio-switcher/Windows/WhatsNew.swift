//
//  WhatsNew.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 2/28/21.
//

import Foundation

enum ChangelogEntry {
  case feature(String)
  case bug(String)
}

extension ChangelogEntry: Identifiable {
  var id: String {
    switch self {
    case .feature(let s): return "feature-\(s)"
    case .bug(let s): return "bug-\(s)"
    }
  }

}

enum Version: String, Identifiable {
  var id: String { rawValue }

  case v1_3_1 = "1.3.1"
  case v1_3 = "1.3"
  case v1_2 = "1.2"
  case v1_1 = "1.1"

  static let allVersions: [Version] = [.v1_3_1, .v1_3, .v1_2, .v1_1]
  var changelog: [ChangelogEntry] {
    switch self {
    case .v1_3_1: return [
      .bug("Disabling “Play sound after connecting” now turns off the sound effect played after connecting")
    ]
    case .v1_3: return [
      .feature("Option to add a shortcut for toggling/switching to your preferred audio output"),
      .feature("Redesigned Preferences window"),
      .feature("Easier to access feedback"),
    ]
    case .v1_2: return [
      .feature("Ability to add a second device to toggle between"),
      .feature("Welcome window for new users"),
      .feature("What’s New window when updating (You’re looking at it!)"),
      .bug("Crashes when adding or removing audio devices (hopefully!)")
    ]
    case .v1_1: return [
      .feature("Optionally play a sound effect when switching devices"),
      .feature("Send a notification when a device can’t be switched to"),
      .feature("Improved preferences and menu UI")
    ]
    }
  }
}

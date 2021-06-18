//
//  Defaults.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Defaults
import Preferences
import KeyboardShortcuts

extension Defaults.Keys {
  static let showInDock = Key<Bool>("showInDock", default: true)
  static let clickToActivate = Key<Bool>("clickToActivate", default: false)
  static let playSound = Key<Bool>("playSound", default: false)
  static let effectOutputBehavior = Key<EffectOutputBehavior>("effectOutputBehavior", default: .auto)

  static let deviceName = Key<String?>("deviceName")
  static let secondaryDeviceName = Key<String?>("secondaryDeviceName")
  static let iconName = Key<String>("iconName", default: "sparkles")

  static let latestRunVersion = Key<String?>("latestRunVersion")
}

extension KeyboardShortcuts.Name {
  static let activateDevice = Self("activateDevice")
}

extension Preferences.PaneIdentifier {
  static let general = Self("general")
  static let device = Self("device")
  static let icon = Self("icon")
  #if DEBUG
  static let debug = Self("debug")
  #endif
}

enum EffectOutputBehavior: String, Codable {
  case always
  case never
  case auto
}

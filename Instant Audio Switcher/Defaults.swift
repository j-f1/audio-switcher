//
//  Defaults.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Defaults

extension Defaults.Keys {
    static let deviceName = Key<String?>("deviceName", default: Device.selected(for: .output)?.name)
    static let showInDock = Key<Bool>("showInDock", default: true)
    static let clickToActivate = Key<Bool>("clickToActivate", default: false)
    static let iconName = Key<String>("iconName", default: "sparkles")
    static let iconSize = Key<IconSize>("iconSize", default: .large)
}

enum IconSize: String, Codable, CaseIterable, Identifiable {
    case regular
    case large

    var id: String { rawValue }
}

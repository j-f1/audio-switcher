//
//  AboutScreen.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/2/21.
//

#if canImport(AboutScreen)
import AboutScreen
import SwiftUI

let dependencies = [
  Dependency(
    "Defaults",
    url: "https://github.com/sindresorhus/Defaults",
    version: "4.1.0",
    license: .mit,
    licenseURL: "https://github.com/sindresorhus/Defaults/blob/4.1.0/license",
    description: Text("Swifty and modern ") + Text("UserDefaults").font(.system(.body, design: .monospaced))
  ),
  Dependency(
    "MenuBuilder",
    url: "https://github.com/j-f1/MenuBuilder",
    version: "1.2.0",
    license: .mit,
    licenseURL: "https://github.com/user/repo/blob/1.2.0/LICENSE.md",
    description:
      Text("Swift Function Builder for creating ")
      + Text("NSMenuItem").font(.system(.body, design: .monospaced))
      + Text("s")
  ),
  Dependency(
    "LaunchAtLogin",
    url: "https://github.com/sindresorhus/LaunchAtLogin",
    version: "4.0.0",
    license: .mit,
    licenseURL: "https://github.com/sindresorhus/LaunchAtLogin/blob/4.0.0/license",
    description: "Add “Launch at Login” functionality to your macOS app in seconds"
  ),
  Dependency(
    "Preferences",
    url: "https://github.com/sindresorhus/Preferences",
    version: "2.2.1",
    license: .mit,
    licenseURL: "https://github.com/sindresorhus/Preferences/blob/v2.2.1/license",
    description: "Add a preferences window to your macOS app in minutes"
  ),
  Dependency(
    "KeyboardShortcuts",
    url: "https://github.com/sindresorhus/KeyboardShortcuts",
    version: "0.7.1",
    license: .mit,
    licenseURL: "https://github.com/sindresorhus/KeyboardShortcuts/blob/v0.7.1/license",
    description: "Add user-customizable global keyboard shortcuts to your macOS app in minutes"
  ),
]

class AboutScreenVC: NSHostingController<AnyView> {
  required init?(coder: NSCoder) {
    super.init(coder: coder, rootView: AnyView(
      AboutScreen(
        copyrightYear: "2020–2021",
        dependencies: dependencies,
        dependenciesScroll: false,
        icon: "App Icon"
      ).frame(width: 400)
    ))
  }
}
#endif

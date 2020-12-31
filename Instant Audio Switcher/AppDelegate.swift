//
//  AppDelegate.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Cocoa
import Defaults

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController()

        NSApp.setActivationPolicy(Defaults[.showInDock] ? .regular : .accessory)
        Defaults.observe(.showInDock) { change in
            NSApp.setActivationPolicy(Defaults[.showInDock] ? .regular : .accessory)
//            if change.oldValue && !change.newValue {
//                self.settingsWC.open()
//            }
        }.tieToLifetime(of: self)
    }
}

//
//  AppDelegate.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Cocoa
import Defaults
import Preferences
import SwiftUI
import CoreFoundation
import MenuBuilder

extension Preferences.PaneIdentifier {
    static let general = Self("general")
    static let device = Self("device")
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?

    let prefsWC = PreferencesWindowController(panes: [
        Preferences.Pane(identifier: .general, title: "General", toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)!) {
            SettingsView()  
        },
        Preferences.Pane(identifier: .device, title: "Device", toolbarIcon: NSImage(systemSymbolName: "headphones", accessibilityDescription: nil)!) {
            DevicePickerView()
        }
    ])
    let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String]!
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController {
            if let name = Defaults[.deviceName],
               let device = Device.named(name) {
                MenuItem("Activate \(name)")
                    .onSelect {
                        device.activate(for: .output)
                    }
            }
            SeparatorItem()
            MenuItem("Preferences…")
                .onSelect { self.prefsWC.show() }
                .shortcut(",")
            SeparatorItem()
            MenuItem("About \(appName)")
            MenuItem("Send Feedback…")
                .onSelect {
                    NSWorkspace.shared.open(URL(string: "https://github.com/j-f1/input-sources/issues/new")!)
                }
            SeparatorItem()
            MenuItem("Quit \(appName)")
                .onSelect { NSApp.terminate(nil) }
                .shortcut("q")
        }
        
        NSApp.setActivationPolicy(Defaults[.showInDock] ? .regular : .accessory)
        Defaults.observe(.showInDock) { change in
            NSApp.setActivationPolicy(Defaults[.showInDock] ? .regular : .accessory)
            if change.oldValue && !change.newValue {
                self.prefsWC.show()
            }
        }.tieToLifetime(of: self)
    }
}

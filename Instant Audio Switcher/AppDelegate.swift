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

@NSApplicationMain
@objc class AppDelegate: NSObject, NSApplicationDelegate {
  var statusBar: StatusBarController?
  let devicesWC: NSWindowController = NSStoryboard.main!.instantiateController(identifier: "DevicesWindow")
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    devicesWC.contentViewController = NSHostingController(rootView: SettingsView())
    devicesWC.window!.backgroundColor = NSColor.underPageBackgroundColor
    statusBar = StatusBarController {
      let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String]!
      if let name = Defaults[.deviceName],
         let device = Device.named(name) {
        MenuItem("Activate \(name)")
          .onSelect {
            device.activate(for: .output)
          }
      }
      SeparatorItem()
      MenuItem("Preferences")
        .shortcut(",")
        .onSelect {
          NSApp.activate(ignoringOtherApps: true)
          self.devicesWC.window!.center()
          self.devicesWC.window!.makeKeyAndOrderFront(nil)
        }
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
    
    Defaults.observe(.showInDock, options: [.initial]) { _ in
      NSApp.setActivationPolicy(Defaults[.showInDock] ? .regular : .accessory)
    }.tieToLifetime(of: self)
  }
  
  func applicationDidResignActive(_ notification: Notification) {
    devicesWC.window?.close()
  }
}

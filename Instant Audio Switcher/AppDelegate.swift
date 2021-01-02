//
//  AppDelegate.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Cocoa
import Defaults
import SwiftUI
import CoreFoundation
import MenuBuilder

@NSApplicationMain
@objc class AppDelegate: NSObject, NSApplicationDelegate {
  var statusBar: StatusBarController?
  let prefsWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "PrefsWindow")
  let aboutWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "AboutWindow")

  func applicationDidFinishLaunching(_ notification: Notification) {
    prefsWC.contentViewController = NSHostingController(rootView: SettingsView())
    prefsWC.window!.backgroundColor = NSColor.underPageBackgroundColor
    statusBar = StatusBarController {
      let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String]!
      if let name = Defaults[.deviceName],
         let device = Device.named(name) {
        MenuItem("Activate \(name)")
          .onSelect {
            device.activate(for: .output)
          }
        SeparatorItem()
      }
      MenuItem("Preferences")
        .shortcut(",")
        .onSelect {
          self.prefsWC.open()
        }
      SeparatorItem()
      MenuItem("About \(appName)")
        .onSelect {
          self.aboutWC.open()
        }
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
    prefsWC.window?.close()
    aboutWC.window?.close()
  }
}

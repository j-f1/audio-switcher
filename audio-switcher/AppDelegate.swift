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
  var statusBar: StatusBarController!
  let prefsWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "PrefsWindow")
  #if canImport(AboutScreen)
  let aboutWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "AboutWindow")
  #endif

  func applicationDidFinishLaunching(_ notification: Notification) {
    prefsWC.contentViewController = NSHostingController(rootView: SettingsView())
    prefsWC.window!.backgroundColor = NSColor.underPageBackgroundColor
    statusBar = StatusBarController {
      let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String]!
      if let name = Defaults[.deviceName] {
        if let device = Device.named(name) {
          let isActive = Device.selected(for: .output) == device
          MenuItem("Activate \(name)")
            .state(isActive ? .on : .off)
            .onSelect { self.statusBar.activateDevice() }
        } else {
          MenuItem("“\(name)\u{200d}” is not available")
        }
      } else {
        MenuItem("Choose a device to activate in Preferences")
      }
      SeparatorItem()
      MenuItem("Preferences")
        .shortcut(",")
        .onSelect {
          self.prefsWC.open()
        }
      SeparatorItem()
      #if canImport(AboutScreen)
      MenuItem("About \(appName)")
        .onSelect {
          self.aboutWC.open()
        }
      #endif
      MenuItem("Send Feedback…")
        .onSelect {
          NSWorkspace.shared.open(URL(string: "https://github.com/j-f1/audio-switcher/issues/new")!)
        }
      SeparatorItem()
      MenuItem("Quit \(appName)")
        .onSelect { NSApp.terminate(nil) }
        .shortcut("q")
    }
    
    Defaults.observe(.showInDock, options: [.initial]) { _ in
      NSApp.setActivationPolicy(Defaults[.showInDock] ? .regular : .accessory)
      if self.prefsWC.window!.isVisible {
        DispatchQueue.main.async {
          self.prefsWC.open()
          self.prefsWC.window!.makeKey()
        }
      }
    }.tieToLifetime(of: self)
  }
  
  func applicationDidResignActive(_ notification: Notification) {
    if !Defaults[.showInDock] {
      prefsWC.window?.close()
      #if canImport(AboutScreen)
      aboutWC.window?.close()
      #endif
    } 
  }
}

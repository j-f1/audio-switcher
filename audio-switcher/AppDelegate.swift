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
import Preferences

func quote(_ str: String) -> String {
  "“\(str)\u{200d}”"
}

#if DEBUG
let debugSetting = [
  Preferences.Pane(
    identifier: .debug,
    title: "Debug",
    toolbarIcon: NSImage(systemSymbolName: "ant.fill", accessibilityDescription: "Debug preferences")!
  ) {
    DebugSettings()
  }
]
#else
let debugSetting: [PreferencePaneConvertible] = []
#endif


@NSApplicationMain
@objc class AppDelegate: NSObject, NSApplicationDelegate {
  var statusBar: StatusBarController!
  lazy var prefsWC = PreferencesWindowController(
    panes: [
      Preferences.Pane(
        identifier: .general,
        title: "General",
        toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!
      ) {
        GeneralSettings()
      },
      Preferences.Pane(
        identifier: .device,
        title: "Device",
        toolbarIcon: NSImage(systemSymbolName: "speaker.wave.2", accessibilityDescription: "Device preferences")!
      ) {
        DeviceSettings()
      },
      Preferences.Pane(
        identifier: .icon,
        title: "Icon",
        toolbarIcon: NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Icon preferences")!
      ) {
        IconSettings()
      },
    ] + debugSetting
  )
  let welcomeWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "WelcomeWindow")
  let whatsNewWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "WhatsNewWindow")
  #if canImport(AboutScreen)
  let aboutWC: TransientWindowController = NSStoryboard.main!.instantiateController(identifier: "AboutWindow")
  #endif

  @MenuBuilder func makeDeviceItem(name: String, label: String) -> [NSMenuItem] {
    if let device = Device.named(name) {
      let isActive = Device.selected(for: .output) == device
      MenuItem(label)
        .state(isActive ? .on : .off)
        .onSelect { activateDevice(named: name) }
    } else {
      MenuItem("\(quote(name)) is not available")
    }
  }

  func applicationDidFinishLaunching(_ notification: Notification) {
    welcomeWC.window!.backgroundColor = .underPageBackgroundColor
    let newVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
      // forgot to add release notes, oops!
      if Defaults[.latestRunVersion] == "1.3" {
        Defaults[.latestRunVersion] = "1.2"
      }
      if let lastRunVersion = Defaults[.latestRunVersion] {
        if newVersion != lastRunVersion {
          (self.whatsNewWC.contentViewController as! WhatsNewVC).lastVersion = lastRunVersion
          self.whatsNewWC.open()
        }
      } else {
          self.welcomeWC.open()
      }
      Defaults[.latestRunVersion] = newVersion
    }
    statusBar = StatusBarController {
      #if DEBUG
      MenuItem("DEV MODE")
      SeparatorItem()
      #endif
      let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String]!
      let names: [String] = [Defaults[.deviceName], Defaults[.secondaryDeviceName]].compactMap { $0 }
      if names.isEmpty {
        MenuItem("Choose a device to activate in Preferences")
      } else if let name = names.only {
        self.makeDeviceItem(name: name, label: "Activate \(name)")
      } else {
        MenuItem("Active Device")
          .view {
            HStack {
              Text("Active Device")
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .font(.caption)
                .foregroundColor(.secondary)
                .offset(x: names.contains { Device.selected(for: .output)?.name == $0 } ? 20 : 10)
              Spacer()
            }
            .padding(5)
          }
        for name in names {
          self.makeDeviceItem(name: name, label: name)
        }
      }
      SeparatorItem()
      MenuItem("Preferences")
        .shortcut(",")
        .onSelect {
          self.prefsWC.show()
        }
      MenuItem("Send Feedback…")
        .onSelect {
          NSWorkspace.shared.open(URL(string: "https://j-f1.github.io/audio-switcher/contact.html")!)
        }
      SeparatorItem()
      MenuItem("Welcome…")
        .onSelect {
          self.welcomeWC.open()
        }
      #if canImport(AboutScreen)
      MenuItem("About \(appName)")
        .onSelect {
          self.aboutWC.open()
        }
      #endif
      MenuItem("What’s New…")
        .onSelect {
          (self.whatsNewWC.contentViewController as! WhatsNewVC).lastVersion = "1.0"
          self.whatsNewWC.open()
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
          self.prefsWC.show()
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

//
//  StatusBarController.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Cocoa
import Defaults
import SwiftUI
import MenuBuilder
import AVFoundation

class StatusBarController {
  private var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private var menu = NSMenu()
  private var items: () -> [NSMenuItem?]

  lazy var audioPlayer: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "sound-effect", withExtension: "wav") else { return nil }
    return try? AVAudioPlayer(contentsOf: url)
  }()

  func activateDevice() {
    if let name = Defaults[.deviceName],
       let device = Device.named(name) {
      audioPlayer?.prepareToPlay()
      device.activate(for: .output)
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
        self.audioPlayer?.play()
      }
    }
  }
  
  init(@MenuBuilder items: @escaping () -> [NSMenuItem?]) {
    self.items = items
    
    Defaults.observe(keys: .iconName, options: [.initial]) { [weak self] in
      self?.statusItem.button?.image = NSImage(systemSymbolName: Defaults[.iconName], accessibilityDescription: nil)!
    }.tieToLifetime(of: self)
    
    statusItem.button!.target = self
    statusItem.button!.action = #selector(onClick)
    statusItem.button!.sendAction(on: [.rightMouseUp, .leftMouseUp, .rightMouseDown, .leftMouseDown])
  }
  
  @objc func onClick() {
    let event = NSApp.currentEvent!
    let override =
      event.modifierFlags.contains(.control) ||
      event.modifierFlags.contains(.option) ||
      event.type == .rightMouseDown ||
      event.type == .rightMouseUp
    let shouldActivate = Defaults[.clickToActivate] ? !override : override
    
    if shouldActivate && (event.type == .leftMouseUp || event.type == .rightMouseUp) {
      activateDevice()
    } else if !shouldActivate {
      self.menu.replaceItems(with: items)
      statusItem.popUpMenu(menu)
    }
  }
}


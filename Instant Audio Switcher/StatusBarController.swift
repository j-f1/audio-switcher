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

extension DispatchTimeInterval: Comparable {
  var nanoseconds: Int64? {
    switch self {
    case .seconds(let s): return Int64(s) * 1_000_000_000
    case .milliseconds(let ms): return Int64(ms) * 1_000_000
    case .microseconds(let μs): return Int64(μs) * 1_000
    case .nanoseconds(let ns): return Int64(ns)
    case .never: return nil
    @unknown default: return nil
    }
  }

  public static func < (_ lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
    if let lhs = lhs.nanoseconds,
       let rhs = rhs.nanoseconds {
      return lhs < rhs
    }
    return false
  }
  public static func > (_ lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
    if let lhs = lhs.nanoseconds,
       let rhs = rhs.nanoseconds {
      return lhs > rhs
    }
    return false
  }
}

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
      device.activate(for: .output)
      checkActivation(of: device)
    }
  }

  func checkActivation(of device: Device, start: DispatchTime = .now()) {
    if Device.selected(for: .output) == device {
      print("ok after \(CGFloat(start.distance(to: .now()).nanoseconds!) / 1_000_000) ms")
      self.audioPlayer?.pause()
      audioPlayer?.currentTime = 0
      self.audioPlayer?.play()
    } else if start.distance(to: .now()) > .seconds(5) {
      print("FALURE")
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
        self.checkActivation(of: device, start: start)
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


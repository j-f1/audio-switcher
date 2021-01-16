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
import UserNotifications

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

enum NotificationIdentifier {
  static let retryAction = "RetryAction"
  static let failureCategory = "connectionFailure"
}

class StatusBarController: NSObject, UNUserNotificationCenterDelegate {
  private var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private var menu = NSMenu()
  private var items: () -> [NSMenuItem?]

  lazy var audioPlayer: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "sound-effect", withExtension: "wav") else { return nil }
    return try? AVAudioPlayer(contentsOf: url)
  }()

  let center: UNUserNotificationCenter = {
    let center = UNUserNotificationCenter.current()
    let notificationCategory = UNNotificationCategory(
      identifier: NotificationIdentifier.failureCategory,
      actions: [
        UNNotificationAction(identifier: NotificationIdentifier.retryAction, title: "Try Again", options: [])
      ],
      intentIdentifiers: []
    )
    center.setNotificationCategories([notificationCategory])
    return center
  }()


  func activateDevice() {
    if let name = Defaults[.deviceName],
       let device = Device.named(name) {
      DispatchQueue.global(qos: .userInitiated).async {
        self.checkActivation(of: device)
      }
    } else {
      reportActivationFailure()
    }
  }

  func checkActivation(of device: Device, start: DispatchTime = .now()) {
    device.activate(for: .output)
    if Device.selected(for: .output) == device {
      print("ok after \(CGFloat(start.distance(to: .now()).nanoseconds!) / 1_000_000) ms")
      self.audioPlayer?.pause()
      audioPlayer?.currentTime = 0
      self.audioPlayer?.play()
    } else if start.distance(to: .now()) > .seconds(5) {
      reportActivationFailure()
    } else {
      DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(100)) {
        self.checkActivation(of: device, start: start)
      }
    }
  }

  func reportActivationFailure() {
    let name = Defaults[.deviceName] ?? "<unknown>"
    center.requestAuthorization(options: [.alert]) { (granted, err) in
      if let err = err {
        print(err)
      }
      if granted {
        let content = UNMutableNotificationContent()
        content.title = "Failed to activate \(name)"
        if Device.named(name) == nil {
          content.body = "No device with that name is currently available."
        }
        content.categoryIdentifier = NotificationIdentifier.failureCategory
        let notif = UNNotificationRequest(identifier: "failure-\(name)", content: content, trigger: nil)
        self.center.add(notif) { (err) in
          if let err = err {
            print(err)
          }
        }
      }
    }
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    switch response.actionIdentifier {
    case UNNotificationDefaultActionIdentifier:
      // User tapped on message itself rather than on an Action button
      return
    case NotificationIdentifier.retryAction:
      activateDevice()
    default:
      break
    }
    completionHandler()
  }

  init(@MenuBuilder items: @escaping () -> [NSMenuItem?]) {
    self.items = items
    super.init()
    center.delegate = self

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


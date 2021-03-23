//
//  DeviceActivation.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 3/23/21.
//

import Foundation
import AVFoundation
import Defaults
import UserNotifications

func activateDevice() {
  if let primaryDevice = Defaults[.deviceName] {
    if let secondaryDevice = Defaults[.secondaryDeviceName],
       primaryDevice == Device.selected(for: .output)?.name {
      activateDevice(named: secondaryDevice)
    } else {
      activateDevice(named: primaryDevice)
    }
  } else {
    NotificationHandler.shared.reportActivationFailure(for: nil)
  }
}

func activateDevice(named name: String) {
  if let device = Device.named(name) {
    DispatchQueue.global(qos: .userInitiated).async {
      checkActivation(of: device)
    }
  } else {
    NotificationHandler.shared.reportActivationFailure(for: name)
  }
}

fileprivate var audioPlayer: AVAudioPlayer? = {
  guard let url = Bundle.main.url(forResource: "sound-effect", withExtension: "wav") else { return nil }
  return try? AVAudioPlayer(contentsOf: url)
}()

func checkActivation(of device: Device, start: DispatchTime = .now()) {
  device.activate(for: .output)
  if Device.selected(for: .output) == device {
    print("activation of \(device.name ?? "<unknown>") ok after \(CGFloat(start.distance(to: .now()).nanoseconds!) / 1_000_000) ms")
    if Defaults[.playSound] {
      audioPlayer?.pause()
      audioPlayer?.currentTime = 0
      audioPlayer?.play()
    }
  } else if start.distance(to: .now()) > .seconds(5) {
    NotificationHandler.shared.reportActivationFailure(for: device.name)
  } else {
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(100)) {
      checkActivation(of: device, start: start)
    }
  }
}

fileprivate class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
  static let shared = NotificationHandler()
  private override init() {
    super.init()
    center.delegate = self
  }

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

  func reportActivationFailure(for name: String?) {
    center.requestAuthorization(options: [.alert]) { (granted, err) in
      if let err = err {
        print(err)
      }
      if granted {
        let content = UNMutableNotificationContent()
        content.title = "Failed to activate \(name ?? "<unknown>")"
        if let name = name, Device.named(name) == nil {
          content.body = "No device with that name is currently available."
        }
        content.categoryIdentifier = NotificationIdentifier.failureCategory
        let notif = UNNotificationRequest(identifier: name ?? "<unknown>", content: content, trigger: nil)
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
      break
    case NotificationIdentifier.retryAction:
      activateDevice(named: response.notification.request.identifier)
    default:
      break
    }
    completionHandler()
  }
}

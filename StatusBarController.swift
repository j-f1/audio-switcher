//
//  StatusBarController.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/31/20.
//

import Cocoa
import Defaults

class StatusBarController {
    private var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var menu = NSMenu()

    init() {
//        statusItem.button!.image = #imageLiteral(resourceName: "StatusBarIcon")
//        statusItem.button!.image?.size = NSSize(width: 18.0, height: 18.0)
//        statusItem.button!.image?.isTemplate = true
        statusItem.button!.title = "**"
        statusItem.button!.target = self
        statusItem.button!.action = #selector(onClick)
        statusItem.button!.sendAction(on: [.rightMouseUp, .leftMouseUp, .rightMouseDown, .leftMouseDown])

        let item = NSMenuItem(title: "Menu", action: nil, keyEquivalent: "")
        item.isEnabled = false
        menu.addItem(item)
    }

    @objc func onClick() {
        let event = NSApp.currentEvent!
        let override =
            event.modifierFlags.contains(.control) ||
            event.modifierFlags.contains(.option) ||
            event.type == .rightMouseDown ||
            event.type == .rightMouseUp
        let shouldActivate = Defaults[.clickToCycle] ? !override : override

        if shouldActivate && (event.type == .leftMouseUp || event.type == .rightMouseUp) {
//            selectNextLayout()
//            render()
        } else if !shouldActivate {
            statusItem.popUpMenu(menu)
        }
    }
}


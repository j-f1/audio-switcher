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

class StatusBarController {
    private var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var menu = NSMenu()
    private var items: () -> [NSMenuItem?]

    init(@MenuBuilder items: @escaping () -> [NSMenuItem?]) {
        self.items = items

        Defaults.observe(keys: .iconName, .iconSize, options: [.initial]) { [weak self] in
            let image = NSImage(systemSymbolName: Defaults[.iconName], accessibilityDescription: nil)!
            let height: CGFloat
            switch Defaults[.iconSize] {
            case .regular: height = image.size.height
            case .large: height = 20
            }
            let width = (image.size.width / image.size.height) * height
            self?.statusItem.length = width
            if let button = self?.statusItem.button {
                button.imagePosition = .imageOnly
                image.isTemplate = true
                button.image = image
            }
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
//            selectNextLayout()
        } else if !shouldActivate {
            self.menu.replaceItems(with: items)
            statusItem.popUpMenu(menu)
        }
    }
}


import Cocoa

class TransientWindowController: NSWindowController, NSWindowDelegate {
    func open() {
        NSApp.activate(ignoringOtherApps: true)
        self.showWindow(nil)
        if !window!.isKeyWindow {
            window!.makeKey()
        }
        window!.center()
    }
}

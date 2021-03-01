//
//  WelcomeWindow.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 2/28/21.
//

import SwiftUI
import Defaults
import LaunchAtLogin

class WelcomeVC: NSHostingController<WelcomeWindow> {
  required init?(coder: NSCoder) {
    super.init(coder: coder, rootView: WelcomeWindow())
  }
}

struct WelcomeWindow: View {
  @Default(.showInDock) var showInDock
  @Default(.deviceName) var selectedDevice
  @Default(.secondaryDeviceName) var secondarySelectedDevice

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image("App Icon")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 50)
          .accessibilityHidden(true)
        Text("Welcome to Instant Audio Switcher!")
          .font(.largeTitle)
          .fontWeight(.medium)
          .fixedSize(horizontal: false, vertical: true)
      }
      Text("Instant Audio Switcher runs in your menu bar — close this window and click the \(Image(systemName: Defaults[.iconName])) icon to get started.")
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical)

      Text("Initial settings")
        .font(.title2)
        .bold()
      Text("I recommend enabling both of these options:")
        .padding(.top, 5)
      Group {
        Toggle("Hide from Dock", isOn: .init(get: { !showInDock }, set: { showInDock = !$0 }))
        LaunchAtLogin.Toggle()
      }.padding(.leading)
      Divider().padding(.vertical)
      Text("Device to Activate")
        .font(.headline)
      DevicePickerView(selectedDevice: $selectedDevice, alreadySelected: secondarySelectedDevice)
        .fixedSize(horizontal: false, vertical: true)
      Text("Customize the menu bar icon, secondary device, and more by choosing “Preferences…” from the menu.")
        .italic()
        .padding(.top)
    }
    .padding([.horizontal, .bottom])
    .padding(.top, 5)
    .frame(width: 350).fixedSize()
  }
}

struct WelcomeWindow_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeWindow()
  }
}

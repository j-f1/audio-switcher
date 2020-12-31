//
//  ContentView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI
import Defaults

struct ContentView: View {
    @Default(.deviceName) var selectedDevice
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select device to activate in menu bar").font(.headline)
                .fixedSize()
            List(selection: $selectedDevice) {
                ForEach(Device.named) { device in
                    Text(device.name!).tag(device.name!)
                }
            }
            .padding(.horizontal, -10)
            .frame(minHeight: 100)
            .toolbar {
                Button {
                    if let name = selectedDevice,
                       let device = Device.named(name) {
                        device.activate(for: .output)
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

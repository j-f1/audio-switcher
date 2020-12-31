//
//  ContentView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI

struct ContentView: View {
    let device = Device.selected(for: .output)
    var body: some View {
        VStack {
            if let device = device {
                Text("Hello, \(device.name ?? "<???>") [in: \(device.isInput.description), out: \(device.isOutput.description)]!")
            }
            Text("\(Device.all!.compactMap(\.name).joined(separator: ", "))")
        }
            .fixedSize()
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

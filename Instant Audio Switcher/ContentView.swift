//
//  ContentView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI

struct ContentView: View {
    @State var current = Device.selected(for: .output)
    let all = Device.all!.filter({ $0.name != nil })
    var body: some View {
        VStack {
            if let device = current {
                Text("Hello, \(device.name ?? "<???>") [in: \(device.isInput.description), out: \(device.isOutput.description)]!")
            }
            Text("\(Device.all!.compactMap(\.name).joined(separator: ", "))")
            Button("Next") {
                let idx = all.firstIndex(where: { $0 == current })!
                current = all[(idx + 1) % all.count]
                current!.activate(for: .output)
            }
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

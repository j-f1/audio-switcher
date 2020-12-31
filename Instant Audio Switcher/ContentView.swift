//
//  ContentView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 12/30/20.
//

import SwiftUI

struct ContentView: View {
    @State var current = Device.selected(for: .output)
    var body: some View {
        List(selection: $current) {
            ForEach(Device.named) { device in
                Text(device.name!).tag(device)
            }
        }
        .listStyle(SidebarListStyle())
        .onChange(of: current, perform: { $0?.activate(for: .output) })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

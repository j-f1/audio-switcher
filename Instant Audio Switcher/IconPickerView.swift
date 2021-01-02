//
//  IconPickerView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    var body: some View {
        HStack {
            VStack {
                ForEach(icons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                            }) {
                                let img = Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                if selectedIcon == icon {
                                    img.background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(Color.accentColor)
                                    )
                                    .foregroundColor(.white)
                                } else {
                                    img
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }

            }
        }
    }
}

let icons = [
    [
        "sparkles",
        "earpods",
        "airpods",
        "airpod.left",
        "airpod.right",
        "headphones",
        "headphones.circle",
        "headphones.circle.fill"
    ],
    [
        "link",
        "waveform",
        "airpodspro",
        "airpodpro.left",
        "airpodpro.right",
        "speaker.wave.2.fill",
        "speaker.wave.2.circle",
        "speaker.wave.2.circle.fill"
    ],
    [
        "hands.sparkles",
        "waveform.circle",
        "homepod.2",
        "homepod",
        "hifispeaker.and.homepod",
        "hifispeaker.2",
        "hifispeaker",
        "tv"
    ],
    [
        "hands.sparkles.fill",
        "waveform.circle.fill",
        "homepod.2.fill",
        "homepod.fill",
        "hifispeaker.and.homepod.fill",
        "hifispeaker.2.fill",
        "hifispeaker.fill",
        "tv.fill"
    ]
]


struct IconPickerView_Previews: PreviewProvider {
    struct TestView: View {
        @State var icon = "sparkles"
        var body: some View {
            IconPickerView(selectedIcon: $icon)
        }
    }
    static var previews: some View {
        TestView()
    }
}

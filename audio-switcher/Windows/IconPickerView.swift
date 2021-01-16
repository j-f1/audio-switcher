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
    VStack(spacing: 0) {
      ForEach(icons, id: \.self) { row in
        HStack(spacing: 0) {
          ForEach(row, id: \.self) { icon in
            Button(action: { selectedIcon = icon }) {
              Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            }.buttonStyle(IconButtonStyle(selected: selectedIcon == icon))
          }
        }
      }
    }
    .contentShape(Rectangle())
    .padding(-4)
  }
}

struct IconButtonStyle: ButtonStyle {
  let selected: Bool

  struct Content<Icon: View>: View {
    let icon: Icon
    let selected: Bool
    let isPressed: Bool
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder var background: some View {
      if selected {
        Color(NSColor.selectedContentBackgroundColor).brightness(isPressed ? -0.1 : 0)
      } else if isPressed {
        Color.secondary.opacity(0.4)
      }
    }

    var body: some View {
      icon
        .foregroundColor(
          colorScheme == .dark || selected
            ? .white
            : .black
        )
        .padding(5)
        .background(
          background
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        )
        .padding(4)
    }
  }
  func makeBody(configuration: Configuration) -> some View {
    Content(icon: configuration.label, selected: selected, isPressed: configuration.isPressed)
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
    let icon = Image(systemName: "star.fill")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 25, height: 25)
    
    let buttonPreview = VStack {
      HStack {
        IconButtonStyle.Content(icon: icon, selected: false, isPressed: false)
        IconButtonStyle.Content(icon: icon, selected: false, isPressed: false)
        IconButtonStyle.Content(icon: icon, selected: false, isPressed: true)
      }
      HStack {
        IconButtonStyle.Content(icon: icon, selected: true, isPressed: false)
        IconButtonStyle.Content(icon: icon, selected: true, isPressed: false)
        IconButtonStyle.Content(icon: icon, selected: true, isPressed: true)
      }
    }.padding()
    
    TestView().padding()
    buttonPreview
    buttonPreview.preferredColorScheme(.dark)
  }
}

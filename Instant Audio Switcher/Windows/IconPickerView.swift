//
//  IconPickerView.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/1/21.
//

import SwiftUI

struct IconPickerView: View {
  @Binding var selectedIcon: String
  // work around some weirdness where the hover state doesn’t get cleared
  @State var hoveringIcon: String?
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
            }.buttonStyle(
              IconButtonStyle(
                selected: selectedIcon == icon,
                hovering: .init(get: { hoveringIcon == icon }, set: {
                  if $0 {
                    DispatchQueue.main.async {
                      hoveringIcon = icon
                    }
                  }
                })
              )
            )
          }
        }
      }
    }
    .contentShape(Rectangle())
    .onHover { if !$0 { hoveringIcon = nil } }
    .padding(.horizontal, -10)
  }
}

struct IconButtonStyle: ButtonStyle {
  let selected: Bool
  @Binding var hovering: Bool
  
  struct Content<Icon: View>: View {
    let icon: Icon
    let selected: Bool
    let isPressed: Bool
    @Binding var hovering: Bool
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder var background: some View {
      if selected {
        Color.accentColor.brightness(isPressed ? -0.1 : 0)
      } else if hovering {
        Color.secondary.opacity(isPressed ? 0.4 : 0.25)
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
        .onHover { hovering = $0 }
    }
  }
  func makeBody(configuration: Configuration) -> some View {
    Content(icon: configuration.label, selected: selected, isPressed: configuration.isPressed, hovering: $hovering)
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
        IconButtonStyle.Content(icon: icon, selected: false, isPressed: false, hovering: .constant(false))
        IconButtonStyle.Content(icon: icon, selected: false, isPressed: false, hovering: .constant(true))
        IconButtonStyle.Content(icon: icon, selected: false, isPressed: true, hovering: .constant(true))
      }
      HStack {
        IconButtonStyle.Content(icon: icon, selected: true, isPressed: false, hovering: .constant(false))
        IconButtonStyle.Content(icon: icon, selected: true, isPressed: false, hovering: .constant(true))
        IconButtonStyle.Content(icon: icon, selected: true, isPressed: true, hovering: .constant(true))
      }
    }.padding()
    
    TestView().padding()
    buttonPreview
    buttonPreview.preferredColorScheme(.dark)
  }
}

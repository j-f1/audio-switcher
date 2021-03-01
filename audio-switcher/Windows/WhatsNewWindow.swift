//
//  WhatsNewWindow.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 2/28/21.
//

import SwiftUI

class WhatsNewVC: NSHostingController<WhatsNewWindow> {
  var lastVersion = "1.0" {
    didSet {
      self.rootView = WhatsNewWindow(fromVersion: lastVersion)
    }
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder, rootView: WhatsNewWindow(fromVersion: "1.0"))
  }
}

fileprivate struct Token: View {
  let color: Color
  let text: String
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    Text(text)
      .padding(3)
      .foregroundColor(colorScheme == .dark ? .black : .white)
      .font(.caption)
      .background(RoundedRectangle(cornerRadius: 5).fill(color))
      .padding(3)
  }
}

extension ChangelogEntry: View {
  var body: some View {
    HStack {
      switch self {
      case .feature(let s):
        Token(color: .green, text: "NEW")
        Text(s)
      case .bug(let s):
        Token(color: .orange, text: "FIXED")
        Text(s)
      }
    }

  }
}

struct WhatsNewWindow: View {
  let fromVersion: String
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    let versionsToShow = Version.allVersions.prefix(while: { $0.rawValue != fromVersion })
    VStack(alignment: .leading) {
      ForEach(versionsToShow, id: \.self) { version in
        HStack(alignment: .top) {
          if versionsToShow.count > 1 {
            Text("v" + version.rawValue)
              .font(.headline)
              .frame(width: 30, alignment: .trailing)
              .padding(.top, 5)
          }
          VStack(alignment: .leading) {
            ForEach(version.changelog) { $0 }
          }
        }.padding(.vertical, 5)
      }
    }
    .padding()
    .padding(.horizontal)
    .background(Color(NSColor.textBackgroundColor))
    .fixedSize(horizontal: true, vertical: false)
  }
}

struct WhatsNewWindow_Previews: PreviewProvider {
  static var previews: some View {
    WhatsNewWindow(fromVersion: "1.1").preferredColorScheme(.light)
    WhatsNewWindow(fromVersion: "1.1").preferredColorScheme(.dark)
    WhatsNewWindow(fromVersion: "1.0").preferredColorScheme(.light)
    WhatsNewWindow(fromVersion: "1.0").preferredColorScheme(.dark)
  }
}

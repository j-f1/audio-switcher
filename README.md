#  Instant Audio Switcher

> Switch your audio input with a click

The volume menu on macOS Big Sur allows you to change which device receives audio output. However, this takes a few clicks. I loved using [ToothFairy](https://c-command.com/toothfairy/) in the past, but discovered that it does not work well with the new AirPods feature that leaves them connected to all your devices. This meant that there was no way to switch my AirPods from my phone to my laptop in one click. This app provides that feature.

Click the menu bar icon to open the menu and choose which device to connect to, as well as the icon and a few behavior settings.

If you want me to add configuration options, [send me a DM](https://twitter.com/jed_fox1) or open an issue and I’ll consider it

*If you don’t want to download the app from the App Store (and don’t mind manually installing updates), you can download Instant Audio Switcher from [the GitHub Releases page](https://github.com/j-f1/audio-switcher/releases/latest).*

Note: if you want to build the app yourself, you’ll need to remove my private “AboutScreen” dependency. When you open the project in Xcode, remove the “AboutScreen” package from “Instant Audio Switcher → Project → Instant Audio Switcher → Swift Packages,” then clean (⌘⇧K) and rebuild. All the code related to the about screen should be disabled once you do that and you should have no problems running the app.

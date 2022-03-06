//
//  Native_DiscordApp.swift
//  Native Discord
//
//  Created by Vincent Kwok on 19/2/22.
//

import SwiftUI

func hideZoomButton() {
    for window in NSApplication.shared.windows {
        window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
    }
}

// Get rid of over the top focus indicator
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

@main
struct SwiftcordApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(
                    NotificationCenter.default.publisher(for: NSApplication.didUnhideNotification),
                    perform: { _ in hideZoomButton() }
                )
                .onReceive(
                    NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification),
                    perform: { _ in hideZoomButton() }
                )
                .onAppear {
                    // Overwrite shared URLCache with a higher capacity one
                    URLCache.shared = URLCache(memoryCapacity: 32*1024*1024,  // 32MB
                                                 diskCapacity: 256*1024*1024, // 256MB
                                                     diskPath: nil)
                }
        }
        
        Settings {
            SettingsView()
        }
    }
}
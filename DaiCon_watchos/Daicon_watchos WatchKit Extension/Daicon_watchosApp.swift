//
//  Daicon_watchosApp.swift
//  Daicon_watchos WatchKit Extension
//
//  Created by 立花巧樹 on 2020/11/04.
//

import SwiftUI

@main
struct Daicon_watchosApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }.environmentObject(DeepViewModel())
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

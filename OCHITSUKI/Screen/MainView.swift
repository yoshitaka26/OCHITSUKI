//
//  MainView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

@main
struct MainView: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .accentColor(Color("AccentColor"))
        }
    }
}

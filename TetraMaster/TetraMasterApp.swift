//
//  TetraMasterApp.swift
//  TetraMaster
//
//  Created by Tim Musil on 28.11.20.
//

import SwiftUI

@main
struct TetraMasterApp: App {
    var body: some Scene {
        WindowGroup {
            StartingScreen()
                // Gamedata needs to be passed at app start to access the EnvironmentObject in further views
                .environmentObject(GameData())
              
            
        }
    }
}

//
//  ChordInTheActApp.swift
//  ChordInTheAct
//
//  Created by Dimitri Brukakis on 06.07.23.
//

import SwiftUI

@main
struct ChordInTheActApp: App {
    
    let applicationModel = ApplicationModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationModel)
        }
    }
}

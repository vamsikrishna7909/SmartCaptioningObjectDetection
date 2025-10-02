//
//  SmartCaptioningObjectDetectionApp.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/7/25.
//

import SwiftUI
import SwiftData

@main
struct SmartCaptioningObjectDetectionApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [DetectedItem.self])
    }
}

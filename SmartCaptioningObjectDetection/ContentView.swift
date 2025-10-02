//
//  ContentView.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/7/25.
//

import SwiftUI
import SwiftData
import MapKit

enum Route: Hashable {
    case detectiom
    case captioning
    //case history
}

struct ContentView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                NavigationLink("Object Detection", value: Route.detectiom)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                NavigationLink("Image Captioning", value: Route.captioning)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                NavigationLink("Detection History") {
                    DetectedItemListView()
                }
                .font(.title3)
                .padding()
                .background(.gray.opacity(0.2))
                .clipShape(.capsule)
            }
            .padding()
            .navigationTitle("Detection And Captioning App")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detectiom:
                    ObjectDetectionView()
                case .captioning:
                    Text("cap")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

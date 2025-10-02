//
//  DetectionViewModel.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/7/25.
//

import Foundation
import SwiftUI
import Vision
import SwiftData

@MainActor
class DetectionViewModel: ObservableObject {
    @Published var detectedObjects: [VNRecognizedObjectObservation] = []
    private let detector = ObjectDetector()

    func detect(in image: UIImage, modelContext: ModelContext) {
        let resizedImage = image.resized(to: CGSize(width: 416, height: 416))
        detector?.detectObjects(in: resizedImage) { [weak self] results in
            guard let self = self else { return }
            // Ensures main-thread-safe UI updates
            Task { @MainActor in
                let filtered = results.filter { observation in
                    guard let topLabel = observation.labels.first else { return false }
                    return topLabel.confidence > 0.5
                }
                self.detectedObjects = filtered
                self.saveResults(image: image, results: filtered, modelContext: modelContext)
            }
        }
    }

    private func saveResults(image: UIImage, results: [VNRecognizedObjectObservation], modelContext: ModelContext) {
        let labelSummary = results.prefix(5).compactMap { $0.labels.first?.identifier }.joined(separator: ", ")
        let newItem = DetectedItem(labels: labelSummary, createdAt: .now)
        modelContext.insert(newItem)
        try? modelContext.save()
    }
}


extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

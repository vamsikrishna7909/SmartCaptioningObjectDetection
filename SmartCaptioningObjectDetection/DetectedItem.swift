//
//  Item.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/7/25.
//

import Foundation
import SwiftData

@Model
final class DetectedItem {
    var id: UUID
    var labels: String
    var createdAt: Date
    
    init(labels: String, createdAt: Date) {
        self.id = UUID()
        self.labels = labels
        self.createdAt = createdAt
    }
}

//
//  DetectionOverlay.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/9/25.
//

import SwiftUI
import Vision

struct DetectionOverlay: View {
    let imageSize: CGSize
    let observations: [VNRecognizedObjectObservation]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ForEach(observations.indices, id: \.self) { i in
                    let obs: VNRecognizedObjectObservation = observations[i]
                    let rect: CGRect = mapNormalizedRect(obs.boundingBox, imageSize: imageSize, viewSize: geometry.size)
                    
                    BoxView(rectInView: rect, title: topTitle(for: obs))
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
            .allowsHitTesting(false)
        }
    }
    
    // MARK: - Helpers

    /// Convert Vision's normalized (0..1) bottom-left origin rect to view coords (top-left origin),
    /// accounting for aspect-fit letterboxing of the source image inside the view.
    
    private func mapNormalizedRect(_ bbox: CGRect, imageSize: CGSize, viewSize: CGSize) -> CGRect {
        guard imageSize.width > 0, imageSize.height > 0 else { return .zero }

        // Step 1: Calculate scale and padding
        let imageAspect = imageSize.width / imageSize.height
        let viewAspect = viewSize.width / viewSize.height

        let scale: CGFloat
        let xOffset: CGFloat
        let yOffset: CGFloat

        if imageAspect > viewAspect {
            // Image is wider than view → pad top and bottom
            scale = viewSize.width / imageSize.width
            let scaledImageHeight = imageSize.height * scale
            yOffset = (viewSize.height - scaledImageHeight) / 2
            xOffset = 0
        } else {
            // Image is taller than view → pad left and right
            scale = viewSize.height / imageSize.height
            let scaledImageWidth = imageSize.width * scale
            xOffset = (viewSize.width - scaledImageWidth) / 2
            yOffset = 0
        }

        // Step 2: Convert normalized bbox to image pixel coords
        let x = bbox.origin.x * imageSize.width
        let y = (1 - bbox.origin.y - bbox.height) * imageSize.height
        let width = bbox.width * imageSize.width
        let height = bbox.height * imageSize.height

        // Step 3: Scale to view space and add padding
        let scaledX = x * scale + xOffset
        let scaledY = y * scale + yOffset
        let scaledWidth = width * scale
        let scaledHeight = height * scale

        return CGRect(x: scaledX, y: scaledY, width: scaledWidth, height: scaledHeight)
    }
    
    private func topTitle(for obs: VNRecognizedObjectObservation) -> String {
        if let best = obs.labels.first {
            return String(format: "%@ %.0f%%", best.identifier, best.confidence * 100)
        }
        return "Object"
    }
}

private struct BoxView: View {
    let rectInView: CGRect
    let title: String
    
    var body: some View {
        let rr = RoundedRectangle(cornerRadius: 4, style: .continuous)
        
        return ZStack(alignment: .topLeading) {
            rr
                .stroke(style: StrokeStyle(lineWidth:2, lineCap: .round, lineJoin: .round))
                .foregroundStyle(Color.red)
            
            //Label chip
            Text(title)
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.black.opacity(0.7), in: Capsule())
                .foregroundStyle(.orange)
                .offset(x: 6, y: -14)
        }
        .frame(width: rectInView.width, height: rectInView.height, alignment: .topLeading)
        .position(x: rectInView.midX, y: rectInView.midY)
    }
}

#Preview {
    DetectionOverlay(imageSize: CGSize(width: 200, height: 300), observations: [.init(boundingBox: CGRect(x: 0.1, y: 0.1, width: 0.5, height: 0.5))])
}

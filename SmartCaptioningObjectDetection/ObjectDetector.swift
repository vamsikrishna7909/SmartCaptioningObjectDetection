//
//  ObjectDetection.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/7/25.
//

import Foundation
import Vision
import UIKit

class ObjectDetector {
    private let model: VNCoreMLModel
    init?() {
        guard let coreMLModel = try? YOLOv3TinyFP16(configuration: .init()).model,
              let visionModel = try? VNCoreMLModel(for: coreMLModel) else {
            print("Failed to load YOLOv3TinyFP16 model")
            return nil
        }
        self.model = visionModel
    }
    
    func detectObjects(in image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]) -> Void) {
        //Core Graphics Image because Vision deosn't work directly with UIImage
        guard let cgImage = image.cgImage else {
            print("No CGImage found")
            completion([])
            return
        }
        //Vision Request
        let request = VNCoreMLRequest(model: model) { result, error in
            if let error = error {
                print("Detection error: \(error)")
                completion([])
                return
            }
            let results = result.results as? [VNRecognizedObjectObservation] ?? []
            completion(results)
        }
        
        request.imageCropAndScaleOption = .scaleFill
        //Engine that executes Vision requests
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}

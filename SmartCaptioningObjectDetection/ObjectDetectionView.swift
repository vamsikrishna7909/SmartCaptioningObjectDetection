//
//  ObjectDetectionView.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/7/25.
//

import SwiftUI
import PhotosUI

struct ObjectDetectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showCamera = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    
    
    @StateObject private var viewModel = DetectionViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                if let image = selectedImage {
                Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                        .cornerRadius(12)
                        .background(Color.red)
                        .foregroundStyle(Color.clear)
                    DetectionOverlay(imageSize: image.size, observations: viewModel.detectedObjects)
                    if viewModel.detectedObjects.isEmpty {
                        Text("No objects detected")
                            .foregroundStyle(Color.gray)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
                    Text("Select an image to start detection")
                        .foregroundStyle(Color.gray)
                }
            }
            Spacer()
            HStack(spacing: 40) {
                Button("Camera") {
                    showCamera = true
                }
                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    Text("Photo Library")
                }
            }
            .font(.title3)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Object Detection")
        .sheet(isPresented: $showCamera, onDismiss: {
            if let image = selectedImage {
                viewModel.detect(in: image, modelContext: modelContext)
            }
        }) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    viewModel.detect(in: uiImage, modelContext: modelContext)
                }
            }
        }
    }
}

#Preview {
    ObjectDetectionView()
}

# SmartCaptioningObjectDetection
Captioning and Detecting the images/photos using Apples Foundation Models
# 📸 Smart Captioning & Object Detection App

An on-device iOS app built with **SwiftUI**, **Vision**, and **Core ML** that enables users to detect objects and generate captions for selected images or camera-captured photos. Results are stored using **SwiftData**, and the UI is fully native and responsive.

---

## 🚀 Features

- 📷 **Object Detection**
  - Load images via **camera** or **photo library**
  - On-device detection using YOLOv3 or MobileNet Core ML models
  - Bounding boxes with confidence levels

- 🖼️ **Image Captioning (Coming Soon)**
  - Auto-generates text descriptions for images using BLIP/Core ML models

- 💾 **Detection History**
  - Stores detected labels with timestamps using **SwiftData**
  - Supports deletion (individual or all) with haptic feedback and confirmation

- 🔊 **UX Enhancements**
  - Haptics & alert confirmations for destructive actions
  - Responsive SwiftUI interface with animation-ready structure

---

## 📱 Screenshots

| Detection | Overlay | History |
|----------|---------|---------|
| ![Detection](assets/detection.png) | ![Overlay](assets/overlay.png) | ![History](assets/history.png) |

---

## 🧠 Architecture

- **SwiftUI** – UI framework with NavigationStack & modern declarative patterns
- **SwiftData** – Used for persistent local storage of detection results
- **Vision + Core ML** – For object detection using YOLOv3 / MobileNet
- **Combine** – `@Published` + `@MainActor` for reactive state updates
- **UIKit Integration** – Used only for Camera (via `UIImagePickerController`)

---

## 📂 Folder Structure

SmartCaptioningObjectDetection/
│
├── Models/
│ └── DetectedItem.swift
│
├── ViewModels/
│ └── DetectionViewModel.swift
│
├── Views/
│ ├── ContentView.swift
│ ├── ObjectDetectionView.swift
│ ├── DetectionOverlay.swift
│ ├── DetectedItemListView.swift
│ └── ImagePicker.swift
│
├── ML Models/
│ └── YOLOv3Tiny.mlmodelc
│
└── Resources/
└── Assets.xcassets


---

## 🛠️ Requirements

- iOS 16.0+
- Xcode 15+
- Swift 5.9+
- Real device (camera access needed)

---

## 🧪 Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/vamsikrishna7909/SmartCaptioningObjectDetection.git
   cd SmartCaptioningObjectDetection


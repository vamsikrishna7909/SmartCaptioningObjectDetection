//
//  DetectedItemListView.swift
//  SmartCaptioningObjectDetection
//
//  Created by Vamsi Krishna Sivakavi on 9/22/25.
//

import SwiftUI
import SwiftData
import UIKit


enum HapticFeedback {
    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    static func rigitTap() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
}

struct DetectedItemListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \DetectedItem.createdAt, order: .reverse)
    private var detectedItems: [DetectedItem]
    
    @State private var showDeleteAllAlert = false
    
    var body: some View {
        List {
            if detectedItems.isEmpty {
                Text("No detection history yet")
                    .foregroundStyle(Color.gray)
            } else {
                ForEach(detectedItems, id: \.id) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.labels)
                            .font(.headline)
                        Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(Color.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle("Detection History")
        .listStyle(.insetGrouped)
        .toolbar {
            if !detectedItems.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        //deleteAllItems()
                        HapticFeedback.warning()
                        showDeleteAllAlert = true

                    } label: {
                        Label("Delete All", systemImage: "trash")
                    }
                }
            }
        }
        .alert("Delete All Items", isPresented: $showDeleteAllAlert) {
            Button("Delete All", role: .destructive) {
                deleteAllItems()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = detectedItems[index]
            modelContext.delete(item)
        }
        do {
            try modelContext.save() // ✅ Correct usage
            HapticFeedback.success()
        } catch {
            print("Failed to save context after deletion: \(error)")
        }
    }
    
    private func deleteAllItems() {
        for item in detectedItems {
            modelContext.delete(item)
        }
        do {
            try modelContext.save()
            HapticFeedback.success()
        } catch {
            print("Failed to delete all: \(error)")
        }
    }
}

#Preview {
    DetectedItemListView()
}

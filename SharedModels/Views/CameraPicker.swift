//
//  CameraPicker.swift
//  SharedUI
//

import SwiftUI

public struct CameraPicker: UIViewControllerRepresentable {
    public var onCapture: (UIImage) -> Void
    
    public init(onCapture: @escaping (UIImage) -> Void) {
        self.onCapture = onCapture
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.onCapture(uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

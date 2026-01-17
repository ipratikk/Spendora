//
//  AttachmentCarousel.swift
//  SharedUI
//

import SwiftUI
import PhotosUI
import SwiftyCrop

public enum AttachmentTapStyle {
    case viewer     // Tap opens ImageViewer
    case cropper    // Tap opens SwiftyCropView
}

public struct AttachmentCarousel: View {
    let title: String
    @Binding var attachments: [Data]
    
    let allowCamera: Bool
    let addLabel: String
    let usePolaroidStyle: Bool
    let tapStyle: AttachmentTapStyle
    
    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var showDeleteAllAlert = false
    
    // Viewer
    @State private var showViewer = false
    @State private var viewerIndex = 0
    
    // Cropper
    @State private var showCropper = false
    @State private var cropTargetIndex: Int?
    @State private var cropUIImage: UIImage?
    
    public init(
        title: String,
        attachments: Binding<[Data]>,
        allowCamera: Bool = true,
        addLabel: String = "Add",
        usePolaroidStyle: Bool = false,
        tapStyle: AttachmentTapStyle = .viewer
    ) {
        self.title = title
        self._attachments = attachments
        self.allowCamera = allowCamera
        self.addLabel = addLabel
        self.usePolaroidStyle = usePolaroidStyle
        self.tapStyle = tapStyle
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if attachments.isEmpty {
                AddAttachmentButton(
                    addLabel: addLabel,
                    onCamera: { showCamera = true },
                    onLibrary: { showPhotoPicker = true },
                    onRemoveAll: { showDeleteAllAlert = true },
                    hasAttachments: false
                )
                .frame(height: 200)
                .padding(.horizontal)
            } else {
                TabView {
                    ForEach(Array(attachments.enumerated()), id: \.offset) { index, data in
                        if let ui = UIImage(data: data) {
                            AttachmentCell(
                                uiImage: ui,
                                usePolaroid: usePolaroidStyle,
                                onDelete: { attachments.remove(at: index) },
                                onTap: {
                                    switch tapStyle {
                                    case .viewer:
                                        viewerIndex = index
                                        showViewer = true
                                    case .cropper:
                                        cropTargetIndex = index
                                        cropUIImage = ui
                                        showCropper = true
                                    }
                                }
                            )
                        }
                    }
                    
                    AddAttachmentButton(
                        addLabel: addLabel,
                        onCamera: { showCamera = true },
                        onLibrary: { showPhotoPicker = true },
                        onRemoveAll: { showDeleteAllAlert = true },
                        hasAttachments: !attachments.isEmpty
                    )
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: usePolaroidStyle ? UIScreen.main.bounds.width : 250)
            }
        }
        // ✅ Photo picker
        .photosPicker(isPresented: $showPhotoPicker, selection: $pickerItems, matching: .images)
        .onChange(of: pickerItems) { newItems in
            for newItem in newItems {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       UIImage(data: data) != nil {
                        attachments.append(data)
                    }
                }
            }
            pickerItems.removeAll()
        }
        // ✅ Camera
        .sheet(isPresented: $showCamera) {
            CameraPicker { ui in
                if let data = ui.jpegData(compressionQuality: 0.8) {
                    attachments.append(data)
                }
            }
        }
        // ✅ Viewer
        .fullScreenCover(isPresented: $showViewer) {
            ImageViewer(
                images: attachments,
                startIndex: viewerIndex,
                currentIndex: $viewerIndex
            )
        }
        // ✅ Cropper
        .sheet(isPresented: $showCropper) {
            if let ui = cropUIImage {
                NavigationView {
                    SwiftyCropView(
                        imageToCrop: ui,
                        maskShape: .square,
                        configuration: cropConfig,
                        onCancel: {
                            cropTargetIndex = nil
                            cropUIImage = nil
                            showCropper = false
                        },
                        onComplete: { cropped in
                            if let cropped,
                               let data = cropped.jpegData(compressionQuality: 0.8) {
                                if let idx = cropTargetIndex, idx < attachments.count {
                                    attachments[idx] = data
                                } else {
                                    attachments.append(data)
                                }
                            }
                            cropTargetIndex = nil
                            cropUIImage = nil
                            showCropper = false
                        }
                    )
                }
                .ignoresSafeArea()
            }
        }
        // ✅ Delete all
        .alert("Remove All?", isPresented: $showDeleteAllAlert) {
            Button("Delete All", role: .destructive) { attachments.removeAll() }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var cropConfig: SwiftyCropConfiguration {
        SwiftyCropConfiguration(
            maxMagnificationScale: 4.0,
            rotateImageWithButtons: true,
            usesLiquidGlassDesign: true,
            zoomSensitivity: 6.0,
            rectAspectRatio: 1
        )
    }
}

// MARK: - AttachmentCell
fileprivate struct AttachmentCell: View {
    let uiImage: UIImage
    let usePolaroid: Bool
    let onDelete: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if usePolaroid {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipped()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 6)
                    .onTapGesture { onTap() }
            } else {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipped()
                    .onTapGesture { onTap() }
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .padding(12)
        }
    }
}

// MARK: - AddAttachmentButton
fileprivate struct AddAttachmentButton: View {
    let addLabel: String
    let onCamera: () -> Void
    let onLibrary: () -> Void
    let onRemoveAll: () -> Void
    let hasAttachments: Bool
    
    var body: some View {
        Menu {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button(action: onCamera) {
                    Label("Take Photo", systemImage: "camera")
                }
            }
            
            Button(action: onLibrary) {
                Label("Choose from Library", systemImage: "photo.on.rectangle")
            }
            
            if hasAttachments {
                Button(role: .destructive, action: onRemoveAll) {
                    Label("Remove All", systemImage: "trash")
                }
            }
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                Text(addLabel)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
}

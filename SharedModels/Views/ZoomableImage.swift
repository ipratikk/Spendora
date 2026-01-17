//
//  ZoomableImage.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 16/09/25.
//


import SwiftUI

struct ZoomableImage: View {
    let uiImage: UIImage
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .scaleEffect(scale)
                .offset(offset)
            // Pinch gesture
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { _ in
                            lastScale = scale
                            if scale < 1 { resetZoom() }
                            clampOffset(in: size)
                        }
                )
            // Drag gesture only when zoomed
                .simultaneousGesture(
                    scale > 1 ?
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                            clampOffset(in: size)
                        }
                    : nil
                )
            // Double tap zoom/reset
                .onTapGesture(count: 2) {
                    if scale > 1 {
                        resetZoom()
                    } else {
                        withAnimation {
                            scale = 2
                            lastScale = 2
                        }
                    }
                }
                .animation(.easeInOut, value: scale)
                .animation(.easeInOut, value: offset)
                .background(Color.black)
                .ignoresSafeArea()
        }
    }
    
    // MARK: - Helpers
    private func resetZoom() {
        withAnimation {
            scale = 1
            lastScale = 1
            offset = .zero
            lastOffset = .zero
        }
    }
    
    private func clampOffset(in size: CGSize) {
        // available extra width/height after zoom
        let maxX = max(0, (size.width * scale - size.width) / 2)
        let maxY = max(0, (size.height * scale - size.height) / 2)
        
        // clamp values
        let clampedX = min(max(offset.width, -maxX), maxX)
        let clampedY = min(max(offset.height, -maxY), maxY)
        
        withAnimation {
            offset = CGSize(width: clampedX, height: clampedY)
            lastOffset = offset
        }
    }
}

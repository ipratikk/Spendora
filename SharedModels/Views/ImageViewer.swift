import SwiftUI

public struct ImageViewer: View {
    let images: [Data]
    let startIndex: Int
    
    @Binding var currentIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    public init(images: [Data], startIndex: Int, currentIndex: Binding<Int>) {
        self.images = images
        self.startIndex = startIndex
        self._currentIndex = currentIndex
    }
    
    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, data in
                if let ui = UIImage(data: data) {
                    ZoomableImage(uiImage: ui)
                        .tag(index)
                        .background(Color.black)
                        .ignoresSafeArea()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            currentIndex = startIndex
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

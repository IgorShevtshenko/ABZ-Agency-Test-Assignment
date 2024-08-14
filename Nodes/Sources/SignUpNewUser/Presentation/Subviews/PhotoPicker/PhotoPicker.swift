import SwiftUI
import UILibrary
import PhotosUI

struct PhotoPicker: View {
    
    @Binding private var photo: Data?
    
    @State private var isPickerActive = false
    @State private var isCameraActive = false
    @State private var isGalleryActive = false
    @State private var photosPickerItem: PhotosPickerItem?
    
    init(photo: Binding<Data?>) {
        _photo = photo
    }
    
    var body: some View {
        PrimaryTextField(
            text: .constant(""),
            isErrorActive: .constant(false)
        )
        .updatePlaceholder("Upload your photo")
        .updateIsEnabled(false)
        .updateTrailingContent {
            Button(action: { isPickerActive = true }) {
                Text(photo == nil ? "Upload" : "Reupload")
            }
            .buttonStyle(.secondary)
            .padding(.trailing, 8)
        }
        .confirmationDialog("", isPresented: $isPickerActive) {
            Button("Camera") {
                isCameraActive = true
            }
            Button("Gallery") {
                isGalleryActive = true
            }
            Button("Cancel", role: .cancel) {
                isPickerActive = false
            }
        } message: {
            Text("Choose how you want to add a photo")
        }
        .fullScreenCover(isPresented: $isCameraActive) {
            CameraPicker { image in
                photo = image.jpegData(compressionQuality: 1)
            }
        }
        .photosPicker(
            isPresented: $isGalleryActive,
            selection: $photosPickerItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: photosPickerItem) { _, newPhoto in
            Task {
                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                    photo = data
                }
            }
        }
    }
}

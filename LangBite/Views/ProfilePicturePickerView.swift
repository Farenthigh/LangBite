//
//  ProfilePicturePickerView.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage

struct ProfilePictureView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var fav: FavoritesViewModel // optional if needed
    @State private var pickedImage: UIImage?
    @State private var showPicker = false
    @State private var isUploading = false
    @State private var uploadError: String?

    var body: some View {
        VStack(spacing: 16) {
            if let urlString = auth.currentUser?.avatar, let url = URL(string: urlString) {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            } else if let ui = pickedImage {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 120, height: 120)
            }

            Button("เลือกรูป") { showPicker = true }
            if pickedImage != nil {
                Button(action: { Task { await upload() } }) {
                    if isUploading { ProgressView() } else { Text("อัพโหลด") }
                }
                .disabled(pickedImage == nil || isUploading)
                .buttonStyle(.borderedProminent)
            }

            if let err = uploadError {
                Text(err).foregroundColor(.red).font(.caption)
            }
        }
        .sheet(isPresented: $showPicker) {
            PhotoPicker(image: $pickedImage)
        }
        .padding()
    }

    // MARK: - Upload (using putData, simpler)
    func upload() async {
        // 1) unwrap needed values
        guard let user = auth.currentUser else {
            uploadError = "User not logged in"
            return
        }
        guard let image = pickedImage else {
            uploadError = "No image selected"
            return
        }

        isUploading = true
        uploadError = nil

        // Convert to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            uploadError = "Cannot convert image to data"
            isUploading = false
            return
        }

        do {
            // If you use default bucket configured in GoogleService-Info.plist:
            let storage = Storage.storage()
            let storageRef = storage.reference()

            // choose a path (e.g., avatars/{userId}.jpg or with UUID)
            let filename = "avatars/\(UUID().uuidString).jpg"
            let imageRef = storageRef.child(filename)

            // Upload using putData (no temp file required)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            var imgURL = try await uploadImage(data: imageData)
            print(imgURL)

            // Get download URL

            // Update your user model / backend with downloadURL.absoluteString
            // Example: auth.updateAvatar(url: downloadURL.absoluteString)  (implement this)
            // Optionally set in local user:
            auth.currentUser?.avatar = imgURL.absoluteString
            try await auth.UpdataAvatar()

        } catch {
            uploadError = error.localizedDescription
        }

        isUploading = false
    }

    // Helper: convert callback-style putData to async/await
    func uploadImage(data: Data) async throws -> URL {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference().child("avatars/\(filename).jpg")

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            
            ref.putData(data, metadata: nil) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                ref.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let downloadURL = url else {
                        continuation.resume(throwing: URLError(.badURL))
                        return
                    }

                    continuation.resume(returning: downloadURL)
                }
            }
        }
    }
}

// Preview (adjust env objects as needed)
#Preview {
    ProfilePictureView()
        .environmentObject(AuthViewModel())
        .environmentObject(FavoritesViewModel())
}


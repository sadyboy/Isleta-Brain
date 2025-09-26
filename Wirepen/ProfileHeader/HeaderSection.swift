import Foundation
import SwiftUI
import PhotosUI

 struct HeaderSection: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                if let data = userViewModel.currentUser.avatarImageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    
                } else {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 32).stroke(Color.text1, lineWidth: 1)
                        }
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        )
                        .shadow(radius: 2)
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        userViewModel.updateAvatar(with: uiImage)
                    }
                }
            }

            
            VStack(alignment: .leading, spacing: 6) {
                TextField("Your Name", text: $userViewModel.currentUser.username)
                .font(.headline)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 160)

                Text("Ready to Workout?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text("\(userViewModel.currentUser.virtualCurrency)")
                        .font(.headline)
                    Image(.orl).renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                }
                Text("XP: \(userViewModel.currentUser.experience)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.08)))
        }
        .padding(.horizontal)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    userViewModel.updateAvatar(with: uiImage)
                }
            }
        }
    }

}


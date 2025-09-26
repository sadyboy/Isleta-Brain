import Foundation
import SwiftUI


// MARK: ExampleCard
struct ExampleCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            Text(description).foregroundColor(.secondary)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.1))
                .frame(height: 100)
                .overlay(Image(systemName: "photo").foregroundColor(.blue))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

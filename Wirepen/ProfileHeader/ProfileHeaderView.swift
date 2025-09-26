import Foundation
import SwiftUI

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.title2)
                        .bold()
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text(user.username)
                                    .font(.headline)
                                    .lineLimit(2)
                            )
                    Text(" Level \(user.level)")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("\(user.virtualCurrency) 💎")
                    .font(.headline)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }

            ProgressView(value: Double(user.experience % 1000) / 1000.0)
                .progressViewStyle(.linear)
                .overlay(
                    Text("\(user.experience % 1000)/1000 XP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                )
        }
        .padding(.vertical, 8)
    }
}

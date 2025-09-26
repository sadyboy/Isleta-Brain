import Foundation
import SwiftUI

struct AchievementRowView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: achievement.icon)
                    .foregroundColor(achievement.color)
                Text(achievement.title)
                    .font(.headline)
                Spacer()
                if achievement.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(achievement.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                ProgressView(value: achievement.progress)
                    .progressViewStyle(.linear)
                Text("\(Int(achievement.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("\(achievement.reward) 💎")
                .font(.caption)
                .padding(4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
    }
}

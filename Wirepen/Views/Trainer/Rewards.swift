import Foundation
import SwiftUI

// MARK: RewardsView
struct RewardsView: View {
    let reward: LessonReward
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎁 Lesson Rewards")
                .font(.headline)
            
            HStack {
                Label("\(reward.xp) XP", systemImage: "star.fill")
                    .foregroundColor(.orange)
                Label("\(reward.currency) 💎", systemImage: "diamond.fill")
                    .foregroundColor(.blue)
            }
            
            if !reward.skills.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Skills to be developed:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ForEach(reward.skills, id: \.self) { skill in
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text(skill)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(12)
    }
}

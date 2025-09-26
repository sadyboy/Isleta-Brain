import Foundation
import SwiftUI

struct AchievementBadgeView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color.opacity(0.2) : Color.text1.opacity(0.5))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: achievement.icon)
                            .font(.system(size: 36))
                            .foregroundColor(achievement.isUnlocked ? achievement.color : .white)
                    )
                
                if achievement.isUnlocked {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .offset(x: 25, y: 25)
                        .transition(.scale)
                }
            }
            
            Text(achievement.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text(achievement.title)
                            .font(.subheadline)
                    )
            
            ProgressView(value: achievement.progress)
                .progressViewStyle(.linear)
                .tint(achievement.color)
                .frame(width: 120)
            
            Text("\(Int(achievement.progress * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.4)))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .animation(.spring(), value: achievement.isUnlocked)
    }
}

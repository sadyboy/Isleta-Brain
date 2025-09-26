//
import Foundation
import SwiftUI

enum AchievementCategory: String, Codable {
    case lesson
    case practice
    case probability
    case strategy
    case quiz
    case analysis
}

// MARK: - Models
struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: AchievementCategory
    let reward: Int
    
    var progress: Double
    var isUnlocked: Bool
    var unlockCondition: String
    
    var icon: String {
        switch category {
            case .quiz: return "questionmark.circle.fill"
            case .lesson: return "book.fill"
            case .practice: return "figure.walk"
            case .strategy: return "brain"
            case .probability: return "percent"
            case .analysis: return "chart.bar.fill"
        }
    }
    
    var color: Color {
        switch category {
            case .quiz: return .yellow
            case .lesson: return .blue
            case .practice: return .green
            case .strategy: return .orange
            case .probability: return .pink
            case .analysis: return .indigo
        }
    }
}


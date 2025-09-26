import Foundation
import Combine
import SwiftUI


class AchievementsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var leaderboard: [LeaderboardEntry] = []
    @Published var selectedTimeFrame: TimeFrame = .week
    
    private var cancellables = Set<AnyCancellable>()
    
    enum TimeFrame {
        case day, week, month, allTime
    }
    
    private let leaderboardKey = "saved_leaderboard"
    
    init() {
        loadAchievements()
        loadLeaderboard()
    }

    func loadLeaderboard() {
        if let data = UserDefaults.standard.data(forKey: leaderboardKey),
           let saved = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            leaderboard = saved.sorted { $0.points > $1.points }
                .enumerated()
                .map { index, entry in
                    LeaderboardEntry(username: entry.username, points: entry.points, rank: index + 1)
                }
        }
    }
    
    private func saveLeaderboard() {
        if let data = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(data, forKey: leaderboardKey)
        }
    }
    
    func addRecord(username: String, points: Int) {
        var entries = leaderboard
        entries.append(LeaderboardEntry(username: username, points: points, rank: entries.count + 1))
        
        leaderboard = entries.sorted { $0.points > $1.points }
            .enumerated()
            .map { index, entry in
                LeaderboardEntry(username: entry.username, points: entry.points, rank: index + 1)
            }
        
        saveLeaderboard()
    }
    func loadAchievements() {
        achievements = [
            Achievement(
                title: "First Step",
                description: "Complete 1 lesson",
                category: .lesson,
                reward: 500,
                progress: 0,
                isUnlocked: false,
                unlockCondition: "Complete at least one lesson"
            ),
            Achievement(
                title: "Practitioner",
                description: "Complete 10 exercises",
                category: .practice,
                reward: 1000,
                progress: 0,
                isUnlocked: false,
                unlockCondition: "Complete 10 practice assignments"
            ),
            Achievement(
                title: "Probability Master",
                description: "Solve 20 probability problems",
                category: .probability,
                reward: 1500,
                progress: 0,
                isUnlocked: false,
                unlockCondition: "20 assignments with category 'Probability"
            ),
            Achievement(
                title: "Tactician",
                description: "Win 5 difficult quizzes",
                category: .strategy,
                reward: 2000,
                progress: 0,
                isUnlocked: false,
                unlockCondition: "Win 5 hard level quizzes"
            )
        ]
    }
    
}
extension AchievementsViewModel {
    func registerLessonCompleted() {
        updateAchievement(category: .lesson, progressStep: 1.0) // First Step
    }
    
    func registerPracticeCompleted() {
        updateAchievement(category: .practice, progressStep: 0.1) // Practitioner
        updateAchievement(category: .probability, progressStep: 0.05) // Probability Master
    }
    
    func registerQuizResult(score: Int, quiz: Quiz?) {
        updateAchievement(category: .quiz, progressStep: 0.1)
        
        if score > 500 {
            updateAchievement(category: .analysis, progressStep: 0.3)
        }
        
        if quiz?.difficulty == .hard {
            updateAchievement(category: .strategy, progressStep: 0.25) // Tactician
        }
    }
    
    private func updateAchievement(category: AchievementCategory, progressStep: Double) {
        if let index = achievements.firstIndex(where: { $0.category == category }) {
            achievements[index].progress += progressStep
            if achievements[index].progress >= 1.0 {
                achievements[index].progress = 1.0
                achievements[index].isUnlocked = true
            }
        }
    }
}


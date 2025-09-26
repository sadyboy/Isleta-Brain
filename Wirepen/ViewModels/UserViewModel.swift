import Foundation
import Combine
import PhotosUI
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var notifications: [String] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var currentUser: User {
            didSet {
                saveUser()
            }
        }
    init(user: User? = nil) {
        if let saved = UserDefaults.standard.data(forKey: "currentUser"),
           let decoded = try? JSONDecoder().decode(User.self, from: saved) {
            self.currentUser = decoded
        } else {
            self.currentUser = user ?? User(username: "Guest")
        }
    }
    
    func updateAvatar(with image: UIImage?) {
            if let image = image,
               let data = image.jpegData(compressionQuality: 0.8) {
                currentUser.avatarImageData = data
            } else {
                currentUser.avatarImageData = nil
            }
        }
    
    // MARK: - Save / Load
    private func saveUser() {
        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }

    // MARK: - User Progress
    func addExperience(_ points: Int) {
        currentUser.experience += points
        checkLevelUp()
    }
    
    private func checkLevelUp() {
        let experienceNeeded = currentUser.level * 1000
        if currentUser.experience >= experienceNeeded {
            currentUser.level += 1
            addNotification("Congratulations! You have reached level \(currentUser.level)!")
        }
    }
    
    // MARK: - Virtual Currency
    func addCurrency(_ amount: Int) {
        currentUser.virtualCurrency += amount
    }
    
    // MARK: - Badges
    func awardBadge(_ badge: Badge) {
        if !currentUser.badges.contains(where: { $0.id == badge.id }) {
            currentUser.badges.append(badge)
            addNotification("New badge received: \(badge.name)!")
        }
    }
    
    // MARK: - Notifications
    private func addNotification(_ message: String) {
        notifications.append(message)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.notifications.removeFirst()
        }
    }
    
    // MARK: - Statistics
    func updateStatistics(lessonCompleted: Bool = false, quizWon: Bool = false, correctAnswer: Bool = false) {
        if lessonCompleted {
            currentUser.completedLessons += 1
        }
        if quizWon {
            currentUser.quizWins += 1
        }
        if correctAnswer {
            currentUser.correctAnswers += 1
        }
    }
}



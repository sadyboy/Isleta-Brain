import Foundation
struct User: Identifiable, Codable {
    let id: UUID
    var username: String
    var level: Int
    var experience: Int
    var badges: [Badge]
    var virtualCurrency: Int
    
    var completedLessons: Int
    var quizWins: Int
    var correctAnswers: Int
    var avatarImageData: Data?
    
    init(id: UUID = UUID(), username: String) {
        self.id = id
        self.username = username
        self.level = 1
        self.experience = 0
        self.badges = []
        self.virtualCurrency = 0
        self.completedLessons = 0
        self.quizWins = 0
        self.correctAnswers = 0
        self.avatarImageData = nil
    }
}

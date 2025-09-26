import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let username: String
    let points: Int
    let rank: Int
}

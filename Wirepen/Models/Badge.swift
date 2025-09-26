import Foundation

struct Badge: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let imageSystemName: String
    let type: BadgeType
    
    enum BadgeType: String, Codable {
        case mathematician
        case strategist
        case quizMaster
        case analyst
        case champion
    }
}

import Foundation
import Combine
import SwiftUI

class QuizDataService {
    static let shared = QuizDataService()
    private init() {}
    
    func loadQuizCategories() -> AnyPublisher<[QuizCategory], Error> {
        guard let url = Bundle.main.url(forResource: "quiz_data", withExtension: "json") else {
            return Fail(error: DataError.fileNotFound).eraseToAnyPublisher()
        }
        
        return Future { promise in
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(QuizCategoriesResponse.self, from: data)
                promise(.success(response.categories))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadThemeAssets() -> AnyPublisher<ThemeAssets, Error> {
        guard let url = Bundle.main.url(forResource: "theme_assets", withExtension: "json") else {
            return Fail(error: DataError.fileNotFound).eraseToAnyPublisher()
        }
        
        return Future { promise in
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let themeAssets = try decoder.decode(ThemeAssets.self, from: data)
                promise(.success(themeAssets))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Models
struct QuizCategoriesResponse: Codable {
    let categories: [QuizCategory]
}

struct QuizCategory: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: String
    let quizzes: [Quiz]
}

struct Quiz: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let difficulty: QuizDifficulty
    let questions: [Question]
}

struct Question: Codable, Identifiable {
    let id: String
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

enum QuizDifficulty: String, Codable {
    case easy
    case medium
    case hard
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var title: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    var timeLimit: Int {
        switch self {
        case .easy: return 30
        case .medium: return 20
        case .hard: return 15
        }
    }
    
    var points: Int {
        switch self {
        case .easy: return 10
        case .medium: return 20
        case .hard: return 30
        }
    }
}

struct ThemeAssets: Codable {
    let themes: [ThemeData]
    let commonAssets: CommonAssets
    
    enum CodingKeys: String, CodingKey {
        case themes
        case commonAssets = "common_assets"
    }
}

struct ThemeData: Codable {
    let id: String
    let assets: ThemeAssetData
}

struct ThemeAssetData: Codable {
    let headerImage: String
    let background: String
    let icons: [String: String]
    let illustrations: [String]
    
    enum CodingKeys: String, CodingKey {
        case headerImage = "header_image"
        case background
        case icons
        case illustrations
    }
}

struct CommonAssets: Codable {
    let backgrounds: [String: [String]]
    let animations: [String: String]
}

enum DataError: Error {
    case fileNotFound
    case decodingError
}

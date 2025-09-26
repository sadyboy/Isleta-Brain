import Foundation
import Combine
import SwiftUI

class UtilitiesViewModel: ObservableObject {
    @Published var selectedCalculator: CalculatorType = .poker
    @Published var pokerCalculatorState = PokerCalculatorState()
    @Published var probabilityCalculatorState = ProbabilityCalculatorState()
    @Published var upcomingEvents: [SportEvent] = []
    @Published var showingResult = false
    @Published var calculationResult: CalculationResult?
    
    private let analyticsService = AnalyticsService.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum CalculatorType: String, CaseIterable {
        case poker = "Poker"
        case probability = "Probabilities"
        var icon: String {
            switch self {
            case .poker: return "orl"
            case .probability: return "orlProce"
            }
        }
        
        var color: Color {
            switch self {
            case .poker: return .purple
            case .probability: return .blue
            }
        }
    }
    
  
    func calculatePokerOdds() {
        let situation = GameSituation(
            currentScore: pokerCalculatorState.stack,
            difficulty: pokerCalculatorState.position.difficulty,
            timeRemaining: 60
        )
        
        let analysis = analyticsService.calculateProbabilities(for: situation)
        
        calculationResult = CalculationResult(
            mainValue: analysis.winProbability,
            description: "Probability of winning",
            recommendations: analysis.recommendedActions,
            riskLevel: analysis.riskLevel
        )
        
        showingResult = true
    }
    
    func calculateEventProbability() {
        var parameters: [String: Double] = [:]
        parameters["historical"] = probabilityCalculatorState.historicalData
        parameters["current"] = probabilityCalculatorState.currentForm
        parameters["external"] = probabilityCalculatorState.externalFactors
        
        let probability = parameters.values.reduce(0, +) / Double(parameters.count)
        
        calculationResult = CalculationResult(
        mainValue: probability,
        description: "Probability of an event",
        recommendations: [
        "Consider historical statistics",
        "Analyze current form",
        "Consider external factors"
        ],
        riskLevel: getRiskLevel(for: probability)
        )
        
        showingResult = true
    }

    
    private func getRiskLevel(for probability: Double) -> ProbabilityAnalysis.RiskLevel {
        switch probability {
        case 0.0...0.3: return .high
        case 0.3...0.7: return .medium
        default: return .low
        }
    }
    
}

// MARK: - Models
struct PokerCalculatorState {
    var stack: Int = 1000
    var position = Position.middle
    var handStrength: Double = 0.5
    var opponentRange: Double = 0.5
    
    enum Position: String, CaseIterable {
    case early = "Early"
    case middle = "Middle"
    case late = "Late"
        var difficulty: Double {
            switch self {
            case .early: return 0.7
            case .middle: return 0.5
            case .late: return 0.3
            }
        }
    }
}


struct ProbabilityCalculatorState {
    var historicalData: Double = 0.5
    var currentForm: Double = 0.5
    var externalFactors: Double = 0.5
}

struct CalculationResult {
    let mainValue: Double
    let description: String
    let recommendations: [String]
    let riskLevel: ProbabilityAnalysis.RiskLevel
    
    var formattedValue: String {
        "\(Int(mainValue * 100))%"
    }
    
    var riskColor: Color {
        switch riskLevel {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct SportEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let type: SportType
    let importance: EventImportance
    let odds: Double
    
    enum SportType {
        case football
        case basketball
        case tennis
        case poker
        
        var icon: String {
            switch self {
            case .football: return "soccerball"
            case .basketball: return "basketball"
            case .tennis: return "tennis.racket"
            case .poker: return "suit.spade.fill"
            }
        }
    }
    
    enum EventImportance {
        case low
        case medium
        case high
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
}
extension UtilitiesViewModel {
    var canCalculatePoker: Bool { pokerCalculatorState.stack > 0 }
    func apply(preset: PokerPresetsBar.Preset) {
        switch preset {
        case .shortStack:
            pokerCalculatorState.stack = 20
            pokerCalculatorState.position = .late
        case .threeBetPot:
            pokerCalculatorState.stack = 80
            pokerCalculatorState.position = .middle
        case .icmBubble:
            pokerCalculatorState.stack = 15
            pokerCalculatorState.position = .early
        }
    }
}

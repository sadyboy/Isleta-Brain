import Foundation
import Combine

class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func analyzeProgress(_ user: User) -> UserProgressAnalysis {
        let completionRate = calculateCompletionRate(user)
        let learningStyle = determineLearningStyle(user)
        let strengths = identifyStrengths(user)
        let weaknesses = identifyWeaknesses(user)
        
        return UserProgressAnalysis(
            completionRate: completionRate,
            learningStyle: learningStyle,
            strengths: strengths,
            weaknesses: weaknesses
        )
    }
    
    func generateLearningPlan(based analysis: UserProgressAnalysis) -> LearningPlan {
        let recommendedTopics = selectTopics(based: analysis)
        let dailyGoals = calculateDailyGoals(analysis)
        let estimatedCompletion = calculateEstimatedCompletion(analysis)
        
        return LearningPlan(
            recommendedTopics: recommendedTopics,
            dailyGoals: dailyGoals,
            estimatedCompletion: estimatedCompletion
        )
    }

    func calculateProbabilities(for situation: GameSituation) -> ProbabilityAnalysis {
        let winProbability = calculateWinProbability(situation)
        let riskLevel = assessRiskLevel(situation)
        let recommendedActions = generateRecommendedActions(situation)
        
        return ProbabilityAnalysis(
            winProbability: winProbability,
            riskLevel: riskLevel,
            recommendedActions: recommendedActions
        )
    }
    
    private func calculateWinProbability(_ situation: GameSituation) -> Double {
        var probability = 1.0 - situation.difficulty

        let timeFactorWeight = 0.2
        let timeFactor = situation.timeRemaining / 60.0
        probability += timeFactor * timeFactorWeight
        
        let scoreFactorWeight = 0.3
        let scoreFactor = Double(situation.currentScore) / 1000.0
        probability += scoreFactor * scoreFactorWeight
        
        return min(max(probability, 0.1), 0.9)
    }
    
    private func assessRiskLevel(_ situation: GameSituation) -> ProbabilityAnalysis.RiskLevel {
        let winProbability = calculateWinProbability(situation)
        
        switch winProbability {
        case 0.0...0.3:
            return .high
        case 0.3...0.7:
            return .medium
        default:
            return .low
        }
    }
    
    private func generateRecommendedActions(_ situation: GameSituation) -> [String] {
        var recommendations: [String] = []
        let winProbability = calculateWinProbability(situation)
        let riskLevel = assessRiskLevel(situation)
        
        if winProbability < 0.3 {
        recommendations.append("Focus on a defensive strategy")
        recommendations.append("Minimize risks")
        } else if winProbability > 0.7 {
        recommendations.append("Use an aggressive strategy")
        recommendations.append("Maximize your advantage")
        } else {
        recommendations.append("Stick to a balanced strategy")
        }

        // Recommendations based on time remaining
        if situation.timeRemaining < 30 {
        recommendations.append("Speed ​​up your decision-making")
        } else if situation.timeRemaining > 120 {
        recommendations.append("Carefully analyze each decision")
        }

        // Recommendations based on the current score
        if situation.currentScore < 500 {
        recommendations.append("Focus on accumulating points")
        } else if situation.currentScore > 2000 {
        recommendations.append("Maintain your current advantage")
        }
        
        return recommendations
    }
    
    private func calculateCompletionRate(_ user: User) -> Double {
        let lessonCompletion = Double(user.completedLessons) / 50.0
        let quizCompletion = Double(user.quizWins) / 20.0
        
        return (lessonCompletion + quizCompletion) / 2.0
    }
    
    private func determineLearningStyle(_ user: User) -> LearningStyle {
        if user.quizWins > user.completedLessons {
            return .practical
        } else if user.correctAnswers > user.completedLessons * 2 {
            return .theoretical
        } else {
            return .balanced
        }
    }
    
    private func identifyStrengths(_ user: User) -> [SkillArea] {
        var strengths: [SkillArea] = []
        
        if Double(user.correctAnswers) / Double(max(user.completedLessons, 1)) > 0.8 {
            strengths.append(.problemSolving)
        }
        
        if user.quizWins > 10 {
            strengths.append(.quickThinking)
        }
        
        return strengths
    }
    
    private func identifyWeaknesses(_ user: User) -> [SkillArea] {
        var weaknesses: [SkillArea] = []
        
        if Double(user.correctAnswers) / Double(max(user.completedLessons, 1)) < 0.6 {
            weaknesses.append(.theoreticalKnowledge)
        }
        
        if user.quizWins < 5 {
            weaknesses.append(.practicalApplication)
        }
        
        return weaknesses
    }
    
    private func selectTopics(based analysis: UserProgressAnalysis) -> [LearningTopic] {
        var topics: [LearningTopic] = []
        
        for weakness in analysis.weaknesses {
            switch weakness {
            case .theoreticalKnowledge:
                topics.append(.probabilityTheory)
                topics.append(.statisticalAnalysis)
            case .practicalApplication:
                topics.append(.practicalExercises)
                topics.append(.realWorldCases)
            default:
                topics.append(.basicConcepts)
            }
        }
        
        return topics
    }
    
    private func calculateDailyGoals(_ analysis: UserProgressAnalysis) -> [DailyGoal] {
        switch analysis.learningStyle {
        case .practical:
            return [
                DailyGoal(type: .exercise, count: 3),
                DailyGoal(type: .quiz, count: 2)
            ]
        case .theoretical:
            return [
                DailyGoal(type: .lesson, count: 2),
                DailyGoal(type: .exercise, count: 1)
            ]
        case .balanced:
            return [
                DailyGoal(type: .lesson, count: 1),
                DailyGoal(type: .exercise, count: 2),
                DailyGoal(type: .quiz, count: 1)
            ]
        }
    }
    
    private func calculateEstimatedCompletion(_ analysis: UserProgressAnalysis) -> Date {
        let remainingProgress = 1.0 - analysis.completionRate
        let daysNeeded = Int(remainingProgress * 30) 
        return Calendar.current.date(byAdding: .day, value: daysNeeded, to: Date()) ?? Date()
    }
}

// MARK: - Models
struct UserProgressAnalysis {
    var completionRate: Double
    let learningStyle: LearningStyle
    let strengths: [SkillArea]
    let weaknesses: [SkillArea]
    
}

enum LearningStyle {
    case practical
    case theoretical
    case balanced
}

enum SkillArea {
    case problemSolving
    case quickThinking
    case theoreticalKnowledge
    case practicalApplication
    case strategicThinking
}

struct LearningPlan {
    let recommendedTopics: [LearningTopic]
    let dailyGoals: [DailyGoal]
    let estimatedCompletion: Date
}


struct DailyGoal {
    let type: GoalType
    let count: Int

    enum GoalType: Identifiable {
        case lesson
        case exercise
        case quiz

        var id: String {
            switch self {
            case .lesson: return "lesson"
            case .exercise: return "exercise"
            case .quiz: return "quiz"
            }
        }
    }
}

struct GameSituation {
    let currentScore: Int
    let difficulty: Double
    let timeRemaining: TimeInterval
}

struct ProbabilityAnalysis {
    let winProbability: Double
    let riskLevel: RiskLevel
    let recommendedActions: [String]
    
    enum RiskLevel {
        case low
        case medium
        case high
    }
}

import Foundation
import Combine

class AIService {
    static let shared = AIService()
    
    private init() {}
    
    func analyzeUserProgress(_ user: User) -> AnyPublisher<[AIRecommendation], Never> {
        return Future<[AIRecommendation], Never> { promise in
            var recommendations: [AIRecommendation] = []
            
            let correctAnswerRate = Double(user.correctAnswers) / max(Double(user.completedLessons * 3), 1.0)
            if correctAnswerRate < 0.7 {
                recommendations.append(
                    AIRecommendation(
                        content: "I notice you're having difficulty with some topics. I suggest starting with basic lessons on probability theory.",
                        priority: .high
                    )
                )
            }
            if user.quizWins < 5 {
                recommendations.append(
                    AIRecommendation(
                        content: "Try participating in more quizzes - they're a great way to reinforce knowledge in a fun way!",
                        priority: .medium
                    )
                )
            }
            if user.completedLessons > 0 && user.completedLessons < 10 {
                recommendations.append(
                    AIRecommendation(
                        content: "For best results, I recommend completing at least 2-3 lessons per week.",
                        priority: .medium
                    )
                )
            }
            if user.completedLessons < 5 {
                recommendations.append(
                    AIRecommendation(
                        content: "Practice is essential! Try solving more exercises to consolidate your skills.",
                        priority: .high
                    )
                )
            }
            if user.quizWins < 3 {
                recommendations.append(
                    AIRecommendation(
                        content: "Consistency matters. Even 10-15 minutes a day can keep your learning streak alive!",
                        priority: .medium
                    )
                )
            }
            if user.level <= 1 {
                recommendations.append(
                    AIRecommendation(
                        content: "Start with the 'Basic Concepts' section. It will give you a solid foundation for advanced topics.",
                        priority: .high
                    )
                )
            }
            if user.level >= 3 && user.completedLessons < 15 {
                recommendations.append(
                    AIRecommendation(
                        content: "You already know a lot, but need more applied tasks. Try advanced exercises and real-world cases!",
                        priority: .medium
                    )
                )
            }
            if user.experience < 500 {
                recommendations.append(
                    AIRecommendation(
                        content: "Earn more XP by completing short quizzes and quick exercises. They’re great for leveling up faster!",
                        priority: .low
                    )
                )
            }
            recommendations.append(
                AIRecommendation(
                    content: "Remember to take breaks — your brain learns better when you combine study with rest.",
                    priority: .low
                )
            )
            
            promise(.success(recommendations))
        }.eraseToAnyPublisher()
    }

    
    func generatePersonalizedExercise(based on: [PracticeExercise], user: User) -> AnyPublisher<PracticeExercise, Never> {
        return Future<PracticeExercise, Never> { promise in
            let difficulty = self.calculateDifficulty(for: user)
            let exercise = PracticeExercise(
                title: "Personalized task",
                type: self.selectExerciseType(based: on),
                points: self.calculatePoints(difficulty: difficulty),
                content: self.generateContent(difficulty: difficulty, user: user)
            )
            promise(.success(exercise))
        }.eraseToAnyPublisher()
    }
    
    private func calculateDifficulty(for user: User) -> Double {
        let baseLevel = Double(user.level) / 10.0
        let successRate = Double(user.correctAnswers) / max(Double(user.completedLessons), 1.0)
        return min(max(baseLevel + successRate, 0.3), 1.0)
    }
    
    private func selectExerciseType(based exercises: [PracticeExercise]) -> ExerciseType {
        let counts = exercises.reduce(into: [:]) { counts, exercise in
            counts[exercise.type, default: 0] += 1
        }
        return counts.min(by: { $0.value < $1.value })?.key ?? .probability
    }
    
    private func calculatePoints(difficulty: Double) -> Int {
        return Int(difficulty * 200)
    }
    
    private func generateContent(difficulty: Double, user: User) -> String {
        let topics = ["probabilities", "statistics", "data analysis", "strategic thinking"]
        let topic = topics[Int.random(in: 0..<topics.count)]
        
        return """
    Based on your level and previous results, I propose a problem on topic "\(topic)".
    
    Analyze the given situation and apply your acquired knowledge to solve it.
    """
    }
}

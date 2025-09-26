import Foundation
import Combine
struct PracticeStats: Codable {
    var completed: Int
    var accuracy: Double
    var streak: Int
}
class TrainerViewModel: ObservableObject {
    @Published var availableLessons: [Lesson] = []
    @Published var aiRecommendations: [AIRecommendation] = []
    @Published var practiceExercises: [PracticeExercise] = []
    @Published var learningPlan: LearningPlan?
    @Published var progressAnalysis: UserProgressAnalysis?
    @Published var dailyProgress: [DailyGoal] = []
    
    @Published var practiceStats = PracticeStats(completed: 0, accuracy: 0, streak: 0)
    private var cancellables = Set<AnyCancellable>()
    private let aiService = AIService.shared
    private let analyticsService = AnalyticsService.shared
    
    init() {
        loadProgress()
        loadContent()
        refreshContents()
        setupSubscriptions()
        refreshContent()
    }
    
    private func setupSubscriptions() {
        Timer.publish(every: 20, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if let data = UserDefaults.standard.data(forKey: "currentUser"),
                   let user = try? JSONDecoder().decode(User.self, from: data) {
                    self?.loadRecommendations(for: user)
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshContent() {
        let lastReset = UserDefaults.standard.object(forKey: "lastGoalReset") as? Date ?? .distantPast
        if !Calendar.current.isDate(lastReset, inSameDayAs: Date()) {
            dailyProgress = [
                DailyGoal(type: .lesson, count: 2),
                DailyGoal(type: .exercise, count: 5),
                DailyGoal(type: .quiz, count: 1)
            ]
            UserDefaults.standard.set(Date(), forKey: "lastGoalReset")
        }
        loadContent()
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            loadRecommendations(for: user)
        }
        updateLearningPlan()
        if progressAnalysis == nil {
            progressAnalysis = UserProgressAnalysis(
                completionRate: 0,
                learningStyle: .theoretical,
                strengths: [.practicalApplication, .problemSolving],
                weaknesses: [.quickThinking]
            )
        }
        if practiceStats.completed == 0 {
            practiceStats = PracticeStats(completed: 12, accuracy: 0.85, streak: 5)
        }
        
    }
    
    func completeLesson(_ lesson: Lesson) {
        if let index = availableLessons.firstIndex(where: { $0.id == lesson.id }) {
            availableLessons[index].isCompleted = true
            practiceStats.completed += 1
            progressAnalysis?.completionRate = Double(availableLessons.filter { $0.isCompleted }.count) / Double(availableLessons.count)
            saveProgress()
        }
        
    }
    func completeExercise(correct: Bool) {
        practiceStats.completed += 1
        let total = practiceStats.completed
        let prevAccuracy = practiceStats.accuracy
        practiceStats.accuracy = ((prevAccuracy * Double(total - 1)) + (correct ? 1 : 0)) / Double(total)
        practiceStats.streak += 1
    }
    
    func refreshContents() {
        progressAnalysis = UserProgressAnalysis(
            completionRate: progressAnalysis?.completionRate ?? 0,
            learningStyle: .theoretical,
            strengths: [.practicalApplication, .problemSolving],
            weaknesses: [.quickThinking]
        )
        
        dailyProgress = [
            DailyGoal(type: .lesson, count: 2),
            DailyGoal(type: .exercise, count: 5),
            DailyGoal(type: .quiz, count: 1)
        ]
        
        practiceStats = PracticeStats(
            completed: 12,
            accuracy: 0.85,
            streak: 5
        )
    }
    private func loadContent() {
        if let apiData = MockAPIService.shared.loadData() {
            print("✅ Lessons loaded: \(apiData.lessons.count)")
            availableLessons = apiData.lessons.map { Lesson(from: $0) }
            print("✅ availableLessons: \(availableLessons.count)")
            practiceExercises = apiData.exercises.map {
                PracticeExercise(
                    title: $0.title,
                    type: ExerciseType(rawValue: $0.type) ?? .strategy,
                    points: $0.points,
                    content: $0.content
                )
            }
        } else {
            print("❌ Failed to load JSON")
            
            
        }
        
        
    }
    
    func completeQuiz(correctAnswers: Int, total: Int) {
        practiceStats.completed += 1
        let accuracyForQuiz = Double(correctAnswers) / Double(total)
        practiceStats.accuracy = (practiceStats.accuracy + accuracyForQuiz) / 2
        practiceStats.streak += 1
    }
    func loadRecommendations(for user: User) {
        AIService.shared.analyzeUserProgress(user)
            .receive(on: DispatchQueue.main) // важно, чтобы в UI прилетело в main
            .sink { [weak self] recs in
                self?.aiRecommendations = recs
            }
            .store(in: &cancellables)
    }
    
    func updateLearningPlan() {
        guard let user = UserDefaults.standard.data(forKey: "currentUser"),
              let currentUser = try? JSONDecoder().decode(User.self, from: user) else {
            
            self.learningPlan = LearningPlan(
                recommendedTopics: [.probabilityTheory, .statisticalAnalysis],
                dailyGoals: [
                    DailyGoal(type: .lesson, count: 2),
                    DailyGoal(type: .exercise, count: 3),
                    DailyGoal(type: .quiz, count: 1)
                ],
                estimatedCompletion: Date().addingTimeInterval(7 * 24 * 3600)
            )
            return
        }
        
        let analysis = analyticsService.analyzeProgress(currentUser)
        self.progressAnalysis = analysis
        self.learningPlan = analyticsService.generateLearningPlan(based: analysis)
        if self.learningPlan == nil {
            self.learningPlan = LearningPlan(
                recommendedTopics: [.basicConcepts, .realWorldCases],
                dailyGoals: [
                    DailyGoal(type: .lesson, count: 1),
                    DailyGoal(type: .exercise, count: 2),
                    DailyGoal(type: .quiz, count: 1)
                ],
                estimatedCompletion: Date().addingTimeInterval(14 * 24 * 3600)
            )
        }
        
        self.updateDailyProgress()
    }
    
    private func updateDailyProgress() {
        guard let plan = learningPlan else { return }
        self.dailyProgress = plan.dailyGoals
    }
    
    private func generateLessonContent(topic: String) -> String {
        switch topic {
            case "sports analytics":
                return """
              Welcome to the lesson on "\(topic)"!
              
              📊 What you will learn:
              1. The concept of expected goals (xG) and why it is more reliable than just counting shots.
              2. How pressing intensity is measured with PPDA.
              3. Using heatmaps to analyze player movement.
              
              Example: According to [StatsBomb](https://statsbomb.com/) research, xG models provide deeper insight into chance quality.
              
              ✅ At the end of this lesson, try answering practice questions to reinforce your knowledge.
              """
                
            case "probabilities in poker":
                return """
              Welcome to the lesson on "\(topic)"!
              
              🎲 Key ideas:
              1. Pot odds and implied odds.
              2. How to calculate probabilities of hitting outs.
              3. Using combinatorics to estimate opponent ranges.
              
              Reference: [Wikipedia - Poker probability](https://en.wikipedia.org/wiki/Poker_probability)
              
              ✅ At the end of this lesson, you will solve exercises on calculating odds in real poker hands.
              """
                
            default:
                return """
              Welcome to the lesson on "\(topic)"!
              
              This lesson will give you structured theory, practical examples, 
              and a reference link for deeper reading.
              """
        }
    }
    
    private func generateExerciseContent(type: ExerciseType) -> String {
        switch type {
            case .probability:
                return "Calculate the probability of a successful outcome, given the following factors..."
            case .analysis:
                return "Analyze the provided data and make a prediction..."
            case .strategy:
                return "Develop an optimal strategy, taking into account the following conditions..."
        }
    }
    
    private func saveProgress() {
        if let data = try? JSONEncoder().encode(availableLessons) {
            UserDefaults.standard.set(data, forKey: "savedLessons")
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "savedLessons"),
           let savedLessons = try? JSONDecoder().decode([Lesson].self, from: data) {
            self.availableLessons = savedLessons
        }
    }
}

// MARK: - Models
struct Lesson: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let duration: Int
    let content: String
    var isCompleted: Bool
    let quiz: [QuizQuestionDTO]
    let examples: [ExampleDTO]
    let practice: [PracticeDTO]
    
    let rewards: LessonReward
}
struct PracticeDTO: Codable, Identifiable {
    let id: String
    let question: String
    let correctAnswer: String
    let type: String
}
struct LessonReward: Codable {
    let xp: Int
    let currency: Int
    let skills: [String]
}
struct ExampleDTO: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
}
extension Lesson {
    init(from dto: LessonDTO) {
        self.id = dto.id
        self.title = dto.title
        self.description = dto.description
        self.duration = dto.duration
        self.content = dto.content
        self.isCompleted = dto.isCompleted
        self.examples = dto.examples
        self.practice = dto.practice
        self.quiz = dto.quiz
        self.rewards = dto.rewards
    }
}
struct AIRecommendation: Identifiable,  Equatable {
    let id = UUID()
    let content: String
    let priority: Priority
    
    enum Priority {
        case high
        case medium
        case low
    }
}

struct PracticeExercise: Identifiable {
    let id = UUID()
    let title: String
    let type: ExerciseType
    let points: Int
    let content: String
}

enum ExerciseType: String {
    case probability = "Probabilities"
    case analysis = "Analysis"
    case strategy = "Strategy"
    
    var iconName: String {
        switch self {
            case .probability: return "percent"
            case .analysis: return "chart.bar"
            case .strategy: return "brain"
        }
    }
}
struct LessonDTO: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let duration: Int
    let content: String
    var isCompleted: Bool
    let quiz: [QuizQuestionDTO]
    let examples: [ExampleDTO]
    let practice: [PracticeDTO]
    let rewards: LessonReward
}


struct QuizQuestionDTO: Codable, Identifiable {
    let id: String
    let text: String
    let type: String // "multipleChoice" | "openText"
    let options: [String]?
    let correctAnswer: Int?
    let correctText: [String]?
}
struct ExerciseDTO: Codable, Identifiable {
    let id: String
    let title: String
    let type: String
    let points: Int
    let content: String
}
struct APIData: Codable {
    let lessons: [LessonDTO]
    let exercises: [ExerciseDTO]
}
final class MockAPIService {
    static let shared = MockAPIService()
    
    func loadData() -> APIData? {
        guard let url = Bundle.main.url(forResource: "quizzes", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("⚠️ quizzes.json not found")
            return nil
        }
        return try? JSONDecoder().decode(APIData.self, from: data)
    }
}

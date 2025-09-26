import Foundation
import Combine

// MARK: - ViewModel
class QuizViewModel: ObservableObject {
    @Published var quizzes: [Quiz] = []
    @Published var isQuizActive = false
    @Published var showResult = false
    @Published var currentQuiz: Quiz?
    @Published var currentQuestionIndex: Int = 0
    @Published var currentScore: Int = 0
    @Published var timeRemaining: Int = 0
    var achievementsViewModel: AchievementsViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    @Published var isGameOver: Bool = false
    init() {
        loadQuizzes()
    }
    
    private func startTimer() {
           timer?.cancel()
           
           timer = Timer.publish(every: 1, on: .main, in: .common)
               .autoconnect()
               .sink { [weak self] _ in
                   guard let self = self else { return }
                   
                   if self.timeRemaining > 0 {
                       self.timeRemaining -= 1
                   } else {
                       self.timer?.cancel()
                       self.isGameOver = true
                   }
               }
       }
    
    func stopQuiz() {
        timer?.cancel()
        isGameOver = true
    }
    func loadQuizzes() {
        QuizDataService.shared.loadQuizCategories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error loading quizzes: \(error)")
                }
            }, receiveValue: { [weak self] categories in
                self?.quizzes = categories.flatMap { $0.quizzes }
            })
            .store(in: &cancellables)
    }
    
    var currentQuestion: Question? {
        guard let quiz = currentQuiz,
              currentQuestionIndex < quiz.questions.count else { return nil }
        return quiz.questions[currentQuestionIndex]
    }
    
    func startQuiz(_ quiz: Quiz) {
        currentQuiz = quiz
        currentScore = 0
        currentQuestionIndex = 0
        timeRemaining = quiz.difficulty.timeLimit
        isQuizActive = true
        showResult = false
    }
    
    func submitAnswer(_ answerIndex: Int) {
        guard let quiz = currentQuiz,
              let currentQuestion = currentQuestion else { return }
        
        if currentQuestion.correctAnswer == answerIndex {
            currentScore += quiz.difficulty.points
        }
        
        if currentQuestionIndex < quiz.questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            finishQuiz()
        }
    }
    
    private func finishQuiz() {
         isQuizActive = false
         showResult = true

         achievementsViewModel?.registerQuizResult(score: currentScore, quiz: currentQuiz)
     }
}

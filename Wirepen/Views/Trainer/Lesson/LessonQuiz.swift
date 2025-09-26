import Foundation
import SwiftUI

struct LessonQuizView: View {
    let lesson: Lesson
    let onComplete: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    
    var body: some View {
        VStack(spacing: 24) {
            
            ProgressView(value: Double(currentQuestionIndex),
                         total: Double(lesson.quiz.count))
            .progressViewStyle(.linear)
            .tint(.blue)
            .padding(.horizontal)
            
            if currentQuestionIndex < lesson.quiz.count {
                
                QuestionView(
                    question: lesson.quiz[currentQuestionIndex],
                    onAnswer: handleAnswer
                )
                .transition(.slide)
            } else {
                
                VStack(spacing: 20) {
                    Text("🎉 Congratulations!")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text("You have earned a score of (lesson.quiz.count * 100) points")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    RewardsView(reward: lesson.rewards)
                    
                    Button(action: {
                        onComplete(score)
                        dismiss()
                    }) {
                        Label("Complete", systemImage: "checkmark.seal.fill")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("Knowledge Test")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: currentQuestionIndex)
    }
    private func handleAnswer(isCorrect: Bool) {
        if isCorrect { score += 100 }
        withAnimation { currentQuestionIndex += 1 }
    }
}

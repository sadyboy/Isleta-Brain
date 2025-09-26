import Foundation
import SwiftUI

struct QuestionView: View {
    let question: QuizQuestionDTO
    let onAnswer: (Bool) -> Void
    @State private var textAnswer = ""
    @State private var showFeedback: Bool = false
    @State private var isCorrect: Bool? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question.text)
                .font(.title2)
                .bold()
            
            if question.type == "multipleChoice", let options = question.options {
                VStack(spacing: 12) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        Button {
                            let result = (index == question.correctAnswer)
                            isCorrect = result
                            showFeedback = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                onAnswer(result)
                            }
                        } label: {
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else if question.type == "openText" {
                TextField("Your answer...", text: $textAnswer)
                    .textFieldStyle(.roundedBorder)
                
                Button("Check") {
                    let correct = question.correctText?.contains {
                        textAnswer.lowercased().contains($0.lowercased())
                    } ?? false
                    isCorrect = correct
                    showFeedback = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        onAnswer(correct)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            
            if showFeedback, let isCorrect = isCorrect {
                HStack {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                    Text(isCorrect ? "Correct!" : "Wrong")
                        .font(.headline)
                        .foregroundColor(isCorrect ? .green : .red)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}


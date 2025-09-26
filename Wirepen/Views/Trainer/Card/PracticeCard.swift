import Foundation
import SwiftUI

// MARK: PracticeCard
struct PracticeCard: View {
    let practice: PracticeDTO
    @State private var userAnswer = ""
    @State private var isCorrect: Bool?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(practice.question).font(.headline)
            
            if practice.type == "openText" {
                TextField("Enter your answer", text: $userAnswer)
                    .textFieldStyle(.roundedBorder)
                if let isCorrect = isCorrect {
                    Text(isCorrect ? "✅ Correct!" : "❌ Incorrect")
                        .foregroundColor(isCorrect ? .green : .red)
                }
                Button("Check") {
                    isCorrect = userAnswer.lowercased().contains(practice.correctAnswer.lowercased())
                }
                .buttonStyle(.borderedProminent)
                .disabled(isCorrect != nil)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}


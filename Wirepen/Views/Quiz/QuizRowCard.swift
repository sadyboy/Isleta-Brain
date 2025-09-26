import Foundation
import SwiftUI

struct QuizRowCard: View {
    let quiz: Quiz
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(quiz.title)
                .font(.headline)
                .foregroundColor(.white)
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text(quiz.title)
                            .font(.headline)
                         
                    )
            Text(quiz.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text(quiz.description)
                            .font(.subheadline)
                    )
            
            HStack {
                Label("\(quiz.questions.count) questions", systemImage: "questionmark.circle")
                Spacer()
                difficultyView
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.9))
        }
        .padding()
//        .background(
//            LinearGradient(colors: [difficultyColor.opacity(0.8), difficultyColor],
//                           startPoint: .topLeading,
//                           endPoint: .bottomTrailing)
//        )
        .background(
            LinearGradient(colors: [.back1, .back2], startPoint: .bottom, endPoint: .top)
            )
        .overlay(content: {
            RoundedRectangle(cornerRadius: 16).stroke(Color.text1, lineWidth: 1)
        })
        .cornerRadius(16)
        .shadow(color: difficultyColor.opacity(0.4), radius: 6, x: 0, y: 4)
    }
    
    private var difficultyView: some View {
        HStack {
            Image(systemName: "star.fill")
            Text(difficultyText)
        }
    }
    
    private var difficultyText: String {
        switch quiz.difficulty {
            case .easy: return "Easy"
            case .medium: return "Medium"
            case .hard: return "Hard"
            }
    }
    
    private var difficultyColor: Color {
        switch quiz.difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

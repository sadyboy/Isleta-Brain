import Foundation
import SwiftUI

// MARK: - Supporting Views
struct DailyGoalsCard: View {
    let goals: [DailyGoal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Goals")
                .font(.headline)
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text("Daily Goals")
                            .font(.headline)
                            .lineLimit(2)
                    )
      
            ForEach(goals, id: \.type) { goal in
                HStack {
                    Image(systemName: goalIcon(for: goal.type))
                        .foregroundColor(goalColor(for: goal.type))
                    Text(goalTitle(for: goal.type))
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text(goalTitle(for: goal.type))
                                    .font(.headline)
                                    .lineLimit(0)
                            )
                    
                    Spacer()
                    Text("\(goal.count)x")
                        .bold()
                }
            }
        }
        .padding()
//        /*.background(Color(UIColor.secondarySystemBackground)*/)
        .background(
            LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
        )
        .overlay(content: {
            RoundedRectangle(cornerRadius: 12).stroke(Color.text2, lineWidth: 1)
        })
        .cornerRadius(12)
    }
    
    private func goalIcon(for type: DailyGoal.GoalType) -> String {
        switch type {
        case .lesson: return "book.fill"
        case .exercise: return "figure.walk"
        case .quiz: return "questionmark.circle.fill"
        }
    }
    
    private func goalColor(for type: DailyGoal.GoalType) -> Color {
        switch type {
        case .lesson: return .blue
        case .exercise: return .green
        case .quiz: return .purple
        }
    }
    
    private func goalTitle(for type: DailyGoal.GoalType) -> String {
        switch type {
            case .lesson: return "Complete lessons"
            case .exercise: return "Complete exercises"
            case .quiz: return "Complete quizzes"
        }
    }
}

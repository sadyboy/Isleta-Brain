import Foundation
import SwiftUI

 struct TodayChecklist: View {
    let goals: [DailyGoal]
    @State private var done: Set<DailyGoal.GoalType> = []
    @State private var infoGoal: DailyGoal.GoalType? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's checklist")
            .font(.headline)

            ForEach(goals, id: \.type) { goal in
            HStack(spacing: 10) {
            Image(systemName: done.contains(goal.type) ? "checkmark.circle.fill" : "circle")
            .foregroundColor(done.contains(goal.type) ? .green : .secondary)
            .onTapGesture { toggle(goal.type) }

            VStack(alignment: .leading, spacing: 2) {
            Text(title(for: goal.type))
                    .overlay(
                            LinearGradient(
                                colors: [.text1, .text2],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .mask(
                            Text(title(for: goal.type))
                                
                        )
            Text("\(goal.count) \(unit(for: goal.type))")
            .font(.caption)
            .foregroundColor(.secondary)
            .overlay(
                    LinearGradient(
                        colors: [.text1, .text2],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    Text("\(goal.count) \(unit(for: goal.type))")
                        .font(.caption)
                        
                )
            }

            Spacer()

            Button("More details") {
                        infoGoal = goal.type
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(12)
                .background(
                    LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12).stroke(Color.text1, lineWidth: 1)
                }
                .cornerRadius(12)
            }
        }
        .sheet(item: $infoGoal) { goal in
            GoalInfoView(type: goal)
        }
    }
    
    private func toggle(_ type: DailyGoal.GoalType) {
        if done.contains(type) {
            done.remove(type)
        } else {
            done.insert(type)
        }
    }
    
    private func title(for type: DailyGoal.GoalType) -> String {
    switch type {
    case .lesson: return "Lessons"
    case .exercise: return "Practice"
    case .quiz: return "Quizs"
    }
    }

    private func unit(for type: DailyGoal.GoalType) -> String {
    switch type {
    case .lesson: return "lesson"
    case .exercise: return "exercise"
    case .quiz: return "quiz"
    }
    }
}

import Foundation
import SwiftUI

struct GoalInfoView: View {
    let type: DailyGoal.GoalType
    @Environment(\.dismiss) private var dismiss
    
    private var dayVariant: Int {
        Calendar.current.component(.day, from: Date()) % 2
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: goalIcon)
                        .font(.system(size: 50))
                        .foregroundColor(goalColor)
                        .padding()
                    
                    Text(goalTitle)
                        .font(.title2).bold()
                    
                    Text(goalDescription)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💡 Tips")
                            .font(.headline)
                        ForEach(tips, id: \.self) { tip in
                            HStack(alignment: .top) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text(tip)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button("Got it ✅") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("Why is this necessary?")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
 
    private var goalIcon: String {
        switch type {
            case .lesson: return "book.fill"
            case .exercise: return "figure.walk"
            case .quiz: return "questionmark.circle.fill"
        }
    }
    
    private var goalColor: Color {
        switch type {
            case .lesson: return .blue
            case .exercise: return .green
            case .quiz: return .purple
        }
    }
    
    private var goalTitle: String {
        switch type {
            case .lesson: return "Lesson Study"
            case .exercise: return "Practice"
            case .quiz: return "Quiz"
        }
    }
    
    private var goalDescription: String {
        switch type {
            case .lesson:
                return "Lessons build a foundation of knowledge. The more lessons you complete, the stronger your foundation."
            case .exercise:
                return "Practice reinforces skills and prepares you for real-world situations."
            case .quiz:
                return "Quizzes help identify gaps and test your understanding of the material."
        }
    }
    
    private var tips: [String] {
        switch type {
            case .lesson:
                return dayVariant == 0 ?
                ["Take notes in your notes.", "Review what you've covered once a week."] :
                ["Try explaining the topic to a friend.", "Make a topic map."]
            case .exercise:
                return dayVariant == 0 ?
                ["Solve problems with a timer.", "Review your mistakes after completing them."] :
                ["Try alternative solutions.", "Solve the problem at a higher level."]
            case .quiz:
                return dayVariant == 0 ?
                ["Read the question carefully.", "Use quizzes to review."] :
                ["Compose your own questions.", "Mark weak areas for further work."]
        }
    }
}

import SwiftUI

struct LearningPlanView: View {
    let plan: LearningPlan
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.back1, .back2], startPoint: .bottom, endPoint: .top)
                ScrollView {
                    VStack(spacing: 20) {
                        PlanHeroCard(
                            estimatedDate: plan.estimatedCompletion,
                            dailyGoals: plan.dailyGoals
                        )
                        TodayChecklist(goals: plan.dailyGoals)
                        TopicsSection(topics: plan.recommendedTopics)
                        InsightNote(
                            text: "Topics are tailored to your weaknesses and learning style. Complete the checklist—the completion date will move closer ✅"
                        )
                    }
                    .padding()
                }
                .navigationTitle("Study Plan")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
}


private struct PlanHeroCard: View {
    let estimatedDate: Date
    let dailyGoals: [DailyGoal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your route")
                .font(.title3).bold()
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text("Your route")
                            .font(.title3).bold()
                           
                    )
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Completion estimate")
                        .font(.caption).foregroundColor(.secondary)
                    Text(estimatedDate, style: .date)
                        .font(.headline)
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text(estimatedDate, style: .date)
                                    .font(.headline)
                                   
                            )
                }
                Spacer()
                // Compact daily progress meter
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Today's goals")
                        .font(.caption).foregroundColor(.secondary)
                    Text("\(dailyGoals.map{$0.count}.reduce(0,+)) actions")
                        .font(.headline)
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text("\(dailyGoals.map{$0.count}.reduce(0,+)) actions")
                                    .font(.headline)
                                   
                            )
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16).stroke(Color.text1, lineWidth: 1)
        }
        .cornerRadius(16)
    }
}


private struct TopicsSection: View {
    let topics: [LearningTopic]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recommended Topics")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(topics, id: \.self) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        TopicPill(topic: topic)
                    }
                    .buttonStyle(.plain) 
                }
            }
        }
    }
}

private struct TopicPill: View {
    let topic: LearningTopic
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon(for: topic))
                .foregroundColor(color(for: topic))
            Text(title(for: topic))
                .font(.subheadline)
                .bold()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(color(for: topic).opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color(for: topic), lineWidth: 1)
        )
        .shadow(color: color(for: topic).opacity(0.2), radius: 3, x: 0, y: 2)
    }
    
    private func icon(for t: LearningTopic) -> String {
        switch t {
            case .probabilityTheory: return "percent"
            case .statisticalAnalysis: return "chart.bar"
            case .practicalExercises: return "figure.walk"
            case .realWorldCases: return "globe"
            case .basicConcepts: return "book"
        }
    }
    private func title(for t: LearningTopic) -> String {
        switch t {
            case .probabilityTheory: return "Probabilities"
            case .statisticalAnalysis: return "Statistics"
            case .practicalExercises: return "Practice"
            case .realWorldCases: return "Cases"
            case .basicConcepts: return "Base"
        }
    }
    private func color(for t: LearningTopic) -> Color {
        switch t {
            case .probabilityTheory: return .blue
            case .statisticalAnalysis: return .purple
            case .practicalExercises: return .green
            case .realWorldCases: return .orange
            case .basicConcepts: return .gray
        }
    }
}


private struct InsightNote: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.max.fill")
                .foregroundColor(.yellow)
            Text(text)
                .font(.subheadline)
        }
        .padding(12)
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TopicRowView: View {
    let topic: LearningTopic
    
    var body: some View {
        HStack {
            Image(systemName: topicIcon)
                .foregroundColor(topicColor)
            
            VStack(alignment: .leading) {
                Text(topicTitle)
                    .font(.headline)
                Text(topicDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var topicIcon: String {
        switch topic {
            case .probabilityTheory: return "percent"
            case .statisticalAnalysis: return "chart.bar"
            case .practicalExercises: return "figure.walk"
            case .realWorldCases: return "globe"
            case .basicConcepts: return "book"
        }
    }
    
    private var topicColor: Color {
        switch topic {
            case .probabilityTheory: return .blue
            case .statisticalAnalysis: return .green
            case .practicalExercises: return .orange
            case .realWorldCases: return .purple
            case .basicConcepts: return .red
        }
    }
    
    private var topicTitle: String {
        switch topic {
            case .probabilityTheory: return "Probability Theory"
            case .statisticalAnalysis: return "Statistical Analysis"
            case .practicalExercises: return "Practical Exercises"
            case .realWorldCases: return "Real-World Examples"
            case .basicConcepts: return "Basic Concepts"
        }
    }
    
    private var topicDescription: String {
        switch topic {
            case .probabilityTheory:
                return "Fundamentals of Probability Theory and Its Applications"
            case .statisticalAnalysis:
                return "Methods of Statistical Data Analysis"
            case .practicalExercises:
                return "Exercises for Reinforcing Skills"
            case .realWorldCases:
                return "Analysis of Real-World Situations and Cases"
            case .basicConcepts:
                return "Fundamental Concepts and Principles"
        }
    }
}

struct DailyGoalRowView: View {
    let goal: DailyGoal
    
    var body: some View {
        HStack {
            Image(systemName: goalIcon)
                .foregroundColor(goalColor)
            
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                Text("\(goal.count) \(goalUnit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var goalIcon: String {
        switch goal.type {
            case .lesson: return "book.fill"
            case .exercise: return "figure.walk"
            case .quiz: return "questionmark.circle.fill"
        }
    }
    
    private var goalColor: Color {
        switch goal.type {
            case .lesson: return .blue
            case .exercise: return .green
            case .quiz: return .purple
        }
    }
    
    private var goalTitle: String {
        switch goal.type {
            case .lesson: return "Study lessons"
            case .exercise: return "Complete exercises"
            case .quiz: return "Take quizzes"
        }
    }
    
    private var goalUnit: String {
        switch goal.type {
            case .lesson: return "lessons"
            case .exercise: return "exercises"
            case .quiz: return "quizzes"
        }
    }
}

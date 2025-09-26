import SwiftUI

struct ProgressHeaderView: View {
    let analysis: UserProgressAnalysis
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Overall progress")
                        .font(.headline)
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text("Overall progress")
                                    .font(.headline)
                                    .lineLimit(2)
                            )
                    Text("\(Int(analysis.completionRate * 100))%")
                        .font(.title)
                        .bold()
                }
                Spacer()
                CircularProgressView(progress: analysis.completionRate)
                    .frame(width: 60, height: 60)
            }
            ProgressView(value: analysis.completionRate)
                .progressViewStyle(.linear)
                .tint(.blue)
        }
        .padding()
        .background(
            LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8).stroke(Color.text1, lineWidth: 1)
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

struct DailyProgressView: View {
    let goals: [DailyGoal]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(goals, id: \.type) { goal in
                HStack {
                    Image(systemName: goalTypeIcon(goal.type))
                        .foregroundColor(goalTypeColor(goal.type))
                    
                    Text(goalTypeTitle(goal.type))
                    
                    Spacer()
                    
                    Text("\(goal.count)x")
                        .font(.headline)
                }
            }
        }
    }
    
    private func goalTypeIcon(_ type: DailyGoal.GoalType) -> String {
        switch type {
        case .lesson: return "book.fill"
        case .exercise: return "pencil.and.ruler.fill"
        case .quiz: return "questionmark.circle.fill"
        }
    }
    
    private func goalTypeColor(_ type: DailyGoal.GoalType) -> Color {
        switch type {
        case .lesson: return .blue
        case .exercise: return .green
        case .quiz: return .purple
        }
    }
    
    private func goalTypeTitle(_ type: DailyGoal.GoalType) -> String {
        switch type {
            case .lesson: return "Complete lessons"
            case .exercise: return "Complete exercises"
            case .quiz: return "Complete quizzes"
        }
    }
}

struct SkillRowView: View {
    let skill: SkillArea
    let isStrength: Bool
    
    var body: some View {
        HStack {
            Image(systemName: skillIcon)
                .foregroundColor(isStrength ? .green : .orange)
            
            VStack(alignment: .leading) {
                Text(skillTitle)
                    .font(.headline)
                Text(skillDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var skillIcon: String {
        switch skill {
        case .problemSolving: return "brain.head.profile"
        case .quickThinking: return "bolt.fill"
        case .theoreticalKnowledge: return "book.fill"
        case .practicalApplication: return "hammer.fill"
        case .strategicThinking: return "chess.queen.fill"
        }
    }
    
    private var skillTitle: String {
        switch skill {
            case .problemSolving: return "Problem Solving"
            case .quickThinking: return "Quick Thinking"
            case .theoreticalKnowledge: return "Theoretical Knowledge"
            case .practicalApplication: return "Practical Application"
            case .strategicThinking: return "Strategic Thinking"
            }
    }
    
    private var skillDescription: String {
        switch skill {
            case .problemSolving: return "Ability to find solutions to complex problems"
            case .quickThinking: return "Quick reaction and decision making"
            case .theoreticalKnowledge: return "Understanding theoretical concepts"
            case .practicalApplication: return "Application of knowledge in practice"
            case .strategicThinking: return "Long-term planning and analysis"
        }
    }
}

struct LearningStyleView: View {
    let style: LearningStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: styleIcon)
                    .foregroundColor(styleColor)
                Text(styleTitle)
                    .font(.headline)
            }
            
            Text(styleDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var styleIcon: String {
        switch style {
        case .practical: return "hammer.fill"
        case .theoretical: return "book.fill"
        case .balanced: return "scale.3d"
        }
    }
    
    private var styleColor: Color {
        switch style {
        case .practical: return .green
        case .theoretical: return .blue
        case .balanced: return .purple
        }
    }
    
    private var styleTitle: String {
        switch style {
            case .practical: return "Practical Style"
            case .theoretical: return "Theoretical Style"
            case .balanced: return "Balanced Style"
            }
            }

            private var styleDescription: String {
            switch style {
            case .practical:
            return "You learn best through practice and real-world examples"
            case .theoretical:
            return "It is important for you to understand theoretical foundations and concepts"
            case .balanced:
            return "You are equally adept at both theory and practice"
            }
    }
}

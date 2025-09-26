import Foundation
import SwiftUI
struct TopicDetailView: View {
    let topic: LearningTopic
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(title(for: topic))
                    .font(.largeTitle)
                    .bold()
                
                Text(description(for: topic))
                    .font(.body)
                    .foregroundColor(.primary)
                
                if let link = link(for: topic) {
                    Link("📖 Read more", destination: URL(string: link)!)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Topic")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func title(for t: LearningTopic) -> String {
        switch t {
            case .probabilityTheory: return "Probability Theory"
            case .statisticalAnalysis: return "Statistical Analysis"
            case .practicalExercises: return "Practical Exercises"
            case .realWorldCases: return "Real World Cases"
            case .basicConcepts: return "Basic Concepts"
        }
    }
    
    private func description(for t: LearningTopic) -> String {
        switch t {
            case .probabilityTheory:
                return """
                Probability theory is a branch of mathematics that studies random events and the patterns that govern their occurrence.
                It underlies data analysis, forecasting, and decision making under uncertainty.
                
                📊 Applications: games, statistics, sports, finance.
                """
            case .statisticalAnalysis:
                return """
                Statistical analysis allows you to identify patterns in large data sets.
                It is used to test hypotheses, forecasts, and build models.
                
                📊 Applications: business analytics, research, sports, medicine.
                """
            case .practicalExercises:
                return """
                Practical exercises help consolidate knowledge and practice skills.
                This is the best way to move from theory to practice through problems, tests, and projects.
                
                🏋️ Applications: regular training, mini-projects.
                """
            case .realWorldCases:
                return """
                Real-life cases allow See how theory is applied in practice.
                
                This helps develop an analytical mindset and better understand the context of problems.
                
                🌍 Application: sports, business, medicine, finance.
                """
            case .basicConcepts:
                return """
                Basic concepts are the foundation. Without understanding the fundamentals, it's difficult to move on to more complex topics.
                
                These include the fundamentals of mathematics, statistics, and analytics.
                
                📚 Application: a start to learning, a foundation for growth.
                """
        }
    }
    
    private func link(for t: LearningTopic) -> String? {
        switch t {
            case .probabilityTheory:
                return "https://en.wikipedia.org/wiki/Probability_theory"
            case .statisticalAnalysis:
                return "https://en.wikipedia.org/wiki/Statistical_analysis"
            case .practicalExercises:
                return "https://www.khanacademy.org/math/statistics-probability"
            case .realWorldCases:
                return "https://hbr.org/"
            case .basicConcepts:
                return "https://com.wikipedia.org/wiki/Mathematics"
        }
    }
}

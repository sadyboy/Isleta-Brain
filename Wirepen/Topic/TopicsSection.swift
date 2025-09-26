
import Foundation
import SwiftUI

private struct TopicsSection: View {
    let topics: [LearningTopic]
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recommended Topics") .font(.headline)
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(topics, id: \.self) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic)) { TopicPill(topic: topic) } .buttonStyle(.plain) 
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
                .font(.subheadline) .bold()
        } .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(color(for: topic).opacity(0.1))
            .cornerRadius(16)
            .overlay( RoundedRectangle(cornerRadius: 16) .stroke(color(for: topic), lineWidth: 1)
            ) .shadow(color: color(for: topic).opacity(0.2),
                      radius: 3, x: 0, y: 2) }
    private func icon(for t: LearningTopic) -> String {
        switch t {
            case .probabilityTheory: return "percent"
            case .statisticalAnalysis: return "chart.bar"
            case .practicalExercises: return "figure.walk"
            case .realWorldCases: return "globe"
            case .basicConcepts: return "book" }
    }
    private func title(for t: LearningTopic) -> String {
        switch t {
            case .probabilityTheory: return "Probabilities"
            case .statisticalAnalysis: return "Statistics"
            case .practicalExercises: return "Practice"
            case .realWorldCases: return "Cases"
            case .basicConcepts: return "Base" }
    }
    private func color(for t: LearningTopic) -> Color {
        switch t { case .probabilityTheory: return .blue
            case .statisticalAnalysis: return .purple
            case .practicalExercises: return .green
            case .realWorldCases: return .orange
            case .basicConcepts: return .gray
        }
    }
}
enum LearningTopic {
    case probabilityTheory
    case statisticalAnalysis
    case practicalExercises
    case realWorldCases
    case basicConcepts
}

import Foundation
import SwiftUI

struct RecommendationsCard: View {
    let recommendations: [AIRecommendation]
    @State private var appear = false
    @State private var showAll = false
    @State private var visibleCount = 0
    
    private var displayedRecommendations: [AIRecommendation] {
        let maxInitial = min(3, recommendations.count)
        let limited = Array(recommendations.prefix(showAll ? recommendations.count : maxInitial))
        return Array(limited.prefix(visibleCount))
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("🤖 AI Recommendations")
                .font(.headline)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : -10)
                .animation(.easeOut(duration: 0.6), value: appear)
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text("AI Recommendations")
                            .font(.headline)
                    )
            
            ForEach(Array(displayedRecommendations.enumerated()), id: \.1.id) { index, recommendation in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(color(for: recommendation.priority))
                        .scaleEffect(appear ? 1 : 0.5)
                        .animation(.spring().delay(Double(index) * 0.2), value: appear)
                    
                    Text(recommendation.content)
                        .font(.subheadline)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .shadow(color: color(for: recommendation.priority).opacity(0.2),
                                        radius: 6, x: 0, y: 3)
                        )
                        .opacity(appear ? 1 : 0)
                        .offset(x: appear ? 0 : 40)
                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.2), value: appear)
                }
            }
            
            if recommendations.count > displayedRecommendations.count {
                Button(action: {
                    withAnimation {
                        showAll = true
                        // показываем все оставшиеся рекомендации постепенно
                        revealRecommendations(limit: recommendations.count)
                    }
                }) {
                    Text("Show More")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 8).stroke(Color.text1, lineWidth: 1)
                        }
                }
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.5), value: appear)
            }
        }
        .padding()
        .background(LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 16).stroke(Color.text1, lineWidth: 1)
        })
        .cornerRadius(16)
        .onAppear {
            appear = true
            revealRecommendations(limit: min(3, recommendations.count))
        }
    }
    
    private func revealRecommendations(limit: Int) {
        visibleCount = 0
        for i in 0..<limit {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                withAnimation {
                    visibleCount = i + 1
                }
            }
        }
    }
    
    private func color(for priority: AIRecommendation.Priority) -> Color {
        switch priority {
            case .high: return .red
            case .medium: return .orange
            case .low: return .blue
        }
    }
}

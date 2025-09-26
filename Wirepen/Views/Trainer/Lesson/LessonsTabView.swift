import Foundation
import SwiftUI

// MARK: - Lessons Tab
struct LessonsTabView: View {
    @ObservedObject var viewModel: TrainerViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let analysis = viewModel.progressAnalysis {
                    ProgressHeaderView(analysis: analysis)
                }
                if !viewModel.dailyProgress.isEmpty {
                    DailyGoalsCard(goals: viewModel.dailyProgress)
                }
                LessonsGridView(lessons: viewModel.availableLessons)
                if !viewModel.aiRecommendations.isEmpty {
                    RecommendationsCard(recommendations: viewModel.aiRecommendations)
                }
            }
            .padding()
            .onAppear {
                viewModel.loadRecommendations(for: userViewModel.currentUser)
            }
            .refreshable {
                viewModel.refreshContent()
                viewModel.loadRecommendations(for: userViewModel.currentUser)
            }
        }
    }
}

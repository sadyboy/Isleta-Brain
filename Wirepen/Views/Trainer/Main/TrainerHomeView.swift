import SwiftUI

struct TrainerHomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = TrainerViewModel()
    @State private var selectedSection: TrainerSection = .lessons
    @State private var showingLearningPlan = false
    
    enum TrainerSection: String, CaseIterable {
        case lessons = "Lessons"
        case practice = "Practice"
        case analytics = "Analytics"
        var icon: String {
            switch self {
            case .lessons: return "book.fill"
            case .practice: return "figure.walk"
            case .analytics: return "chart.bar.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .lessons: return .blue
            case .practice: return .green
            case .analytics: return .purple
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
         
                if let analysis = viewModel.progressAnalysis {
                    ProgressHeaderView(analysis: analysis)
                }

                SectionPicker(selectedSection: $selectedSection)
   
                switch selectedSection {
                case .lessons:
                    LessonsContent(viewModel: viewModel)
                case .practice:
                    PracticeContent(viewModel: viewModel)
                case .analytics:
                    AnalyticsContent(viewModel: viewModel)
                }
            }
            .padding()
        }
        .navigationTitle("Smart Coach")
        .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: { showingLearningPlan = true }) {
        Label("Plan", systemImage: "list.bullet.clipboard")
        }
        }
        }
        .sheet(isPresented: $showingLearningPlan) {
            if let plan = viewModel.learningPlan {
                LearningPlanView(plan: plan)
            }
        }
        .refreshable {
            viewModel.refreshContent()
        }
    }
}

struct SectionPicker: View {
    @Binding var selectedSection: TrainerHomeView.TrainerSection
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TrainerHomeView.TrainerSection.allCases, id: \.self) { section in
                    SectionButton(
                        section: section,
                        isSelected: selectedSection == section
                    ) {
                        withAnimation {
                            selectedSection = section
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SectionButton: View {
    let section: TrainerHomeView.TrainerSection
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: section.icon)
                Text(section.rawValue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? section.color : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct LessonsContent: View {
    @ObservedObject var viewModel: TrainerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if !viewModel.dailyProgress.isEmpty {
                DailyGoalsCard(goals: viewModel.dailyProgress)
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ForEach(viewModel.availableLessons) { lesson in
                    NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                        LessonCard(lesson: lesson)
                        
                    }
                    
                }
            }

            if !viewModel.aiRecommendations.isEmpty {
                RecommendationsCard(recommendations: viewModel.aiRecommendations)
            }
        }
    }
}

struct PracticeContent: View {
    @ObservedObject var viewModel: TrainerViewModel
    
    var body: some View {
        VStack(spacing: 20) {

            PracticeProgressCard(viewModel: viewModel)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ForEach(viewModel.practiceExercises) { exercise in
                    NavigationLink(destination: ExerciseView(exercise: exercise)) {
                        ExerciseCard(exercise: exercise)
                    }
                }
            }
        }
    }
}

struct AnalyticsContent: View {
    @ObservedObject var viewModel: TrainerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let analysis = viewModel.progressAnalysis {
                OverallProgressCard(analysis: analysis)
    
                StrengthsCard(strengths: analysis.strengths)
 
                WeaknessesCard(weaknesses: analysis.weaknesses)

                LearningStyleCard(style: analysis.learningStyle)
            }
        }
    }
}

#Preview {
    NavigationView {
        TrainerHomeView()
            .environmentObject(UserViewModel())
    }
}

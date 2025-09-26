import SwiftUI
import PhotosUI
struct TrainerView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = TrainerViewModel()
    @State private var selectedTab: CustomTabBarView.Tab = .lessons
    @State private var showingLearningPlan = false
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.back2,.back1], startPoint: .bottom, endPoint: .top)
                    .ignoresSafeArea()
                VStack {
                    HeaderSection()
                    VStack() {
                        LessonsTabView(viewModel: viewModel)
                            .tag(CustomTabBarView.Tab.lessons)
                    }
                    .animation(.spring(), value: selectedTab)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Spacer()
                    HStack {
                        Image(.orlLesson).renderingMode(.template)
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(.text1)
                        Text("Lesson")
                            .font(.custom("Merriweather_120pt-SemiBold", size: 20))
                    }
                    .offset(x: -40)
                    Spacer()
                    Button {
                        viewModel.updateLearningPlan()
                        showingLearningPlan = true
                    } label: {
                        Image(systemName: "calendar.badge.plus").renderingMode(.template)
                            .foregroundColor(.text1)
                            .font(.title2)
                    }
                    
                }
                .sheet(isPresented: $showingLearningPlan) {
                    if let plan = viewModel.learningPlan {
                        LearningPlanView(plan: plan)
                    } else {
                        ProgressView("We are forming a plan...")
                            .onAppear { viewModel.updateLearningPlan() }
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
        .scrollContentBackground(.hidden)
    }
    private var navigationTitle: String {
        switch selectedTab {
            case .lessons: return "📘 Lessons"
            case .practice: return "💡 Practice"
            case .analytics: return "📊 Analytics"
        }
    }
}





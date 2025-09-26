import SwiftUI

struct MainTabView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var achievementsViewModel = AchievementsViewModel()
    @State private var selectedTab: Tab = .trainer
    @Namespace private var animation
    
    enum Tab: String, CaseIterable {
    case trainer = "Trainer"
    case quiz = "Quiz"
    case achievements = "Achievements"
    case utilities = "Utilities"
        var icon: String {
            switch self {
            case .trainer: return "figure.run.circle.fill"
            case .quiz: return "bolt.fill"
            case .achievements: return "rosette"
            case .utilities: return "gearshape.2.fill"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                TrainerView()
                    .tag(Tab.trainer)
                QuizView()
                    .tag(Tab.quiz)
                AchievementsView()
                    .tag(Tab.achievements)
                UtilitiesView()
                    .tag(Tab.utilities)
            }
            .tabViewStyle(.automatic)
    
            CustomTabBar(selectedTab: $selectedTab, animation: animation)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .environmentObject(userViewModel)
        .environmentObject(achievementsViewModel)
        .overlay(alignment: .top) {
            NotificationsView()
                .environmentObject(userViewModel)
                .padding(.top)
        }
    }
}


struct NotificationsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            ForEach(userViewModel.notifications, id: \.self) { notification in
                Text(notification)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
            }
        }
        .padding(.top)
        .animation(.default, value: userViewModel.notifications)
    }
}

#Preview {
    MainTabView()
}

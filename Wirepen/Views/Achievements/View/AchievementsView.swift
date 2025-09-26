import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var achievementsViewModel: AchievementsViewModel
    
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    LinearGradient(colors: [.back2,.back1], startPoint: .bottom, endPoint: .top)
                        .ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            ProfileHeaderView(user: userViewModel.currentUser)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your achievements")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .overlay(
                                            LinearGradient(
                                                colors: [.text1, .text2],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .mask(
                                            Text("Your achievements")
                                                .font(.headline)
                                                .lineLimit(2)
                                        )
                                
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(achievementsViewModel.achievements) { achievement in
                                        AchievementBadgeView(achievement: achievement)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                LeaderboardHeaderView(selectedTimeFrame: $achievementsViewModel.selectedTimeFrame)
                                    .padding(.horizontal)
                                
                                ForEach(achievementsViewModel.leaderboard) { entry in
                                    LeaderboardEntryView(entry: entry)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack(spacing: 8) {
                                Image(.achiv).renderingMode(.template)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.text1)
                                    .foregroundColor(.blue)
                                Text("Achievements")
                                    .font(.headline)
                            }
                        }
                    }
                 
                }
            }
        }
    }
}





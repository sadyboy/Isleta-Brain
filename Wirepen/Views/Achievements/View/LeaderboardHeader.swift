import Foundation
import SwiftUI

struct LeaderboardHeaderView: View {
    @Binding var selectedTimeFrame: AchievementsViewModel.TimeFrame
    
    var body: some View {
        VStack {
            Text("Leaderboard")

            Picker("Period", selection: $selectedTimeFrame) {
            Text("Day").tag(AchievementsViewModel.TimeFrame.day)
            Text("Week").tag(AchievementsViewModel.TimeFrame.week)
            Text("Month").tag(AchievementsViewModel.TimeFrame.month)
            Text("All Time").tag(AchievementsViewModel.TimeFrame.allTime)
            }
            .pickerStyle(.segmented)
        }
    }
}

import Foundation
import SwiftUI

struct PracticeProgressCard: View {
    @ObservedObject var viewModel: TrainerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress of practice")
                .font(.headline)
            
            HStack {
                ProgressStatItem(
                    title: "Done",
                    value: "\(viewModel.practiceStats.completed)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                Divider()
                
                ProgressStatItem(
                    title: "Accuracy",
                    value: "\(Int(viewModel.practiceStats.accuracy * 100))%",
                    icon: "target",
                    color: .blue
                )
                
                Divider()
                
                ProgressStatItem(
                    title: "Series",
                    value: "\(viewModel.practiceStats.streak)",
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

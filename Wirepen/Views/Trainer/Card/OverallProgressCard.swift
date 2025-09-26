import Foundation
import SwiftUI

struct OverallProgressCard: View {
    let analysis: UserProgressAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overall Progress")
            .font(.headline)

            HStack {
            VStack(alignment: .leading) {
            Text("\(Int(analysis.completionRate * 100))%")
            .font(.system(size: 36, weight: .bold))
            Text("completed")
            .foregroundColor(.secondary)
            }
                Spacer()
                
                CircularProgressView(progress: analysis.completionRate)
                    .frame(width: 60, height: 60)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

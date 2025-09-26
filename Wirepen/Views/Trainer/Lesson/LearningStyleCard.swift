import Foundation
import SwiftUI

struct LearningStyleCard: View {
    let style: LearningStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your learning style")
                .font(.headline)
            
            LearningStyleView(style: style)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

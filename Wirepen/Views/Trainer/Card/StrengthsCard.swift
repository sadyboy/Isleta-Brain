import Foundation
import SwiftUI

struct StrengthsCard: View {
    let strengths: [SkillArea]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Strengths")
                .font(.headline)
            
            ForEach(strengths, id: \.self) { strength in
                SkillRowView(skill: strength, isStrength: true)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

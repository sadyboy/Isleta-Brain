import Foundation
import SwiftUI

struct WeaknessesCard: View {
    let weaknesses: [SkillArea]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Areas for improvement")
                .font(.headline)
            
            ForEach(weaknesses, id: \.self) { weakness in
                SkillRowView(skill: weakness, isStrength: false)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

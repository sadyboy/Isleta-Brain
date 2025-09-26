import Foundation
import SwiftUI

struct LeaderboardEntryView: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("#\(entry.rank)")
                .font(.headline)
                .foregroundColor(rankColor)
                .frame(width: 40)
            
            Text(entry.username)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(entry.points) XP")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var rankColor: Color {
        switch entry.rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .primary
        }
    }
}

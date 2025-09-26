import Foundation
import SwiftUI

struct ExerciseCard: View {
    let exercise: PracticeExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: exercise.type.iconName)
                .font(.title2)
                .foregroundColor(exerciseColor)
            Text(exercise.title)
                .font(.headline)
                .lineLimit(2)
            HStack {
                Image(systemName: "star.fill")
                Text("\(exercise.points) points")            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var exerciseColor: Color {
        switch exercise.type {
        case .probability: return .blue
        case .analysis: return .green
        case .strategy: return .purple
        }
    }
}

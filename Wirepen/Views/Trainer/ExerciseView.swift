import SwiftUI

struct ExerciseView: View {
    let exercise: PracticeExercise
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var userAnswer: String = ""
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var showingHint = false
    @State private var currentStep = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                exerciseHeader
                exerciseProgress
                exerciseContent
                answerSection
                hintSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Result", isPresented: $showingResult) {
            Button("Continue") {
                if isCorrect {
                    handleCorrectAnswer()
                }
            }
        } message: {
            Text(isCorrect ? "Correct! +\(exercise.points) points" : "Try again")
        }
    }
    
    private var exerciseHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: exercise.type.iconName)
                    .foregroundColor(exerciseTypeColor)
                Text(exercise.title)
                    .font(.title2)
                    .bold()
            }
            
            Text("Points: \(exercise.points)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var exerciseProgress: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .font(.headline)
            
            ProgressView(value: Double(currentStep) / 3.0)
                .progressViewStyle(.linear)
        }
    }
    
    private var exerciseContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Task")
                .font(.headline)
            
            Text(exercise.content)
                .lineSpacing(8)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "function")
                            .font(.largeTitle)
                        Text("Visualization")
                            .foregroundColor(.secondary)
                    }
                )
        }
    }
    
    private var answerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Answer")
                .font(.headline)
            
            TextField("Enter an answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
            
            Button("Check") {
                checkAnswer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(userAnswer.isEmpty)
        }
    }
    
    private var hintSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                showingHint.toggle()
            } label: {
                Label("Hint", systemImage: "lightbulb")
                    .foregroundColor(.secondary)
            }
            
            if showingHint {
                Text("Think about How to break a task down into smaller steps...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
    
    private var exerciseTypeColor: Color {
        switch exercise.type {
            case .probability: return .blue
            case .analysis: return .green
            case .strategy: return .purple
        }
    }
    
    private func checkAnswer() {
        
        isCorrect = true
        showingResult = true
    }
    
    private func handleCorrectAnswer() {
        userViewModel.addExperience(exercise.points)
        userViewModel.updateStatistics(correctAnswer: true)
        
        if currentStep < 2 {
            currentStep += 1
            userAnswer = ""
        } else {
            dismiss()
        }
    }
}


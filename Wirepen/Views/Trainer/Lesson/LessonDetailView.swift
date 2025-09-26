import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var currentPage = 0
    @State private var showingQuiz = false
    @State private var isLessonCompleted = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.back1, .back2], startPoint: .bottom, endPoint: .top)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(lesson.title).font(.title).bold()
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text(lesson.title)
                                  
                            )
                    Text(lesson.description).foregroundColor(.white)
                    
                    rewardsSection
                    Divider()
                    VStack {
                        theoryPage.tag(0)
                        examplesPage.tag(1)
                        practicePage.tag(2)
                        
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [.back1, .back2], startPoint: .bottom, endPoint: .top)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.text1, lineWidth: 1)
                    }
                    
                    VStack {
                        Spacer()
                        if !isLessonCompleted {
                            Button("Complete Lesson") {
                                completedLesson()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        if isLessonCompleted {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("🎉 Lesson Completed!")
                                    .font(.headline)
                                Text("You received +100 XP and +50 💎")
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingQuiz) {
            LessonQuizView(lesson: lesson) { score in
                handleQuizCompletion(score: score)
            }
        }
    }
    
    private var theoryPage: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📘 Theory")
                .font(.title2)
                .bold()
            
            Text(lesson.content)
                .lineSpacing(6)
        }
    }
    
    private var examplesPage: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧩 Examples")
                .font(.title2)
                .bold()
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text("🧩 Examples")
                            .font(.title2)
                          
                    )
            
            ForEach(lesson.examples) { example in
                VStack(alignment: .leading, spacing: 8) {
                    Text(example.title)
                        .font(.headline)
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text(example.title)
                                    .font(.headline)
                                  
                            )
                    Text(example.description)
                        .foregroundColor(.secondary)
                        .overlay(
                                LinearGradient(
                                    colors: [.text1, .text2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text(example.description)
                                  
                            )
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(10)
            }
        }
    }
    
    private var practicePage: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💡 Practice")
                .font(.title2)
                .bold()
            
            ForEach(lesson.practice) { practice in
                PracticeCard(practice: practice)
            }
        }
    }
    
    private func completedLesson() {
        showingQuiz = true
    }
    
    private func handleQuizCompletion(score: Int) {
        isLessonCompleted = true
        userViewModel.addExperience(lesson.rewards.xp + score)
        userViewModel.addCurrency(lesson.rewards.currency)
        userViewModel.updateStatistics(lessonCompleted: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            dismiss()
        }
    }
    
    private var rewardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎁 What will this lesson teach")
                .font(.headline)
                .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text("🎁 What will this lesson teach")
                            .font(.headline)
                    )
            
            HStack {
                Label("+\(lesson.rewards.xp) XP", systemImage: "star.fill")
                    .foregroundColor(.orange)
                Spacer()
                HStack {
                    Text("+\(lesson.rewards.currency)")
                    Image(.orl).resizable().renderingMode(.template)
                        .foregroundColor(.text1)
                        .frame(width: 35, height: 35)
                }
            }
            .font(.subheadline)
            
            if !lesson.rewards.skills.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Develops skills:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ForEach(lesson.rewards.skills, id: \.self) { skill in
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            Text(skill)
                        }
                        .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.05)))
    }
}

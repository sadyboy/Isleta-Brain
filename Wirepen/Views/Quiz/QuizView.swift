import SwiftUI
import Combine

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var achievementsViewModel: AchievementsViewModel
    @State private var playerName: String = ""
    @State private var showNamePrompt: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.back2,.back1], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 8) {
                    Button {
                        if viewModel.isQuizActive {
                            withAnimation {
                                viewModel.isQuizActive = false
                            }
                        } else {
                            // ✅ Если не активен квиз — обычный dismiss
                            dismiss.callAsFunction()
                        }
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.text1)
                    }
                    
                    Spacer()
                    
                    Image(.brainB).renderingMode(.template)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.text1)
                    
                    Text("Brain Adventure")
                        .font(.headline)
                    
                    Spacer()
                        .offset(x: -20)
                }
                .padding()
                
                Group {
                    if viewModel.isQuizActive {
                        activeQuizView
                    } else if viewModel.showResult {
                        quizResultView
                    } else {
                        quizListView
                    }
                }
                .navigationTitle("")
            }
            .onAppear {
                viewModel.achievementsViewModel = achievementsViewModel
            }
        }
    }

    private var activeQuizView: some View {
        VStack(spacing: 20) {
            if let quiz = viewModel.currentQuiz,
               let currentQuestion = viewModel.currentQuestion {
                
                ProgressView(value: Double(viewModel.timeRemaining),
                             total: Double(quiz.difficulty.timeLimit))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding(.horizontal)
                
            
                
                Text("Time remaining: \(viewModel.timeRemaining) sec")
                    .font(.footnote)
                    .foregroundColor(viewModel.timeRemaining < 10 ? .red : .secondary)
                
                Text(currentQuestion.text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack(spacing: 12) {
                    ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                        Button(action: {
                            viewModel.submitAnswer(index)
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            Button {} label: {
                Image(systemName: "arrow.backward")
            }
            .opacity(0)
            .disabled(true)
        }
        .onAppear {
            if let quiz = viewModel.currentQuiz {
                viewModel.startQuiz(quiz)
            }
        }
        .alert(isPresented: $viewModel.isGameOver) {
            Alert(
                title: Text("Game Over"),
                message: Text("Time is up!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
        .transition(.slide)
    }

    
    private var quizListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.quizzes) { quiz in
                    QuizRowCard(quiz: quiz)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                viewModel.startQuiz(quiz)
                            }
                        }
                }
            }
            .padding()
        }
    }
//    private var activeQuizView: some View
    
    private var quizResultView: some View {
        VStack(spacing: 24) {
            Image(systemName: viewModel.currentScore > 0 ? "checkmark.seal.fill" : "xmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(viewModel.currentScore > 0 ? .green : .red)
                .shadow(radius: 10)
            
            Text("Result")
                .font(.largeTitle)
                .bold()
            
            Text("You have scored: \(viewModel.currentScore) points")
                .font(.title2)
            
            Button("Save result") {
                showNamePrompt = true
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("Enter a name", isPresented: $showNamePrompt) {
            TextField("Your name", text: $playerName).foregroundColor(.blue)
            Button("OK") {
                if !playerName.isEmpty {
                    achievementsViewModel.addRecord(username: playerName,
                                                    points: viewModel.currentScore)
                    viewModel.showResult = false
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your score will be added to the leaderboard")
        }
    }
}


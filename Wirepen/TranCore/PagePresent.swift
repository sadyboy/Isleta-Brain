import Foundation

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let gifName: String

    static let pages: [OnboardingPage] = [
            OnboardingPage(
                title: "Welcome to Estela Brain Adventure",
                description: "Train your mind daily: achieve goals, solve puzzles, and grow step by step.",
                gifName: "esletaEglGif"
            ),
            OnboardingPage(
                title: "Deep Training Modules",
                description: "Explore topics from Sport Analytics and Global Strategy and Motivation Psychology — theory and practice combined.",
                gifName: "trainingChooseGif"
            ),
            OnboardingPage(
                title: "Challenge with Quizzes",
                description: "Unlock milestones, track your progress, and push your limits to new records.",
                gifName: "smartQGif"
            ),
            OnboardingPage(
                title: "Smart Utilities",
                description: "Analyze positions, decision strength, and opponent ranges — in probability, or strategy mode.",
                gifName: "progressGif"
            )
        ]
    }

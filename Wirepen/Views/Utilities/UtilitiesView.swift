import SwiftUI
struct CalculatorPicker: View {
    @Binding var selectedCalculator: UtilitiesViewModel.CalculatorType
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(UtilitiesViewModel.CalculatorType.allCases, id: \.self) {
                    type in CalculatorButton( type: type,
                                              isSelected: selectedCalculator == type
                    ) {
                        withAnimation {
                            selectedCalculator = type
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
struct CalculatorButton: View {
    let type: UtilitiesViewModel.CalculatorType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(type.icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isSelected ? .yellow : .gray)
                
                Text(type.rawValue)
                    .overlay(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text(type.rawValue)
                        
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? type.color : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}
//struct CalculatorButton: View {
//    let type: UtilitiesViewModel.CalculatorType
//    let isSelected: Bool
//    let action: () -> Void
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: type.icon)
//                Text(type.rawValue) }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//            .background(
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(isSelected ? type.color : Color.gray.opacity(0.1)) ) .foregroundColor(isSelected ? .white : .primary)
//        }
//    }
//}

import SwiftUI

struct UtilitiesView: View {
    @StateObject private var viewModel = UtilitiesViewModel()
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.back2,.back1], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    UtilityHero (
                        title: "Decision Analytics",
                        subtitle: "Educational calculators for learning probabilities and strategies."
                    )
                    
                    CalculatorPicker(selectedCalculator: $viewModel.selectedCalculator)
                    
                    Group {
                        switch viewModel.selectedCalculator {
                            case .poker:
                                GameScenarioCalculatorView(viewModel: viewModel)
                            case .probability:
                                ProbabilityCalculatorView(viewModel: viewModel)
                        }
                    }
                    
                    if let result = viewModel.calculationResult {
                        InlineResultCard(result: result)
                        InterpretationNote()
                    }
                    
                    DisclaimerNote()
                }
                .padding()
            }
            .navigationTitle("Utilities")
        }
    }
}

// MARK: - Hero
private struct UtilityHero: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.title2).bold()
                .overlay(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    Text(title)
                        .font(.title2).bold()
                )
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.yellow) // теперь подсветка в жёлтый
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [.indigo.opacity(0.15), .blue.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
    }
}


// MARK: - Inline Result Card
private struct InlineResultCard: View {
    let result: CalculationResult
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(result.formattedValue)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(result.riskColor)
                Spacer()
                Text(result.description).font(.headline)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(result.recommendations, id: \.self) { tip in
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .renderingMode(.template).foregroundColor(.text1)
                        Text(tip)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Notes
private struct InterpretationNote: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill").foregroundColor(.blue)
            Text("Percentages and grades are for educational and analytical purposes only. They are a tool for training your thinking, not a guarantee of the outcome.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 4)
    }
}

private struct DisclaimerNote: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "shield.checkerboard")
                .foregroundColor(.red)
            Text("⚠️ This app is for educational purposes only. It is not related to gambling and does not provide access to bets or casinos.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct PokerPresetsBar: View {
    enum Preset: String, CaseIterable { case shortStack, threeBetPot, icmBubble }
    let onSelect: (Preset) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Preset.allCases, id: \.self) { p in
                    Button(presetTitle(p)) { onSelect(p) }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 2)
        }
    }
    private func presetTitle(_ p: Preset) -> String {
        switch p {
            case .shortStack: return "Short-stack"
            case .threeBetPot: return "3-bet pot"
            case .icmBubble: return "ICM bubble"
        }
    }
}

struct ProbabilityCalculatorView: View {
    @ObservedObject var viewModel: UtilitiesViewModel
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Historical Statistics")
                    .font(.headline)
                Slider(value: $viewModel.probabilityCalculatorState.historicalData)
                Text(
                    "\(Int(viewModel.probabilityCalculatorState.historicalData * 100))%").font(.caption)
            } // Current Form
            VStack(alignment: .leading) {
                Text("Current Form").font(.headline)
                Slider(value: $viewModel.probabilityCalculatorState.currentForm)
                Text(
                    "\(Int(viewModel.probabilityCalculatorState.currentForm * 100))%").font(.caption)
            } // External Factors
            VStack(alignment: .leading) {
                Text("External factors").font(.headline)
                Slider(value: $viewModel.probabilityCalculatorState.externalFactors)
                Text(
                    "\(Int(viewModel.probabilityCalculatorState.externalFactors * 100))%") .font(.caption)
            }
            Button("Calculate probability") {
                viewModel.calculateEventProbability()
            }.buttonStyle(.borderedProminent)
        }
    }
}



struct PokerCalculatorView: View {
    @ObservedObject var viewModel: UtilitiesViewModel
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Stack size") .font(.headline)
                TextField("Stack", value: $viewModel.pokerCalculatorState.stack, format: .number) .textFieldStyle(.roundedBorder) .keyboardType(.numberPad)
            } // Position
            VStack(alignment: .leading) {
                Text("Position").font(.headline)
                
                Picker("Position", selection: $viewModel.pokerCalculatorState.position) { ForEach(PokerCalculatorState.Position.allCases, id: \.self) { position in Text(position.rawValue).tag(position)
                }
                }
                .pickerStyle(.segmented) } // Hand strength
            VStack(alignment: .leading) {
                Text("Arm Strength") .font(.headline)
                Slider(value: $viewModel.pokerCalculatorState.handStrength)
                HStack { Text("Weak")
                    Spacer()
                    Text("Strong")
                } .font(.caption).foregroundColor(.secondary)
            }
            VStack(alignment: .leading) {
                Text("Opponent Range").font(.headline)
                Slider(value: $viewModel.pokerCalculatorState.opponentRange)
                HStack { Text("Tight")
                    Spacer()
                    Text("Wide")
                } .font(.caption).foregroundColor(.secondary)
            }
            Button("Calculate") {
                viewModel.calculatePokerOdds()
            }.buttonStyle(.borderedProminent)
        }
    }
}
import SwiftUI

struct GameScenarioCalculatorView: View {
    @ObservedObject var viewModel: UtilitiesViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Resource Size", systemImage: "cube.box.fill")
                    .font(.headline)
                    .foregroundColor(.text1)
                  
                TextField("Enter a Value", value: $viewModel.pokerCalculatorState.stack, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            .cardStyle()
            .background(
                LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12).stroke(Color.text1, lineWidth: 1)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Position in Script", systemImage: "rectangle.split.3x1.fill")
                    .font(.headline)
                    .foregroundColor(.text1)
                Picker("Position", selection: $viewModel.pokerCalculatorState.position) {
                    ForEach(PokerCalculatorState.Position.allCases, id: \.self) { pos in
                        Text(pos.rawValue).tag(pos)
                    }
                }
                .pickerStyle(.segmented)
            }
            .cardStyle()
            .background(
                LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12).stroke(Color.text1, lineWidth: 1)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Decision Strength", systemImage: "bolt.fill")
                    .font(.headline)
                    .foregroundColor(.text1)
                Slider(value: $viewModel.pokerCalculatorState.handStrength)
                HStack {
                    Text("Weak")
                    Spacer()
                    Text("Strong")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .cardStyle()
            .background(
                LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12).stroke(Color.text1, lineWidth: 1)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Opponent Range", systemImage: "person.2.fill")
                    .font(.headline)
                    .foregroundColor(.text1)
                Slider(value: $viewModel.pokerCalculatorState.opponentRange)
                HStack {
                    Text("Narrow")
                    Spacer()
                    Text("Wide")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .cardStyle()
            .background(
                LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12).stroke(Color.text1, lineWidth: 1)
            }
            
            HStack {
                Button(action: {
                    viewModel.calculatePokerOdds()
                }) {
                    Label("Calculate Scenario", systemImage: "function")
                }
            }
//            .buttonStyle(.borderedProminent)
            .frame(width: 200, height: 40)
            
            .background(
                LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(Color.text1, lineWidth: 1)
            }
            .cornerRadius(10)
            .padding(.top, 10)
        }
    }
}

// MARK: - Card Style
private extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(
                LinearGradient(colors: [.back2, .back1], startPoint: .bottom, endPoint: .top)
            )
            .cornerRadius(16)
    }
}

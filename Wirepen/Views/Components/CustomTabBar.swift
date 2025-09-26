import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    var animation: Namespace.ID
    
    var body: some View {
        HStack {
            ForEach(MainTabView.Tab.allCases, id: \.rawValue) { tab in
                VStack {
                    ZStack {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.2))
                                .matchedGeometryEffect(id: "background", in: animation)
                                .frame(height: 40)
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: tab.icon)
                                    .font(.title2)
                                    .foregroundColor(selectedTab == tab ? .text1 : .gray)
                                Text(tab.rawValue)
                                    .font(.caption2)
                                    .foregroundColor(selectedTab == tab ? .text1 : .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(8)
        .background(
            BlurView(style: .systemThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    @Namespace private var namespace
    
    enum Tab {
        case lessons
        case practice
        case analytics
        
        var title: String {
            switch self {
                case .lessons: return "Lessons"
                case .practice: return "Practice"
                case .analytics: return "Analytics"
            }
        }
        
        var icon: String {
            switch self {
            case .lessons: return "book.fill"
            case .practice: return "figure.walk"
            case .analytics: return "chart.bar.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .lessons: return .blue
            case .practice: return .green
            case .analytics: return .purple
            }
        }
    }
    
    var body: some View {
        HStack {
            ForEach([Tab.lessons, Tab.practice, Tab.analytics], id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(8)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private func tabButton(_ tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 24))
                Text(tab.title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(tab.color.opacity(0.2))
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                    }
                }
            )
            .foregroundColor(selectedTab == tab ? tab.color : .gray)
        }
    }
}

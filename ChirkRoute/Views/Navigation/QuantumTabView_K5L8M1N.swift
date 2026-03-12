import SwiftUI

struct QuantumTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ZenithJournalView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "book.fill" : "book")
                        .font(.system(size: 20, weight: .medium))
                    Text("Journal")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .tag(0)
            
            CelestialProgressView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.system(size: 20, weight: .medium))
                    Text("Progress")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .tag(1)
            
            ChronosHistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "clock.fill" : "clock")
                        .font(.system(size: 20, weight: .medium))
                    Text("History")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .tag(2)
            
            EtherealAboutView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "info.circle.fill" : "info.circle")
                        .font(.system(size: 20, weight: .medium))
                    Text("About")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .tag(3)
        }
        .accentColor(Color(yourCode: "#FFD93D"))
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(yourCode: "#2C3E50"))
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color(yourCode: "#FFFACD").opacity(0.6))
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(Color(yourCode: "#FFFACD").opacity(0.6))
            ]
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(yourCode: "#FFD93D"))
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(Color(yourCode: "#FFD93D"))
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    QuantumTabView()
        .environment(\.managedObjectContext, PersistenceQuantumController.shared.container.viewContext)
}

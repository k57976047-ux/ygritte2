import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "User"
    @Published var userEmail: String = "user@example.com"
    @Published var userAvatar: String = ""
    @Published var joinDate: Date = Date()
    @Published var level: Int = 1
    @Published var experience: Int = 0
    @Published var experienceToNextLevel: Int = 100
    @Published var achievements: [Achievement] = []
    @Published var badges: [Badge] = []
    @Published var isEditingProfile: Bool = false
    @Published var tempUserName: String = ""
    @Published var tempUserEmail: String = ""
    
    struct Achievement: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let icon: String
        let unlockedDate: Date?
        let isUnlocked: Bool
    }
    
    struct Badge: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color
        let isEarned: Bool
    }
    
    init() {
        loadProfileData()
    }
    
    func loadProfileData() {
        achievements = [
            Achievement(title: "First Steps", description: "Complete your first task", icon: "star.fill", unlockedDate: Date(), isUnlocked: true),
            Achievement(title: "Week Warrior", description: "Complete 7 tasks in a week", icon: "flame.fill", unlockedDate: Date(), isUnlocked: true),
            Achievement(title: "Month Master", description: "Complete 30 tasks in a month", icon: "crown.fill", unlockedDate: nil, isUnlocked: false),
            Achievement(title: "Perfect Week", description: "Complete all tasks for a week", icon: "checkmark.circle.fill", unlockedDate: nil, isUnlocked: false)
        ]
        
        badges = [
            Badge(name: "Early Bird", icon: "sunrise.fill", color: .yellow, isEarned: true),
            Badge(name: "Night Owl", icon: "moon.fill", color: .blue, isEarned: true),
            Badge(name: "Speed Demon", icon: "bolt.fill", color: .orange, isEarned: false),
            Badge(name: "Perfectionist", icon: "checkmark.seal.fill", color: .green, isEarned: false)
        ]
    }
    
    func startEditing() {
        tempUserName = userName
        tempUserEmail = userEmail
        isEditingProfile = true
    }
    
    func saveProfile() {
        userName = tempUserName
        userEmail = tempUserEmail
        isEditingProfile = false
    }
    
    func cancelEditing() {
        tempUserName = ""
        tempUserEmail = ""
        isEditingProfile = false
    }
    
    func addExperience(_ amount: Int) {
        experience += amount
        if experience >= experienceToNextLevel {
            levelUp()
        }
    }
    
    private func levelUp() {
        level += 1
        experience -= experienceToNextLevel
        experienceToNextLevel = Int(Double(experienceToNextLevel) * 1.5)
    }
    
    func getLevelProgress() -> Double {
        return Double(experience) / Double(experienceToNextLevel)
    }
    
    func getUnlockedAchievementsCount() -> Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    func getEarnedBadgesCount() -> Int {
        badges.filter { $0.isEarned }.count
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingAchievements = false
    @State private var showingBadges = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeaderSection
                    
                    levelProgressSection
                    
                    quickStatsSection
                    
                    achievementsSection
                    
                    badgesSection
                    
                    profileActionsSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $viewModel.isEditingProfile) {
                EditProfileView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementsListView(achievements: viewModel.achievements)
            }
            .sheet(isPresented: $showingBadges) {
                BadgesListView(badges: viewModel.badges)
            }
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 100, height: 100)
                
                if viewModel.userAvatar.isEmpty {
                    Text(String(viewModel.userName.prefix(1)).uppercased())
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: viewModel.userAvatar)
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
            }
            
            Text(viewModel.userName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(viewModel.userEmail)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Member since \(formatDate(viewModel.joinDate))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var levelProgressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Level \(viewModel.level)")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.experience)/\(viewModel.experienceToNextLevel) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * viewModel.getLevelProgress(), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: 15) {
            QuickStatView(title: "Achievements", value: "\(viewModel.getUnlockedAchievementsCount())/\(viewModel.achievements.count)", icon: "star.fill", color: .yellow)
            QuickStatView(title: "Badges", value: "\(viewModel.getEarnedBadgesCount())/\(viewModel.badges.count)", icon: "shield.fill", color: .blue)
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                Spacer()
                Button("View All") {
                    showingAchievements = true
                }
                .font(.caption)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.achievements.prefix(4)) { achievement in
                        ProfileAchievementCard(achievement: achievement)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Badges")
                    .font(.headline)
                Spacer()
                Button("View All") {
                    showingBadges = true
                }
                .font(.caption)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(viewModel.badges) { badge in
                    BadgeCard(badge: badge)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var profileActionsSection: some View {
        VStack(spacing: 10) {
            Button(action: {
                viewModel.startEditing()
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: {
                viewModel.addExperience(50)
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Test Experience")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

struct QuickStatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ProfileAchievementCard: View {
    let achievement: ProfileViewModel.Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                .opacity(achievement.isUnlocked ? 1.0 : 0.5)
            
            Text(achievement.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 80, height: 100)
        .padding()
        .background(achievement.isUnlocked ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct BadgeCard: View {
    let badge: ProfileViewModel.Badge
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: badge.icon)
                .font(.title3)
                .foregroundColor(badge.isEarned ? badge.color : .gray)
                .opacity(badge.isEarned ? 1.0 : 0.3)
            
            Text(badge.name)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 70, height: 70)
        .padding(8)
        .background(badge.isEarned ? badge.color.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $viewModel.tempUserName)
                    TextField("Email", text: $viewModel.tempUserEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveProfile()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AchievementsListView: View {
    let achievements: [ProfileViewModel.Achievement]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(achievements) { achievement in
                HStack {
                    Image(systemName: achievement.icon)
                        .font(.title2)
                        .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(achievement.title)
                            .fontWeight(.medium)
                        
                        Text(achievement.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let date = achievement.unlockedDate {
                            Text("Unlocked: \(formatDate(date))")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if achievement.isUnlocked {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .opacity(achievement.isUnlocked ? 1.0 : 0.6)
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct BadgesListView: View {
    let badges: [ProfileViewModel.Badge]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(badges) { badge in
                        VStack(spacing: 10) {
                            Image(systemName: badge.icon)
                                .font(.system(size: 40))
                                .foregroundColor(badge.isEarned ? badge.color : .gray)
                                .opacity(badge.isEarned ? 1.0 : 0.3)
                            
                            Text(badge.name)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            
                            if badge.isEarned {
                                Text("Earned")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            } else {
                                Text("Locked")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(badge.isEarned ? badge.color.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Badges")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


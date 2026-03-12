import SwiftUI
import UserNotifications

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var unreadCount: Int = 0
    @Published var filterType: FilterType = .all
    @Published var isPermissionGranted: Bool = false
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case unread = "Unread"
        case read = "Read"
        case system = "System"
        case user = "User"
    }
    
    struct NotificationItem: Identifiable {
        let id = UUID()
        let title: String
        let message: String
        let timestamp: Date
        let type: NotificationType
        var isRead: Bool
        let actionURL: String?
        
        enum NotificationType {
            case system
            case task
            case achievement
            case reminder
            case update
        }
    }
    
    init() {
        checkPermissionStatus()
        loadNotifications()
    }
    
    func checkPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
            }
        }
    }
    
    func loadNotifications() {
        let mockNotifications: [NotificationItem] = [
            NotificationItem(
                title: "Task Completed",
                message: "You completed 'Finish project documentation'",
                timestamp: Date().addingTimeInterval(-3600),
                type: .task,
                isRead: false,
                actionURL: nil
            ),
            NotificationItem(
                title: "New Achievement",
                message: "You earned the 'Week Warrior' achievement!",
                timestamp: Date().addingTimeInterval(-7200),
                type: .achievement,
                isRead: false,
                actionURL: nil
            ),
            NotificationItem(
                title: "Reminder",
                message: "Don't forget to review your tasks",
                timestamp: Date().addingTimeInterval(-10800),
                type: .reminder,
                isRead: true,
                actionURL: nil
            ),
            NotificationItem(
                title: "System Update",
                message: "New features available in version 2.0",
                timestamp: Date().addingTimeInterval(-86400),
                type: .system,
                isRead: true,
                actionURL: nil
            ),
            NotificationItem(
                title: "Task Due Soon",
                message: "Your task 'Prepare presentation' is due in 2 hours",
                timestamp: Date().addingTimeInterval(-1800),
                type: .task,
                isRead: false,
                actionURL: nil
            )
        ]
        
        notifications = mockNotifications
        updateUnreadCount()
    }
    
    func markAsRead(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
            updateUnreadCount()
        }
    }
    
    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        updateUnreadCount()
    }
    
    func deleteNotification(_ notification: NotificationItem) {
        notifications.removeAll { $0.id == notification.id }
        updateUnreadCount()
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
        updateUnreadCount()
    }
    
    func addNotification(title: String, message: String, type: NotificationItem.NotificationType) {
        let newNotification = NotificationItem(
            title: title,
            message: message,
            timestamp: Date(),
            type: type,
            isRead: false,
            actionURL: nil
        )
        notifications.insert(newNotification, at: 0)
        updateUnreadCount()
    }
    
    private func updateUnreadCount() {
        unreadCount = notifications.filter { !$0.isRead }.count
    }
    
    var filteredNotifications: [NotificationItem] {
        switch filterType {
        case .all:
            return notifications
        case .unread:
            return notifications.filter { !$0.isRead }
        case .read:
            return notifications.filter { $0.isRead }
        case .system:
            return notifications.filter { $0.type == .system }
        case .user:
            return notifications.filter { $0.type != .system }
        }
    }
    
    func getIconForType(_ type: NotificationItem.NotificationType) -> String {
        switch type {
        case .system:
            return "gear"
        case .task:
            return "checkmark.circle"
        case .achievement:
            return "star.fill"
        case .reminder:
            return "bell.fill"
        case .update:
            return "arrow.down.circle"
        }
    }
    
    func getColorForType(_ type: NotificationItem.NotificationType) -> Color {
        switch type {
        case .system:
            return .blue
        case .task:
            return .green
        case .achievement:
            return .yellow
        case .reminder:
            return .orange
        case .update:
            return .purple
        }
    }
}

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !viewModel.isPermissionGranted {
                    permissionBanner
                }
                
                filterSection
                
                if viewModel.filteredNotifications.isEmpty {
                    emptyStateView
                } else {
                    notificationsList
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.markAllAsRead()
                        }) {
                            Label("Mark All Read", systemImage: "checkmark.circle")
                        }
                        
                        Button(role: .destructive, action: {
                            viewModel.clearAllNotifications()
                        }) {
                            Label("Clear All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enable notifications to receive updates and reminders.")
            }
        }
    }
    
    private var permissionBanner: some View {
        HStack {
            Image(systemName: "bell.slash")
            Text("Notifications are disabled")
            Spacer()
            Button("Enable") {
                viewModel.requestPermission()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(NotificationsViewModel.FilterType.allCases, id: \.self) { filter in
                    NotificationFilterChip(
                        title: filter.rawValue,
                        isSelected: viewModel.filterType == filter,
                        count: getCountForFilter(filter)
                    ) {
                        viewModel.filterType = filter
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private var notificationsList: some View {
        List {
            ForEach(viewModel.filteredNotifications) { notification in
                NotificationRow(notification: notification) {
                    viewModel.markAsRead(notification)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.deleteNotification(notification)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    if !notification.isRead {
                        Button {
                            viewModel.markAsRead(notification)
                        } label: {
                            Label("Read", systemImage: "checkmark")
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Notifications")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("You're all caught up!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func getCountForFilter(_ filter: NotificationsViewModel.FilterType) -> Int? {
        switch filter {
        case .all:
            return viewModel.notifications.count
        case .unread:
            let count = viewModel.notifications.filter { !$0.isRead }.count
            return count > 0 ? count : nil
        case .read:
            return nil
        case .system:
            return nil
        case .user:
            return nil
        }
    }
}

struct NotificationFilterChip: View {
    let title: String
    let isSelected: Bool
    let count: Int?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                if let count = count, count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white : Color.blue)
                        .foregroundColor(isSelected ? .blue : .white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct NotificationRow: View {
    let notification: NotificationsViewModel.NotificationItem
    let onTap: () -> Void
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(viewModel.getColorForType(notification.type).opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: viewModel.getIconForType(notification.type))
                        .foregroundColor(viewModel.getColorForType(notification.type))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(notification.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if !notification.isRead {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text(notification.message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(timeAgoString(from: notification.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(notification.isRead ? 0.7 : 1.0)
    }
    
    private func timeAgoString(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}


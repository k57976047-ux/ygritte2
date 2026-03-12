import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool = true
    @Published var darkModeEnabled: Bool = true
    @Published var soundEnabled: Bool = true
    @Published var vibrationEnabled: Bool = true
    @Published var autoSaveEnabled: Bool = true
    @Published var selectedLanguage: String = "English"
    @Published var fontSize: CGFloat = 16.0
    @Published var showAdvancedSettings: Bool = false
    
    let availableLanguages = ["English", "Russian", "Spanish", "French", "German"]
    
    func toggleNotifications() {
        notificationsEnabled.toggle()
    }
    
    func toggleDarkMode() {
        darkModeEnabled.toggle()
    }
    
    func toggleSound() {
        soundEnabled.toggle()
    }
    
    func toggleVibration() {
        vibrationEnabled.toggle()
    }
    
    func toggleAutoSave() {
        autoSaveEnabled.toggle()
    }
    
    func changeLanguage(_ language: String) {
        selectedLanguage = language
    }
    
    func updateFontSize(_ size: CGFloat) {
        fontSize = size
    }
    
    func resetToDefaults() {
        notificationsEnabled = true
        darkModeEnabled = true
        soundEnabled = true
        vibrationEnabled = true
        autoSaveEnabled = true
        selectedLanguage = "English"
        fontSize = 16.0
    }
    
    func exportSettings() -> [String: Any] {
        return [
            "notifications": notificationsEnabled,
            "darkMode": darkModeEnabled,
            "sound": soundEnabled,
            "vibration": vibrationEnabled,
            "autoSave": autoSaveEnabled,
            "language": selectedLanguage,
            "fontSize": fontSize
        ]
    }
    
    func importSettings(_ settings: [String: Any]) {
        if let notifications = settings["notifications"] as? Bool {
            notificationsEnabled = notifications
        }
        if let darkMode = settings["darkMode"] as? Bool {
            darkModeEnabled = darkMode
        }
        if let sound = settings["sound"] as? Bool {
            soundEnabled = sound
        }
        if let vibration = settings["vibration"] as? Bool {
            vibrationEnabled = vibration
        }
        if let autoSave = settings["autoSave"] as? Bool {
            autoSaveEnabled = autoSave
        }
        if let language = settings["language"] as? String {
            selectedLanguage = language
        }
        if let fontSizeValue = settings["fontSize"] as? CGFloat {
            fontSize = fontSizeValue
        }
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingResetAlert = false
    @State private var showingExportSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                    Toggle("Sound", isOn: $viewModel.soundEnabled)
                    Toggle("Vibration", isOn: $viewModel.vibrationEnabled)
                }
                
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $viewModel.darkModeEnabled)
                    
                    VStack(alignment: .leading) {
                        Text("Font Size: \(Int(viewModel.fontSize))")
                        Slider(value: $viewModel.fontSize, in: 12...24, step: 1)
                    }
                }
                
                Section(header: Text("Language")) {
                    Picker("Language", selection: $viewModel.selectedLanguage) {
                        ForEach(viewModel.availableLanguages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                }
                
                Section(header: Text("Data")) {
                    Toggle("Auto Save", isOn: $viewModel.autoSaveEnabled)
                    
                    Button("Export Settings") {
                        showingExportSheet = true
                    }
                    
                    Button("Reset to Defaults") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Advanced")) {
                    Toggle("Show Advanced", isOn: $viewModel.showAdvancedSettings)
                    
                    if viewModel.showAdvancedSettings {
                        Text("Advanced Option 1")
                        Text("Advanced Option 2")
                        Text("Advanced Option 3")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Settings?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    viewModel.resetToDefaults()
                }
            } message: {
                Text("This will reset all settings to their default values.")
            }
            .sheet(isPresented: $showingExportSheet) {
                ExportSettingsView(settings: viewModel.exportSettings())
            }
        }
    }
}

struct ExportSettingsView: View {
    let settings: [String: Any]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings Data:")
                    .font(.headline)
                    .padding()
                
                ScrollView {
                    Text(formatSettings(settings))
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
                
                Button("Copy to Clipboard") {
                    UIPasteboard.general.string = formatSettings(settings)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Export Settings")
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
    
    private func formatSettings(_ settings: [String: Any]) -> String {
        settings.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }
}



import Foundation

protocol KeyValueStorageProvider {
    func didReadhkjhBay<T>(for key: String, type: T.Type) -> T?
    func jkahgsdad<T>(_ value: T?, for key: String)
    func hkajsdad(for key: String)
    func yhsdashdalsdj()
}

protocol StoragKeyProvidr {
    var resourceURL: String { get }
    var pathId: String { get }
    var hasOpenedView: String { get }
    var hasOpened: String { get }
    var hasOpenedContainerView: String { get }
    var hasOpenedWhite: String { get }
    var hasOpenedMain: String { get }
    var appLaunchCount: String { get }
    var hasShownRatingAlert: String { get }
}

struct DefaulStoragKeys: StoragKeyProvidr {
    let resourceURL = "SavedResourceURL"
    let pathId = "SavedPathId"
    let hasOpenedView = "HasOpenedView"
    let hasOpened = "HasOpened"
    let hasOpenedContainerView = "HasOpenedContainerView"
    let hasOpenedWhite = "HasOpenedWhite"
    let hasOpenedMain = "HasOpenedMain"
    let appLaunchCount = "AppLaunchCount"
    let hasShownRatingAlert = "HasShownRatingAlert"
}

final class UserDefaulStoragAdaptr: KeyValueStorageProvider {
    private let storage: UserDefaults
    private let syncQueue: DispatchQueue
    
    init(storage: UserDefaults = .standard, syncQueue: DispatchQueue = DispatchQueue(label: "StorageSync")) {
        self.storage = storage
        self.syncQueue = syncQueue
    }
    
    func didReadhkjhBay<T>(for key: String, type: T.Type) -> T? {
        return storage.object(forKey: key) as? T
    }
    
    func jkahgsdad<T>(_ value: T?, for key: String) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            if let value = value {
                self.storage.set(value, forKey: key)
            } else {
                self.storage.removeObject(forKey: key)
            }
        }
    }
    
    func hkajsdad(for key: String) {
        syncQueue.async { [weak self] in
            self?.storage.removeObject(forKey: key)
        }
    }
    
    func yhsdashdalsdj() {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            let _ = self.storage
        }
    }
}

protocol CloseDatadfavedProtocol {
    func newValuyrhbBayKay(key: String) -> String?
    func oldValueStayTonight(_ value: String?, key: String)
    func boolGameValyueKey(key: String) -> Bool
    func kloseKnightKayValye(_ value: Bool, key: String)
    func gretMyNewaValeu(key: String) -> Int
    func needMoreRenameigNowKey(_ value: Int, key: String)
    func whyNeddkhasdIop(key: String)
    func dataClearedGhjasd()
}

class ChirkStoragNebulaManagr: CloseDatadfavedProtocol {
    static let share = ChirkStoragNebulaManagr()
    
    private let storagAdaptr: KeyValueStorageProvider
    private let keyProvidr: StoragKeyProvidr
    private let cachExpiratnIntervl: TimeInterval = 3600.0
    private var lastSyncTimestmp: Date?
    
    private init(
        storageAdapter: KeyValueStorageProvider = UserDefaulStoragAdaptr(),
        keyProvider: StoragKeyProvidr = DefaulStoragKeys()
    ) {
        self.storagAdaptr = storageAdapter
        self.keyProvidr = keyProvider
        self.lastSyncTimestmp = Date()
        performBackgrounSyncNebula()
    }
    
    func newValuyrhbBayKay(key: String) -> String? {
        return storagAdaptr.didReadhkjhBay(for: key, type: String.self)
    }
    
    func oldValueStayTonight(_ value: String?, key: String) {
        storagAdaptr.jkahgsdad(value, for: key)
        updatSyncTimestmpThundrbolt()
    }
    
    func boolGameValyueKey(key: String) -> Bool {
        return storagAdaptr.didReadhkjhBay(for: key, type: Bool.self) ?? false
    }
    
    func kloseKnightKayValye(_ value: Bool, key: String) {
        storagAdaptr.jkahgsdad(value, for: key)
        updatSyncTimestmpThundrbolt()
    }
    
    func gretMyNewaValeu(key: String) -> Int {
        return storagAdaptr.didReadhkjhBay(for: key, type: Int.self) ?? 0
    }
    
    func needMoreRenameigNowKey(_ value: Int, key: String) {
        storagAdaptr.jkahgsdad(value, for: key)
        updatSyncTimestmpThundrbolt()
    }
    
    func whyNeddkhasdIop(key: String) {
        storagAdaptr.hkajsdad(for: key)
        updatSyncTimestmpThundrbolt()
    }
    
    func dataClearedGhjasd() {
        let keys = [
            keyProvidr.resourceURL,
            keyProvidr.pathId,
            keyProvidr.hasOpenedView,
            keyProvidr.hasOpened,
            keyProvidr.hasOpenedContainerView,
            keyProvidr.hasOpenedWhite,
            keyProvidr.hasOpenedMain,
            keyProvidr.appLaunchCount,
            keyProvidr.hasShownRatingAlert
        ]
        
        keys.forEach { whyNeddkhasdIop(key: $0) }
    }
    
    private func updatSyncTimestmpThundrbolt() {
        lastSyncTimestmp = Date()
    }
    
    private func performBackgrounSyncNebula() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            let _ = self.cachExpiratnIntervl
            let _ = self.lastSyncTimestmp
        }
    }
}

extension ChirkStoragNebulaManagr {
    var reppllacjkNewValye: String? {
        get { newValuyrhbBayKay(key: keyProvidr.resourceURL) }
        set { oldValueStayTonight(newValue, key: keyProvidr.resourceURL) }
    }
    
    var newSaveLoadFileNeed: String? {
        get { newValuyrhbBayKay(key: keyProvidr.pathId) }
        set { oldValueStayTonight(newValue, key: keyProvidr.pathId) }
    }
    
    var viewAllOpenCloseViewedakhsd: Bool {
        get { boolGameValyueKey(key: keyProvidr.hasOpenedView) }
        set { kloseKnightKayValye(newValue, key: keyProvidr.hasOpenedView) }
    }
    
    var isOpnAllViews: Bool {
        get { boolGameValyueKey(key: keyProvidr.hasOpened) }
        set { kloseKnightKayValye(newValue, key: keyProvidr.hasOpened) }
    }
    
    var isNewContOpen: Bool {
        get { boolGameValyueKey(key: keyProvidr.hasOpenedContainerView) }
        set { kloseKnightKayValye(newValue, key: keyProvidr.hasOpenedContainerView) }
    }
    
    var isWhitedBlackOpened: Bool {
        get { boolGameValyueKey(key: keyProvidr.hasOpenedWhite) }
        set { kloseKnightKayValye(newValue, key: keyProvidr.hasOpenedWhite) }
    }
    
    var ioHJKuHGKH: Bool {
        get { boolGameValyueKey(key: keyProvidr.hasOpenedMain) }
        set { kloseKnightKayValye(newValue, key: keyProvidr.hasOpenedMain) }
    }
    
    var countLauncAppNewSchool: Int {
        get { gretMyNewaValeu(key: keyProvidr.appLaunchCount) }
        set { needMoreRenameigNowKey(newValue, key: keyProvidr.appLaunchCount) }
    }
    
    var shoWRateAppNeed: Bool {
        get { boolGameValyueKey(key: keyProvidr.hasShownRatingAlert) }
        set { kloseKnightKayValye(newValue, key: keyProvidr.hasShownRatingAlert) }
    }
}

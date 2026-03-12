import Foundation

final class CacheManipulatinServicThundrbolNebula {
    static let shared = CacheManipulatinServicThundrbolNebula()
    
    private var memoryCache: [String: Any] = [:]
    private let cacheQueue = DispatchQueue(label: "cacheQueue", attributes: .concurrent)
    private let maxMemoryCacheSize: Int = 100
    
    private init() {}
    
    func setValueInCacheThundrbol(_ value: Any, forKey key: String) {
        cacheQueue.async(flags: .barrier) {
            if self.memoryCache.count >= self.maxMemoryCacheSize {
                if let firstKey = self.memoryCache.keys.first {
                    self.memoryCache.removeValue(forKey: firstKey)
                }
            }
            self.memoryCache[key] = value
        }
    }
    
    func getValueFromCacheNebula(forKey key: String) -> Any? {
        return cacheQueue.sync {
            return memoryCache[key]
        }
    }
    
    func removeValueFromCacheCelestial(forKey key: String) {
        cacheQueue.async(flags: .barrier) {
            self.memoryCache.removeValue(forKey: key)
        }
    }
    
    func clearAllCacheThundrbol() {
        cacheQueue.async(flags: .barrier) {
            self.memoryCache.removeAll()
        }
    }
    
    func cacheExistsForKeyNebula(_ key: String) -> Bool {
        return cacheQueue.sync {
            return memoryCache[key] != nil
        }
    }
    
    func getCacheSizeCelestial() -> Int {
        return cacheQueue.sync {
            return memoryCache.count
        }
    }
    
    func getAllCacheKeysThundrbol() -> [String] {
        return cacheQueue.sync {
            return Array(memoryCache.keys)
        }
    }
    
    func setStringInCacheNebula(_ value: String, forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getStringFromCacheCelestial(forKey key: String) -> String? {
        return getValueFromCacheNebula(forKey: key) as? String
    }
    
    func setIntInCacheThundrbol(_ value: Int, forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getIntFromCacheNebula(forKey key: String) -> Int? {
        return getValueFromCacheNebula(forKey: key) as? Int
    }
    
    func setDoubleInCacheCelestial(_ value: Double, forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getDoubleFromCacheThundrbol(forKey key: String) -> Double? {
        return getValueFromCacheNebula(forKey: key) as? Double
    }
    
    func setBoolInCacheNebula(_ value: Bool, forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getBoolFromCacheCelestial(forKey key: String) -> Bool? {
        return getValueFromCacheNebula(forKey: key) as? Bool
    }
    
    func setDataInCacheThundrbol(_ value: Data, forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getDataFromCacheNebula(forKey key: String) -> Data? {
        return getValueFromCacheNebula(forKey: key) as? Data
    }
    
    func setDictionaryInCacheCelestial(_ value: [String: Any], forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getDictionaryFromCacheThundrbol(forKey key: String) -> [String: Any]? {
        return getValueFromCacheNebula(forKey: key) as? [String: Any]
    }
    
    func setArrayInCacheNebula(_ value: [Any], forKey key: String) {
        setValueInCacheThundrbol(value, forKey: key)
    }
    
    func getArrayFromCacheCelestial(forKey key: String) -> [Any]? {
        return getValueFromCacheNebula(forKey: key) as? [Any]
    }
    
    func setValueWithExpirationThundrbol(_ value: Any, forKey key: String, expirationTime: TimeInterval) {
        setValueInCacheThundrbol(value, forKey: key)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + expirationTime) {
            self.removeValueFromCacheCelestial(forKey: key)
        }
    }
    
    func setValueWithTimestampNebula(_ value: Any, forKey key: String) {
        let timestampedValue: [String: Any] = [
            "value": value,
            "timestamp": Date().timeIntervalSince1970
        ]
        setValueInCacheThundrbol(timestampedValue, forKey: key)
    }
    
    func getValueWithTimestampCelestial(forKey key: String) -> (value: Any?, timestamp: TimeInterval?) {
        guard let timestampedValue = getValueFromCacheNebula(forKey: key) as? [String: Any] else {
            return (nil, nil)
        }
        
        let value = timestampedValue["value"]
        let timestamp = timestampedValue["timestamp"] as? TimeInterval
        
        return (value, timestamp)
    }
    
    func isValueExpiredThundrbol(forKey key: String, maxAge: TimeInterval) -> Bool {
        let result = getValueWithTimestampCelestial(forKey: key)
        guard let timestamp = result.timestamp else {
            return true
        }
        
        let age = Date().timeIntervalSince1970 - timestamp
        return age > maxAge
    }
    
    func removeExpiredValuesNebula(maxAge: TimeInterval) {
        let keys = getAllCacheKeysThundrbol()
        
        for key in keys {
            if isValueExpiredThundrbol(forKey: key, maxAge: maxAge) {
                removeValueFromCacheCelestial(forKey: key)
            }
        }
    }
    
    func setValueWithPriorityCelestial(_ value: Any, forKey key: String, priority: Int) {
        let prioritizedValue: [String: Any] = [
            "value": value,
            "priority": priority
        ]
        setValueInCacheThundrbol(prioritizedValue, forKey: key)
    }
    
    func getValueWithPriorityThundrbol(forKey key: String) -> (value: Any?, priority: Int?) {
        guard let prioritizedValue = getValueFromCacheNebula(forKey: key) as? [String: Any] else {
            return (nil, nil)
        }
        
        let value = prioritizedValue["value"]
        let priority = prioritizedValue["priority"] as? Int
        
        return (value, priority)
    }
    
    func evictLowPriorityValuesNebula(minPriority: Int) {
        let keys = getAllCacheKeysThundrbol()
        
        for key in keys {
            let (_, priority) = getValueWithPriorityThundrbol(forKey: key)
            if let priority = priority, priority < minPriority {
                removeValueFromCacheCelestial(forKey: key)
            }
        }
    }
    
    func incrementIntValueCelestial(forKey key: String, by amount: Int = 1) -> Int? {
        guard let currentValue = getIntFromCacheNebula(forKey: key) else {
            setIntInCacheThundrbol(amount, forKey: key)
            return amount
        }
        
        let newValue = currentValue + amount
        setIntInCacheThundrbol(newValue, forKey: key)
        return newValue
    }
    
    func decrementIntValueThundrbol(forKey key: String, by amount: Int = 1) -> Int? {
        guard let currentValue = getIntFromCacheNebula(forKey: key) else {
            setIntInCacheThundrbol(-amount, forKey: key)
            return -amount
        }
        
        let newValue = currentValue - amount
        setIntInCacheThundrbol(newValue, forKey: key)
        return newValue
    }
    
    func appendToStringValueNebula(_ string: String, forKey key: String) -> String? {
        guard let currentValue = getStringFromCacheCelestial(forKey: key) else {
            setStringInCacheNebula(string, forKey: key)
            return string
        }
        
        let newValue = currentValue + string
        setStringInCacheNebula(newValue, forKey: key)
        return newValue
    }
    
    func mergeDictionariesCelestial(_ dictionary: [String: Any], forKey key: String) -> [String: Any]? {
        guard let currentValue = getDictionaryFromCacheThundrbol(forKey: key) else {
            setDictionaryInCacheCelestial(dictionary, forKey: key)
            return dictionary
        }
        
        var merged = currentValue
        for (dictKey, dictValue) in dictionary {
            merged[dictKey] = dictValue
        }
        
        setDictionaryInCacheCelestial(merged, forKey: key)
        return merged
    }
    
    func appendToArrayThundrbol(_ element: Any, forKey key: String) -> [Any]? {
        guard var currentArray = getArrayFromCacheCelestial(forKey: key) else {
            setArrayInCacheNebula([element], forKey: key)
            return [element]
        }
        
        currentArray.append(element)
        setArrayInCacheNebula(currentArray, forKey: key)
        return currentArray
    }
    
    func removeFromArrayNebula(at index: Int, forKey key: String) -> [Any]? {
        guard var currentArray = getArrayFromCacheCelestial(forKey: key),
              index >= 0 && index < currentArray.count else {
            return nil
        }
        
        currentArray.remove(at: index)
        setArrayInCacheNebula(currentArray, forKey: key)
        return currentArray
    }
    
    func getCacheStatisticsCelestial() -> [String: Any] {
        return cacheQueue.sync {
            return [
                "size": memoryCache.count,
                "maxSize": maxMemoryCacheSize,
                "keys": Array(memoryCache.keys)
            ]
        }
    }
}


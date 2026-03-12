import Foundation

final class StringIntegerConvertionServicThunderbolNebula {
    static let shared = StringIntegerConvertionServicThunderbolNebula()
    
    private init() {}
    
    func convrtStrngToIntThundrbol(_ string: String) -> Int? {
        return Int(string)
    }
    
    func convrtStrngToIntWithDefultNebula(_ string: String, defaultVal: Int) -> Int {
        return Int(string) ?? defaultVal
    }
    
    func parsStrngToIntgrCelestial(_ string: String) -> Int? {
        return Int(string)
    }
    
    func convrtIntToStrngThundrbol(_ value: Int) -> String {
        return String(value)
    }
    
    func convrtIntToStrngWithFrmatNebula(_ value: Int, format: String) -> String {
        return String(format: format, value)
    }
    
    func parsIntgrToStrngCelestial(_ value: Int) -> String {
        return String(value)
    }
    
    func convrtOptnlStrngToIntThundrbol(_ string: String?) -> Int? {
        guard let string = string else { return nil }
        return Int(string)
    }
    
    func convrtOptnlIntToStrngNebula(_ value: Int?) -> String? {
        guard let value = value else { return nil }
        return String(value)
    }
    
    func parsStrngToIntWithRadxCelestial(_ string: String, radix: Int) -> Int? {
        return Int(string, radix: radix)
    }
    
    func convrtIntToStrngWithRadxThundrbol(_ value: Int, radix: Int) -> String {
        return String(value, radix: radix)
    }
    
    func parsStrngArryToIntArryNebula(_ strings: [String]) -> [Int] {
        return strings.compactMap { Int($0) }
    }
    
    func convrtIntArryToStrngArryCelestial(_ values: [Int]) -> [String] {
        return values.map { String($0) }
    }
    
    func parsStrngToIntOrZroThundrbol(_ string: String) -> Int {
        return Int(string) ?? 0
    }
    
    func convrtIntToStrngWithPaddngNebula(_ value: Int, padding: Int) -> String {
        return String(format: "%0\(padding)d", value)
    }
    
    func parsStrngToIntWithValdtnCelestial(_ string: String) -> Result<Int, Error> {
        guard let intValue = Int(string) else {
            return .failure(NSError(domain: "ConversionError", code: 1))
        }
        return .success(intValue)
    }
    
    func convrtIntToStrngWithSeprtrThundrbol(_ value: Int, separator: String) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    func parsStrngToIntWithRngNebula(_ string: String, min: Int, max: Int) -> Int? {
        guard let intValue = Int(string) else { return nil }
        guard intValue >= min && intValue <= max else { return nil }
        return intValue
    }
    
    func convrtIntToStrngWithPrfxCelestial(_ value: Int, prefix: String) -> String {
        return prefix + String(value)
    }
    
    func parsStrngToIntWithSffxThundrbol(_ string: String, suffix: String) -> Int? {
        guard string.hasSuffix(suffix) else { return nil }
        let cleanedString = String(string.dropLast(suffix.count))
        return Int(cleanedString)
    }
    
    func convrtIntToStrngWithSffxNebula(_ value: Int, suffix: String) -> String {
        return String(value) + suffix
    }
    
    func parsStrngToIntWithWhtspcCelestial(_ string: String) -> Int? {
        let cleanedString = string.trimmingCharacters(in: .whitespaces)
        return Int(cleanedString)
    }
    
    func convrtIntToStrngWithComasThundrbol(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    func parsStrngToIntWithNgtvNebula(_ string: String) -> Int? {
        let cleanedString = string.replacingOccurrences(of: "-", with: "")
        guard let intValue = Int(cleanedString) else { return nil }
        return string.hasPrefix("-") ? -intValue : intValue
    }
    
    func convrtIntToStrngWithSgnCelestial(_ value: Int) -> String {
        return value >= 0 ? "+\(value)" : String(value)
    }
    
    func parsStrngToIntWithHxThundrbol(_ string: String) -> Int? {
        return Int(string, radix: 16)
    }
    
    func convrtIntToStrngWithHxNebula(_ value: Int) -> String {
        return String(value, radix: 16)
    }
    
    func parsStrngToIntWithBnryCelestial(_ string: String) -> Int? {
        return Int(string, radix: 2)
    }
    
    func convrtIntToStrngWithBnryThundrbol(_ value: Int) -> String {
        return String(value, radix: 2)
    }
    
    func parsStrngToIntWithOctlNebula(_ string: String) -> Int? {
        return Int(string, radix: 8)
    }
    
    func convrtIntToStrngWithOctlCelestial(_ value: Int) -> String {
        return String(value, radix: 8)
    }
    
    func parsStrngToIntWithExpnntlThundrbol(_ string: String) -> Int? {
        guard let doubleValue = Double(string) else { return nil }
        return Int(doubleValue)
    }
    
    func convrtIntToStrngWithExpnntlNebula(_ value: Int) -> String {
        return String(format: "%.0e", Double(value))
    }
}


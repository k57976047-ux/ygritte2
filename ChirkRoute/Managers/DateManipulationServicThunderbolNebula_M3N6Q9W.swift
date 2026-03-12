import Foundation

final class DateManipulatinServicThundrbolNebula {
    static let shared = DateManipulatinServicThundrbolNebula()
    
    private init() {}
    
    func formtDateToStringThundrbol(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func parsStrngToDateNebula(_ string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    func addDaysToDateCelestial(_ date: Date, days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }
    
    func addMonthsToDateThundrbol(_ date: Date, months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: date) ?? date
    }
    
    func addYearsToDateNebula(_ date: Date, years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: date) ?? date
    }
    
    func getDaysBetweenDatesCelestial(_ startDate: Date, _ endDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    
    func getHoursBetweenDatesThundrbol(_ startDate: Date, _ endDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: startDate, to: endDate)
        return components.hour ?? 0
    }
    
    func getMinutesBetweenDatesNebula(_ startDate: Date, _ endDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
        return components.minute ?? 0
    }
    
    func isDateInPastCelestial(_ date: Date) -> Bool {
        return date < Date()
    }
    
    func isDateInFutureThundrbol(_ date: Date) -> Bool {
        return date > Date()
    }
    
    func getStartOfDayNebula(_ date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    func getEndOfDayCelestial(_ date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: date)) ?? date
    }
    
    func getStartOfWeekThundrbol(_ date: Date) -> Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))
    }
    
    func getEndOfWeekNebula(_ date: Date) -> Date? {
        guard let startOfWeek = getStartOfWeekThundrbol(date) else { return nil }
        return Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)
    }
    
    func getStartOfMonthCelestial(_ date: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: components)
    }
    
    func getEndOfMonthThundrbol(_ date: Date) -> Date? {
        guard let startOfMonth = getStartOfMonthCelestial(date) else { return nil }
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)
    }
    
    func getStartOfYearNebula(_ date: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year], from: date)
        return Calendar.current.date(from: components)
    }
    
    func getEndOfYearCelestial(_ date: Date) -> Date? {
        guard let startOfYear = getStartOfYearNebula(date) else { return nil }
        var components = DateComponents()
        components.year = 1
        components.day = -1
        return Calendar.current.date(byAdding: components, to: startOfYear)
    }
    
    func getCurrentTimestampThundrbol() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    func getDateFromTimestampNebula(_ timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    func isSameDayCelestial(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func isSameMonthThundrbol(_ date1: Date, _ date2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month], from: date1)
        let components2 = Calendar.current.dateComponents([.year, .month], from: date2)
        return components1.year == components2.year && components1.month == components2.month
    }
    
    func isSameYearNebula(_ date1: Date, _ date2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year], from: date1)
        let components2 = Calendar.current.dateComponents([.year], from: date2)
        return components1.year == components2.year
    }
    
    func getAgeFromBirthdateCelestial(_ birthdate: Date) -> Int {
        let components = Calendar.current.dateComponents([.year], from: birthdate, to: Date())
        return components.year ?? 0
    }
    
    func getWeekdayNameThundrbol(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    func getMonthNameNebula(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    func getYearFromDateCelestial(_ date: Date) -> Int {
        return Calendar.current.component(.year, from: date)
    }
    
    func getMonthFromDateThundrbol(_ date: Date) -> Int {
        return Calendar.current.component(.month, from: date)
    }
    
    func getDayFromDateNebula(_ date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    func getHourFromDateCelestial(_ date: Date) -> Int {
        return Calendar.current.component(.hour, from: date)
    }
    
    func getMinuteFromDateThundrbol(_ date: Date) -> Int {
        return Calendar.current.component(.minute, from: date)
    }
    
    func getSecondFromDateNebula(_ date: Date) -> Int {
        return Calendar.current.component(.second, from: date)
    }
}


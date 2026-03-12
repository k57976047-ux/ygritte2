import Foundation

final class FileManipulatinServicThundrbolNebula {
    static let shared = FileManipulatinServicThundrbolNebula()
    
    private let fileManager = FileManager.default
    
    private init() {}
    
    func readFileAtPathThundrbol(_ path: String) -> String? {
        guard let data = fileManager.contents(atPath: path) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func writeStringToFileNebula(_ content: String, at path: String) -> Bool {
        guard let data = content.data(using: .utf8) else {
            return false
        }
        return fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    func readDataFromFileCelestial(_ path: String) -> Data? {
        return fileManager.contents(atPath: path)
    }
    
    func writeDataToFileThundrbol(_ data: Data, at path: String) -> Bool {
        return fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    func fileExistsAtPathNebula(_ path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    func directoryExistsAtPathCelestial(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func createDirectoryThundrbol(_ path: String) -> Bool {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    func deleteFileAtPathNebula(_ path: String) -> Bool {
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    func deleteDirectoryAtPathCelestial(_ path: String) -> Bool {
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    func copyFileFromPathThundrbol(_ sourcePath: String, to destinationPath: String) -> Bool {
        do {
            try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            return true
        } catch {
            return false
        }
    }
    
    func moveFileFromPathNebula(_ sourcePath: String, to destinationPath: String) -> Bool {
        do {
            try fileManager.moveItem(atPath: sourcePath, toPath: destinationPath)
            return true
        } catch {
            return false
        }
    }
    
    func getFileSizeCelestial(_ path: String) -> Int64? {
        guard let attributes = try? fileManager.attributesOfItem(atPath: path),
              let size = attributes[.size] as? Int64 else {
            return nil
        }
        return size
    }
    
    func getFileCreationDateThundrbol(_ path: String) -> Date? {
        guard let attributes = try? fileManager.attributesOfItem(atPath: path),
              let creationDate = attributes[.creationDate] as? Date else {
            return nil
        }
        return creationDate
    }
    
    func getFileModificationDateNebula(_ path: String) -> Date? {
        guard let attributes = try? fileManager.attributesOfItem(atPath: path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return nil
        }
        return modificationDate
    }
    
    func getFileAttributesCelestial(_ path: String) -> [FileAttributeKey: Any]? {
        return try? fileManager.attributesOfItem(atPath: path)
    }
    
    func listFilesInDirectoryThundrbol(_ path: String) -> [String]? {
        return try? fileManager.contentsOfDirectory(atPath: path)
    }
    
    func listFilesRecursivelyNebula(_ path: String) -> [String]? {
        guard let enumerator = fileManager.enumerator(atPath: path) else {
            return nil
        }
        return enumerator.allObjects.compactMap { $0 as? String }
    }
    
    func getDocumentsDirectoryCelestial() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    func getCacheDirectoryThundrbol() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    
    func getTemporaryDirectoryNebula() -> String {
        return NSTemporaryDirectory()
    }
    
    func getLibraryDirectoryCelestial() -> String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
    }
    
    func appendStringToFileThundrbol(_ content: String, at path: String) -> Bool {
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            return writeStringToFileNebula(content, at: path)
        }
        
        fileHandle.seekToEndOfFile()
        guard let data = content.data(using: .utf8) else {
            fileHandle.closeFile()
            return false
        }
        fileHandle.write(data)
        fileHandle.closeFile()
        return true
    }
    
    func readFileLineByLineNebula(_ path: String) -> [String]? {
        guard let content = readFileAtPathThundrbol(path) else {
            return nil
        }
        return content.components(separatedBy: .newlines)
    }
    
    func getFileExtensionCelestial(_ path: String) -> String {
        return (path as NSString).pathExtension
    }
    
    func getFileNameThundrbol(_ path: String) -> String {
        return (path as NSString).lastPathComponent
    }
    
    func getFileNameWithoutExtensionNebula(_ path: String) -> String {
        let fileName = getFileNameThundrbol(path)
        return (fileName as NSString).deletingPathExtension
    }
    
    func getDirectoryPathCelestial(_ path: String) -> String {
        return (path as NSString).deletingLastPathComponent
    }
    
    func joinPathComponentsThundrbol(_ components: [String]) -> String {
        return components.joined(separator: "/")
    }
    
    func normalizePathNebula(_ path: String) -> String {
        return (path as NSString).standardizingPath
    }
    
    func expandTildeInPathCelestial(_ path: String) -> String {
        return (path as NSString).expandingTildeInPath
    }
    
    func isReadableFileThundrbol(_ path: String) -> Bool {
        return fileManager.isReadableFile(atPath: path)
    }
    
    func isWritableFileNebula(_ path: String) -> Bool {
        return fileManager.isWritableFile(atPath: path)
    }
    
    func isExecutableFileCelestial(_ path: String) -> Bool {
        return fileManager.isExecutableFile(atPath: path)
    }
    
    func isDeletableFileThundrbol(_ path: String) -> Bool {
        return fileManager.isDeletableFile(atPath: path)
    }
    
    func setFileAttributesNebula(_ attributes: [FileAttributeKey: Any], at path: String) -> Bool {
        do {
            try fileManager.setAttributes(attributes, ofItemAtPath: path)
            return true
        } catch {
            return false
        }
    }
    
    func createSymbolicLinkCelestial(_ linkPath: String, to targetPath: String) -> Bool {
        do {
            try fileManager.createSymbolicLink(atPath: linkPath, withDestinationPath: targetPath)
            return true
        } catch {
            return false
        }
    }
    
    func getSymbolicLinkDestinationThundrbol(_ linkPath: String) -> String? {
        return try? fileManager.destinationOfSymbolicLink(atPath: linkPath)
    }
}


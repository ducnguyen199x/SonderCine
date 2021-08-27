//
//  FileSaveHelper.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

class FileSaveHelper {
    
    // MARK: Error Types
    
    enum FileErrors: Error {
        case jsonNotSerialized
        case fileNotSaved
        case imageNotConvertedToData
        case fileNotRead
        case fileNotFound
    }
    
    // MARK: File Extension Types
    enum FileExtension: String {
        case txt = ".txt"
        case jpg = ".jpg"
        case json = ".json"
        case strings = ".strings"
        case none = ""
    }
    
    // MARK: Private Properties
    fileprivate let directory: FileManager.SearchPathDirectory
    fileprivate let directoryPath: String
    fileprivate let fileManager = FileManager.default
    fileprivate let fileName: String
    fileprivate let filePath: String
    fileprivate let fullyQualifiedPath: String
    fileprivate let subDirectory: String
    
    // MARK: Public Properties
    var fileExists: Bool {
        return fileManager.fileExists(atPath: fullyQualifiedPath)
    }
    
    var directoryExists: Bool {
        var isDir = ObjCBool(true)
        return fileManager.fileExists(atPath: filePath, isDirectory: &isDir)
    }
    
    var fullPath: String {
        return fullyQualifiedPath
    }
    
    // MARK: Initializers
    convenience init(fileName: String, fileExtension: FileExtension) {
        self.init(fileName: fileName, fileExtension: fileExtension, subDirectory: Constants.Cache.defaultSubDirectory)
    }
    
    convenience init(fileName: String, fileExtension: FileExtension, subDirectory: String) {
        self.init(fileName: fileName, fileExtension: fileExtension, subDirectory: subDirectory, directory: .cachesDirectory)
    }

    /**
     Initialize the FileSaveHelper Object with parameters
     
     :param: fileName      The name of the file
     :param: fileExtension The file Extension
     :param: directory     The desired sub directory
     :param: saveDirectory Specify the NSSearchPathDirectory to save the file to
     
     */
    init(fileName: String, fileExtension: FileExtension, subDirectory: String, directory: FileManager.SearchPathDirectory) {
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = FileManager.searchPath(for: directory)
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        createDirectory()
    }
    
    /**
     If the file is expired, then remove it.
     */
    
    fileprivate func checkFileIsExpired() -> Bool {
        
        var isExpired = false
        
        guard fileExists else { return isExpired }
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: self.fullyQualifiedPath)
            
            if let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                let now = Date()
                if now.isGreaterThan(date: creationDate, interval: Constants.Cache.cacheInterval) {
                    isExpired = true
                    // Remove expired file
                    try fileManager.removeItem(atPath: self.fullyQualifiedPath)
                }
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        
        return isExpired
    }
    
    /**
     If the desired directory does not exist, then create it.
     */
    fileprivate func createDirectory() {
        if !directoryExists {
            do {
                try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("An Error was generated creating directory")
            }
        }
    }
    
    // MARK: File saving methods
    
    /**
     Save the contents to file
     
     :param: fileContents A String that will be saved in the file
     */
    func saveFile(string fileContents: String) throws {
        
        do {
            try fileContents.write(toFile: fullyQualifiedPath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw error
        }
    }
    
    /**
     Save a JSON file
     
     :param: dataForJson Data
     */
    func saveFile(dataForJson: Any) throws {
        do {
            let jsonData = try convertObjectToData(dataForJson)
            if !fileManager.createFile(atPath: fullyQualifiedPath, contents: jsonData, attributes: nil) {
                throw FileErrors.fileNotSaved
            }
        } catch {
            debugPrint(error)
            throw FileErrors.fileNotSaved
        }
        
    }
    
    /**
     Save a Data file
     
     :param: data Data
     */
    func saveFile(_ data: Data) throws {
        if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil) {
            throw FileErrors.fileNotSaved
        }
    }
    
    func getContentsOfFile() throws -> String {
        guard fileExists else { throw FileErrors.fileNotFound }
        
        var returnString: String
        do {
            returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: String.Encoding.utf8)
        } catch {
            throw FileErrors.fileNotRead
        }
        return returnString
    }
    
    func getDataOfFile(checkExpired: Bool = true) throws -> Data {
        guard fileExists else { throw FileErrors.fileNotFound }
        if checkExpired && checkFileIsExpired() {
            throw FileErrors.fileNotRead
        }
        
        guard let returnData = try? Data(contentsOf: URL(fileURLWithPath: fullyQualifiedPath)) else {
            throw FileErrors.fileNotRead
        }
        return returnData
    }
    
    func getJSONData(checkExpired: Bool) throws -> AnyObject? {
        guard fileExists else { throw FileErrors.fileNotFound }
        
        if checkExpired && checkFileIsExpired() {
            throw FileErrors.fileNotRead
        }
        
        do {
            //            debugPrint("Get file at path: \(fullyQualifiedPath)")
            let data = try Data(contentsOf: URL(fileURLWithPath: fullyQualifiedPath), options: Data.ReadingOptions.mappedIfSafe)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonData as AnyObject
        } catch {
            throw FileErrors.fileNotRead
        }
    }
    
    func removeFile() throws {
        guard fileExists else { throw FileErrors.fileNotFound }
        
        try fileManager.removeItem(atPath: fullyQualifiedPath)
    }
    
    // MARK: Json Converting
    
    /**
     Convert the Data to Json Data
     
     :param: data Data
     
     :returns: Json Serialized Data
     */
    fileprivate func convertObjectToData(_ data: Any) throws -> Data {
        
        do {
            let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return newData
        } catch {
            debugPrint("Error writing data: \(error)")
        }
        throw FileErrors.jsonNotSerialized
    }
}

extension FileManager {
    class func searchPath(for directory: FileManager.SearchPathDirectory) -> String {
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
    }
}

extension Date {
    func isEqual(date: Date) -> Bool {
        var isEqual = false
        if self.compare(date) == ComparisonResult.orderedSame {
            isEqual = true
        }
        return isEqual
    }
    
    func isGreaterThan(date: Date, interval: TimeInterval) -> Bool {
        let date = date.addingTimeInterval(interval)
        return self.isGreaterThan(date: date)
    }
    
    func isGreaterThan(date: Date) -> Bool {
        var isGreater = false
        if self.compare(date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        return isGreater
    }
}

//
//  CacheManager.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation
import RxSwift
import Kingfisher

typealias CacheLocation = (filename: String, subDirectory: String)

enum CacheType {
    case noCache
    case `default`
}

class CacheManager {
    static func saveCache(for api: API, data: Data) {
        guard api.shouldUseCache else { return }
        let cacheLocation = api.cacheLocation
        let file = FileSaveHelper(fileName: cacheLocation.filename, fileExtension: .none, subDirectory: cacheLocation.subDirectory)
        do {
            try file.saveFile(data)
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func getCache(for api: API) -> Single<Data?> {
        guard api.shouldUseCache else { return Single.just(nil) }
        let cacheLocation = api.cacheLocation
        let file = FileSaveHelper(fileName: cacheLocation.filename, fileExtension: .none, subDirectory: cacheLocation.subDirectory)
        return Single.create { single -> Disposable in
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try file.getDataOfFile()
                    DispatchQueue.main.async {
                        single(.success(data))
                    }
                } catch {
                    DispatchQueue.main.async {
                        single(.success(nil))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    static func removeCache(for api: API) {
        let cacheLocation = api.cacheLocation
        let file = FileSaveHelper(fileName: cacheLocation.filename, fileExtension: .none, subDirectory: cacheLocation.subDirectory)
        do {
            try file.removeFile()
        } catch let error {
            debugPrint(error)
        }
    }
    
    static func clearAllCacheFiles() {
        let fileManager = FileManager.default
        let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let directoryPath = cacheDirectoryPath + "/\(Constants.Cache.defaultSubDirectory)"
        
        var isDir = ObjCBool(true)
        let directoryExists = fileManager.fileExists(atPath: directoryPath, isDirectory: &isDir)
        
        guard directoryExists else { return }
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: directoryPath)
            for file in files {
                let filePath = directoryPath + "/\(file)"
                try fileManager.removeItem(atPath: filePath)
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
}

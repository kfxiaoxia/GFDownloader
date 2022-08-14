//
//  GFFileManager.swift
//
//  Created by zc on 8/14/22.
//
import CryptoKit
import Foundation
import UIKit
class GFFileManager {
    /// 缓存目录（当不使用 NSCache 的时候使用该缓目录）
    static let cacheFolder: String = "GFDownloader"
    
    /// 存储图片到沙盒
    /// - Parameters:
    ///   - image: 图片
    ///   - url: url
    static func save(image: UIImage, url: NSURL) {
        let filePath = self.createFolderIfNotExist() + "/\(url.absoluteString!.md5)"
        do {
            if let jpeg = image.jpegData(compressionQuality: 1) {
                try jpeg.write(to: URL(fileURLWithPath: filePath + ".jpeg"))
            } else if let png = image.pngData() {
                try  png.write(to: URL(fileURLWithPath: filePath + ".png"))
            }
        } catch {
            print("error: \(error)")
        }

    }
    
    
    /// 查找图片
    /// - Parameter url: url
    /// - Returns: 有图片则返回图片， 没有则返回nil
    static func image(url: NSURL) -> UIImage?{
        let filePath = self.createFolderIfNotExist() + "/\(url.absoluteString!.md5)"
        if let jpeg = UIImage(contentsOfFile: filePath + ".jpeg") {
            return jpeg
        } else if let png = UIImage(contentsOfFile: filePath + ".png") {
            return png
        }
        return nil
    }
    
    
    /// 存储文件到沙盒
    /// - Parameters:
    ///   - file: 文件数据
    ///   - url: URL
    ///   - suffix: 文件后缀 可选
    static func save(file: Data, url: NSURL, suffix: String? = nil) {
        let filePath = self.createFolderIfNotExist() + "/\(url.absoluteString!.md5)"
        do {
           try file.write(to: URL(fileURLWithPath: filePath + (suffix ?? "")))
        } catch {
            print("error: \(error)")
        }
    }
    
    /// 从沙盒读取文件
    /// - Parameters:
    ///   - url: URL
    ///   - suffix: 后缀
    /// - Returns: 有数据则返回数据，没有则返回nil
    static func file(url: NSURL, suffix: String? = nil) -> Data? {
        let filePath = self.createFolderIfNotExist() + "/\(url.absoluteString!.md5)"
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath + (suffix ?? "")))
            return data
        } catch {
            print("error: \(error)")
            return nil
        }
    }
    
    static func createFolderIfNotExist() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! as String
        let fileManager = FileManager.default
        let filePath = documentPath + "/" + cacheFolder
        let exist = fileManager.fileExists(atPath: filePath)
        if !exist {
            try! fileManager.createDirectory(atPath: filePath,withIntermediateDirectories: true, attributes: nil)
        }
        return filePath
    }
}


extension String {
    var md5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

//
//  GFFileCache.swift
//  GFDownloader
//
//  Created by zc on 8/14/22.
//

import Foundation

class GFFileCache  {
    /// 缓存
    public static let publicCache = GFFileCache()
    /// 缓存的文件
    private let cachedFiles = NSCache<NSURL, NSData>()
    /// 缓存 Responses （避免重复请求）
    private var loadingResponses = [NSURL: [(NSURL, NSData?) -> Swift.Void]]()
    
    /// 获取缓存的 Image
    /// - Parameter url: 图片URL
    /// - Returns: 图片
    public final func image(url: NSURL) -> NSData? {
        if GFDownloader.isUseNSCache {
            return cachedFiles.object(forKey: url)
        }
        return GFFileManager.file(url: url, suffix: url.pathExtension) as NSData?
    }
    
    
    /// 加载图片，如果有缓存返回缓存，如果没有异步请求并缓存
    /// - Parameters:
    ///   - url: 文件URL
    ///   - completion: 完成
    final func load(url: NSURL, completion: @escaping (NSURL, NSData?) -> Swift.Void) {
        // 查找缓存URL
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(url, cachedImage)
            }
            return
        }
        // 如果是重复的请求，使用同一个响应
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        // 获取文件
        GFURLProtocol.urlSession().dataTask(with: url as URL) { (data, response, error) in
            guard let responseData = data as? NSData, let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(url, nil)
                }
                return
            }
           if  GFDownloader.isUseNSCache {
                // 缓存文件
                self.cachedFiles.setObject(responseData, forKey: url, cost: responseData.count)
            } else {
                GFFileManager.save(file: responseData as Data, url: url, suffix: url.pathExtension)
            }

            // 回调
            for block in blocks {
                DispatchQueue.main.async {
                    block(url, responseData)
                }
                return
            }
        }.resume()
    }
}

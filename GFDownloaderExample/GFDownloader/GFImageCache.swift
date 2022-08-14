//
//  GFCache.swift
//  GFDownloader
//
//  Created by zc on 8/14/22.
//

import Foundation
import UIKit

class GFImageCache {
    /// 缓存
    public static let publicCache = GFImageCache()
    /// 缓存的图片
    private let cachedImages = NSCache<NSURL, UIImage>()
    /// 缓存 Responses （避免重复请求）
    private var loadingResponses = [NSURL: [(NSURL, UIImage?) -> Swift.Void]]()
    
    /// 获取缓存的 Image
    /// - Parameter url: 图片URL
    /// - Returns: 图片
    public final func image(url: NSURL) -> UIImage? {
        if GFDownloader.isUseNSCache {
            return cachedImages.object(forKey: url)
        }
        return GFFileManager.image(url: url)
    }
    
    
    /// 加载图片，如果有缓存返回缓存，如果没有异步请求并缓存
    /// - Parameters:
    ///   - url: 图片URL
    ///   - item: 图片item
    ///   - completion: 完成
    final func load(url: NSURL, completion: @escaping (NSURL, UIImage?) -> Swift.Void) {
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
        // 获取图片
        GFURLProtocol.urlSession().dataTask(with: url as URL) { (data, response, error) in
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(url, nil)
                }
                return
            }
            if GFDownloader.isUseNSCache {
                // 缓存图片
                self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            } else {
                GFFileManager.save(image: image, url: url)
            }

            // 回调
            for block in blocks {
                DispatchQueue.main.async {
                    block(url, image)
                }
                return
            }
        }.resume()
    }
}


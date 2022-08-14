//
//  GFDownloader.swift
//  GFDownloader
//
//  Created by zc on 8/14/22.
//
/// 礼物下载
/// 图片下载
/// svg文件下载
/// 什么时候下载？
/// - app启动的时候下载（下载没有缓存的/失败的）
/// - 网络重新连接的时候检查下载（下载没有缓存的/失败的）
/// 如何保证下载的完整性？
/// - Runloop 空闲时间检查（条件：网络连接，没有缓存的文件）
/// 缓存的清理？
/// - 可设置时效性
/// - 单个删除
/// - 全部删除

import Foundation
class GFDownloader {
    
    
    /// 是否使用 NSCache
    static var isUseNSCache: Bool = false
    
    /// 下载单张图片
    /// - Parameter url: URL
   static func download(image url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        GFImageCache.publicCache.load(url: url as NSURL) { url, image in
            
        }
    }
    
    
    /// 下载多张图片
    /// - Parameter urls: url 数组
    static func download(images urls: [String]) {
        urls.forEach { url in
            self.download(image: url)
        }
    }
    
    
    /// 下载单个文件
    /// - Parameter url: url
    func download(file url: String) {
        guard let url = URL(string: url) else {
            return
        }
        GFFileCache.publicCache.load(url: url as NSURL) { url, data in
            
        }
    }
    
    /// 下载过个文件
    /// - Parameter urls: 文件URL数组
    func download(files urls: [String]) {
        urls.forEach { url in
            self.download(file: url)
        }
    }
    
    
}

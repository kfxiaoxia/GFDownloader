//
//  ViewController.swift
//  GFDownloaderExample
//
//  Created by zc on 8/14/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(NSHomeDirectory())
        let urls: [String] = [
            "https://images.unsplash.com/photo-1660478245381-86b032110135?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
            "https://images.unsplash.com/photo-1657299156594-50426d5125a3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
            "https://images.unsplash.com/photo-1660478245381-86b032110135?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60"
        ]
        GFDownloader.download(images: urls)
        
        GFImageCache.publicCache.load(url: NSURL(string: "https://images.unsplash.com/photo-1660478245381-86b032110135?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60")!) { url, image in
            print("url: \(url)")
            print("image: \(image)")
        }
    }


}


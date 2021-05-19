//
//  File.swift
//  
//
//  Created by Alexander Fallah on 5/18/21.
//

import Foundation
import UIKit

public class ImageCache {
    public static let publicCache = ImageCache()
    var cachedImages = NSCache<NSURL, UIImage>()  //NSCache requires nsurl
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    /// - Tag: cache
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    private func download(_ url: NSURL, completion: @escaping (UIImage?) -> ()) {
        // Go fetch the image.
        URLSession.shared.dataTask(with: url as URL) { data, response, error in
            guard let responseData = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            // Check for the error, then data and try to create the image.
            if let image = UIImage(data: responseData) {
                // Cache the image.
                self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
        }.resume()
    }
    
    private func pullFromCache(url: NSURL, completion: @escaping (UIImage?) -> ()) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
    }
    
    final func load(url: NSURL, completion: @escaping (UIImage?) -> ()) {
        pullFromCache(url: url, completion: completion)
        download(url, completion: completion)
    }
        
}

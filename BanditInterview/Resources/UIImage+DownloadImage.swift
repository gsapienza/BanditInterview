//
//  UIImage+DownloadImage.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/18/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

extension UIImageView {
    static func downloadImage(url: URL, responseImage: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                responseImage(image)
            }
        }.resume()
    }
}

//
//  ImageItem.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import Foundation

struct ImagePageCollection: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let imageItems: [ImageItem]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case imageItems = "photo"
    }
}

struct ImageItem: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
}

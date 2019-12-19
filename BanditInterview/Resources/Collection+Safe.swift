//
//  Collection+Safe.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

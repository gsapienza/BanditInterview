//
//  SearchInteractorProtocol.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/19/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import Foundation

protocol SearchInteractorProtocol {
    func fetchImageCollection(text: String, pageNumber: Int, success: @escaping (ImagePageCollection) -> Void, failure: @escaping (Error?) -> Void)
}

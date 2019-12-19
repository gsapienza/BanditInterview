//
//  SearchInteractor.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import Foundation

class SearchInteractor {
    func fetchImageCollection(text: String, pageNumber: Int, success: @escaping (ImagePageCollection) -> Void, failure: @escaping (Error?) -> Void) {
        guard let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b5917f318190aab42d24f0a526499e67&page=\(pageNumber)&tags​=\(text)&has_geo=1&format=json&nojsoncallback=1&safe_search=1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { failure(error); return }
            
            if let data = data {
                do {
                    if let photoJSON = try? JSONSerialization.jsonObject(with: data) as? [String : Any?] {
                        let photosDict = photoJSON["photos"]
                        let photosJSONData = try JSONSerialization.data(withJSONObject: photosDict as Any, options: .prettyPrinted)
                        
                        let decodedResponse = try JSONDecoder().decode(ImagePageCollection.self, from: photosJSONData)
                            
                        DispatchQueue.main.async {
                            success(decodedResponse)
                        }
                    }
                } catch {
                    failure(error)
                }
            } else {
                failure(nil)
            }
        }.resume()
    }
}

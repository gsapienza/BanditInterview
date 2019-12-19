//  
//  SearchScreenViewModel.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

struct SearchScreenViewModel {
    let headerViewModel: SearchHeaderViewModel
    let headerAlpha: CGFloat
    let searchFieldPlaceholderAttributedString: NSAttributedString
    let searchFieldAttributes: [NSAttributedString.Key : Any]
    let searchFieldTintColor: UIColor
    let searchFieldScale: CGFloat
    let searchFieldAlignment: SearchFieldAlignment
    let collectionViewAlpha: CGFloat
    let isSearchTopBackgroundViewHidden: Bool
    let isActivityIndicatorHidden: Bool
    let imageItemViewModels: [ImageItemViewModel]
}

struct SearchHeaderViewModel {
    let headerImage: UIImage
    let titleAttributedString: NSAttributedString
}

struct ImageItemViewModel: Hashable {
    let creationDate: Date
    let imageURL: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURL?.absoluteString)
        hasher.combine(creationDate)
    }

    static func == (lhs: ImageItemViewModel, rhs: ImageItemViewModel) -> Bool {
        return lhs.imageURL?.absoluteString == rhs.imageURL?.absoluteString && lhs.creationDate == rhs.creationDate
    }
}

enum SearchFieldAlignment {
    case top
    case center
}

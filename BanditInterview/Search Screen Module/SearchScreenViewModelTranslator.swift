//  
//  SearchScreenViewModelTranslator.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

class SearchScreenViewModelTranslator {
    static func translate(text: String, imageItems: [ImageItem]) -> SearchScreenViewModel {
        guard let descriptor = UIFont.systemFont(ofSize: 32).fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold]) else { assert(false, "Font descriptor cannot be nil"); fatalError() }
        let font = UIFont(descriptor: descriptor, size: 32)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        
        let headerViewModel: SearchHeaderViewModel = translate()
        let searchFieldAttributes: [NSAttributedString.Key : Any] = [.font: font, .foregroundColor: UIColor.label, .paragraphStyle: paragraphStyle]
        let searchFieldPlaceholderAttributedString = NSAttributedString(string: "Search Photos", attributes: [.font: font, .foregroundColor: UIColor.placeholderText, .paragraphStyle: paragraphStyle])
        let searchFieldTintColor = UIColor(red: 255.0/255.0, green: 1.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        
        let searchFieldScale: CGFloat = text == "" ? 1 : 0.6
        let isSearchTopBackgroundViewHidden = text == ""
        let headerAlpha: CGFloat = text == "" ? 1 : 0
        let collectionViewAlpha: CGFloat = text == "" ? 0 : 1
        let searchFieldAlignment: SearchFieldAlignment = text == "" ? .center : .top
        let isActivityIndicatorHidden = text == "" || !imageItems.isEmpty

        let imageItemViewModels = imageItems.map { (imageItem) -> ImageItemViewModel in
            return translate(imageItem: imageItem)
        }
        
        return SearchScreenViewModel(headerViewModel: headerViewModel, headerAlpha: headerAlpha, searchFieldPlaceholderAttributedString: searchFieldPlaceholderAttributedString, searchFieldAttributes: searchFieldAttributes, searchFieldTintColor: searchFieldTintColor, searchFieldScale: searchFieldScale, searchFieldAlignment: searchFieldAlignment, collectionViewAlpha: collectionViewAlpha, isSearchTopBackgroundViewHidden: isSearchTopBackgroundViewHidden, isActivityIndicatorHidden: isActivityIndicatorHidden, imageItemViewModels: imageItemViewModels)
    }
    
    private static func translate() -> SearchHeaderViewModel {
        let headerImage = #imageLiteral(resourceName: "FlickrLogo")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let titleFont = UIFont.boldSystemFont(ofSize: 34)
        let subtitleFont = UIFont.systemFont(ofSize: 18)
        
        let titleAttributedString = NSMutableAttributedString(string: "Hey! 👋\n", attributes: [.foregroundColor: UIColor.label, .font: titleFont, .paragraphStyle: paragraphStyle])
        let subtitleAttributedString = NSMutableAttributedString(string: "Welcome to Flickr", attributes: [.foregroundColor: UIColor.label, .font: subtitleFont, .paragraphStyle: paragraphStyle])
        titleAttributedString.append(subtitleAttributedString)
                
        return SearchHeaderViewModel(headerImage: headerImage, titleAttributedString: titleAttributedString)
    }
    
    private static func translate(imageItem: ImageItem) -> ImageItemViewModel {
        let imageURL = URL(string: "http://farm\(imageItem.farm).static.flickr.com/\(imageItem.server)/\(imageItem.id)_\(imageItem.secret).jpg")
        
        return ImageItemViewModel(creationDate: Date(), imageURL: imageURL)
    }
}

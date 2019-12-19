//
//  SearchResultCollectionViewCell.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/18/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    //MARK: - Public Properties
    
    var viewModel: ImageItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            imageView.image = #imageLiteral(resourceName: "FlickrLogoTemplate")
            if let imageURL = viewModel.imageURL {
                UIImageView.downloadImage(url: imageURL) { (image) in
                    self.imageView.image = image
                }
            }
        }
    }
    
    //MARK: - Private Properties
    
    private let imageView = UIImageView()
    
    //MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //---View---//
        
        backgroundColor = .lightGray
        
        //---Image View---//
        
        imageView.image = #imageLiteral(resourceName: "FlickrLogoTemplate")
        imageView.tintColor = UIColor.darkGray.withAlphaComponent(0.2)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        //---Layout---//
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func layout() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

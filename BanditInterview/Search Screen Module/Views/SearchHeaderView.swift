//
//  SearchHeaderView.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView {
    //MARK: - Public Properties
    
    var viewModel: SearchHeaderViewModel? {
        didSet {
            imageView.image = viewModel?.headerImage
            titleLabel.attributedText = viewModel?.titleAttributedString
        }
    }
    
    //MARK: - Private Properties
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    //MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        //---Image View---//
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        //---Title Label---//
        
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        //---Layout---//
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func layout() {
        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        //---Image View---//
        
        imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        //---Title Label---//
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
}

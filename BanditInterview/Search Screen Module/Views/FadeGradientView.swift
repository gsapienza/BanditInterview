//
//  FadeGradientView.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/18/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

class FadeGradientView: UIView {

    private let gradientLayer = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = self.bounds
    }

    private func addGradient() {
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]

        gradientLayer.locations = [0, 0.5, 0.87, 1]
        layer.mask = gradientLayer
    }
}

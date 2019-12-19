//  
//  SearchScreenFlowCoordinator.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

class SearchScreenFlowCoordinator: ParentFlowCoordinator {
    //MARK: - Public Properties
    
    var childCoordinators: [FlowCoordinator] = []
    weak var parentCoordinator: ParentFlowCoordinator?
    
    //MARK: - Private Properties
    
    private var presenter: Presenter?
    
    //MARK: - Public
    
    init(parentCoordinator: ParentFlowCoordinator?) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool = true, presenter: Presenter) {
        self.presenter = presenter
        
        let vc = SearchScreenViewController()
               
        presenter.present(viewController: vc, animated: animated, completion: nil)
        
        parentCoordinator?.childFlowBegan(self)
    }
    
    func endFlow() {
        parentCoordinator?.childFlowEnded(self)
    }
    
    //MARK: - Private
}

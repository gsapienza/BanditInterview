//
//  NavigationControllerPresenter.swift
//  BanditInterview
//
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

class NavigationControllerPresenter: Presenter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func present(viewController: UIViewController, animated: Bool, completion: ((Any?) -> Void)?) {        
        navigationController.pushViewController(viewController, animated: animated)
        completion?(nil)
    }
    
    func dismiss(animated: Bool, completion: ((Any?) -> Void)?) {
        navigationController.popViewController(animated: animated)
        completion?(nil)
    }
}

//
//  FlowCoordinator.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import Foundation

@objc protocol FlowCoordinator: class {
    weak var parentCoordinator: ParentFlowCoordinator? { get set }
    func endFlow()
}

@objc protocol ParentFlowCoordinator: FlowCoordinator {
    var childCoordinators: [FlowCoordinator] { get set }
}

extension ParentFlowCoordinator {
    func childFlowBegan(_ childCoordinator: FlowCoordinator) {
        childCoordinator.parentCoordinator = self
        childCoordinators.append(childCoordinator)
    }
    
    func childFlowEnded(_ childCoordinator: FlowCoordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}

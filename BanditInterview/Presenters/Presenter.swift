//
//  Presenter.swift
//  BanditInterview
//
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

protocol Presenter {
    func present(viewController: UIViewController, animated: Bool, completion: ((Any?) -> Void)?)
    func dismiss(animated: Bool, completion: ((Any?) -> Void)?)
}

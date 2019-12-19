//  
//  SearchScreenViewController.swift
//  BanditInterview
//
//  Created by Gregory Sapienza on 12/17/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import UIKit

enum Section: CaseIterable {
       case main
}

class SearchScreenViewController: UIViewController {
    
    //MARK: - Public
    
    let searchTextField = UITextField()
    
    //MARK: - Private Properties
    
    private let interactor: SearchInteractorProtocol
    private let headerView = SearchHeaderView()
    private let searchTopBackgroundView = FadeGradientView()
    private let collectionView: UICollectionView
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private var searchTextFieldCenterConstraint: NSLayoutConstraint?
    private var searchTextFieldTopConstraint: NSLayoutConstraint?
    private var imagePageCollections = [ImagePageCollection]()
    private var currentlyPerformingEndlessScrollSearch = false
    private var dataSource: UICollectionViewDiffableDataSource<Section, ImageItemViewModel>?
    private var viewModel: SearchScreenViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            headerView.viewModel = viewModel.headerViewModel
            headerView.alpha = viewModel.headerAlpha
            searchTopBackgroundView.isHidden = viewModel.isSearchTopBackgroundViewHidden
            searchTextField.attributedPlaceholder = viewModel.searchFieldPlaceholderAttributedString
            searchTextField.typingAttributes = viewModel.searchFieldAttributes
            searchTextField.defaultTextAttributes = viewModel.searchFieldAttributes
            searchTextField.tintColor = viewModel.searchFieldTintColor
            searchTextField.transform = CGAffineTransform(scaleX: viewModel.searchFieldScale, y: viewModel.searchFieldScale)
            collectionView.alpha = viewModel.collectionViewAlpha
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, ImageItemViewModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(viewModel.imageItemViewModels, toSection: .main)
            dataSource?.apply(snapshot, animatingDifferences: true)
            
            if viewModel.isActivityIndicatorHidden {
                activityIndicatorView.stopAnimating()
            } else {
                activityIndicatorView.startAnimating()
            }
            
            switch viewModel.searchFieldAlignment {
            case .center:
                searchTextFieldTopConstraint?.isActive = false
                searchTextFieldCenterConstraint?.isActive = true
            case .top:
                searchTextFieldCenterConstraint?.isActive = false
                searchTextFieldTopConstraint?.isActive = true
            }
        }
    }
    
    //MARK: - Public
    
    init(interactor: SearchInteractorProtocol) {
        self.interactor = interactor
        
        collectionViewLayout.minimumLineSpacing = 2
        collectionViewLayout.minimumInteritemSpacing = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        super.init(nibName: nil, bundle: nil)
        
        //---View---//
        
        view.backgroundColor = .systemBackground
        
        //---Collection View---//
          
        configureDataSource()
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "\(SearchResultCollectionViewCell.self)")
        //collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        //---Header View---//
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        //---Search Top Background View---//
        
        searchTopBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTopBackgroundView)
        
        //---Text Field---//
        
        searchTextField.becomeFirstResponder()
        searchTextField.returnKeyType = .done
        searchTextField.autocapitalizationType = .words
        searchTextField.autocorrectionType = .no
        searchTextField.borderStyle = .none
        searchTextField.addTarget(self, action: #selector(onSearchTextFieldEdit), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(onSearchTextFieldEditEnd), for: .editingDidEndOnExit)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        
        //---Activity Indicator View---//
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        
        //---Notifications---//
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //---Layout---//
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //---Collection View---//
        
        let numberOfColumns: CGFloat = 3
        let spacing: CGFloat = 2
        let itemSize = (view.bounds.width / numberOfColumns) - spacing
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        //---VM---//
               
        viewModel = SearchScreenViewModelTranslator.translate(text: searchTextField.text ?? "", imageItems: imageItemsFromCollections())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentInset.top = searchTopBackgroundView.frame.height
        collectionView.verticalScrollIndicatorInsets.top = searchTopBackgroundView.frame.height
    }
    
    func search(text: String, pageNumber: Int, success: @escaping () -> Void, failure: @escaping () -> Void) {
        interactor.fetchImageCollection(text: text, pageNumber: pageNumber, success: { (imagePageCollection) in
            if text == self.searchTextField.text {
                success()
                self.imagePageCollections.append(imagePageCollection)
                self.viewModel = SearchScreenViewModelTranslator.translate(text: text, imageItems: self.imageItemsFromCollections())
            } else {
                failure()
            }
        }) { (error) in
            failure()
            print(error ?? "")
        }
    }
    
    //MARK: - Private
    
    private func layout() {
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
        //---Header View---//
        
        headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        //---Search Top Background View---//
        
        searchTopBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchTopBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchTopBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchTopBackgroundView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        //---Search Text Field---//
        
        searchTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        searchTextFieldCenterConstraint = searchTextField.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        searchTextFieldCenterConstraint?.isActive = true
        searchTextFieldTopConstraint = searchTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        searchTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //---Collection View---//
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //---Activity Indicator View---//
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func onSearchTextFieldEdit() {
        if let text = searchTextField.text, text != "" {
            let delay: Double = text.count == 1 ? 0.0 : 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if text == self.searchTextField.text {
                    self.search(text: text, pageNumber: 1, success: {
                        if self.collectionView.contentOffset.y + self.collectionView.contentInset.top != 0 {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                        self.imagePageCollections = []
                    }, failure: {
                        
                    })
                }
            }
        } else {
            imagePageCollections = []
            viewModel = SearchScreenViewModelTranslator.translate(text: "", imageItems: imageItemsFromCollections())
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.viewModel = SearchScreenViewModelTranslator.translate(text: self.searchTextField.text ?? "", imageItems: self.imageItemsFromCollections())
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func onSearchTextFieldEditEnd() {
        searchTextField.resignFirstResponder()
    }
    
    @objc private func onKeyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardHeightValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardHeightValue.cgRectValue.height
        
        collectionView.contentInset.bottom = keyboardHeight
        collectionView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func onKeyboardWillHideNotification(_ notification: Notification) {
        collectionView.contentInset.bottom = 0
        collectionView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func imageItemsFromCollections() -> [ImageItem] {
        var imageItems = [ImageItem]()
        
        for collection in imagePageCollections {
            imageItems.append(contentsOf: collection.imageItems)
        }
        
        return imageItems
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ImageItemViewModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, viewModel: ImageItemViewModel) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchResultCollectionViewCell.self)", for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
            
            cell.viewModel = viewModel
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchScreenViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let text = searchTextField.text, text != "", !currentlyPerformingEndlessScrollSearch else { return }
        
        if scrollView.contentOffset.y + scrollView.contentInset.bottom >= scrollView.contentSize.height - scrollView.frame.size.height {
            currentlyPerformingEndlessScrollSearch = true
            search(text: text, pageNumber: imagePageCollections.count + 1, success: {
                self.currentlyPerformingEndlessScrollSearch = false
            }, failure: {
                self.currentlyPerformingEndlessScrollSearch = false
            })
        }
    }
}

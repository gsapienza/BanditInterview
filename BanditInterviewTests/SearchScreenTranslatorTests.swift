//
//  SearchScreenTranslatorTests.swift
//  BanditInterviewTests
//
//  Created by Gregory Sapienza on 12/19/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import XCTest
@testable import BanditInterview

class SearchScreenTranslatorTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSearchScreenEmptyResultsTranslator() {
        let imageCollection = ImagePageCollection(page: 1, pages: 5, perpage: 100, imageItems: [])
        
        let vm = SearchScreenViewModelTranslator.translate(text: "", imageItems: imageCollection.imageItems)
        
        XCTAssert(vm.headerAlpha == 1)
        XCTAssert(vm.searchFieldScale == 1)
        XCTAssert(vm.searchFieldAlignment == .center)
        XCTAssert(vm.collectionViewAlpha == 0)
        XCTAssertTrue(vm.isSearchTopBackgroundViewHidden)
        XCTAssertTrue(vm.isActivityIndicatorHidden)
        XCTAssertTrue(vm.imageItemViewModels.isEmpty)
    }
    
    func testSearchScreenResultsTranslator() {
        let imageItem = ImageItem(id: "1234", secret: "1234", server: "1234", farm: 20)
        let imageItem2 = ImageItem(id: "5678", secret: "5678", server: "5678", farm: 20)
        
        let imageCollection = ImagePageCollection(page: 1, pages: 5, perpage: 100, imageItems: [imageItem, imageItem2])
        
        let vm = SearchScreenViewModelTranslator.translate(text: "Coffee", imageItems: imageCollection.imageItems)
        
        XCTAssert(vm.headerAlpha == 0)
        XCTAssert(vm.searchFieldScale != 1)
        XCTAssert(vm.searchFieldAlignment == .top)
        XCTAssert(vm.collectionViewAlpha == 1)
        XCTAssertFalse(vm.isSearchTopBackgroundViewHidden)
        XCTAssertTrue(vm.isActivityIndicatorHidden)
        XCTAssert(vm.imageItemViewModels.count == 2)
        
        for (i, imageItemVM) in vm.imageItemViewModels.enumerated() {
            let imageItem = imageCollection.imageItems[i]
            let imageURL = URL(string: "http://farm\(imageItem.farm).static.flickr.com/\(imageItem.server)/\(imageItem.id)_\(imageItem.secret).jpg")
            XCTAssert(imageItemVM.imageURL == imageURL)
        }
    }
}

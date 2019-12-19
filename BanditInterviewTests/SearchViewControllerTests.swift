//
//  SearchViewControllerTests.swift
//  BanditInterviewTests
//
//  Created by Gregory Sapienza on 12/19/19.
//  Copyright © 2019 Gregory Sapienza. All rights reserved.
//

import XCTest
@testable import BanditInterview

class SearchViewControllerTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSearch() {
        let interactor = MockSearchInteractor()
        let vc = SearchScreenViewController(interactor: interactor)
        vc.searchTextField.text = "Coffee"
        
        let searchExpectation = expectation(description: "search")
        vc.search(text: "Coffee", pageNumber: 1, success: {
            searchExpectation.fulfill()
        }) {
            XCTFail("Search Failed")
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}

private class MockSearchInteractor: SearchInteractorProtocol {
    func fetchImageCollection(text: String, pageNumber: Int, success: @escaping (ImagePageCollection) -> Void, failure: @escaping (Error?) -> Void) {

        do {
            let data = getData(name: "TestSearchResults")
            if let photoJSON = try? JSONSerialization.jsonObject(with: data) as? [String : Any?] {
                let photosDict = photoJSON["photos"]
                let photosJSONData = try JSONSerialization.data(withJSONObject: photosDict as Any, options: .prettyPrinted)
                
                let decodedResponse = try JSONDecoder().decode(ImagePageCollection.self, from: photosJSONData)
                    
                success(decodedResponse)
            }
        } catch {
            failure(error)
        }
    }
    
    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}

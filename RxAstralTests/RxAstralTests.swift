//
//  RxAstralTests.swift
//  RxAstralTests
//
//  Created by Julio Alorro on 1/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import Astral
import RxSwift
@testable import RxAstral

class RxAstralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRequest() {

        let request: Request = GetRequest()
        let dispatcher: JSONRequestDispatcher = JSONRequestDispatcher(request: request)

        let expectation = self.expectation(description: "Get Request Query")
        let bag: DisposeBag = DisposeBag()

        dispatcher.rx.response()
            .subscribe(
                onSuccess: { (response: Response) -> Void in
                    print(response.json.dictValue)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in
                    print(error)
                    expectation.fulfill()
                }
            )
            .disposed(by: bag)

        self.waitForExpectations(timeout: 5.0, handler: nil)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

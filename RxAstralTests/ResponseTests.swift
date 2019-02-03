//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import XCTest
import Astral
import RxSwift
@testable import RxAstral

class ResponseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        self.disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        self.disposeBag = nil
    }

    var disposeBag: DisposeBag!
    let decoder: JSONDecoder = JSONDecoder()

    private let backgroundScheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.utility)

    func transform<T: Decodable>(response: Response) -> T {
        do {

            return try self.decoder.decode(T.self, from: response.data)

        } catch {
            XCTFail("Failed to get args or url")
            fatalError(error.localizedDescription)
        }
    }

    func testHeaders() {
        let expectation: XCTestExpectation = self.expectation(description: "Headers Query")

        let request: BasicGetRequest = BasicGetRequest()

        BaseRequestDispatcher().rx.response(of: request)
            .observeOn(self.backgroundScheduler)
            .do(
                onSuccess: { response in
                    print("Thread is Utility:", Thread.current.qualityOfService == QualityOfService.utility)
                    print("Thread is Main:", Thread.current.isMainThread)
                },
                onError:  { error in
                    print("Thread is Utility:", Thread.current.qualityOfService == QualityOfService.utility)
                    print("Thread is Main:", Thread.current.isMainThread)
                }
            )
            .subscribe(
                onSuccess: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: GetResponse = s.transform(response: response)

                    let accept: Header = request.headers.filter { $0.key == .accept }.first!
                    let contentType: Header = request.headers.filter { $0.key == .contentType }.first!
                    let custom: Header = request.headers.filter { $0.key == Header.Key.custom("Get-Request") }.first!

                    XCTAssertTrue(response.headers.accept == accept.value.stringValue)
                    XCTAssertTrue(response.headers.contentType == contentType.value.stringValue)
                    XCTAssertTrue(response.headers.custom == custom.value.stringValue)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in
                     XCTFail(error.localizedDescription)
                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetRequest() {

        let expectation: XCTestExpectation = self.expectation(description: "Get Request Query")

        let request: Request = BasicGetRequest()
        let dispatcher: BaseRequestDispatcher = BaseRequestDispatcher()

        dispatcher.rx.response(of: request)
            .subscribe(
                onSuccess: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: GetResponse = s.transform(response: response)

                    guard case .dict(let parameters) = request.parameters else { XCTFail("Not a dictionary"); return }

                    XCTAssertTrue(response.url == dispatcher.builder.urlRequest(of: request).url!)
                    XCTAssertTrue(response.args.this == parameters["this"]! as! String)
                    XCTAssertTrue(response.args.what == parameters["what"]! as! String)
                    XCTAssertTrue(response.args.why == parameters["why"]! as! String)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in

                    XCTFail(error.localizedDescription)

                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 5.0, handler: nil)

    }

    /**
     PUT and DELETE http methods produce identical results with POST request
    */
    func testPostRequest() {
        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: Request = BasicPostRequest()

        let dispatcher: BaseRequestDispatcher = BaseRequestDispatcher()

        dispatcher.rx.response(of: request)
            .subscribe(
                onSuccess: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: PostResponse = s.transform(response: response)

                    guard case .dict(let parameters) = request.parameters else { XCTFail("Not a dictionary"); return }

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    XCTAssertTrue(response.json.this == parameters["this"]! as! String)
                    XCTAssertTrue(response.json.what == parameters["what"]! as! String)
                    XCTAssertTrue(response.json.why == parameters["why"]! as! String)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in

                    XCTFail(error.localizedDescription)

                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testFormURLEncodedRequest() {
        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: Request = FormURLEncodedPostRequest()

        let dispatcher: BaseRequestDispatcher = BaseRequestDispatcher(
            strategy: FormURLEncodedStrategy()
        )

        dispatcher.rx.response(of: request)
            .subscribe(
                onSuccess: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: FormURLEncodedResponse = s.transform(response: response)

                    guard case .dict(let parameters) = request.parameters else { XCTFail("Not a dictionary"); return }

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    XCTAssertTrue(response.form.this == parameters["this"]! as! String)
                    XCTAssertTrue(response.form.what == parameters["what"]! as! String)
                    XCTAssertTrue(response.form.why == parameters["why"]! as! String)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in

                    XCTFail(error.localizedDescription)

                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testMultiPartFormDataRequest() {

        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: MultiPartFormDataRequest = BasicMultipartFormDataRequest()

        let dispatcher: BaseRequestDispatcher = BaseRequestDispatcher(
            strategy: MultiPartFormDataStrategy()
        )

        dispatcher.rx.response(of: request)
            .subscribe(
                onSuccess: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: MultipartFormDataResponse = s.transform(response: response)

                    guard case .dict(let parameters) = request.parameters else { XCTFail("Not a dictionary"); return }

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    XCTAssertTrue(response.form.this == parameters["this"]! as! String)
                    XCTAssertTrue(response.form.what == parameters["what"]! as! String)
                    XCTAssertTrue(response.form.why == parameters["why"]! as! String)
                    XCTAssertFalse(response.files.isEmpty)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in

                    XCTFail(error.localizedDescription)

                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 5.0, handler: nil)

    }

    public func testForMultipartFormDataRequest2() {

        let expectation: XCTestExpectation = self.expectation(description: "Multipart form data")

        let dispatcher: BaseRequestDispatcher = BaseRequestDispatcher(builder: MultiPartFormDataBuilder())
        let request: MultiPartFormDataRequest = BasicMultipartFormDataRequest()

        dispatcher.rx.multipartFormDataResponse(of: request)
            .observeOn(self.backgroundScheduler)
            .do(
                onSuccess: { response in
                    XCTAssertTrue(Thread.current.qualityOfService == QualityOfService.utility)
                },
                onError:  { error in
                    XCTAssertTrue(Thread.current.qualityOfService == QualityOfService.utility)
                }
            )
            .subscribe(
                onSuccess: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: MultipartFormDataResponse = s.transform(response: response)

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    switch request.parameters {
                        case .dict(let parameters):
                            XCTAssertTrue(response.form.this == parameters["this"]! as! String)
                            XCTAssertTrue(response.form.what == parameters["what"]! as! String)
                            XCTAssertTrue(response.form.why == parameters["why"]! as! String)

                        case .array, .none:
                            XCTFail()
                    }
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in
                    XCTFail(error.localizedDescription)
                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 20.0, handler: nil)
    }

}

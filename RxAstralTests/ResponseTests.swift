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

    func transform<U: Decodable>(response: Response) -> U {
        do {

            return try self.decoder.decode(U.self, from: response.data)

        } catch {
            XCTFail("Failed to get args or url")
            fatalError(error.localizedDescription)
        }
    }

    func testHeaders() {
        let expectation: XCTestExpectation = self.expectation(description: "Headers Query")

        let request: BasicGetRequest = BasicGetRequest()

        BaseRequestDispatcher().rx.response(of: request)
            .subscribe(
                onNext: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: GetResponse = s.transform(response: response)

                    let accept: Header = request.headers.filter { $0.key == .accept }.first!
                    let contentType: Header = request.headers.filter { $0.key == .contentType }.first!
                    let custom: Header = request.headers.filter { $0.key == Header.Field.custom("Get-Request") }.first!

                    XCTAssertTrue(response.headers.accept == accept.value.stringValue)
                    XCTAssertTrue(response.headers.contentType == contentType.value.stringValue)
                    XCTAssertTrue(response.headers.custom == custom.value.stringValue)
                    expectation.fulfill()
                },
                onError: { (error: Error) -> Void in
                     XCTFail(error.localizedDescription)
                },
                onCompleted: {
                    print("Thread is Utility:", Thread.current.qualityOfService == QualityOfService.utility)
                    print("Thread:", Thread.current.isMainThread)
                }
            )
            .disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetRequest() {

        let expectation: XCTestExpectation = self.expectation(description: "Get Request Query")

        let request: Request = BasicGetRequest()

        BaseRequestDispatcher().rx.response(of: request)
            .subscribe(
                onNext: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: GetResponse = s.transform(response: response)

                    XCTAssertTrue(response.url == BaseRequestDispatcher().urlRequest(of: request).url!)
                    XCTAssertTrue(response.args.this == request.parameters["this"]! as! String)
                    XCTAssertTrue(response.args.what == request.parameters["what"]! as! String)
                    XCTAssertTrue(response.args.why == request.parameters["why"]! as! String)
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
                onNext: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: PostResponse = s.transform(response: response)

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    XCTAssertTrue(response.json.this == request.parameters["this"]! as! String)
                    XCTAssertTrue(response.json.what == request.parameters["what"]! as! String)
                    XCTAssertTrue(response.json.why == request.parameters["why"]! as! String)
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
                onNext: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: FormURLEncodedResponse = s.transform(response: response)

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    XCTAssertTrue(response.form.this == request.parameters["this"]! as! String)
                    XCTAssertTrue(response.form.what == request.parameters["what"]! as! String)
                    XCTAssertTrue(response.form.why == request.parameters["why"]! as! String)
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
            strategy: MultiPartFormDataStrategy(request: request)
        )

        dispatcher.rx.response(of: request)
            .subscribe(
                onNext: { [weak self] (response: Response) -> Void in
                    guard let s = self else { return }
                    let response: MultipartFormDataResponse = s.transform(response: response)

                    XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                    XCTAssertTrue(response.form.this == request.parameters["this"]! as! String)
                    XCTAssertTrue(response.form.what == request.parameters["what"]! as! String)
                    XCTAssertTrue(response.form.why == request.parameters["why"]! as! String)
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

}

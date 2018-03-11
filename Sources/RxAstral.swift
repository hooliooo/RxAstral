//
//  RxAstral.swift
//  RxAstral
//
//  Created by Julio Alorro on 1/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Astral
import RxSwift

extension BaseRequestDispatcher: ReactiveCompatible {}

extension Reactive where Base: RequestDispatcher {

    /**

     Rx extension on RequestDispatcher that returns an Observable<Response>.
     - parameter request: The Request instance used to create an Observable<Response>.

    */
    public func response(of request: Request) -> Observable<Response> {
        let urlRequest: URLRequest = self.base.urlRequest(of: request)
        self.base.tasks = self.base.tasks.filter {
            $0.state == URLSessionTask.State.running ||
            $0.state == URLSessionTask.State.suspended
        }

        return Observable.create { (observer: AnyObserver<Response>) -> Disposable in
            let task = Base.session.dataTask(with: urlRequest) {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                // swiftlint:disable:previous closure_parameter_position

                if let error = error {

                    observer.onError(
                        NetworkingError.connection(error)
                    )

                } else if let data = data, let response = response as? HTTPURLResponse {

                    switch self.base.isDebugMode {
                        case true:
                            print("HTTP Method: \(request.method.stringValue)")
                            print("Response: \(response)")

                        case false:
                            break
                    }

                    switch response.statusCode {
                        case 200...399:
                            observer.onNext(
                                JSONResponse(
                                    httpResponse: response,
                                    data: data
                                )
                            )

                        case 400...599:
                            observer.onError(
                                NetworkingError.response(
                                    JSONResponse(
                                        httpResponse: response,
                                        data: data
                                    )
                                )
                            )

                        default:
                           observer.onError(
                                NetworkingError.unknownResponse(
                                    JSONResponse(httpResponse: response, data: data),
                                    "Unhandled status code: \(response.statusCode)"
                                )
                            )
                    }
                } else {
                    observer.onError(
                        NetworkingError.unknown("Unknown error occured")
                    )
                }
            }

            task.resume()

            return Disposables.create(with: task.cancel)
        }
    }

    /**
     Cancels all URLSessionTasks created by this RequestDispatcher instance.
    */
    public func cancel() {
        self.base.cancel()
    }

}

//
//  RxAstral.swift
//  RxAstral
//
//  Created by Julio Alorro on 1/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import struct Foundation.URLRequest
import class Foundation.URLSessionTask
import struct Foundation.Data
import class Foundation.URLResponse
import class Foundation.HTTPURLResponse
import class Astral.BaseRequestDispatcher
import protocol Astral.RequestDispatcher
import protocol Astral.Response
import protocol Astral.Request
import enum Astral.NetworkingError
import struct Astral.JSONResponse
import struct RxSwift.Reactive
import protocol RxSwift.ReactiveCompatible
import struct RxSwift.Single
import enum RxSwift.SingleEvent
import protocol RxSwift.Disposable
import struct RxSwift.Disposables

extension BaseRequestDispatcher: ReactiveCompatible {}

extension Reactive where Base: RequestDispatcher {

    /**

     Rx extension on RequestDispatcher that returns an Observable<Response>.
     - parameter request: The Request instance used to create an Observable<Response>.

    */
    public func response(of request: Request) -> Single<Response> {
        let urlRequest: URLRequest = self.base.urlRequest(of: request)
        self.base.tasks = self.base.tasks.filter {
            $0.state == URLSessionTask.State.running ||
            $0.state == URLSessionTask.State.suspended
        }

        let base: Base = self.base

        return Single.create { (single: @escaping (SingleEvent<Response>) -> Void) -> Disposable in

            let task = base.session.dataTask(with: urlRequest) {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                // swiftlint:disable:previous closure_parameter_position

                if let error = error {

                    single(
                        SingleEvent.error(
                            NetworkingError.connection(error)
                        )
                    )

                } else if let data = data, let response = response as? HTTPURLResponse {

                    switch base.isDebugMode {
                        case true:
                            print("HTTP Method: \(request.method.stringValue)")
                            print("Response: \(response)")

                        case false:
                            break
                    }

                    switch response.statusCode {
                        case 200...399:
                            single(
                                SingleEvent.success(
                                    JSONResponse(
                                        httpResponse: response,
                                        data: data
                                    )
                                )
                            )

                        case 400...599:
                            single(
                                SingleEvent.error(
                                    NetworkingError.response(
                                        JSONResponse(
                                            httpResponse: response,
                                            data: data
                                        )
                                    )
                                )
                            )

                        default:
                            single(
                                SingleEvent.error(
                                    NetworkingError.unknownResponse(
                                        JSONResponse(httpResponse: response, data: data),
                                        "Unhandled status code: \(response.statusCode)"
                                    )
                                )
                            )
                    }
                } else {
                    single(
                        SingleEvent.error(
                            NetworkingError.unknown("Unknown error occured")
                        )
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

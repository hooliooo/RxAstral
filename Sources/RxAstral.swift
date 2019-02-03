//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import class Foundation.URLSessionDataTask
import class Astral.BaseRequestDispatcher
import protocol Astral.Response
import protocol Astral.Request
import enum Astral.NetworkingError
import protocol Astral.MultiPartFormDataRequest
import struct RxSwift.Reactive
import struct RxSwift.Single
import enum RxSwift.SingleEvent
import protocol RxSwift.Disposable
import struct RxSwift.Disposables

extension Reactive where Base: BaseRequestDispatcher {

    /**

     Rx extension on BaseRequestDispatcher that returns an Single<Response>.
     - parameter request: The Request instance used to create an Single<Response>.

    */
    public func response(of request: Request) -> Single<Response> {
        let base: Base = self.base

        return Single.create { (single: @escaping (SingleEvent<Response>) -> Void) -> Disposable in

            let task: URLSessionDataTask = base.response(
                of: request,
                onSuccess: { (resp: Response) -> Void in
                    single(SingleEvent.success(resp))
                },
                onFailure: { (error: NetworkingError) -> Void in
                    single(SingleEvent.error(error))
                },
                onComplete: {}
            )

            return Disposables.create(with: task.cancel)
        }
    }

    /**

     Rx extension on BaseRequestDispatcher that returns an Single<Response>.
     - parameter request: The MultiPartFormDataRequest instance used to create an Single<Response>.

    */
    public func multipartFormDataResponse(of request: MultiPartFormDataRequest) -> Single<Response> {
        let base: Base = self.base
        return Single.create { (single: @escaping (SingleEvent<Response>) -> Void) -> Disposable in

            do {
                let task: URLSessionDataTask = try base.multipartFormDataResponse(
                    of: request,
                    onSuccess: { (resp: Response) -> Void in
                        single(SingleEvent.success(resp))
                    },
                    onFailure: { (error: NetworkingError) -> Void in
                        single(SingleEvent.error(error))
                    },
                    onComplete: {}
                )

                return Disposables.create(with: task.cancel)
            } catch {
                single(SingleEvent.error(error))
                return Disposables.create()
            }
        }
    }

}

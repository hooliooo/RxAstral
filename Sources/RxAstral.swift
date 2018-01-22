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
import Result

extension JSONRequestDispatcher: ReactiveCompatible {}

extension Reactive where Base: JSONRequestDispatcher {

    /**

     Rx extension to the response() method that transforms the Future into a Single and return it.

     Returns a Single<Response> instance.

    */
    public func response() -> Single<Response> {

        return Single.create(
            subscribe: { (single: @escaping (SingleEvent<Response>) -> Void) -> Disposable in

                self.base.response()
                    .onComplete { (result: Result<Response, NetworkingError>) -> Void in
                        switch result {
                            case .success(let response):
                                single(SingleEvent<Response>.success(response))

                            case .failure(let error):
                                single(SingleEvent<Response>.error(error))
                        }
                    }

                return Disposables.create {
                    self.base.cancel()
                }
            }
        )
    }

    /**
     Cancels all URLSessionTasks created by this RequestDispatcher instance.
    */
    public func cancel() {
        self.base.cancel()
    }

}

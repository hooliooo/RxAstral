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
import RxCocoa
import Result

extension JSONRequestDispatcher: ReactiveCompatible {}

extension Reactive where Base: JSONRequestDispatcher {

    func response() -> Single<Response> {

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

}

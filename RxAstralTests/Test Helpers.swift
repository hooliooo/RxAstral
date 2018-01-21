//
//  Test Helpers.swift
//  RxAstralTests
//
//  Created by Julio Alorro on 1/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Astral

struct Configuration: RequestConfiguration {
    var scheme: URLScheme {
        return .https
    }

    var host: String {
        return "httpbin.org"
    }

    var basePathComponents: [String] {
        return []
    }

    var baseHeaders: [String: Any] {
        return [
            "Content-Type": "application/json"
        ]
    }
}

struct GetRequest: Request {
    let configuration: RequestConfiguration  = Configuration()

    let method: HTTPMethod =  .get

    let pathComponents: [String] = ["get"]

    let parameters: [String: Any] = [
        "this": "that"
    ]

    let headers: [String: Any] = [
        "Get-Request": "YES"
    ]
}

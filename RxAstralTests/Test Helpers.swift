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

    var baseHeaders: Set<Header> = [
        Header(key: Header.Field.contentType, value: Header.Value.mediaType(MediaType.applicationJSON))
    ]
}

struct GetRequest: Request {
    let configuration: RequestConfiguration = Configuration()

    let method: HTTPMethod =  .get

    let pathComponents: [String] = ["get"]

    let parameters: Parameters = Parameters.dict([
        "this": "that"
    ])

    let headers: Set<Header> = [
        Header(key: Header.Field.custom("Get-Request"), value: Header.Value.custom("YES"))
    ]
}

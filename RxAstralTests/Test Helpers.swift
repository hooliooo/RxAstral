//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
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
        Header(key: Header.Key.contentType, value: Header.Value.mediaType(MediaType.applicationJSON))
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
        Header(key: Header.Key.custom("Get-Request"), value: Header.Value.custom("YES"))
    ]
}

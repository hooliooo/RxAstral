//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

struct FormURLEncodedResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case form
        case headers
        case url
    }

    public let form: BinData
    public let headers: BinHeaders
    public let url: URL

}

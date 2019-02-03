//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

struct BinHeaders: Decodable {

    enum CodingKeys: String, CodingKey {
        case accept = "Accept"
        case contentType = "Content-Type"
        case custom = "Get-Request"
    }

    public let accept: String
    public let contentType: String
    public let custom: String

}

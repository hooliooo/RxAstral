//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Astral

struct BinData: Decodable {

    enum CodingKeys: String, CodingKey {
        case this
        case what
        case why
    }

    public let this: String
    public let what: String
    public let why: String

}

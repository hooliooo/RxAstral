//
//  RxAstral
//  Copyright (c) 2017-2019 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation
import Astral
import UIKit

struct BasicMultipartFormDataRequest: MultiPartFormDataRequest {

    let configuration: RequestConfiguration = MultiPartFormConfiguration()

    let method: HTTPMethod = HTTPMethod.post

    let pathComponents: [String] = [
        "post"
    ]

    let parameters: Parameters = Parameters.dict([
        "this": "that",
        "what": "where",
        "why": "what"
        ])

    var headers: Set<Header> {

        return [
            Header(key: Header.Key.custom("Get-Request"), value: Header.Value.custom("Yes")),
            Header(key: Header.Key.contentType, value: Header.Value.mediaType(MediaType.multipartFormData(Astral.shared.boundary))),
            Header(key: Header.Key.custom("Connection"), value: Header.Value.custom("Keep-Alive"))
        ]
    }

    public var components: [MultiPartFormDataComponent] {

        let bundle: Bundle = Bundle(for: ResponseTests.self)

        let getData: (String) -> Data = { (imageName: String) -> Data in
            return UIImage(named: imageName, in: bundle, compatibleWith: nil)!.pngData()!
        }

        let getURL: (String, String) -> URL = { (imageName: String, fileExtension: String) -> URL in
            return bundle.url(forResource: imageName, withExtension: fileExtension)! // swiftlint:disable:this force_unwrapping

        }

        return [
            MultiPartFormDataComponent(
                name: "file1",
                fileName: "image1.png",
                contentType: "image/png",
                file: MultiPartFormDataComponent.File.data(getData("pic1"))
            ),
            MultiPartFormDataComponent(
                name: "file2",
                fileName: "image2.png",
                contentType: "image/png",
                file: MultiPartFormDataComponent.File.url(getURL("pic2", "png"))
            ),
            MultiPartFormDataComponent(
                name: "file3",
                fileName: "image3.png",
                contentType: "image/png",
                file: MultiPartFormDataComponent.File.data(getData("pic3"))
            ),
        ]
    }

    public var fileName: String {
        return String(describing: Mirror(reflecting: self).subjectType)
    }
}

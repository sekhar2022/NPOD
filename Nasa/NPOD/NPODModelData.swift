//
//  NPODModelData.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import Foundation

// MARK: - NPODModelData
class NPODModelData: Codable {
    let date, explanation: String
    let hdurl: String
    let mediaType, serviceVersion, title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }

    init(date: String, explanation: String, hdurl: String, mediaType: String, serviceVersion: String, title: String, url: String) {
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.mediaType = mediaType
        self.serviceVersion = serviceVersion
        self.title = title
        self.url = url
    }
}

// MARK: PODModelData convenience initializers and mutators
extension NPODModelData {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(NPODModelData.self, from: data)
        self.init(date: me.date, explanation: me.explanation, hdurl: me.hdurl, mediaType: me.mediaType, serviceVersion: me.serviceVersion, title: me.title, url: me.url)
    }

//    func with(
//        date: String? = nil,
//        explanation: String? = nil,
//        hdurl: String? = nil,
//        mediaType: String? = nil,
//        serviceVersion: String? = nil,
//        title: String? = nil,
//        url: String? = nil
//    ) -> NPODModelData {
//        return NPODModelData(
//            date: date ?? self.date,
//            explanation: explanation ?? self.explanation,
//            hdurl: hdurl ?? self.hdurl,
//            mediaType: mediaType ?? self.mediaType,
//            serviceVersion: serviceVersion ?? self.serviceVersion,
//            title: title ?? self.title,
//            url: url ?? self.url
//        )
//    }
}

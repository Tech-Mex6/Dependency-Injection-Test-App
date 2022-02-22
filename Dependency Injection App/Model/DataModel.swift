//
//  DataModel.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import UIKit

struct DataModel: Codable {
    var id: String
    var title: String
    var rating: String
    var sourceTld: String
    var images: Images
}

struct Images: Codable {
    var fixedHeightSmall: FixedHeightSmall
    var downsized: Downsized
}

struct FixedHeightSmall: Codable {
    var url: String
}

struct Downsized: Codable {
    var url: String
}

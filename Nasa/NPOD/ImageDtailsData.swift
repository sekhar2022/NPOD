//
//  ImageDtailsData.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import Foundation
import UIKit

class ImageDetailsViewModel {
    var date: String
    var imageTitle: String
    var descriptionText: String
    var uiImage: UIImage
    var isFavourite: Bool = false
    
    init(date: String, imageTitle: String, descriptionText: String, uiImage: UIImage) {
        self.date = date
        self.imageTitle = imageTitle
        self.descriptionText = descriptionText
        self.uiImage = uiImage
    }
}

//
//  AboutFilmModel.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 09.02.2023.
//

import UIKit
import Foundation

struct AboutFilm: Decodable {
    var title: String
    var description: String
    var image: String
}

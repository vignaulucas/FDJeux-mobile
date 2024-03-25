//
//  NewsModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation

struct News : Codable {
    var idNews: Int
    var createur: String
    var titre: String
    var description: String
    var favori: Bool
}

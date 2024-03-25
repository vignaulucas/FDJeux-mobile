//
//  FestivalModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation

struct Festival: Codable {
    var idFestival: Int
    var nom: String
    var date: String
    var nbReferent: Int
    var nbRespoSoiree: Int
    var nbAccueilBenevole: Int
    var nbBenevole: Int
    var enCours: Bool
    var idPlanning: String
}

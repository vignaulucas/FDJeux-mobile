//
//  SlotsModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation

struct Creneau: Codable {
    var idCreneau: Int
    var LigneId: Int
    var JourId: Int
    var HoraireId: Int
    var idPlanning: Int
    var ouvert: Bool
    var heure_debut: String
    var heure_fin: String
    var titre: String
    var nb_max: Int
    var nb_inscrit: Int
    var ReferentId: Int
    
}

struct CreneauBenevole: Codable {
    var idCreneauBenevole: Int
    var idUser: Int
    var idCreneau: Int
    var isPresent: Int
}

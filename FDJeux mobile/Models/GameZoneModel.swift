//
//  GameZoneModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 26/03/2024.
//

import Foundation

struct Jeu: Codable, Identifiable {
    let id: Int
    let idJeu, nameGame, author, editor: String?
    let description: String?
    let duration, type: String?
    let minAge, nbPlayers: String?
    let mechanisms, themes, tags: String?
    let planZone, volunteerZone, idZone: String?
    let toAnimate, received: String?
    let image, logo, video: String?
    let notice: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case idJeu = "idJeu"
        case nameGame = "nameGame"
        case author = "author"
        case editor = "editor"
        case description = "description"
        case duration = "duration"
        case type = "type"
        case minAge = "minAge"
        case nbPlayers = "nbPlayers"
        case mechanisms = "mechanisms"
        case themes = "themes"
        case tags = "tags"
        case planZone = "planZone"
        case volunteerZone = "volunteerZone"
        case idZone = "idZone"
        case toAnimate = "toAnimate"
        case received = "received"
        case image = "image"
        case logo = "logo"
        case video = "video"
        case notice = "notice"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}


struct Espace: Codable {
    let planZone: String
}

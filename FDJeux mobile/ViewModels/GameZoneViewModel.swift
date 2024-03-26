//
//  GameZoneViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 26/03/2024.
//

import Foundation

class GameZoneViewModel: ObservableObject {
    @Published var espaces: [Espace] = []
    @Published var jeux: [Jeu] = []

    func loadAllEspace() {
        guard let token = AuthenticationManager.shared.fetchToken() else {
            print("Token non disponible")
            return
        }
        
        guard let url = URL(string: "\(urlAPI)/csv/getallespace") else {
            print("URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Erreur lors de la requête: \(error?.localizedDescription ?? "Erreur inconnue")")
                return
            }

            do {
                let espaces = try JSONDecoder().decode([Espace].self, from: data)
                DispatchQueue.main.async {
                    self.espaces = espaces
                    print("Espaces chargés: \(espaces)")
                }
            } catch {
                print("Erreur lors du décodage des espaces: \(error)")
            }
        }.resume()
    }



    func loadJeuxByEspace(planZone: String) {
        
        guard let token = AuthenticationManager.shared.fetchToken() else {
            print("Token non disponible")
            return
        }
        
        guard let encodedPlanZone = planZone.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("Impossible d'encoder la zone de plan")
            return
        }
        
        let urlString = "\(urlAPI)/csv/getjeu/\(encodedPlanZone)"
        guard let url = URL(string: urlString) else {
            print("URL invalide: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Erreur lors de la requête: \(error?.localizedDescription ?? "Erreur inconnue")")
                return
            }

            let jeux = try? JSONDecoder().decode([Jeu].self, from: data)
            DispatchQueue.main.async {
                self.jeux = jeux ?? []
            }
        }.resume()
    }


}


            

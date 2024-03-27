//
//  SlotsViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 26/03/2024.
//

import Foundation

class SlotsViewModel: ObservableObject {
    @Published var creneauxBenevoles: [CreneauBenevole] = []

    func getCreneauxBenevole(forUserId userId: Int) {
        
        let token = AuthenticationManager.shared.fetchToken()
    
        guard let url = URL(string: "\(urlAPI)/creneau_benevole/getcreneaux/\(userId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Erreur lors de la récupération des créneaux bénévoles: \(error?.localizedDescription ?? "Inconnue")")
                return
            }

            do {
                let creneaux = try JSONDecoder().decode([CreneauBenevole].self, from: data)
                DispatchQueue.main.async {
                    self?.creneauxBenevoles = creneaux
                }
            } catch {
                print(String(data: data , encoding: .utf8) ?? "Données invalides")
                print("Erreur lors du décodage des créneaux bénévoles: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func getCreneauById(idCreneau: Int, completion: @escaping (Result<Creneau, Error>) -> Void) {
        
        let token = AuthenticationManager.shared.fetchToken()

        guard let url = URL(string: "\(urlAPI)/creneau/getbyid/\(idCreneau)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "dataTaskError", code: -1, userInfo: nil)))
                return
            }

            do {
                let creneau = try JSONDecoder().decode(Creneau.self, from: data)
                completion(.success(creneau))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    

    func InscriptionCreneauBenevole(idCreneau: Int, idUser: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let token = AuthenticationManager.shared.fetchToken()
        
        guard let token = token else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/creneau_benevole/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let requestData: [String: Any] = [
            "idCreneau": idCreneau,
            "idUser": idUser
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                        
            completion(.success(()))
        }.resume()
    }

    func DesinscriptionCreneauBenevole(idCreneau: Int, idUser: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let token = AuthenticationManager.shared.fetchToken()
        
        guard let token = token else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/creneau_benevole/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let requestData: [String: Any] = [
            "idCreneau": idCreneau,
            "idUser": idUser
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                        
            completion(.success(()))
        }.resume()
    }
    
    func GetAllSlots(PlanningId: Int, completion: @escaping (Result<[Creneau], Error>) -> Void) {
        print("Je suis bien dans GetAllSlots")
        
        let token = AuthenticationManager.shared.fetchToken()
        
        guard let token = token else {
            completion(.failure(NSError(domain: "AuthenticationError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token non disponible"])))
            return
        }
        
        let urlString = "\(urlAPI)/creneau/\(PlanningId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URLError", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL invalide: \(urlString)"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])))
                }
                return
            }
            
            do {
                let creneaux = try JSONDecoder().decode([Creneau].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(creneaux))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }

}

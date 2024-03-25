//
//  festivalViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation

func getCurrentFestival(completion: @escaping (Result<Festival, Error>) -> Void) {
    let token = AuthenticationManager.shared.fetchToken()
    
    guard let token = token else {
        completion(.failure(UserError.credentialsUnavailable))
        return
    }
    
    let url = URL(string: "\(urlAPI)/festival/enCours")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UserError.serverError))
            }
            return
        }
        
        do {
            let festivalsList = try JSONDecoder().decode(Festival.self, from: data)
            completion(.success(festivalsList))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

func registerToCurrentFestival(idFestival: Int) {
    let idUser = AuthenticationManager.shared.fetchUserId()
    if let idUser = idUser {
        updateUserForFestival(userId: idUser, festivalId: idFestival, isFlexible: true) { result in
            switch result {
            case .success(let updatedUser):
                print("Utilisateur mis à jour : \(updatedUser)")
            case .failure(let error):
                print("Erreur lors de la mise à jour de l'utilisateur : \(error)")
            }
        }
    }
}

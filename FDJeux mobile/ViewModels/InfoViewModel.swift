//
//  InfoViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation

func getInfos(completion: @escaping (Result<[Infos], Error>) -> Void) {
    let token = AuthenticationManager.shared.fetchToken()
    
    guard let token = token else {
        completion(.failure(UserError.credentialsUnavailable))
        return
    }
    
    let url = URL(string: "\(urlAPI)/infos/")! 
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
            let infosList = try JSONDecoder().decode([Infos].self, from: data)
            completion(.success(infosList))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

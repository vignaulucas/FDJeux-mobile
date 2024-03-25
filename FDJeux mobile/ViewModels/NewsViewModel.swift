//
//  newsViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation

func getNews(completion: @escaping (Result<[News], Error>) -> Void) {
    let token = AuthenticationManager.shared.fetchToken()
    
    guard let token = token else {
        completion(.failure(UserError.credentialsUnavailable))
        return
    }
    
    let url = URL(string: "\(urlAPI)/news/")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
    
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
            let newsList = try JSONDecoder().decode([News].self, from: data)
            completion(.success(newsList))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

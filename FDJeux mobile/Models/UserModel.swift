//
//  User.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 18/03/2024.
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
    let active: Bool
    let role: String
    let firstName: String
    let lastName: String
    let nbEdition: Int
    let pseudo: String?
    let postalAddress: String?
    let proposition: String?
    let association: String?
    let telephone: String?
    let profilePicture: String?
    let idFestival: String?
    let isFlexible: Bool?
}

struct ConnectedUser: Codable {
    var id: Int
    var accessToken: String
}

enum UserError: Error {
    case credentialsUnavailable
    case serverError
    // Other error cases as necessary
}

// Fetches the current user's details from the API
func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
    guard let token = AuthenticationManager.shared.fetchToken(),
          let userId = AuthenticationManager.shared.fetchUserId() else {
        completion(.failure(UserError.credentialsUnavailable))
        return
    }
    
    let userDetailsURL = "\(urlAPI)/user/\(userId)"
    guard let url = URL(string: userDetailsURL) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error ?? UserError.serverError))
            return
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            completion(.success(user))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

// Updates user profile information on the server
func updateProfile(email: String, phone: String, association: String, nickname: String, address: String, completion: @escaping (Result<User, Error>) -> Void) {
    guard let token = AuthenticationManager.shared.fetchToken(),
          let userId = AuthenticationManager.shared.fetchUserId() else {
        completion(.failure(UserError.credentialsUnavailable))
        return
    }
    
    let updateURL = "\(urlAPI)/user/ModifProfil"
    guard let url = URL(string: updateURL) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let body: [String: Any] = [
        "userId": userId,
        "email": email,
        "phone": phone,
        "association": association,
        "nickname": nickname,
        "postalAddress": address
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? UserError.serverError))
                return
            }
            
            do {
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(UserError.serverError))
                    return
                }
                
                let updatedUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(updatedUser))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    } catch {
        completion(.failure(error))
    }
}

// Example function for updating user information related to a festival
func updateUserForFestival(userId: String, festivalId: Int, isFlexible: Bool, completion: @escaping (Result<User, Error>) -> Void) {
    guard let token = AuthenticationManager.shared.fetchToken() else {
        completion(.failure(UserError.credentialsUnavailable))
        return
    }
    
    let updateFestivalURL = "\(urlAPI)/user"
    guard let url = URL(string: updateFestivalURL) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let parameters: [String: Any] = [
        "userId": userId,
        "festivalId": festivalId,
        "isFlexible": isFlexible
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? UserError.serverError))
                return
            }
            
            do {
                let updatedUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(updatedUser))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    } catch {
        completion(.failure(error))
    }
}

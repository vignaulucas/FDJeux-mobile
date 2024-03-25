//
//  authViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 18/03/2024.
//

import Foundation

class AuthenticationSession: ObservableObject {
    @Published var isLoggedIn = false
    
    private let tokenStorageKey = "UserAuthToken"

    var authToken: String? {
        get {
            AuthenticationManager.shared.fetchToken()
        }
        set(token) {
            guard let token = token else {
                AuthenticationManager.shared.deleteToken()
                isLoggedIn = false
                return
            }
            AuthenticationManager.shared.saveToken(token: token)
            isLoggedIn = true
        }
    }

    init() {
        isLoggedIn = authToken != nil
    }

    func signIn(token: String) {
        self.authToken = token
        isLoggedIn = true
    }
    
    func signOut() {
        self.authToken = nil
    }
}

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

    // Tentative d'obtenir le token du Keychain au lieu de UserDefaults
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

    // Initialise l'état d'authentification basé sur la présence du token
    init() {
        isLoggedIn = authToken != nil
    }

    // Enregistre l'utilisateur comme connecté
    func signIn(token: String) {
        self.authToken = token
        isLoggedIn = true
// Le didSet mettra à jour isLoggedIn
    }
    
    // Déconnecte l'utilisateur et supprime le token du stockage sécurisé
    func signOut() {
        self.authToken = nil // Le didSet de authToken gère la déconnexion et la suppression du token
    }
}

//
//  KeyChainAuthService.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 18/03/2024.
//

import Foundation
import SwiftUI

// Gère l'authentification et le stockage sécurisé du token et de l'ID utilisateur
class AuthenticationManager {
    
    // Instance partagée pour accéder à la classe dans toute l'application
    static let shared = AuthenticationManager()
    
    // Clés pour le stockage sécurisé
    private let tokenKey = "authToken"
    private let userIdKey = "userID"
    
    private init() {} // Empêche l'initialisation externe
    
    // Sauvegarde l'ID de l'utilisateur dans le Keychain
    func saveUserId(idUser: String) {
        guard saveToKeychain(data: idUser.data(using: .utf8)!, forKey: userIdKey) else {
            print("Impossible de sauvegarder l'ID utilisateur.")
            return
        }
        print("ID utilisateur sauvegardé.")
    }
    
    // Récupère l'ID de l'utilisateur depuis le Keychain
    func fetchUserId() -> String? {
        guard let userData = fetchFromKeychain(forKey: userIdKey) else {
            print("ID utilisateur introuvable.")
            return nil
        }
        return String(decoding: userData, as: UTF8.self)
    }
    
    // Supprime l'ID utilisateur du Keychain
    func deleteUserId() {
        guard deleteFromKeychain(forKey: userIdKey) else {
            print("Impossible de supprimer l'ID utilisateur.")
            return
        }
        print("ID utilisateur supprimé.")
    }
    
    // Sauvegarde le token d'authentification dans le Keychain
    func saveToken(token: String) {
        guard saveToKeychain(data: token.data(using: .utf8)!, forKey: tokenKey) else {
            print("Impossible de sauvegarder le token.")
            return
        }
        print("Token sauvegardé.")
    }
    
    // Récupère le token d'authentification depuis le Keychain
    func fetchToken() -> String? {
        guard let tokenData = fetchFromKeychain(forKey: tokenKey) else {
            print("Token introuvable.")
            return nil
        }
        return String(decoding: tokenData, as: UTF8.self)
    }
    
    // Supprime le token d'authentification du Keychain
    func deleteToken() {
        guard deleteFromKeychain(forKey: tokenKey) else {
            print("Impossible de supprimer le token.")
            return
        }
        print("Token supprimé.")
    }
    
    // MARK: - Keychain Interaction Helpers
    
    private func saveToKeychain(data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // Supprime l'ancienne valeur si elle existe
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    private func fetchFromKeychain(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return data
    }
    
    private func deleteFromKeychain(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}

//
//  ProfileViewModel.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User = User.placeholder()
    @Published var pseudo: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var phone: String = ""
    @Published var association: String = ""
    
    // Utilisez isSuccess pour le feedback d'animation
    @Published var isSuccess: Bool? = nil
    
    // Initialisation avec l'utilisateur actuel
    init(user: User) {
        self.user = user
        fetchUserData()
    }
    
    func fetchUserData() {
        self.pseudo = user.pseudo ?? ""
        self.email = user.email
        self.address = user.postalAddress ?? ""
        self.phone = user.telephone ?? ""
        self.association = user.association ?? ""
    }
    
    func updateProfile() {
        User.updateProfile(email: email, phone: phone, association: association, pseudo: pseudo, address: address) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedUser):
                    self?.user = updatedUser
                    self?.isSuccess = true
                    
                    // Déclenchez ici tout feedback visuel ou alerte pour le succès
                    
                case .failure:
                    self?.isSuccess = false
                    
                    // Déclenchez ici tout feedback visuel ou alerte pour l'échec
                }
                
                // Réinitialiser le feedback après un certain délai pour permettre l'affichage de l'animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.isSuccess = nil
                }
            }
        }
    }
}

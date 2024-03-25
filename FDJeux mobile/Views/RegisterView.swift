//
//  RegisterView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 18/03/2024.
//

import SwiftUI

struct RegisterView: View {
    
    //gerer la connexion
    @ObservedObject var AuthenticationManager : AuthenticationSession
    
    @State private var pseudo = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var telephone = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isShowingLoginView = false
    
    @State private var user : ConnectedUser? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Inscription")
                        .font(.largeTitle)
                        .bold()
                    
                    
                    HStack {
                        TextField("Prénom", text: $firstName)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        TextField("Nom de famille", text: $lastName)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                    }
                    
                    HStack {
                        TextField("Pseudo", text: $pseudo)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        TextField("Téléphone", text: $telephone)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                    }
                    
                    // Champ de saisie pour l'email
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Champ de saisie sécurisé pour le mot de passe
                    SecureField("Mot de passe", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Champ de saisie sécurisé pour la confirmation du mot de passe
                    SecureField("Confirmer le mot de passe", text: $confirmPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    Button("S'inscrire") {
                        registerUser()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    // Bouton pour aller sur la page de connexion
                    Button("Déjà inscrit ?") {
                        isShowingLoginView = true
                    }
                    .sheet(isPresented: $isShowingLoginView) {
                        LoginView(authSession: AuthenticationManager)
                    }
                    .foregroundColor(.blue)
                    .padding(.top, 10)
                }
            }
        }
    }
    // Fonction pour envoyer les données d'inscription à l'API
    func registerUser() {
        // Vérification des champs obligatoires
        guard !pseudo.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !email.isEmpty else {
            // Gérer l'erreur
            return
        }
        
        // Vérification de la correspondance des mots de passe
        guard password == confirmPassword else {
            // Gérer l'erreur
            return
        }
        
        // Création de l'objet utilisateur
        let newUser = User(
            email: email,
            password: password,
            active: true,
            role: "Bénévole",
            firstName: firstName,
            lastName: lastName,
            nbEdition: 0,
            pseudo: pseudo,
            postalAddress: nil,
            proposition: nil,
            association: nil,
            telephone: telephone,
            profilePicture: nil,
            idFestival: nil,
            isFlexible: nil
        )
        
        // Encodage de l'utilisateur en JSON
        guard let encodedUser = try? JSONEncoder().encode(newUser) else {
            // Gérer l'erreur
            return
        }
        
        // Envoi des données à l'API
        guard let url = URL(string: "\(urlAPI)/user/") else {
            // Gérer l'erreur
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedUser
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            // Vérifier la réponse de l'API et effectuer les actions nécessaires
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(ConnectedUser.self, from: data)
                    DispatchQueue.main.async {
                        self.user = decodedResponse
                        let token = decodedResponse.accessToken
                        let idUser = decodedResponse.id
                        
                        //sauvergarder le token
                        FDJeux_mobile.AuthenticationManager.shared.saveToken(token: token)
                        FDJeux_mobile.AuthenticationManager.shared.saveUserId(idUser: String(idUser))
                        
                        //se loger avec le token
                        AuthenticationManager.signIn(token: token)
                        
                    }
                } catch {
                    // Gérer l'erreur de désérialisation
                    print("Erreur lors de la désérialisation de la réponse JSON : \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
    // Structure pour le modèle de réponse de l'API (à adapter selon le format de réponse de votre API)
    struct Response: Decodable {
        // Propriétés de réponse de votre API
    }

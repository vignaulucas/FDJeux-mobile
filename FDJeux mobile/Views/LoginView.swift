//
//  LoginView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 18/03/2024.
//

import SwiftUI


struct LoginView: View {
    @StateObject var authSession = AuthenticationSession() // Utilisez AuthenticationSession au lieu de LoginManager
    @State private var isShowingRegisterView = false
    @State private var navigationTarget: NavigationDestination? // Renommé pour éviter toute confusion
    
    
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var invalidEmailIndicator: CGFloat = 0
    @State private var invalidPasswordIndicator: CGFloat = 0
    @State private var isPasswordVisible = false
    @State private var showingLoginScreen = false
    
    
    @State private var user: ConnectedUser? = nil
    
    enum NavigationDestination {
        case register
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.3).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Circle().scaleEffect(1.5).foregroundColor(.white.opacity(0.1))
                    Circle().scaleEffect(1.2).foregroundColor(.white)
                }
                
                VStack(spacing: 15) {
                    Text("Espace Membre").font(.title).fontWeight(.semibold)
                    
                    CustomTextField(placeholder: "Adresse e-mail", text: $userEmail, invalidIndicator: invalidEmailIndicator)
                    
                    CustomSecureField(placeholder: "Mot de passe", text: $userPassword, isPasswordVisible: $isPasswordVisible, invalidIndicator: invalidPasswordIndicator)
                    
                    Button("Connexion") {
                        processLogin(email: userEmail, password: userPassword)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    // Bouton pour aller vers la page d'inscription
                    Button("Pas encore inscrit ?") {
                                    isShowingRegisterView = true
                                }
                                .sheet(isPresented: $isShowingRegisterView) {
                                    RegisterView(AuthenticationManager: authSession)
                                }
                    .foregroundColor(.blue)
                    .padding()
                }
                // Déclencheur de navigation conditionnelle
                .navigationDestination(for: NavigationDestination.self, destination: { destination in
                    switch destination {
                    case .register:
                        RegisterView(AuthenticationManager: authSession) // Assurez-vous que cette vue existe
                    }
                })
            }
        }
    }
    
    func processLogin(email: String, password: String) {
        loginUser()
    }
    
    // Fonction pour récupérer les données de l'API
    func loginUser() {
        guard let url = URL(string: "\(urlAPI)/user/login") else {
            return
        }
        
        // Création des données JSON à envoyer
        let userData = [
            "email": userEmail,
            "password": userPassword
        ]
        
        do {
            // Encodage des données JSON
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            
            // Création de la requête URLRequest avec la méthode POST
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Création de la session URLSession et envoi de la requête
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Erreur lors de la récupération des données : \(error?.localizedDescription ?? "Erreur inconnue")")
                    return
                }
                
                do {
                    // Désérialisation des données JSON en un objet UserConnected
                    print(String(data: data, encoding: .utf8) ?? "coucou")
                    let decodedData = try JSONDecoder().decode(ConnectedUser.self, from: data)
                    DispatchQueue.main.async {
                        self.user = decodedData
                        // Vérification des informations de connexion ici
                        if self.user != nil {
                            self.invalidEmailIndicator = 0
                            self.invalidPasswordIndicator = 0
                            self.showingLoginScreen = true
                            
                            //sauvegarder le token
                            let token = decodedData.accessToken
                            let idUser = String(decodedData.id)
                            print(token)
                            print(idUser)
                            AuthenticationManager.shared.saveUserId(idUser: idUser)
                            AuthenticationManager.shared.saveToken(token: token)
                            
                            //se loger avec le token
                            authSession.signIn(token: token)
                        } else {
                            self.invalidEmailIndicator = 2
                        }
                    }
                } catch {
                    print("Erreur lors de la désérialisation de la réponse JSON : \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            print("Erreur lors de la création des données JSON : \(error.localizedDescription)")
        }
    }
    
    
    struct UserCredentials: Codable {
        let email: String
        let password: String
    }
    
    struct AuthenticatedUser: Codable {
        let idUser: Int
        let token: String?
    }
    
    class AuthenticationService: ObservableObject {
        func authenticate(with token: String) {
            // Implement token-based authentication logic here
        }
    }
    
    struct CustomTextField: View {
        var placeholder: String
        @Binding var text: String
        var invalidIndicator: CGFloat
        
        var body: some View {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: invalidIndicator))
        }
    }
    
    struct CustomSecureField: View {
        var placeholder: String
        @Binding var text: String
        @Binding var isPasswordVisible: Bool
        var invalidIndicator: CGFloat
        
        var body: some View {
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    CustomTextField(placeholder: placeholder, text: $text, invalidIndicator: invalidIndicator)
                } else {
                    SecureField(placeholder, text: $text)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: invalidIndicator))
                }
                
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
}

//
//  ContentView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 18/03/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authSession = AuthenticationSession() // Utilisez AuthenticationSession
    
    var body: some View {
        if authSession.isLoggedIn {
            //NavBarView()
            Text("Bienvenue dans votre application")
            ProtectedContentView()
                .onTapGesture {
                    authSession.signOut()
                }
        } else {
            // Afficher l'écran de connexion
            LoginView(authSession: authSession) // Assurez-vous que LoginView peut accepter un authSession
        }
    }
}


struct ProtectedContentView: View {
    var body: some View {
        Text("Bienvenue dans votre application")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

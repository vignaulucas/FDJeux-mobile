import SwiftUI

struct ContentView: View {
    @StateObject private var authSession = AuthenticationSession()

    init() {
        // Configuration de l'apparence de la barre de navigation
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
    }

    var body: some View {
        if authSession.isLoggedIn {
            VStack {
                NavBarView(logoutAction: authSession.signOut)
            }
        } else {
            LoginView(authSession: authSession)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

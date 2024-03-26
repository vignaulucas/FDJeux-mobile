import SwiftUI

struct CustomProfileView: View {
    @State private var isEditing = true
    
    @State private var user: User? = nil
    @State private var pseudo = ""
    @State private var postalAddress = ""
    @State private var telephone = ""
    @State private var association = ""
    @State private var email = ""
    
    @State private var imagePickerPresented = false
    @State private var profileImage: UIImage?
    
    @State private var showSuccessFeedback = false
    @State private var showErrorFeedback = false
    
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeaderView(user: user, profileImage: $profileImage)
                    .padding(.vertical)
                
                if let user = user {
                    if isEditing {
                        EditableUserInfoSection(pseudo: $pseudo, email: $email, postalAddress: $postalAddress, telephone: $telephone, association: $association)
                    } else {
                        UserInfoDisplaySection(user: user)
                    }
                    
                    if isEditing {
                        Button("Sauvegarder les changements") {
                            submitProfileUpdates()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                } else {
                    Text("Chargement du profil...").padding()
                }
                if showSuccessFeedback {
                                    Text("Profil mis à jour avec succès !")
                                        .foregroundColor(.green)
                                        .bold()
                                        .transition(.opacity)
                                        .animation(.easeInOut, value: showSuccessFeedback)
                }
            }
            .navigationBarTitle("Profil", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isEditing.toggle()
            }) {
                Text(isEditing ? "Annuler" : "Modifier")
            })
            .alert(isPresented: $showErrorFeedback) {
                Alert(title: Text("Erreur"), message: Text("Impossible de mettre à jour le profil."), dismissButton: .default(Text("OK")))
            }
            
        }
        .onAppear {
            fetchCurrentUser()
        }
    }
    
    private func fetchCurrentUser() {
        FDJeux_mobile.fetchCurrentUser { result in
            switch result {
            case .success(let fetchedUser):
                DispatchQueue.main.async {
                    self.user = fetchedUser
                    self.pseudo = fetchedUser.pseudo ?? ""
                    self.email = fetchedUser.email
                    self.postalAddress = fetchedUser.postalAddress ?? ""
                    self.telephone = fetchedUser.telephone ?? ""
                    self.association = fetchedUser.association ?? ""
                }
            case .failure(let error):
                print("Erreur lors de la récupération de l'utilisateur: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorFeedback = true
                }
            }
        }
    }
    
    private func submitProfileUpdates() {
        updateProfile(email: email, phone: telephone, association: association, pseudo: pseudo, address: postalAddress) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let updatedUser):
                            self.user = updatedUser
                            self.showSuccessFeedback = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showSuccessFeedback = false
                            }
                        case .failure(let error):
                            print("Erreur lors de la mise à jour du profil: \(error.localizedDescription)")
                            self.showErrorFeedback = true
                        }
                    }
                }
            }
        }


struct ProfileHeaderView: View {
    var user: User?
    @Binding var profileImage: UIImage?
    
    var body: some View {
        VStack {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
            } else if let initial = user?.firstName.first {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .overlay(Text(String(initial)).font(.largeTitle).foregroundColor(.white))
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            
            if let user = user {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.headline)
            }
        }
    }
}

struct EditableUserInfoSection: View {
    @Binding var pseudo: String
    @Binding var email: String
    @Binding var postalAddress: String
    @Binding var telephone: String
    @Binding var association: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Pseudo", text: $pseudo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Adresse postale", text: $postalAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Téléphone", text: $telephone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Association", text: $association)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}

struct UserInfoDisplaySection: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pseudo: \(user.pseudo ?? "Non défini")")
            Text("Email: \(user.email)")
            Text("Adresse postale: \(user.postalAddress ?? "Non définie")")
            Text("Téléphone: \(user.telephone ?? "Non défini")")
            Text("Association: \(user.association ?? "Non définie")")
        }
        .padding()
    }
}

struct MyPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

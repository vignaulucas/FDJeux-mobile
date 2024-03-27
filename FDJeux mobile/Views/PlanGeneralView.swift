//
//  PlanGeneralView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import SwiftUI

struct PlanningGeneralView: View {
    @StateObject private var viewModel = SlotsViewModel()
    @State private var creneauxDetails: [Creneau] = []
    @State private var selectedCreneauId: Int? = nil
    @State private var creneauxBenevole: [Creneau] = []
    
    private var creneauxParJour: [Int: [Creneau]] {
        Dictionary(grouping: creneauxDetails.sorted(by: { $0.heure_debut < $1.heure_debut }), by: { $0.JourId })
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(creneauxParJour.keys.sorted()), id: \.self) { jourId in
                    Section(header: Text("Jour \(jourId)").font(.title2)) {
                        ForEach(creneauxParJour[jourId] ?? [], id: \.idCreneau) { creneau in
                            CreneauCellView(creneau: creneau, estInscrit: creneauxBenevole.map({ $0.idCreneau }).contains(creneau.idCreneau), selectedCreneauId: $selectedCreneauId)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Planning général", displayMode: .inline)
        }
        .onAppear {
            fetchAndLoadCreneaux()
            fetchCreneauxBenevole()
        }
    }
    
    
    private func fetchAndLoadCreneaux() {
        viewModel.GetAllSlots(PlanningId: 1) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let creneaux):
                    self.creneauxDetails = creneaux
                case .failure(let error):
                    print("Erreur lors de la récupération des créneaux: \(error.localizedDescription)")
                }
            }
        }
    }
    private func fetchCreneauxBenevole() {
        guard let userIdString = AuthenticationManager.shared.fetchUserId(),
              let userId = Int(userIdString) else {
            print("Erreur: UserID indisponible ou n'est pas un entier")
            return
        }
        
        viewModel.getCreneauxBenevole(forUserId: userId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for creneauBenevole in self.viewModel.creneauxBenevoles {
                self.viewModel.getCreneauById(idCreneau: creneauBenevole.idCreneau) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let creneau):
                            self.creneauxBenevole.append(creneau)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

struct CreneauCellView: View {
    let creneau: Creneau
    var estInscrit: Bool
    @Binding var selectedCreneauId: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rôle: \(creneau.titre)")
            Text("Heure de début: \(creneau.heure_debut)h")
            Text("Heure de fin: \(creneau.heure_fin)h")
            if estInscrit {
                HStack {
                    Text("Inscrit")
                        .foregroundColor(.green)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            if selectedCreneauId == creneau.idCreneau {
                CreneauDetailView(creneau: creneau, estInscrit: estInscrit, selectedCreneauId: $selectedCreneauId)
            }
            
            HStack {
                Spacer()
                Image(systemName: "chevron.down.circle")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(selectedCreneauId == creneau.idCreneau ? 180 : 0))
                    .onTapGesture {
                        if selectedCreneauId == creneau.idCreneau {
                            selectedCreneauId = nil
                        } else {
                            selectedCreneauId = creneau.idCreneau
                        }
                    }
            }
            .padding(.top, 5)
        }
        .padding(.vertical)
    }
}


struct CreneauDetailView: View {
    @EnvironmentObject var viewModel: SlotsViewModel
    var creneau: Creneau
    var estInscrit: Bool
    @Binding var selectedCreneauId: Int?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showMessage = false
    @State private var messageText = ""
    @State private var messageColor = Color.green
    
    
    private var idUser: Int? {
        if let userIdString = AuthenticationManager.shared.fetchUserId() {
            return Int(userIdString)
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Participants: \(creneau.nb_inscrit)/\(creneau.nb_max)")
            
            Button(estInscrit ? "Se désinscrire" : "S'inscrire") {
                guard let userId = idUser else {
                    alertMessage = "Erreur: UserID indisponible"
                    showingAlert = true
                    return
                }
                if estInscrit {
                    viewModel.DesinscriptionCreneauBenevole(idCreneau: creneau.idCreneau, idUser: (userId)) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success():
                                self.messageText = "Désinscription réussie."
                                self.messageColor = Color.green
                            case .failure(let error):
                                self.messageText = "Erreur de désinscription: \(error.localizedDescription)"
                                self.messageColor = Color.red
                            }
                            self.showMessage = true
                            print(showMessage)
                            // Faire disparaitre le message après 2 secondes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showMessage = false
                            }
                            selectedCreneauId = nil
                        }
                    }
                } else {
                    viewModel.InscriptionCreneauBenevole(idCreneau: creneau.idCreneau, idUser: userId) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success():
                                self.messageText = "Inscription réussie."
                                self.messageColor = Color.green
                            case .failure(let error):
                                self.messageText = "Erreur d'inscription: \(error.localizedDescription)"
                                self.messageColor = Color.red
                            }
                            self.showMessage = true
                            // Faire disparaitre le message après 2 secondes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showMessage = false
                            }
                            selectedCreneauId = nil
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .font(.system(size: 14))
            .background(estInscrit ? Color.red : Color.green)
            .cornerRadius(8)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            if showMessage {
                Text(messageText)
                    .foregroundColor(messageColor)
                    .padding()
                    .background(messageColor.opacity(0.2))
                    .cornerRadius(10)
                // Appliquez l'animation directement ici
                    .animation(.easeInOut(duration: 0.5), value: showMessage)
            }
        }
    }
}


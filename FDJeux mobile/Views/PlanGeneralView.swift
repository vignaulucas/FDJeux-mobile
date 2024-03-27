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
    @State private var creneauxBenevole: [Creneau] = []

    private var creneauxParJour: [Int: [Creneau]] {
        Dictionary(grouping: creneauxDetails.sorted(by: { $0.JourId < $1.JourId }), by: { $0.JourId })
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(creneauxParJour.keys.sorted()), id: \.self) { jourId in
                    Section(header: Text("Jour \(jourId)").font(.title2)) {
                        ForEach(creneauxParJour[jourId] ?? [], id: \.idCreneau) { creneau in
                            VStack(alignment: .leading) {
                                Text("Rôle: \(creneau.titre)")
                                Text("Heure de début: \(creneau.heure_debut)h")
                                Text("Heure de fin: \(creneau.heure_fin)h")
                                if creneauxBenevole.map({ $0.idCreneau }).contains(creneau.idCreneau) {
                                    HStack {
                                        Text("Inscrit")
                                            .foregroundColor(.green)
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(.vertical)
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

struct CreneauView: View {
    let creneau: Creneau
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rôle: \(creneau.titre)")
            Text("Heure de début: \(creneau.heure_debut)h")
            Text("Heure de fin: \(creneau.heure_fin)h")
        }
        .padding(.vertical)
    }
}

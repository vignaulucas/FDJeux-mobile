import SwiftUI

struct PlanningPersoView: View {
    @StateObject private var viewModel = SlotsViewModel()
    @State private var creneauxDetails: [Creneau] = []

    private var creneauxParJour: [Int: [Creneau]] {
        Dictionary(grouping: creneauxDetails.sorted(by: { $0.JourId < $1.JourId }), by: { $0.JourId })
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Planning Personnel").font(.headline)) {
                    ForEach(creneauxParJour.keys.sorted(), id: \.self) { jourId in
                        Section(header: Text("Jour \(jourId)").font(.title2)) {
                            ForEach(creneauxParJour[jourId] ?? [], id: \.idCreneau) { creneau in
                                VStack(alignment: .leading) {
                                    Text("Rôle: \(creneau.titre)")
                                    Text("Heure de début: \(creneau.heure_debut)h")
                                    Text("Heure de fin: \(creneau.heure_fin)h")
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Mon Planning", displayMode: .inline)
        }
        .onAppear {
            fetchAndLoadCreneaux()
        }
    }

    private func fetchAndLoadCreneaux() {
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
                            self.creneauxDetails.append(creneau)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

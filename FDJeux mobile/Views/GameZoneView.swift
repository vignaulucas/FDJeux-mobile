//
//  GameZoneView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 26/03/2024.
//

import Foundation
import SwiftUI

struct GameZoneView: View {
    @ObservedObject var viewModel = GameZoneViewModel()
    @State private var selectedPlanZone: String?

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Zones de Jeu")
        }
        .onAppear {
            viewModel.loadAllEspace()
        }
    }
    
    private var content: some View {
        List {
            ForEach(viewModel.espaces, id: \.planZone) { espace in
                Section(header: espaceHeader(for: espace)) {
                    if selectedPlanZone == espace.planZone {
                        jeuxList(for: espace)
                    }
                }
            }
        }
    }
    
    private func espaceHeader(for espace: Espace) -> some View {
        Text(espace.planZone)
            .font(.headline)
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(5)
            .onTapGesture {
                withAnimation {
                    toggleSelectedPlanZone(for: espace)
                }
            }
    }
    
    private func toggleSelectedPlanZone(for espace: Espace) {
        if selectedPlanZone == espace.planZone {
            selectedPlanZone = nil
        } else {
            selectedPlanZone = espace.planZone
            viewModel.loadJeuxByEspace(planZone: espace.planZone)
        }
    }
    
    private func jeuxList(for espace: Espace) -> some View {
        ForEach(viewModel.jeux.filter { $0.planZone == espace.planZone }, id: \.id) { jeu in
            jeuRow(for: jeu)
        }
    }
    
    private func jeuRow(for jeu: Jeu) -> some View {
        VStack(alignment: .leading) {
            Text(jeu.nameGame ?? "Nom inconnu")
                .font(.headline)
            Text("Type: \(jeu.type ?? "N/A")")
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

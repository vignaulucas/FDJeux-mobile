//
//  InfoView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation
import SwiftUI

struct InfoView: View {
    @State private var infos: [Infos] = []
    @State private var errorMessage: String = ""
    @State private var selectedTabIndex = 0

    var body: some View {
        VStack {
            if !infos.isEmpty {
                TabView(selection: $selectedTabIndex) {
                    ForEach(infos.indices, id: \.self) { index in
                        infoCard(for: infos[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 200)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .padding()
            } else {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            getInfos { result in
                switch result {
                case .success(let infosList):
                    self.infos = infosList
                case .failure(let error):
                    self.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }

    @ViewBuilder
    private func infoCard(for info: Infos) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(info.titre)
                .font(.headline)
                .bold()
                .foregroundColor(.blue)
            Text(info.description)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


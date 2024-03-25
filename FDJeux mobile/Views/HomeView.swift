//
//  HomeView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation
import SwiftUI

struct HomeView: View {
    let headerImageName = "HeaderFDJeux"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(headerImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .clipped()

                // Section Actualités
                VStack {
                    Text("Actualités")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                        .padding(.top)
                    NewsView()
                }
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)

                // Section Festival en cours
                VStack {
                    Text("Festival en cours")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                        .padding(.top)
                    CurrentFestivalView()
                }

                // Section Infos
                VStack {
                    Text("Infos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                        .padding(.top)
                    InfoView()
                }
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

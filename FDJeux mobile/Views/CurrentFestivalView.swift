//
//  CurrentFestivalView.swift
//  FDJeux mobile
//
//  Created by VIGNAU Lucas on 25/03/2024.
//

import Foundation
import SwiftUI

struct CurrentFestivalView: View {
    @State private var currentFestival: Festival?
    @State private var feedbackMessage = ""
    @State private var currentUser: User?
    @State private var hasRegistered: Bool = false

    var body: some View {
        Group {
              if let fest = currentFestival {
                VStack(alignment: .leading, spacing: 10) {
                    Text(fest.nom)
                        .font(.title)
                        .foregroundColor(.indigo)
                    Text("Date: \(fest.date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()

                registrationStatusView(festivalId: fest.idFestival)
            } else {
                Text(feedbackMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            fetchCurrentFestival()
        }
    }

    private func registrationStatusView(festivalId: Int) -> some View {
        Group {
            if hasRegistered {
                Text("You're registered for this festival!")
                    .padding()
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(5)
            } else {
                Button("Register") {
                    registerForFestival(festivalId: festivalId)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private func fetchCurrentFestival() {
         fetchCurrentUser { result in
            handleUserResult(result)
        }

        getCurrentFestival { result in
            handleFestivalResult(result)
        }
    }

    private func handleUserResult(_ result: Result<User, Error>) {
        switch result {
        case .success(let user):
            currentUser = user
        case .failure(let error):
            feedbackMessage = "User error: \(error.localizedDescription)"
        }
    }

    private func handleFestivalResult(_ result: Result<Festival, Error>) {
        switch result {
        case .success(let fest):
            currentFestival = fest
            verifyRegistration(festivalId: fest.idFestival)
        case .failure(let error):
            feedbackMessage = "Festival error: \(error.localizedDescription)"
        }
    }

    private func verifyRegistration(festivalId: Int) {
        if let festId = currentFestival?.idFestival, let userId = currentUser?.idFestival, festId == Int(userId) {
            hasRegistered = true
        }
    }

    private func registerForFestival(festivalId: Int) {
        hasRegistered = true
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct FestivalCurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentFestivalView()
    }
}

import Foundation
import SwiftUI

struct NewsView: View {
    @State private var news: [News] = []
    @State private var errorMessage: String = ""
    @State private var selectedTabIndex = 0

    var body: some View {
        VStack {
            if !news.isEmpty {
                TabView(selection: $selectedTabIndex) {
                    ForEach(news.indices, id: \.self) { index in
                        newsCard(for: news[index])
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
        .padding(.bottom, 40)
        .onAppear {
            getNews { result in
                switch result {
                case .success(let newsList):
                    self.news = newsList
                case .failure(let error):
                    self.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }

    @ViewBuilder
    private func newsCard(for newsItem: News) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsItem.titre)
                .font(.headline)
                .bold()
                .foregroundColor(.blue)
            Text(newsItem.description)
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

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}


//
//  ContentView.swift
//  BreakingBadAPI
//
//  Created by Lucas Pereira on 11/06/23.
//

import SwiftUI

struct Info : Codable, Hashable {
    var quote: String
    var author: String
}

struct ContentView: View {
    
    @State private var infos = [Info]()
    
    var body: some View {
        NavigationView {
            List (infos, id: \.self) {info in
                VStack(alignment: .leading) {
                    Text("\"\(info.quote)\"")
                    Text(info.author)
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .task {
                await fetchData()
            }
        }
        .padding()
    }
    
    // create URL and fetch data
    func fetchData() async {
        guard let url = URL(string: "https://api.breakingbadquotes.xyz/v1/quotes/50") else {
            print("URL does not exists")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // decode the data
            if let decodedResponse = try? JSONDecoder().decode([Info].self, from: data) {
                infos = decodedResponse
            }
        } catch {
            print("Invalid data or failed to fetch request")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

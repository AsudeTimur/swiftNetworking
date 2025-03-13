//
//  ContentView.swift
//  SwiftFlix
//
//  Created by Asude Timur on 11.03.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var movies: [Movie] = []
    @State private var errorMessage: String? = nil
    
    let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=e7af948dbbe7c68ef27e4357cb76c568")
    
    let session = URLSession.shared
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Movies")
                    .font(.title)
                    .bold()
                
                List(movies, id: \.id) { movie in
                    Text(movie.title)
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let url = url else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            } else if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.movies = jsonResponse.results
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse data"
                    }
                }
            }
        }
        
        task.resume()
    }
}

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
}

struct MovieResponse: Codable {
    let results: [Movie]
}

#Preview {
    ContentView()
}

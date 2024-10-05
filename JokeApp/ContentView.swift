//
//  ContentView.swift
//  JokeApp
//
//  Created by Oscar David Myerston Vega on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var joke: Joke?
    @State private var isLoading = false

    private func fetchJoke() async throws -> Joke {
        let url = URL(string: "https://v2.jokeapi.dev/joke/Programming?type=twopart")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        return joke
    }

    var body: some View {
        VStack(spacing: 8) {
            if let joke = joke {
                Text(joke.setup)
                    .font(.title)
                Text(joke.delivery)
                    .font(.headline)
            } else {
                Text("Tap to fetch a joke!")
            }

            Button {
                Task {
                    isLoading = true
                    do {
                        joke = try await fetchJoke()
                    } catch {
                        print("Failed to fetch joke: \(error)")
                    }
                    isLoading = false
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.horizontal)
                } else {
                    Text("Fetch Joke")
                }
            }
            .disabled(isLoading)
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

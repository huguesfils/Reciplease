//
//  SearchView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

extension SearchView {
    @MainActor class ViewModel: ObservableObject {
        @Published var ingredients = [String]()
        @Published var searchInput = ""
        @Published var isNavigate = false
        
        let api_id = "c39bf8a9"
        let api_key = "eeacf7dbdf9f33c8887e9db29c640a16"
        
        func addIngredient() {
            let newIngredient = searchInput.lowercased()
            ingredients.insert(newIngredient, at: 0)
        }
        
        func loadData() {
            print("coucou")
            let message = "Coucou"
        }
        
//        func loadData() async {
//            guard let url = URL(string: "https://api.edamam.com/search?q=cheese&app_id=\(api_id)&app_key=\(api_key)") else {
//                print("Invalid URL")
//                return
//            }

//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//
//                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//                    results = decodedResponse.results
//                }
//            } catch {
//                print("Invalid data")
//            }
//       }
    }
}
//
//  RecipiesListView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

extension RecipiesListView {
    @MainActor class ViewModel: ObservableObject {
        @Published var ingredients = [String]()
        @Published var message = ""
        
        init(ingredients: [String]) {
            self.ingredients = ingredients
        }
        
    }
}

//
//  RecipiesListViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation
import Alamofire

class RecipiesListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var recipesViewModel = [RecipeViewModel]()

    private var ingredients: [String]?
    private let service = Service(manager: Session.default)
    private var dataController: DataController?

    init(_ ingredients: [String]) {
        self.ingredients = ingredients
        loadData()
    }

    init(_ dataControler: DataController) {
        self.dataController = dataControler
        refreshData()
    }

    func loadData() {
        isLoading = true // Indicate loading starts
        service.loadData(ingredients: ingredients!) { recipes, nextPage, cases in
            DispatchQueue.main.async {
                self.isLoading = false // Indicate loading ends
                switch cases {
                case .Success:
                    guard let recipes = recipes else { return }
                    self.recipesViewModel = recipes.map { RecipeViewModel(recipe: $0) }
                case .WrongDataReceived, .BadUrlForRequest, .HttpStatusCodeError, .Empty:
                    print("Error loading recipes: \(cases)")
                }
            }
        }
    }

    func refreshData() {
        guard let dataController = self.dataController else {
            return
        }

        dataController.fetchFavorites { favorites in
            DispatchQueue.main.async {
                self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
            }
        }
    }
}

//
//  RecipiesListViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation
import Alamofire

class RecipiesListViewModel: ObservableObject {
    @Published var isLoading = Bool()
    @Published var recipesViewModel = [RecipeViewModel]()

    private var ingredients: [String]?
    private let service = Service(manager: Session.default)
    private var dataController: DataController?
    
    init(_ ingredients: [String]) {
        self.ingredients = ingredients
        service.loadData(ingredients: ingredients) { recipes, nextPage, cases in
            switch cases {
            case .Success:
                guard let recipes = recipes else { return }
                self.isLoading = false
                self.recipesViewModel = recipes.map { RecipeViewModel(recipe: $0) }
            case .WrongDataReceived:
                print("WrongDataReceived")
                return
            case .BadUrlForRequest:
                print("BadUrlForRequest")
                return
            case .HttpStatusCodeError:
                print("HttpStatusCodeError")
                return
            case .Empty:
                print("Empty")
                return
            }
        }
    }
    
    init(_ dataControler: DataController) {
        self.dataController = dataControler
        refreshData()
    }
    
    func refreshData() {
        guard let dataController = self.dataController else {
            return
        }

        dataController.fetchFavorites { favorites in
            self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
        } 
    }
}

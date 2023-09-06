//
//  FavoritesView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/09/2023.
//

import Foundation


@MainActor class FavoritesViewModel: ObservableObject {
    @Published var favorites = [FavRecipe] = []
    
    let dataController: DataController
    
    init(dataController: DataController = DataController(errorCoreData: "")) {
        self.dataController = dataController
    }
    
    func fetchFavorites()  {
        favorites = dataController.fetch()!
    }
    
}


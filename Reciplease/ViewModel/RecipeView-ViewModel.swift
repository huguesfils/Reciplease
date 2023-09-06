//
//  RecipeView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/09/2023.
//

import Foundation

@MainActor class RecipeViewModel: ObservableObject {
    private let dataController: DataController
    private let recipe: any RecipeProtocol
    
    init(dataController: DataController = DataController(errorCoreData: ""), recipe: any RecipeProtocol) {
        self.dataController = dataController
        self.recipe = recipe
    }
    
}

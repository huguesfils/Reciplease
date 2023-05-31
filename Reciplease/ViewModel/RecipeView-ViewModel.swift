//
//  RecipeView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import Foundation
import SwiftUI

extension RecipeView {
    @MainActor class ViewModel: ObservableObject {
        @Published var recipe: RecipeProtocol
        
        init(recipe: RecipeProtocol) {
            self.recipe = recipe
        }
        //coucou
    }
}

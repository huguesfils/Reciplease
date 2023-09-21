//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel: RecipeViewModel
    
    init(_ viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("listColor").ignoresSafeArea()
                if viewModel.favorites.isEmpty {
                    Text("You don't have favorite recipe for the moment")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView{
                        RecipeList(results: viewModel.favorites.map { $0 })
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetch()
        }
        
    }
      
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(Recipe(label: "", image: "", ingredientLines: [""], ingredients: [ingredient(food: "")], url: "", totalTime: 0))
    }
}

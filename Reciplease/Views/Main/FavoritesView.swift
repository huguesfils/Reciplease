//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: SearchView.ViewModel
    @FetchRequest(sortDescriptors: [
    ]) var favorites: FetchedResults<FavRecipe>
    
    var body: some View {
        NavigationStack {
                if favorites.isEmpty {
                    Text("You don't have favorite recipe for the moment")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView{
                        RecipeList(results: favorites.map { $0 })
                    }
                }
            
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: SearchView.ViewModel())
    }
}

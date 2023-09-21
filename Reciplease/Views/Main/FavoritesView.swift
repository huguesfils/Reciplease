//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("listColor").ignoresSafeArea()
                if favoriteViewModel.isEmpty {
                    Text("You don't have favorite recipe for the moment")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    RecipiesListView(viewModel: self.favoriteViewModel.recipeListViewModel)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            favoriteViewModel.fetchFavorites()
        }
        
    }
      
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

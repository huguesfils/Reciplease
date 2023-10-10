//
//  FavoritesView.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/10/2023.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var favoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("CustomBackgroundColor").ignoresSafeArea()
                if favoriteViewModel.favorites.isEmpty {
//                if favoriteViewModel. {
                    Text("You don't have favorite recipe for the moment")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    RecipiesListView(recipiesListViewModel: favoriteViewModel.recipiesListViewModel)
                }
            }
            .onAppear {
                favoriteViewModel.fetchFavorites()
            }
        }
    }
}

#Preview {
    FavoritesView(favoriteViewModel: FavoriteViewModel())
}

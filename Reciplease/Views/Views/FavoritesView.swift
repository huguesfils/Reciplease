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
        NavigationView {
            ZStack {
                Color("CustomBackgroundColor").ignoresSafeArea()
                if favoriteViewModel.recipesViewModel.isEmpty {
                    Text("You don't have any favorite recipes at the moment")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView{
                        VStack(spacing: 15) {
                            ForEach(favoriteViewModel.recipesViewModel, id: \.url) { item in
                                NavigationLink(destination: RecipeDetailsView(item)) {
                                        RecipeCardView(item)
                                    }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
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
}

#Preview {
    FavoritesView(favoriteViewModel: FavoriteViewModel())
}

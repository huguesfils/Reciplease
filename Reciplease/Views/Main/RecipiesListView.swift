//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI

struct RecipiesListView: View {
    @StateObject var recipeListViewModel: RecipeListViewModel
    //@ObservedObject var searchViewModel: SearchViewModel
    //@ObservedObject var favoriteViewModel: FavoriteViewModel
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            if recipeListViewModel.isLoading {
                ProgressView()
            } else {
                if recipeListViewModel.recipes.isEmpty {
                    Text("Sorry, no recipes founded")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView{
                        VStack(spacing: 15) {
                            ForEach(recipeListViewModel.recipes, id: \.label) { item in
                                NavigationLink(destination: RecipeDetailView(recipeDetailViewModel: RecipeDetailViewModel(recipe: item))) {
                                    RecipeCardView(recipe: item)
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            recipeListViewModel.fetchRecipes(viewModel: searchViewModel)
        }
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(searchViewModel: SearchViewModel(), favoriteViewModel: FavoriteViewModel())
    }
}

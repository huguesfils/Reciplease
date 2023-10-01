//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI


struct RecipiesListView: View {
    @ObservedObject var recipeListViewModel: RecipeListViewModel
    //    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            if recipeListViewModel.recipesViewModel.isEmpty {
                Text("Sorry, no recipes founded")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ScrollView{
                    VStack(spacing: 15) {
                        ForEach(recipeListViewModel.recipesViewModel, id: \.title) { item in
                            NavigationLink(destination: RecipeDetailView(item)) {
                                RecipeCardView(item)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(recipeListViewModel: RecipeListViewModel([Recipe]()))
    }
}

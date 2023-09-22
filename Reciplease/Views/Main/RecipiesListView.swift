//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI

    
struct RecipiesListView: View {
    @ObservedObject var recipeListViewModel: RecipeListViewModel
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            ScrollView{
                VStack {
                    HStack{
                        Text("\(recipeListViewModel.recipesViewModel.count) \(recipeListViewModel.recipesViewModel.count > 1 ? "recipes" : "recipe")")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                    }
                    VStack(spacing: 15) {
                        if recipeListViewModel.recipesViewModel.count > 0 {
                            ForEach(recipeListViewModel.recipesViewModel, id: \.title) { item in
                                NavigationLink(destination: RecipeView(item)) {
                                    RecipeCard(item)
                                }
                            }
                        } else {
                            Text("Sorry, no recipe founded :(")
                                .font(.headline)
                                .fontWeight(.medium)
                                .opacity(0.7)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            recipeListViewModel.fetchFavorites()
        }
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(recipeListViewModel: RecipeListViewModel([Recipe]()))
    }
}

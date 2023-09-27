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
            ScrollView{
                VStack(spacing: 15) {
                    ForEach(recipeListViewModel.recipesViewModel, id: \.title) { item in
                        NavigationLink(destination: RecipeDetailView(item)) {
                            RecipeCardView(item)
//                                .onAppear(){
//                                    searchViewModel.loadMoreContent()
//                                }
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(recipeListViewModel: RecipeListViewModel([Recipe]()))
    }
}

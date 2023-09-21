//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI

    
struct RecipiesListView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            ScrollView{
                VStack {
                    HStack{
                        Text("\(viewModel.recipesViewModel.count) \(viewModel.recipesViewModel.count > 1 ? "recipes" : "recipe")")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                    }
                    VStack(spacing: 15) {
                        if viewModel.recipesViewModel.count > 0 {
                            ForEach(viewModel.recipesViewModel, id: \.title) { item in
                                NavigationLink(destination: RecipeView(item)) {
                                    RecipeCard(item)
                                }
                            }
                        } else {
                            Text("Sorry, no recipe found :(")
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
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(viewModel: RecipeListViewModel([Recipe]()))
    }
}

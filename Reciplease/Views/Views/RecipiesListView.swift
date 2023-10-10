//
//  RecipiesListView.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import SwiftUI

struct RecipiesListView: View {
    @StateObject var recipiesListViewModel: RecipiesListViewModel
    
    var body: some View {
        ZStack {
            Color("CustomBackgroundColor").ignoresSafeArea()
            if recipiesListViewModel.isLoading {
                ProgressView()
            } 
//            else {
//                if recipiesListViewModel.recipes.isEmpty && !recipiesListViewModel.favorites.isEmpty{
//                    Text("Sorry, no recipes founded")
//                        .font(.headline)
//                        .fontWeight(.medium)
//                        .opacity(0.7)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                } 
                else {
                    ScrollView{
                        VStack(spacing: 15) {
                            ForEach(recipiesListViewModel.recipesViewModel, id: \.url) { item in
                                NavigationLink(destination: RecipeDetailsView(item)) {
                                    RecipeCardView(item)
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
                    }
                }
//            }
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            recipiesListViewModel.refreshData()
        }
    }
}

#Preview {
    RecipiesListView(recipiesListViewModel: RecipiesListViewModel(["Test"]))
}

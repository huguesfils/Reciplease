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
                ProgressView("Loading recipes...")
            } else {
                if recipiesListViewModel.recipesViewModel.isEmpty {
                    Text("Sorry, no recipe found")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(recipiesListViewModel.recipesViewModel, id: \.url) { item in
                                NavigationLink(destination: RecipeDetailsView(item).onDisappear {
                                    recipiesListViewModel.refreshData()
                                }) {
                                    RecipeCardView(item)
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
            recipiesListViewModel.loadData()
        }
    }
}

#Preview {
    RecipiesListView(recipiesListViewModel: RecipiesListViewModel(["Test"]))
}

//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("listColor").ignoresSafeArea()
                if $viewModel.favorites.isEmpty {
                    Text("You don't have favorite recipe for the moment")
                        .font(.headline)
                        .fontWeight(.medium)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView{
                        RecipeList(results: viewModel.favorites.map { $0 })
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

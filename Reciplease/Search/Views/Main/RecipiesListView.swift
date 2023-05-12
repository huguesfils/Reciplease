//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI

struct RecipiesListView: View {
    @ObservedObject var viewModel: SearchView.ViewModel
    
    var body: some View {
        ScrollView{
            RecipeList(results: viewModel.results)
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(viewModel: SearchView.ViewModel())
    }
}

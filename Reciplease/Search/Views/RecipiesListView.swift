//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI

struct RecipiesListView: View {
    @StateObject private var viewModel = SearchView.ViewModel()
   
    var body: some View {
        NavigationView {
            List(viewModel.results, id: \.label) { item in
                VStack(alignment: .leading) {
                    Text(item.label)
                        .font(.headline)
                }
            }
            .navigationTitle("List")
        }
        
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView()
    }
}

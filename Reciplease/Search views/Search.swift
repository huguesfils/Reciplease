//
//  Search.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct Search: View {
    @State private var searchText = ""
    @State private var isNavigate = false
    
    var body: some View {
        NavigationView {
            VStack(){
                Text("Ingredient list")
                Spacer()
                NavigationLink(destination: RecipiesList(), isActive: $isNavigate) {
               
                Button("Search for recipies") {
                    self.isNavigate = true
                }
                    .buttonStyle(.borderedProminent)
                }
                .searchable(text: $searchText, prompt: "What's in your fridge?")
                .navigationTitle("Search")
                .padding(20)
            }
            .background(.regularMaterial)
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

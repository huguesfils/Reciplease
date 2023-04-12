//
//  Search.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct Search: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: RecipiesList()) {
                Text("Search for recepies")
            }
            .searchable(text: $searchText, prompt: "What's in your fridge?")
            .navigationTitle("Search")
                    }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

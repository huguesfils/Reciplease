//
//  RecipeList.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeList: View {
    private let results: [RecipeViewModel]
    
    init(results: [RecipeViewModel]) {
        self.results = results
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("\(results.count) \(results.count > 1 ? "recipes" : "recipe")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
            VStack(spacing: 15) {
                if results.count > 0 {
                    ForEach(results, id: \.title) { item in
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
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            RecipeList(results: [])
        }
    }
}

//
//  RecipeList.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeList: View {
    let results: [Recipe]
    
    init(results: [Recipe]) {
        self.results = results
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("\(results.count) \(results.count > 1 ? "recipes" : "recipe")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                Spacer()
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                ForEach(results, id: \.label) { item in
                    RecipeCard(recipe: item)
                }
            }
            
        }
        .padding(.horizontal)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            RecipeList(results: [Recipe(label: "Test", image: "photo")])
        }
        
    }
}

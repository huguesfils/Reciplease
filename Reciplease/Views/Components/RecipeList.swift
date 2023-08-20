//
//  RecipeList.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeList: View {
    @FetchRequest(sortDescriptors: [
    ]) private var favorites: FetchedResults<FavRecipe>
    
    private let results: [any RecipeProtocol]
    
    init(results: [any RecipeProtocol]) {
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
                                ForEach(results, id: \.labelValue) { item in
                                    NavigationLink(destination: RecipeView(recipe: item)) {
                                        RecipeCard(recipe: item)
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

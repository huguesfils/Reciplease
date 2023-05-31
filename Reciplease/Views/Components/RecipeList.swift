//
//  RecipeList.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeList: View {
    @FetchRequest(sortDescriptors: [
    ]) var favorites: FetchedResults<FavRecipe>
    
    let results: [RecipeProtocol]
    
    init(results: [RecipeProtocol]) {
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
            VStack(spacing: 15) {
                ForEach(results, id: \.labelValue) { item in
                    NavigationLink(destination: RecipeView(recipe: item)) {
                                           RecipeCard(recipe: item)
                                       }
//                    NavigationLink(destination: Text(item.labelValue)) {
//                            //RecipeCard(recipe: item)
//                        Text(item.labelValue)
//                        }
                    
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
            RecipeList(results: [Recipe(
                label: "Test",
                image: "photo",
                ingredientLines: ["2 tablespoons bottled fat-free Italian salad dressing","Dash cayenne pepper"],
//                ingredients: [],
                url: "https://www.apple.com",
//                foods: [Food(food: "Salad")],
                totalTime: 40)])
        }
        
    }
}

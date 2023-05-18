//
//  RecipeCard.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        print(self.recipe.label)
    }
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
//                    .overlay(alignment: .bottom) {
//                        Text(recipe.label)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .shadow(color: .black, radius: 3, x:0, y: 0)
//                            .frame(maxWidth: 136)
//                            .padding()
//                    }
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .overlay(alignment: .bottom) {
//                        Text(recipe.label)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .shadow(color: .black, radius: 3, x:0, y: 0)
//                            .frame(maxWidth: 136)
//                            .padding()
//                    }
            }
            
            Text(recipe.label)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 3, x:0, y: 0)
                .frame(maxWidth: 136)
                .padding(.top)
        }
        
        .frame(height: 217, alignment: .top)
        .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}


struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Recipe(label: "Test", image: "photo", ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"], url: "https://www.apple.com"))
    }
}

//
//  RecipeCardView.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeCardView: View {
    
    var recipe: Recipe
    
//    @ObservedObject private var recipeViewModel: RecipeViewModel
    
//    init(_ recipeViewModel: RecipeViewModel) {
//        self.recipeViewModel = recipeViewModel
//    }
    
    var body: some View {
        ZStack {
//            if let favRecipe = recipeViewModel.favorites.first(where: {$0.urlValue == recipeViewModel.url}) {
//                Image(uiImage: UIImage(data: favRecipe.storedImage ?? Data()) ?? UIImage())
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .clipped()
//                    .frame(height: 217)
//                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                    .overlay(alignment: .bottom) {
//                        VStack {
//                            HStack {
//                                VStack {
//                                    Text(favRecipe.labelValue)
//                                        .font(.subheadline.weight(.heavy))
//                                        .foregroundColor(Color("text"))
//                                        .frame(maxWidth:.infinity,alignment: .leading)
//                                        .lineLimit(1)
//                                    Text(favRecipe.foodIngredientsValue.joined(separator: ", "))
//                                        .font(.caption)
//                                        .foregroundColor(Color("text"))
//                                        .lineLimit(1)
//                                        .padding(-2)
//                                        .frame(maxWidth: .infinity,alignment: .leading)
//                                        .truncationMode(.tail)
//                                    
//                                }
//                                .frame(maxWidth: 300,alignment: .leading)
//                                
//                                if favRecipe.totalTimeValue != 0 {
//                                    let favTime = favRecipe.totalTimeValue.toTimeString()
//                                    Text("\(favTime)")
//                                        .foregroundColor(Color("text"))
//                                        .frame(maxWidth: 100, alignment: .trailing)
//                                        .accessibilityValue(favTime)
//                                }
//                            }
//                            .frame(maxWidth:.infinity,alignment: .leading)
//                            .padding(.horizontal)
//                        }
//                        .frame(height: 65)
//                        .background(.regularMaterial, in: RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 20))
//                    }
//            } else {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(height: 217)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(alignment: .bottom) {
                            VStack {
                                HStack {
                                    VStack {
                                        Text(recipe.label)
                                            .font(.subheadline.weight(.heavy))
                                            .foregroundColor(Color("text"))
                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            .lineLimit(1)
                                        Text(recipe.foodIngredients.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundColor(Color("text"))
                                            .lineLimit(1)
                                            .padding(-2)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                            .truncationMode(.tail)
                                        
                                    }
                                    .frame(maxWidth: 300,alignment: .leading)
                                    
                                    if recipe.totalTime != 0 {
                                        let time = recipe.totalTime.toTimeString()
                                        Text("\(recipe.totalTime.toTimeString())")
                                            .foregroundColor(Color("text"))
                                            .frame(maxWidth: 100, alignment: .trailing)
                                            .accessibilityValue(time)
                                    }
                                }
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .padding(.horizontal)
                            }
                            .frame(height: 65)
                            .background(.regularMaterial, in: RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                        }
                } placeholder: {
                    ProgressView()
                }
            }
            
//        }
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct RecipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardView(recipe: Recipe(
            label: "Test",
            image: "photo",
            ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"],
            ingredients: [Ingredient(food: "test")],
            totalTime: 40,
            url: "https://www.apple.com"))
    }
}


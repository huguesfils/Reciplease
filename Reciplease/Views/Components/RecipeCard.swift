//
//  RecipeCard.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeCard: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [
    ]) private var favorites: FetchedResults<FavRecipe>
    
    private let recipe: any RecipeProtocol
    
    init(recipe: any RecipeProtocol) {
        self.recipe = recipe
    }
    
    var body: some View {
        ZStack {
            if let favRecipe = favorites.first(where: {$0.urlValue == recipe.urlValue}) {
                Image(uiImage: UIImage(data: favRecipe.storedImage ?? Data()) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 217)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(alignment: .bottom) {
                        VStack {
                            HStack {
                                VStack {
                                    Text(favRecipe.labelValue)
                                        .font(.subheadline.weight(.heavy))
                                        .foregroundColor(Color("text"))
                                        .frame(maxWidth:.infinity,alignment: .leading)
                                        .lineLimit(1)
                                    Text(favRecipe.foodIngredientsValue.joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundColor(Color("text"))
                                        .lineLimit(1)
                                        .padding(-2)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .truncationMode(.tail)
                                    
                                }
                                .frame(maxWidth: 300,alignment: .leading)
                                
                                if favRecipe.totalTimeValue != 0 {
                                    let favTime = favRecipe.totalTimeValue.toTimeString()
                                    Text("\(favTime)")
                                        .foregroundColor(Color("text"))
                                        .frame(maxWidth: 100, alignment: .trailing)
                                        .accessibilityValue(favTime)
                                }
                            }
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .padding(.horizontal)
                        }
                        .frame(height: 65)
                        .background(.regularMaterial, in: RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                    }
            } else {
                AsyncImage(url: URL(string: recipe.imageValue)) { image in
                    return image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(height: 217)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(alignment: .bottom) {
                            VStack {
                                HStack {
                                    VStack {
                                        Text(recipe.labelValue)
                                            .font(.subheadline.weight(.heavy))
                                            .foregroundColor(Color("text"))
                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            .lineLimit(1)
                                        Text(recipe.foodIngredientsValue.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundColor(Color("text"))
                                            .lineLimit(1)
                                            .padding(-2)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                            .truncationMode(.tail)
                                        
                                    }
                                    .frame(maxWidth: 300,alignment: .leading)
                                    
                                    if recipe.totalTimeValue != 0 {
                                        let time = recipe.totalTimeValue.toTimeString()
                                        Text("\(time)")
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
            
        }
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

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Recipe(
            label: "Test",
            image: "https://www.adorama.com/alc/wp-content/uploads/2018/11/landscape-photography-tips-yosemite-valley-feature.jpg",
            ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"],
            ingredients: [ingredient(food: "cheese"), ingredient(food: "lemon"), ingredient(food: "paprika")],
            url: "https://www.apple.com",
            totalTime: 40))
    }
}


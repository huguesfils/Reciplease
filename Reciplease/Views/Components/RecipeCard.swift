//
//  RecipeCard.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeCard: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
    ]) var favorites: FetchedResults<FavRecipe>
    
    let recipe: any RecipeProtocol
    
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
                                    Text(recipe.labelValue)
                                        .font(.subheadline.weight(.heavy))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                    
                                }
                                
                                if recipe.totalTimeValue != 0 {
                                    Text("\(recipe.totalTimeValue) min")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
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
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        
                                    }
                                    
                                    if recipe.totalTimeValue != 0 {
                                        Text("\(recipe.totalTimeValue) min")
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
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
            image: "photo",
            ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"],
            url: "https://www.apple.com",
            totalTime: 40))
    }
}


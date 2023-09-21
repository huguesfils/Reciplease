//
//  RecipeCard.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeCard: View {
    
    @ObservedObject private var viewModel: RecipeViewModel
    
    init(_ viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            if let favRecipe = viewModel.favorites.first(where: {$0.urlValue == viewModel.url}) {
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
                AsyncImage(url: URL(string: viewModel.image)) { image in
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
                                        Text(viewModel.title)
                                            .font(.subheadline.weight(.heavy))
                                            .foregroundColor(Color("text"))
                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            .lineLimit(1)
                                        Text(viewModel.ingredients.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundColor(Color("text"))
                                            .lineLimit(1)
                                            .padding(-2)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                            .truncationMode(.tail)
                                        
                                    }
                                    .frame(maxWidth: 300,alignment: .leading)
                                    
                                    if viewModel.totalTime == 0 {
                                        let time = viewModel.totalTime.toTimeString()
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
        .onAppear {
            viewModel.fetch()
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
        RecipeCard(RecipeViewModel(recipe: Recipe(
            label: "Test",
            image: "photo",
            ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"],
            ingredients: [ingredient(food: "cheese"), ingredient(food: "lemon"), ingredient(food: "paprika")],
            url: "https://www.apple.com",
            totalTime: 40)))
    }
}


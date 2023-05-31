//
//  RecipeView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
    ]) var favorites: FetchedResults<FavRecipe>
    
    @State private var isFavrorite = false
    
    let recipe: RecipeProtocol

    init(recipe: RecipeProtocol) {
        self.recipe = recipe
    }

    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: recipe.imageValue)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 233)
                        .clipped()
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 233)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
                
                VStack(spacing: 30) {
                    Text(recipe.labelValue)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        HStack {
                            Text("Ingredients: ")
                                .font(.headline)
                            Spacer()
                            HStack {
                                Image(systemName: "clock.badge.checkmark")
                                Text("\(recipe.totalTimeValue) min")
                            }
                        }
                        
                        ForEach(recipe.ingredientLinesValue, id: \.self) {
                            item in
                            Text("- \(item)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(isFavrorite ? "Remove from favorite" :  "Add to Favorite") {
                        if let favorite = favorites.first(where: { $0.url == recipe.urlValue }) {
                            moc.delete(favorite)
                            isFavrorite = false
                            try? moc.save()
                            
                        } else if let webRecipe = recipe as? Recipe {
                            let fav = FavRecipe(context: moc)
                            fav.image = webRecipe.image
                            fav.ingredientLines = webRecipe.ingredientLines.joined(separator: " || ")
                            fav.label = webRecipe.label
                            fav.url = webRecipe.url
//                            fav.foods = webRecipe.ingredients.map({ $0.food }).joined(separator: " || ")
                            do {
                                isFavrorite = true
                                try moc.save()
                               
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button {
                        Task {
                            if let url = URL(string: recipe.urlValue) {
                                UIApplication.shared.open(url)
                            }
                        }
                    } label: {
                        Text("Get directions").frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding().background(Color.green)
                    .foregroundColor(Color.white)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe(
            label: "Test",
            image: "photo",
            ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"],
//            ingredients: [],
            url: "https://www.apple.com",
//            foods: [Food(food: "Salad")],
            totalTime: 40))
    }
}

//
//  RecipeView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
    ]) var favorites: FetchedResults<FavRecipe>
    
    let recipe: any RecipeProtocol
    let dataController = DataController()
    init(recipe: any RecipeProtocol) {
        self.recipe = recipe
    }
    
    var body: some View {
        ScrollView{
            VStack{
                if let favRecipe = favorites.first(where: {$0.urlValue == recipe.urlValue}) {
                    Image(uiImage: UIImage(data: favRecipe.storedImage ?? Data()) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 233)
                        .clipped()
                        .accessibilityLabel("meal photo")
                } else {
                    AsyncImage(url: URL(string: recipe.imageValue)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 233)
                            .clipped()
                            .accessibilityLabel("meal photo")
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .accessibilityHidden(true)
                    }
                    .frame(height: 233)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
                }
                
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
                            if recipe.totalTimeValue != 0 {
                                let recipeTime = recipe.totalTimeValue.toTimeString()
                                HStack {
                                    Image(systemName: "clock.badge.checkmark")
                                    Text("\(recipeTime)")
                                        
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityValue(recipeTime)
                            }
                        }
                        
                        ForEach(recipe.ingredientLinesValue, id: \.self) {
                            item in
                            Text("- \(item)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
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
            .toolbar {
                ToolbarItem(placement: .automatic){
                    Button(action: {
                        
                        if let favRecipe = favorites.first(where: {$0.urlValue == recipe.urlValue}) {
                            dataController.removeFavorite(recipe: favRecipe, context: moc)
                            if recipe is FavRecipe {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            dataController.addFavorite(label: recipe.labelValue, image: recipe.imageValue, ingredientLines: recipe.ingredientLinesValue, url: recipe.urlValue, totalTime: recipe.totalTimeValue, foodIngredients: recipe.foodIngredientsValue, context: moc)
                        }
                    }, label: {
                        Image(systemName: favorites.contains(where: {$0.urlValue == recipe.urlValue}) ? "heart.fill" : "heart")
                    })
                    .accessibilityLabel(favorites.contains(where: {$0.urlValue == recipe.urlValue}) ? "remove from favorite" : "add to favorite")
                }
            }
        }
    }
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe(
            label: "Test",
            image: "photo",
            ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"],
            ingredients: [ingredient(food: "cheese"), ingredient(food: "lemon")],
            url: "https://www.apple.com",
            totalTime: 40))
    }
}

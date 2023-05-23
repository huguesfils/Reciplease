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
                        Text("Ingredients")
                            .font(.headline)
                        
                        ForEach(recipe.ingredientLinesValue, id: \.self) {
                            item in
                            Text("- \(item)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Add to Favorite") {
                        if let favorite = favorites.first(where: { $0.url == recipe.urlValue }) {
                            moc.delete(favorite)
                            try? moc.save()
                        } else {
                            let fav = FavRecipe(context: moc)
                            //fav.id = UUID()
                            fav.image = recipe.imageValue
                            fav.ingredientLines = recipe.ingredientLinesValue.joined(separator: "||")
                            fav.label = recipe.labelValue
                            fav.url = recipe.urlValue
                            try? moc.save()
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
            url: "https://www.apple.com",
            ingredients: [Food(food: "Salad")],
            totalTime: 40))
    }
}

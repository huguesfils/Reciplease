//
//  RecipeView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.managedObjectContext) var moc
    
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: recipe.image)) { image in
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
                    Text(recipe.label)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Ingredients")
                            .font(.headline)
                        
                        ForEach(recipe.ingredientLines, id: \.self) {
                            item in
                            Text("- \(item)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Add to Favorite") {
                        let fav = FavRecipe(context: moc)
                        fav.id = UUID()
                        fav.image = recipe.image
                        fav.ingredientLines = recipe.ingredientLines as NSObject
                        fav.label = recipe.label
                        fav.url = recipe.url
                        
                        try? moc.save()
                    }
                    
                    Button {
                        Task {
                            if let url = URL(string: recipe.url) {
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
        RecipeView(recipe: Recipe(label: "Test", image: "photo", ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"], url: "https://www.apple.com"))
    }
}

//
//  RecipeView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var recipeViewModel: RecipeViewModel
    
    init(_ recipeViewModel: RecipeViewModel) {
        self.recipeViewModel = recipeViewModel
    }
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            ScrollView{
                VStack{
                    if let favRecipe = recipeViewModel.favorites.first(where: {$0.urlValue == recipeViewModel.url}) {
                        Image(uiImage: UIImage(data: favRecipe.storedImage ?? Data()) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 233)
                            .clipped()
                            .accessibilityLabel("dish photo")
                    } else {
                        AsyncImage(url: URL(string: recipeViewModel.image)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 233)
                                .clipped()
                                .accessibilityLabel("dish photo")
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
                        Text(recipeViewModel.title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 10){
                            HStack {
                                Text("Ingredients: ")
                                    .font(.headline)
                                Spacer()
                                if recipeViewModel.totalTime != 0 {
                                    let recipeTime = recipeViewModel.totalTime.toTimeString()
                                    HStack {
                                        Image(systemName: "clock.badge.checkmark")
                                        Text("\(recipeTime)")
                                        
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityValue(recipeTime)
                                }
                            }
                            
                            ForEach(recipeViewModel.ingredientLines, id: \.self) {
                                item in
                                Text("- \(item)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            Task {
                                if let url = URL(string: recipeViewModel.url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        } label: {
                            Text("Get directions").frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding()
                        .background(Color("button"))
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                    }
                    .padding(.horizontal)
                }
                .alert("Error", isPresented: $recipeViewModel.dataController.hasError) {
                    Button("Dismiss") { }
                } message: {
                    Text(recipeViewModel.dataController.errorCoreData)
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .automatic){
                        Button(action: {
                            if let favRecipe = recipeViewModel.favorites.first(where: {$0.urlValue == recipeViewModel.url}) {
                                recipeViewModel.dataController.removeFavorite(recipe: favRecipe)
                                if recipeViewModel.recipe is FavRecipe {
                                    recipeViewModel.fetchFavorites()
                                    dismiss()
                                }
                            } else{
                                recipeViewModel.dataController.addFavorite(recipe: recipeViewModel.recipe as! Recipe) { 
                                    recipeViewModel.fetchFavorites()
                                }
                            }
                        }, label: {
                            Image(systemName: recipeViewModel.favorites.contains(where: {$0.urlValue == recipeViewModel.url}) ? "heart.fill" : "heart")
                        })
                        .accessibilityLabel(recipeViewModel.favorites.contains(where: {$0.urlValue == recipeViewModel.url}) ? "remove from favorite" : "add to favorite")
                    }
                }
            }
        }
        .onAppear {
            recipeViewModel.fetchFavorites()
        }
    }
}


struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(RecipeViewModel(recipe: Recipe(label: "Test", image: "photo", ingredientLines: ["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"], ingredients: [ingredient(food: "cheese"), ingredient(food: "lemon")], url: "https://www.apple.com", totalTime: 40)))
    }
}

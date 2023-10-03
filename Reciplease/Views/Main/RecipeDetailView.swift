//
//  RecipeView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var recipeDetailViewModel: RecipeDetailViewModel
    
    var recipe: Recipe
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            ScrollView{
                VStack{
//                    if let favRecipe = recipeViewModel.favorites.first(where: {$0.urlValue == recipeViewModel.url}) {
//                        Image(uiImage: UIImage(data: favRecipe.storedImage ?? Data()) ?? UIImage())
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 233)
//                            .clipped()
//                            .accessibilityLabel("dish photo")
//                    } else {
                        AsyncImage(url: URL(string: recipe.image)) { image in
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
//                    }
                    
                    VStack(spacing: 30) {
                        Text(recipe.label)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 10){
                            HStack {
                                Text("Ingredients: ")
                                    .font(.headline)
                                Spacer()
                                if recipe.totalTime != 0 {
                                    let recipeTime = recipe.totalTime.toTimeString()
                                    HStack {
                                        Image(systemName: "clock.badge.checkmark")
                                        Text("\(recipeTime)")
                                        
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityValue(recipeTime)
                                }
                            }
                            
                            ForEach(recipe.ingredientLines, id: \.self) {
                                item in
                                Text("- \(item)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            Task {
                                if let url = URL(string: recipe.url) {
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
//                .alert("Error", isPresented: $recipeViewModel.dataController.hasError) {
//                    Button("Dismiss") { }
//                } message: {
//                    Text(recipeViewModel.dataController.errorCoreData)
//                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .automatic){
//                        Button(action: {
//                            if let favRecipe = recipeDetailViewModel.favorites.first(where: {$0.label == recipe.label}) {
//                                recipeDetailViewModel.removeFavorite(recipe: favRecipe)
//                                if recipe is FavRecipe {
//                                    recipeDetailViewModel.fetchFavorites()
//                                    dismiss()
//                                }
//                            } else{
//                                recipeDetailViewModel.addFavorite(recipe: recipe) {
//                                    recipeDetailViewModel.fetchFavorites()
//                               }
//                            }
//                        }, label: {
//                            Image(systemName: recipeDetailViewModel.favorites.contains(where: {$0.label == recipe.label}) ? "heart.fill" : "heart")
//                        })
//                        .accessibilityLabel(recipeDetailViewModel.favorites.contains(where: {$0.label == recipe.label}) ? "remove from favorite" : "add to favorite")
//                   }
//              }
            }
        }
//        .onAppear {
//            recipeViewModel.fetchFavorites()
//        }
    }
}


struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView()
    }
}

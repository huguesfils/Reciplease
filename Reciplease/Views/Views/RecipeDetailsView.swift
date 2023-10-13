//
//  RecipeDetailsView.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import SwiftUI

struct RecipeDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var recipeViewModel: RecipeViewModel
    
    init(_ recipeViewModel: RecipeViewModel) {
        self.recipeViewModel = recipeViewModel
    }
    
    var body: some View {
        ZStack {
            Color("CustomBackgroundColor").ignoresSafeArea()
            ScrollView{
                VStack{
                    if recipeViewModel.recipe is FavRecipe {
                        Image(uiImage: UIImage(data: recipeViewModel.storedImage) ?? UIImage())
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
                }
                
                VStack(spacing: 30) {
                    Text(recipeViewModel.label)
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
                    .background(Color("CustomButtonColor"))
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                }
                .padding(.horizontal)
            }
            //                      .alert("Error", isPresented: $recipeViewModel.dataController.hasError) {
            //                          Button("Dismiss") { }
            //                      } message: {
            //                          Text(recipeViewModel.dataController.errorCoreData)
            //                      }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic){
                    Button(action: {
                        if recipeViewModel.isFavorite {
                            recipeViewModel.removeFavorite(recipe: recipeViewModel.recipe)
                            if recipeViewModel.isComingFromFavoriteList {
                                dismiss()
                            }
                            
                        } else{
                            recipeViewModel.addFavorite(recipe: recipeViewModel.recipe as! Recipe)
                        }
                    }, label: {
                        Image(systemName: recipeViewModel.isFavorite ? "heart.fill" : "heart")
                    })
                    .accessibilityLabel(recipeViewModel.isFavorite ? "remove from favorite" : "add to favorite")
                }
            }
        }
        .onAppear {
            recipeViewModel.checkIfRecipeIsFavorite()
        }
    }
    
}

#Preview {
    RecipeDetailsView(RecipeViewModel(recipe: Recipe(label: "Test", image: "photo", ingredientLines: ["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"], ingredients: [Ingredient(food: "cheese"), Ingredient(food: "lemon")], totalTime: 40, url: "https://www.apple.com")))
}

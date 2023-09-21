//
//  RecipeView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/05/2023.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private var viewModel: RecipeViewModel
    
    init(_ viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color("listColor").ignoresSafeArea()
            ScrollView{
                VStack{
                    if let favRecipe = viewModel.favorites.first(where: {$0.urlValue == viewModel.url}) {
                        Image(uiImage: UIImage(data: favRecipe.storedImage ?? Data()) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 233)
                            .clipped()
                            .accessibilityLabel("meal photo")
                    } else {
                        AsyncImage(url: URL(string: viewModel.image)) { image in
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
                        Text(viewModel.title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 10){
                            HStack {
                                Text("Ingredients: ")
                                    .font(.headline)
                                Spacer()
                                if viewModel.totalTime != 0 {
                                    let recipeTime = viewModel.totalTime.toTimeString()
                                    HStack {
                                        Image(systemName: "clock.badge.checkmark")
                                        Text("\(recipeTime)")
                                        
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityValue(recipeTime)
                                }
                            }
                            
                            ForEach(viewModel.ingredientLines, id: \.self) {
                                item in
                                Text("- \(item)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            Task {
                                if let url = URL(string: viewModel.url) {
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
                .alert("Error", isPresented: $viewModel.dataController.hasError) {
                    Button("Dismiss") {
                    }
                } message: {
                    Text(viewModel.dataController.errorCoreData)
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .automatic){
                        Button(action: {
                            if let favRecipe = viewModel.favorites.first(where: {$0.urlValue == viewModel.url}) {
                                print("recipeView: ", favRecipe)
                                viewModel.dataController.removeFavorite(recipe: favRecipe)
                                if viewModel.recipe is FavRecipe {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            } else{
                                viewModel.dataController.addFavorite(recipe: viewModel.recipe as! Recipe) { }
                            }
                        }, label: {
                            Image(systemName: viewModel.favorites.contains(where: {$0.urlValue == viewModel.url}) ? "heart.fill" : "heart")
                        })
                        .accessibilityLabel(viewModel.favorites.contains(where: {$0.urlValue == viewModel.url}) ? "remove from favorite" : "add to favorite")
                    }
                }
            }
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(RecipeViewModel(recipe: Recipe(label: "Test", image: "photo", ingredientLines: ["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"], ingredients: [ingredient(food: "cheese"), ingredient(food: "lemon")], url: "https://www.apple.com", totalTime: 40)))
    }
}

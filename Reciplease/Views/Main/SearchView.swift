//
//  SearchView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var navPath = NavigationPath()
    
    let service = RecipeService()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                VStack(alignment: .leading) {
                    Text("What's in your fridge ?")
                        .font(.title)
                        .bold()
                    HStack {
                        TextField("Lemon, cheese, Sausages...", text: $viewModel.searchInput)
//                            .accessibilityLabel("Enter one or more ingredients here")
                            .accessibilityValue(viewModel.searchInput)
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .whileEditing
                            }
                            .onSubmit(addIngredient)
                        Button(action: addIngredient){
                            Text("Add")
                                .frame(width: 40)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                }
                
                Section {
                    HStack {
                        Text("Your ingredients:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !viewModel.ingredients.isEmpty {
                            Button(action: clearIngredient){
                                Text("Clear")
                                    .frame(width: 40)
                            }
                            .buttonStyle(.bordered)
                            .tint(.gray)
                        }
                    }
                    if !viewModel.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 10){
                            ForEach(viewModel.ingredients, id: \.self) { ingredient in
                                HStack{
                                    Image(systemName: "checkmark").foregroundColor(.green)
                                    Text("\(ingredient)")
                                    
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel(ingredient)
                                
                            }
                        }
                    }
                }
                
                Section {
                    if viewModel.isLoading {
                        ProgressView().frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Button {
                            Task {
                                await viewModel.search()
                                await MainActor.run {
                                    navPath.append(1)
                                }
                            }
                        } label: {
                            Text("Search for recipies").frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(viewModel.ingredients.isEmpty)
                        .tint(.green)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Int.self, destination: { i in
                RecipiesListView(viewModel: self.viewModel)
            })
        }.navigationBarTitleDisplayMode(.inline)
    }
    
    private func addIngredient() {
        withAnimation {
            viewModel.addIngredient()
        }
    }
    
    private func clearIngredient() {
        withAnimation {
            viewModel.clearIngredients()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

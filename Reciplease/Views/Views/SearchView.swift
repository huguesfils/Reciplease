//
//  SearchView.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                VStack(alignment: .leading) {
                    Text("What's in your fridge?")
                        .font(.title)
                        .bold()
                    HStack {
                        TextField("Lemon, cheese, Sausages...", text: $searchViewModel.searchInput)
                            .accessibilityValue(searchViewModel.searchInput)
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .whileEditing
                            }
                            .onSubmit(addIngredient)
                        Button(action: addIngredient) {
                            Text("Add")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("CustomButtonColor"))
                    }
                }
                
                Section {
                    HStack {
                        Text("Your ingredients:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !searchViewModel.ingredients.isEmpty {
                            Button(action: clearIngredient) {
                                Text("Clear")
                            }
                            .buttonStyle(.bordered)
                            .tint(.gray)
                        }
                    }
                    if !searchViewModel.ingredients.isEmpty {
                        ForEach(searchViewModel.ingredients) { ingredient in
                            HStack {
                                Image(systemName: "checkmark").foregroundColor(Color("CustomButtonColor"))
                                Text("\(ingredient.name)")
                                Spacer()
                                Button(action: {
                                    removeIngredient(ingredient.id)
                                }) {
                                    Image(systemName: "minus.circle.fill").foregroundColor(.red)
                                }
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(ingredient.name)
                        }
                    }
                }
                
                Section {
                    Button {
                        Task {
                            await MainActor.run {
                                navPath.append(1)
                            }
                        }
                    } label: {
                        Text("Search for recipies").frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(searchViewModel.ingredients.isEmpty)
                    .tint(Color("CustomButtonColor"))
                }
            }
            .navigationTitle("Reciplease")
            .navigationDestination(for: Int.self, destination: { i in
                RecipiesListView(recipiesListViewModel: self.searchViewModel.toRecipeListViewModel())
            })
        }
    }
    
    private func addIngredient() {
        withAnimation {
            searchViewModel.addIngredient()
        }
    }
    
    private func clearIngredient() {
        withAnimation {
            searchViewModel.clearIngredients()
        }
    }
    
    private func removeIngredient(_ id: UUID) {
        withAnimation {
            searchViewModel.removeIngredient(id: id)
        }
    }
}


#Preview {
    SearchView()
}

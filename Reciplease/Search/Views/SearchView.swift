//
//  SearchView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    TextField("Lemon, cheese, Sausages...", text: $viewModel.searchInput)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                }
                .onSubmit(addIngredient)
                
                Section {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        HStack{
                            Image(systemName: "checkmark.circle").foregroundColor(.green)
                            Text("\(ingredient)")
                        }
                        
                    }.onDelete { indexSet in
                        viewModel.ingredients.remove(atOffsets: indexSet)
                    }
                }
                
                Section {
                    NavigationLink(destination: RecipiesListView(), isActive: $viewModel.isNavigate) {
                    
                        Text("Search for recipies")
                    }.task {
                        await viewModel.loadData()
                    }
                    
                }
                .disabled(viewModel.ingredients.isEmpty)
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("Search")
        }
    }
    
    func addIngredient() {
        withAnimation {
            viewModel.addIngredient()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

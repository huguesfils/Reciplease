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
            VStack(alignment: .center) {
                TextField("Lemon, cheese, Sausages...", text: $viewModel.searchInput)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                
                List {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }.onDelete { indexSet in
                        viewModel.ingredients.remove(atOffsets: indexSet)
                    }
                }
                Spacer()
                NavigationLink(destination: RecipiesListView(), isActive: $viewModel.isNavigate) {
                        
                        Button("Search for recipies") {
                            self.viewModel.isNavigate = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                }
            }
            .padding(20)
            .toolbar {
                EditButton()
            }
            .navigationTitle("Search")
            .onSubmit(addIngredient)
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

//
//  Search.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct Search: View {
    @State private var ingredients = [String]()
    @State private var searchInput = ""
    @State private var isNavigate = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                TextField("Lemon, cheese, Sausages...", text: $searchInput)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                
                List {
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }.onDelete { indexSet in
                        ingredients.remove(atOffsets: indexSet)
                    }
                }
                Spacer()
                NavigationLink(destination: RecipiesList(), isActive: $isNavigate) {
                        
                        Button("Search for recipies") {
                            self.isNavigate = true
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
        let newIngredient = searchInput.lowercased()
        withAnimation {
            ingredients.insert(newIngredient, at: 0)
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

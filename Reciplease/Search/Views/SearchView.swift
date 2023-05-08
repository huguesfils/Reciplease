//
//  SearchView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
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
                    if viewModel.isLoading {
                        ProgressView().frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Button {
                            Task {
                                await self.viewModel.loadData()
                                await MainActor.run {
                                    navPath.append(1)
                                }
                            }
                        } label: {
                            Text("Search for recipies").frame(maxWidth: .infinity, alignment: .center)
                        }.disabled(viewModel.ingredients.isEmpty)
                    }
                }
            }
            .navigationDestination(for: Int.self, destination: { i in
                RecipiesListView(viewModel: self.viewModel)
            })
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

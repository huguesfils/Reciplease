//
//  RecipiesList.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/04/2023.
//

import SwiftUI

struct RecipiesListView: View {
    @ObservedObject var viewModel: SearchView.ViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.results, id: \.label) { item in
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(
                            url: URL(string:item.image)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    //.clipShape(Circle())
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                            }
                            placeholder: {
                                ProgressView()
                            }
                        Text(item.label)
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle("List")
    }
}

struct RecipiesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipiesListView(viewModel: SearchView.ViewModel())
    }
}

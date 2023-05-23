//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: SearchView.ViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
    ]) var favorites: FetchedResults<FavRecipe>
    
    var body: some View {
        List {
            ForEach(favorites) { favorite in
                Text(favorite.label ?? "ça marche pas")
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: SearchView.ViewModel())
    }
}

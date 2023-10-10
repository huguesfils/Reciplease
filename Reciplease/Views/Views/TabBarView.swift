//
//  TabBarView.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            FavoritesView()
                .tabItem{
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

#Preview {
    TabBarView()
}

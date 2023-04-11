//
//  ContentView.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Search()
                .tabItem {
                    Text("Search")
                }
            Favorites()
                .tabItem{
                    Text("Favorites")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

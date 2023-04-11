//
//  Search.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

struct SearchResultList: View {
    var body: some View {
        Text("Result list")
    }
    
}

struct Search: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: SearchResultList()) {
                Text("Search for recepies")
            }
          
            .navigationBarTitle("Search")
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

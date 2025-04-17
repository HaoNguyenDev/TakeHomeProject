//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import SwiftUI

struct UserListView: View {
    private let mockUserArray = User.mockUserArray
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 12) {
                    ForEach(mockUserArray) { user in
                        UserItemView(user: user, isDetailView: .constant(false))
                    }
                }
            }
            .navigationTitle(Text("GitHub Users"))
        }
    }
}

#Preview {
    UserListView()
}

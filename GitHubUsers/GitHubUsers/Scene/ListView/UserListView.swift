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
        CustomNavigationView (title: "GitHub Users", subtitle: nil, hideBackButton: true, content: {
            scrollView
        })
    }
    
    private func userItemView(user: User) -> UserItemView {
        let user = UserItemModel(userName: user.login,
                                 avatarUrl: user.avatarUrl,
                                 githubUrl: user.url,
                                 locationName: "",
                                 followersCount: "",
                                 followingCount: "",
                                 blogUrl: "")
        return UserItemView(user: user, isDetailView: .constant(false))
    }
}

extension UserListView {
    private var scrollView: some View {
        ScrollView {
            VStack (spacing: 12) {
                ForEach(mockUserArray) { user in
                    CustomNavigationLink(title: "User Details", destination: UserDetailsView(userDetail: UserDetail.mockUserDetail)) {
                        userItemView(user: user)
                    }
                }
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    UserListView()
}

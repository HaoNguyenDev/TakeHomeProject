//
//  UserDetailsView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import SwiftUI

struct UserDetailsView: View {
    var userDetail: UserDetail
    var body: some View {
        ScrollView {
            VStack (spacing: 20) {
                userItemView // The user info part
                FollowerView(followerCount: userDetail.getUserFollowers(),
                             followingCount: userDetail.getUserFollowing())
                BlogView(content: userDetail.blog.orEmpty)
            }
            .padding(.vertical)
        }
    }
    
    private var userItemView: some View {
        let user = UserItemModel(userName: userDetail.name,
                                 avatarUrl: userDetail.avatarUrl,
                                 githubUrl: userDetail.url,
                                 locationName: userDetail.location,
                                 followersCount: userDetail.getUserFollowers(),
                                 followingCount: userDetail.getUserFollowing(),
                                 blogUrl: userDetail.blog)
        return UserItemView(user: user, isDetailView: .constant(true))
    }
}

#Preview {
    UserDetailsView(userDetail: UserDetail.mockUserDetail)
}

struct FollowerView: View {
    var followerCount: String = "0"
    var followingCount: String = "0"
    
    var body: some View {
        HStack(spacing: 70) {
            FollowerSubView(iconName: "person.fill", count: followerCount, title: "Follower")
            FollowerSubView(iconName: "person.fill", count: followingCount, title: "Following")
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding()
    }
}

struct FollowerSubView: View {
    var iconName: String = "person.fill"
    var count: String = "0"
    var title: String = "Follower"
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: iconName)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
            Text(count)
                .font(.system(size: 13, weight: .medium))
            Text(title)
                .font(.caption)
        }
    }
}

struct BlogView: View {
    var content: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Blog:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .medium))
                .padding(.leading, 20)
            
            Text(content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(nil)
                .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



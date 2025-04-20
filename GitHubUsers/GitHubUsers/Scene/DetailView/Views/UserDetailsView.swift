//
//  UserDetailsView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import SwiftUI

struct UserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = UserDetailViewModel()
    @State private var showErrorAlert: Bool = false
    var userName: String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 20) {
                    userItemView // The user info part
                    FollowerView(followerCount: viewModel.usersDetail?.getUserFollowers(),
                                 followingCount: viewModel.usersDetail?.getUserFollowing())
                    BlogView(content: viewModel.usersDetail?.blog ?? "Bio not available")
                }
                .padding(.vertical)
            }
            if viewModel.isLoading {
                loadingView
            }
        }
        .onReceive(viewModel.$error, perform: { error in
            if error != nil {
                self.showErrorAlert.toggle()
            }
        })
        .modifier(AlertHandler(showAlert: $showErrorAlert, error: viewModel.error, onDismiss: {
            presentationMode.wrappedValue.dismiss()
        }))
        .task {
            guard let userName = userName else {
                //Todo: handle empty username
                return
            }
            await viewModel.fetchUsers(by: userName)
        }
    }
}

// MARK: - CustomView
extension UserDetailsView {
    private var userItemView: some View {
        let user = UserItemModel(id: viewModel.usersDetail?.id,
                                 userName: viewModel.usersDetail?.name,
                                 avatarUrl: viewModel.usersDetail?.avatarUrl,
                                 githubUrl: viewModel.usersDetail?.url,
                                 locationName: viewModel.usersDetail?.location,
                                 followersCount: viewModel.usersDetail?.getUserFollowers(),
                                 followingCount: viewModel.usersDetail?.getUserFollowing(),
                                 blogUrl: viewModel.usersDetail?.blog,
                                 cachedImage: nil)
        return UserItemView(user: user, isDetailView: .constant(true))
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
            .ignoresSafeArea()
    }
}

#Preview {
    UserDetailsView(userName: "TEST USERNAME")
}

// MARK: - CustomView
struct FollowerView: View {
    var followerCount: String?
    var followingCount: String?
    
    var body: some View {
        HStack(spacing: 70) {
            FollowerSubView(iconName: "person.fill", count: followerCount.orEmpty, title: "Follower")
            FollowerSubView(iconName: "person.fill", count: followingCount.orEmpty, title: "Following")
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



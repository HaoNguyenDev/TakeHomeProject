//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import SwiftUI

struct UserListView: View {
    
    @StateObject private var viewModel = UserListViewModel()
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        CustomNavigationView (title: "GitHub Users", subtitle: nil, hideBackButton: true, content: {
            scrollView
        })
        .task {
            await viewModel.fetchUsers()
        }
        .onReceive(viewModel.$error, perform: { error in
            if error != nil {
                self.showErrorAlert.toggle()
            }
        })
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text((viewModel.error as? NetworkError)?.errorDescription ?? ""), dismissButton: .default(Text("OK")))
        }
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
            LazyVStack(spacing: 12) {
                ForEach(viewModel.users, id: \.id) { user in
                    CustomNavigationLink(title: "User Details",
                                         destination: UserDetailsView(userName: user.login)) {
                        userItemView(user: user)
                    }
                    .onAppear {
                        loadMoreDataIfNeed(currentUser: user)
                    }
                }
            }
            .padding(.top, 10)
        }

    }
    
    func loadMoreDataIfNeed(currentUser: User) {
        if (currentUser == viewModel.users.last && viewModel.isLoading == false && !viewModel.users.isEmpty) {
            print(">>> Load more data...")
            Task {
                await viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    UserListView()
}

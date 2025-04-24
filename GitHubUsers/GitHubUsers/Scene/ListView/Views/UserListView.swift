//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import SwiftUI
import SwiftData

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    @State private var showErrorAlert: Bool = false
    
    init(viewModel: UserListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            CustomNavigationView (title: "GitHub Users", subtitle: nil, hideBackButton: true, content: { scrollView })
            if viewModel.isLoading {
                loadingView
            }
        }
        .task {
            await viewModel.fetchUsers()
        }
        .onReceive(viewModel.$error, perform: { error in
            if error != nil {
                showErrorAlert = true
            }
        })
        .modifier(AlertHandler(showAlert: $showErrorAlert, error: viewModel.error, onDismiss: {
            showErrorAlert = false
        }))
    }
}

extension UserListView {
    private var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.users, id: \.id) { user in
                    UserItemView(user: userItemModel(from: user), isDetailView: .constant(false))
                        .onAppear {
                            loadMoreDataIfNeed(currentUser: user)
                        }
                }
            }
            .padding(.top, 10)
        }
    }
    
    func loadMoreDataIfNeed(currentUser: User) {
        guard currentUser == viewModel.users.last,
              !viewModel.isLoading,
              !viewModel.users.isEmpty else { return }
            #if DEBUG
            print(">>> Load more data from user withID \(String(describing: currentUser.id))")
            #endif
            /* load more if scroll to the last user */
        Task {
            await viewModel.loadMoreUser()
        }
    }
}

// MARK: - CustomView
extension UserListView {
    private func userItemModel(from user: User) -> UserItemModel {
        return UserItemModel(id: user.id,
                             userName: user.login,
                             avatarUrl: user.avatarUrl,
                             githubUrl: user.url,
                             locationName: "",
                             followersCount: "",
                             followingCount: "",
                             blogUrl: "",
                             cachedImage: user.cachedImage)
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
    let container = try! SwiftDataContainer()
    let context = container.createContext()
    
    let viewModel = UserListViewModel(
        networkService: GitHubNetworkService(),
        cacheService: CacheManager<User>(modelType: User.self,
                                         context: context,
                                         appSetting: AppSetting.shared)
    )
    
    UserListView(viewModel: viewModel)
}

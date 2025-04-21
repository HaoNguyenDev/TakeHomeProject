//
//  UserItemView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import SwiftUI

struct UserItemView: View {
    var user: UserItemModel
    @Binding var isDetailView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .top){
                // avatar part
                avatarView
                // info part
                infoView
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
}

extension UserItemView {
    private var avatarView: some View {
        Group {
            /* load image data from cache first */
            if let imageData = user.cachedImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                AsyncImage(url: URL(string: user.avatarUrl.orEmpty), content: { returnImage in
                    returnImage
                        .resizable()
                        .scaledToFit()
                }, placeholder: {
                    Image("man-user-circle-icon")
                        .resizable()
                        .scaledToFit()
                })
            }
        }
        .frame(maxWidth: 100, maxHeight: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding([.leading, .top, .bottom], 10)
    }
}

extension UserItemView {
    private var infoView: some View {
        VStack(alignment: .leading) {
            Text(user.userName.orEmpty.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.black)
                .font(.system(size: 15, weight: .bold))
            
            Divider()
            
            if isDetailView {
                Text(user.locationName ?? "Location not found".uppercased())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12))
            } else {
                if let urlString = user.githubUrl, let url = URL(string: urlString) {
                    Link(urlString, destination: url)
                        .font(.system(size: 12))
                } else {
                    Text("Invalid URL")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
    }
}

#Preview {
    let user = UserDetail.mockUserDetail
    let itemModel = UserItemModel(id: 1,
                                  userName: user.name,
                                  avatarUrl: user.avatarUrl,
                                  githubUrl: user.url,
                                  locationName: user.location,
                                  followersCount: user.getUserFollowers(),
                                  followingCount: user.getUserFollowing(),
                                  blogUrl: user.blog,
                                  cachedImage: nil)
    
    UserItemView(user: itemModel, isDetailView: .constant(false))
}

//
//  UserItemView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import SwiftUI

struct UserItemView: View {
    var user: User
    @Binding var isDetailView: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .top){
                //the avatar part
                AsyncImage(url: URL(string: user.avatarUrl.orEmpty), content: { returnImage in
                    returnImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }, placeholder: {
                    Image("man-user-circle-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                })
                .frame(maxWidth: 100, maxHeight: 100)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding([.leading, .top, .bottom], 10)
                
                // content part
                VStack(alignment: .leading) {
                    Text(user.login.orEmpty.uppercased())
                        .font(.system(size: 15, weight: .bold))
                    
                    Divider()
                    
                    if isDetailView {
                        Text("vietnam".uppercased())
                            .font(.system(size: 12))
                    } else {
                        if let urlString = user.url, let url = URL(string: urlString) {
                            Link(urlString, destination: url)
                                .font(.system(size: 12))
                        } else {
                            Text("Invalid URL")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                    }

                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
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

#Preview {
    UserItemView(user: User.singleUser, isDetailView: .constant(false))
}

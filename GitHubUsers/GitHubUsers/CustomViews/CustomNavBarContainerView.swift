//
//  CustomNavBarContainerView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import SwiftUI

struct CustomNavBarContainerView<Content: View>: View {
    let title: String?
    let subtitle: String?
    var hideBackButton: Bool = false
    let content: Content
    var backgroundColor: Color = .white
    
    init(title: String? = "",
         subtitle: String? = "",
         hideBackButton: Bool = false,
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.subtitle = subtitle
        self.hideBackButton = hideBackButton
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavBarView(title: title,
                             subtitle: nil,
                             hideBackButton: hideBackButton)
            .background(backgroundColor)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }
}

#Preview {
    CustomNavBarContainerView(title: "Title", subtitle: "Subtitle", hideBackButton: false, content: {
        ZStack {
            Color.blue.ignoresSafeArea()
            Text("Hello World!")
        }
    })
}

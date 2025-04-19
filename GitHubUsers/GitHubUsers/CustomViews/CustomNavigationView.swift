//
//  CustomNavigationView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import SwiftUI

struct CustomNavigationView<Content: View>: View {
    var title: String?
    var subtitle: String?
    var hideBackButton: Bool = false
    let content: Content
    
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
        NavigationView {
            CustomNavBarContainerView(title: title, subtitle: subtitle, hideBackButton: hideBackButton) {
                content
    }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CustomNavigationView(title: "Title",
                         subtitle: "Subtitle",
                         hideBackButton: false,
                         content: {
        Color.blue.ignoresSafeArea(edges: .all)
    })
}

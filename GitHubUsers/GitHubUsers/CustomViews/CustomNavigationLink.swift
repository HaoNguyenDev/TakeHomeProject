//
//  CustomNavigationLink.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import SwiftUI

struct CustomNavigationLink<Label: View, Destination: View> : View {
    
    let destination: Destination
    let label: Label
    
    var title: String?
    var subtitle: String?
    var hideBackButton: Bool = false
    
    init(title: String? = "", subtitle: String? = "", hideBackButton: Bool = false, destination: Destination, @ViewBuilder label: () -> Label) {
        self.title = title
        self.subtitle = subtitle
        self.hideBackButton = hideBackButton
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(destination:
                        CustomNavBarContainerView(title: title, subtitle: subtitle, hideBackButton: hideBackButton, content: {
            destination })
                            .navigationBarHidden(true)
                       , label: {
            label
        })
    }
}

#Preview {
    CustomNavigationView(title: "Title", subtitle: "Subtitle", content: {
        CustomNavigationLink(destination:
                                Text("Destination")
        ) {
            Text("Click")
        }
    })
    
}

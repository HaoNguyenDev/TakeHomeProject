//
//  CustomNavBarView.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import SwiftUI

struct CustomNavBarView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var title: String?
    @State var subtitle: String?
    @State var hideBackButton = false
    var body: some View {
        HStack {
            backButton
            Spacer()
            titleSection
            Spacer()
            backButton
            .hidden()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    VStack {
        CustomNavBarView(title: "Title", subtitle: "Subtitle")
        Spacer()
    }
}

extension CustomNavBarView {
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.black)
                .font(.headline)
        }
        .opacity(hideBackButton ? 0 : 1)
        .padding(.leading, 16)
    }
    
    private var titleSection: some View {
        VStack {
            Text(title.orEmpty)
                .font(.title2)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

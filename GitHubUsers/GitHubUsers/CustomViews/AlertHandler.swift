//
//  AlertHandler.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 20/4/25.
//

import SwiftUI

struct AlertHandler: ViewModifier {
    @Binding var showAlert: Bool
    let error: Error?
    let onDismiss: () -> Void?
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                var errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.errorDescription
                } else {
                    errorMessage = error?.localizedDescription ?? "Unknown error"
                }
                return Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK")) {
                        onDismiss()
                    }
                )
            }
    }
}

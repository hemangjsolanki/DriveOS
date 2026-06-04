//
//  AuthContainerView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct AuthContainerView: View {
    @Binding var appState: AppState
    
    var body: some View {
        NavigationStack {
            LoginView(appState: $appState)
        }
    }
}

#Preview {
    AuthContainerView(appState: .constant(.auth))
}

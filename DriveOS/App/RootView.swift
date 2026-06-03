import SwiftUI

enum AppState {
    case splash
    case auth
    case main
}

struct RootView: View {
    @State private var appState: AppState = .splash
    
    var body: some View {
        Group {
            switch appState {
            case .splash:
                SplashView(appState: $appState)
            case .auth:
                AuthContainerView(appState: $appState)
            case .main:
                ContentView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState)
    }
}

#Preview {
    RootView()
}

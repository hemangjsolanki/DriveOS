//
//  LoginView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct LoginView: View {
    @Binding var appState: AppState
    
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var errorMessage = ""
    
    // Simple Email Regex Validation
    private var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "bolt.car.fill")
                            .font(.system(size: 56))
                            .foregroundColor(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.5), radius: 20, x: 0, y: 10)
                            .padding(.top, 40)
                        
                        Text(hasLaunchedBefore ? "Welcome Back" : "Welcome")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Sign in to continue to DriveOS")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    // Input Fields & Error Message
                    VStack(spacing: 16) {
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption.bold())
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                            .onChange(of: email) { _ in errorMessage = "" }
                            
                        CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
                            .onChange(of: password) { _ in errorMessage = "" }
                    }
                    .padding(.horizontal, 24)
                    
                    // Forgot Password Link
                    HStack {
                        Spacer()
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.subheadline.bold())
                                .foregroundColor(Theme.primary)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Login Button
                    Button(action: {
                        if email.isEmpty {
                            errorMessage = "Email cannot be empty."
                        } else if !isEmailValid {
                            errorMessage = "Please enter a valid email address."
                        } else if password.isEmpty {
                            errorMessage = "Password cannot be empty."
                        } else {
                            errorMessage = ""
                            isLoggingIn = true
                            // Simulate network request
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                hasLaunchedBefore = true
                                isLoggedIn = true
                                withAnimation {
                                    appState = .connecting
                                }
                            }
                        }
                    }) {
                        HStack {
                            if isLoggingIn {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign In")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.primary)
                        .foregroundColor(.white)
                        .font(.headline)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Theme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Register Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        NavigationLink(destination: RegisterView(appState: $appState)) {
                            Text("Create one")
                                .font(.subheadline.bold())
                                .foregroundColor(Theme.primary)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleLogin() {
        withAnimation { isLoggingIn = true }
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                appState = .connecting
            }
        }
    }
}

// MARK: - Reusable Input Components
struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Theme.textSecondary)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color(white: 0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    @State private var isSecured: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Theme.textSecondary)
                .frame(width: 20)
            
            ZStack(alignment: .leading) {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .opacity(isSecured ? 1 : 0)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .opacity(isSecured ? 0 : 1)
            }
            
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: isSecured ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(Theme.primary)
            }
        }
        .padding()
        .background(Color(white: 0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    LoginView(appState: .constant(.auth))
}

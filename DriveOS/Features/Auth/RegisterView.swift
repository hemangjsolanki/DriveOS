//
//  RegisterView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var appState: AppState
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isRegistering = false
    @State private var errorMessage = ""
    
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
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 56))
                            .foregroundColor(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.5), radius: 20, x: 0, y: 10)
                            .padding(.top, 40)
                        
                        Text("Create Account")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Join DriveOS to connect your vehicle")
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
                        
                        CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $name)
                            .onChange(of: name) { _ in errorMessage = "" }
                            
                        CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                            .onChange(of: email) { _ in errorMessage = "" }
                            
                        CustomSecureField(icon: "lock.fill", placeholder: "Password (Min 8 chars)", text: $password)
                            .onChange(of: password) { _ in errorMessage = "" }
                            
                        CustomSecureField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword)
                            .onChange(of: confirmPassword) { _ in errorMessage = "" }
                    }
                    .padding(.horizontal, 24)
                    
                    // Register Button
                    Button(action: {
                        if name.count < 3 {
                            errorMessage = "Name must be at least 3 characters long."
                        } else if !isEmailValid {
                            errorMessage = "Please enter a valid email address."
                        } else if password.count < 8 {
                            errorMessage = "Password must be at least 8 characters long."
                        } else if password != confirmPassword {
                            errorMessage = "Passwords do not match."
                        } else {
                            errorMessage = ""
                            isRegistering = true
                            // Simulate network delay
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
                            if isRegistering {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign Up")
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
                    
                    // Login Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        Button(action: { dismiss() }) {
                            Text("Sign In")
                                .font(.subheadline.bold())
                                .foregroundColor(Theme.primary)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleRegister() {
        withAnimation { isRegistering = true }
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isRegistering = false
                dismiss() // Automatically go back to login after registering for this demo
            }
        }
    }
}

#Preview {
    RegisterView(appState: .constant(.auth))
}

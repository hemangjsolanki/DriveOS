//
//  ForgotPasswordView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var isSending = false
    @State private var successMessage = false
    @State private var errorMessage = ""
    
    private var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 56))
                        .foregroundColor(Theme.primary)
                        .shadow(color: Theme.primary.opacity(0.5), radius: 20, x: 0, y: 10)
                        .padding(.top, 40)
                    
                    Text("Reset Password")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Enter your email to receive a reset link")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
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
                    
                    CustomTextField(icon: "envelope.fill", placeholder: "Email Address", text: $email, keyboardType: .emailAddress)
                        .onChange(of: email) { _ in errorMessage = "" }
                }
                .padding(.horizontal, 24)
                
                // Reset Button
                Button(action: {
                    if email.isEmpty {
                        errorMessage = "Email cannot be empty."
                    } else if !isEmailValid {
                        errorMessage = "Please enter a valid email address."
                    } else {
                        errorMessage = ""
                        isSending = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isSending = false
                            successMessage = true
                        }
                    }
                }) {
                    HStack {
                        if isSending {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Send Reset Link")
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
                .alert("Check Your Email", isPresented: $successMessage) {
                    Button("OK", role: .cancel) { dismiss() }
                } message: {
                    Text("We've sent password reset instructions to your email.")
                }
                
                Spacer()
                
                // Back Button
                Button(action: { dismiss() }) {
                    Text("Back to Login")
                        .font(.subheadline.bold())
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}

import SwiftUI

struct GlassCard<Content: View>: View {
    var content: Content
    var isGlowing: Bool
    
    init(isGlowing: Bool = false, @ViewBuilder content: () -> Content) {
        self.isGlowing = isGlowing
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Theme.surface)
            
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Theme.cardBorder, lineWidth: 1)
            
            if isGlowing {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Theme.primary.opacity(0.3), lineWidth: 1)
                    .shadow(color: Theme.primary.opacity(0.15), radius: 30, x: 0, y: 0)
            }
            
            content
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        VStack(spacing: 20) {
            GlassCard {
                Text("Standard Card")
                    .foregroundColor(Theme.textPrimary)
                    .padding()
            }
            .frame(width: 300, height: 100)
            
            GlassCard(isGlowing: true) {
                Text("Glowing Card")
                    .foregroundColor(Theme.textPrimary)
                    .padding()
            }
            .frame(width: 300, height: 100)
        }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        GlassCard {
            VStack {
                Text("Glassmorphism")
                    .font(.title2.bold())
                    .foregroundColor(Theme.textPrimary)
                Text("Premium Apple-style card")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}

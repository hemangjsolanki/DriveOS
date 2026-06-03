import SwiftUI
import SwiftData
import MapKit
import AVFoundation

struct DashboardView: View {
    @Query private var vehicles: [Vehicle]
    
    // Realistic States
    @State private var isLocked: Bool = true
    @State private var isFlashing: Bool = false
    @State private var isHeadlightsOn: Bool = false
    @State private var isFrunkOpen: Bool = false
    @State private var isTrunkOpen: Bool = false
    @State private var isClimateOn: Bool = false
    @State private var targetTemp: Int = 72
    
    // Audio Player for Horn
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var showVehicle = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Model S")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Plaid • Parked")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    isLocked.toggle()
                                }
                            }) {
                                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(isLocked ? Theme.textPrimary : Theme.primary)
                                    .frame(width: 44, height: 44)
                                    .background(Theme.surfaceHighlight)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 3D Vehicle representation (Using CarSilhouetteView)
                        ZStack {
                            CarSilhouetteView(
                                isHeadlightsOn: isHeadlightsOn, 
                                isFlashing: isFlashing,
                                isFrunkOpen: isFrunkOpen,
                                isTrunkOpen: isTrunkOpen,
                                isLocked: isLocked,
                                isClimateOn: isClimateOn
                            )
                                .offset(y: showVehicle ? 0 : 20)
                                .opacity(showVehicle ? 1 : 0)
                        }
                        .frame(height: 220)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.8)) {
                                showVehicle = true
                            }
                        }
                        
                        // Status Grid
                        HStack(spacing: 16) {
                            GlassCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "bolt.fill")
                                            .foregroundColor(Theme.accent)
                                        Text("Battery")
                                            .font(.caption.bold())
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                                        Text("78")
                                            .font(.system(size: 32, weight: .bold, design: .rounded))
                                        Text("%")
                                            .font(.callout.bold())
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    Text("Est. 312 mi")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            GlassCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "fanblades.fill")
                                            .foregroundColor(isClimateOn ? Theme.primary : Theme.textSecondary)
                                            .symbolEffect(.variableColor.iterative, options: .repeating, isActive: isClimateOn)
                                        Text(isClimateOn ? "Climate On" : "Climate Off")
                                            .font(.caption.bold())
                                            .foregroundColor(isClimateOn ? Theme.primary : Theme.textSecondary)
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: $isClimateOn.animation(.spring()))
                                            .labelsHidden()
                                            .tint(Theme.primary)
                                            .scaleEffect(0.7)
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            triggerHaptic()
                                            if targetTemp > 60 { targetTemp -= 1 }
                                            isClimateOn = true
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Theme.textSecondary)
                                        }
                                        
                                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                                            Text("\(targetTemp)")
                                                .font(.system(size: 34, weight: .black, design: .rounded))
                                                .foregroundColor(.white)
                                                .contentTransition(.numericText())
                                                .id(targetTemp)
                                            Text("°")
                                                .font(.title2.bold())
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        
                                        Button(action: {
                                            triggerHaptic()
                                            if targetTemp < 85 { targetTemp += 1 }
                                            isClimateOn = true
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Theme.primary)
                                        }
                                    }
                                    
                                    Text("Interior 75°")
                                        .font(.caption2.bold())
                                        .foregroundColor(Theme.textSecondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Quick Controls
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Controls")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            HStack(spacing: 0) {
                                Spacer()
                                QuickControlButton(icon: "fanblades.fill", title: "Climate", isActive: isClimateOn) { 
                                    triggerHaptic()
                                    withAnimation { isClimateOn.toggle() }
                                }
                                Spacer()
                                QuickControlButton(icon: "archivebox", title: "Frunk", isActive: isFrunkOpen) { 
                                    triggerHaptic()
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                        isFrunkOpen.toggle()
                                    }
                                    flashLights(count: 1)
                                }
                                Spacer()
                                QuickControlButton(icon: "archivebox.fill", title: "Trunk", isActive: isTrunkOpen) { 
                                    triggerHaptic()
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                        isTrunkOpen.toggle()
                                    }
                                    flashLights(count: 1)
                                }
                                Spacer()
                                QuickControlButton(icon: "sun.max.fill", title: "Flash", isActive: isFlashing, action: triggerFlash)
                                Spacer()
                                QuickControlButton(icon: "speaker.wave.3.fill", title: "Honk", isActive: false, action: triggerHonk)
                                Spacer()
                            }
                        }
                        .padding(.top, 16)
                        
                        // Recent Trip (Added Data)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Trip")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            GlassCard {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Theme.surfaceHighlight)
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "map.fill")
                                            .foregroundColor(Theme.primary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Work Commute")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white)
                                        Text("12.4 mi • 24 min")
                                            .font(.caption)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("240")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white)
                                        Text("Wh/mi")
                                            .font(.caption)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.top, 16)
                        
                        Spacer(minLength: 120) // Floating Tab Bar Space
                    }
                }
            }
        }
        .onAppear {
            setupAudioPlayer()
        }
    }
    
    // MARK: - Realistic Actions
    
    private func toggleLock() {
        triggerHaptic()
        isLocked.toggle()
        
        // Real-life behavior: Flash lights once for lock, twice for unlock
        if isLocked {
            flashLights(count: 1)
        } else {
            flashLights(count: 2)
        }
    }
    
    private func triggerFlash() {
        triggerHaptic()
        flashLights(count: 2)
    }
    
    private func flashLights(count: Int) {
        var delays: [Double] = []
        for i in 0..<count {
            delays.append(Double(i) * 0.4) // Turn on
            delays.append(Double(i) * 0.4 + 0.2) // Turn off
        }
        
        for (index, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isFlashing = (index % 2 == 0)
                }
            }
        }
    }
    
    private func triggerHonk() {
        // Strong haptic for horn
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        // Play horn sound if file exists, else use system beep
        if let player = audioPlayer {
            player.play()
        } else {
            // Fallback system sound for horn/beep
            AudioServicesPlaySystemSound(1052)
        }
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func setupAudioPlayer() {
        // Look for horn.mp3 in the main bundle. The user will need to drop this in later.
        if let path = Bundle.main.path(forResource: "horn", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Could not load horn sound: \(error)")
            }
        }
    }
}

// MARK: - Supporting Views

struct CarSilhouetteView: View {
    var isHeadlightsOn: Bool
    var isFlashing: Bool
    var isFrunkOpen: Bool
    var isTrunkOpen: Bool
    var isLocked: Bool
    var isClimateOn: Bool = false
    
    @State private var lockScale: CGFloat = 1.0
    
    // Theme Colors
    let carBodyColor = Color(hex: "291605")
    let carGlowColor = Theme.primary.opacity(0.4)
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                // 1. Sleek Car Body (Base)
                SleekCarBody()
                    .fill(carBodyColor)
                    .shadow(color: carGlowColor, radius: 20, x: 0, y: 10)
                
                // Body Glow Outline
                SleekCarBody()
                    .stroke(LinearGradient(colors: [carGlowColor, .clear], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                
                // Wheels
                SleekWheelView()
                    .frame(width: geo.size.width * 0.16, height: geo.size.width * 0.16)
                    .position(x: geo.size.width * 0.22, y: geo.size.height * 0.8)
                
                SleekWheelView()
                    .frame(width: geo.size.width * 0.16, height: geo.size.width * 0.16)
                    .position(x: geo.size.width * 0.78, y: geo.size.height * 0.8)
                
                // 2. Frunk Lid (Rotates up perfectly from the windshield base)
                ZStack {
                    SleekFrunkLid()
                        .fill(carBodyColor)
                    SleekFrunkLid()
                        .stroke(Theme.primary, lineWidth: 1.5)
                        .shadow(color: Theme.primary, radius: isFrunkOpen ? 10 : 0)
                }
                .rotationEffect(.degrees(isFrunkOpen ? 45 : 0), anchor: UnitPoint(x: 0.35, y: 0.45))
                
                // 3. Trunk Lid (Rotates up perfectly from the rear window base)
                ZStack {
                    SleekTrunkLid()
                        .fill(carBodyColor)
                    SleekTrunkLid()
                        .stroke(Theme.primary, lineWidth: 1.5)
                        .shadow(color: Theme.primary, radius: isTrunkOpen ? 10 : 0)
                }
                .rotationEffect(.degrees(isTrunkOpen ? -45 : 0), anchor: UnitPoint(x: 0.85, y: 0.4))
                
                // Climate Control Airflow
                if isClimateOn {
                    Image(systemName: "wind")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(.cyan.opacity(0.9))
                        .symbolEffect(.variableColor.iterative.reversing, options: .repeating)
                        .position(x: geo.size.width * 0.6, y: geo.size.height * 0.15)
                        .shadow(color: .cyan, radius: 10, x: 0, y: 0)
                }
                
                // Front Headlight
                if isHeadlightsOn || isFlashing {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .blur(radius: 4)
                        .position(x: geo.size.width * 0.05, y: geo.size.height * 0.58)
                        .shadow(color: .white, radius: 15, x: -15, y: 0)
                }
                
                // Rear Taillight
                if isHeadlightsOn || isFlashing {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .blur(radius: 3)
                        .position(x: geo.size.width * 0.95, y: geo.size.height * 0.58)
                        .shadow(color: .red, radius: 15, x: 15, y: 0)
                }
                
                // Lock Icon inside car
                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                    .font(.system(size: 32))
                    .foregroundColor(isLocked ? .white : Theme.primary)
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.45)
                    .opacity(lockScale > 1.0 ? 1 : 0)
            }
        }
        .padding(.horizontal, 40)
        .frame(height: 160)
        .scaleEffect(lockScale)
        .onChange(of: isLocked) { _ in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) { lockScale = 1.15 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { lockScale = 1.0 }
            }
        }
    }
}

// MARK: - Custom Vector Car Shapes

struct SleekCarBody: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.8)) // Bottom front
        // Front bumper curve
        p.addQuadCurve(to: CGPoint(x: w * 0.05, y: h * 0.55), control: CGPoint(x: w * 0.02, y: h * 0.7))
        // Engine bay floor
        p.addLine(to: CGPoint(x: w * 0.35, y: h * 0.45))
        // Windshield curve
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.25), control: CGPoint(x: w * 0.42, y: h * 0.28))
        // Roof curve
        p.addQuadCurve(to: CGPoint(x: w * 0.7, y: h * 0.25), control: CGPoint(x: w * 0.6, y: h * 0.23))
        // Rear window curve
        p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.4), control: CGPoint(x: w * 0.78, y: h * 0.28))
        // Trunk bed floor
        p.addLine(to: CGPoint(x: w * 0.95, y: h * 0.55))
        // Rear bumper curve
        p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.8), control: CGPoint(x: w * 0.98, y: h * 0.7))
        // Bottom floor
        p.addLine(to: CGPoint(x: w * 0.15, y: h * 0.8))
        
        p.closeSubpath()
        return p
    }
}

struct SleekFrunkLid: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.05, y: h * 0.55))
        // Curve the hood upwards slightly
        p.addQuadCurve(to: CGPoint(x: w * 0.35, y: h * 0.45), control: CGPoint(x: w * 0.2, y: h * 0.47))
        // Thickness
        p.addLine(to: CGPoint(x: w * 0.35, y: h * 0.48))
        p.addQuadCurve(to: CGPoint(x: w * 0.07, y: h * 0.58), control: CGPoint(x: w * 0.2, y: h * 0.5))
        p.closeSubpath()
        return p
    }
}

struct SleekTrunkLid: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.85, y: h * 0.4))
        p.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.55), control: CGPoint(x: w * 0.92, y: h * 0.45))
        // Thickness
        p.addLine(to: CGPoint(x: w * 0.92, y: h * 0.58))
        p.addQuadCurve(to: CGPoint(x: w * 0.83, y: h * 0.43), control: CGPoint(x: w * 0.89, y: h * 0.47))
        p.closeSubpath()
        return p
    }
}

struct QuickControlButton: View {
    var icon: String
    var title: String
    var isActive: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isActive ? Theme.primary.opacity(0.2) : Theme.surfaceHighlight)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle()
                                .stroke(isActive ? Theme.primary.opacity(0.5) : Color.clear, lineWidth: 1)
                        )
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(isActive ? Theme.primary : .white)
                        .symbolEffect(.variableColor.iterative, options: .repeating, isActive: isActive)
                }
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SleekWheelView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            ZStack {
                // Outer Tire (Rubber)
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [Color(white: 0.15), Color(white: 0.05)]), center: .center, startRadius: w * 0.3, endRadius: w * 0.5)
                    )
                    .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 5)
                
                // Tire Tread/Edge
                Circle()
                    .stroke(Color.black, lineWidth: w * 0.04)
                
                // Inner Rim Edge
                Circle()
                    .stroke(LinearGradient(colors: [Color(white: 0.5), Color(white: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: w * 0.03)
                    .frame(width: w * 0.65)
                
                // Inner Rim Background (Brake Dust)
                Circle()
                    .fill(Color(white: 0.1))
                    .frame(width: w * 0.62)
                
                // Brake Caliper (Performance Red)
                Capsule()
                    .fill(Color.red)
                    .frame(width: w * 0.15, height: w * 0.35)
                    .offset(x: -w * 0.25)
                    .rotationEffect(.degrees(15))
                
                // Spokes (Metallic 5-Spoke Design)
                ForEach(0..<5) { i in
                    Capsule()
                        .fill(LinearGradient(colors: [Color(white: 0.7), Color(white: 0.4)], startPoint: .top, endPoint: .bottom))
                        .frame(width: w * 0.08, height: w * 0.65)
                        .rotationEffect(.degrees(Double(i) * (360.0 / 5.0)))
                }
                
                // Center Cap
                Circle()
                    .fill(LinearGradient(colors: [Color(white: 0.3), Color(white: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: w * 0.15)
                
                // Center Logo
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Theme.primary)
                    .frame(width: w * 0.06)
            }
            .position(x: w/2, y: w/2)
        }
    }
}

#Preview {
    DashboardView()
}

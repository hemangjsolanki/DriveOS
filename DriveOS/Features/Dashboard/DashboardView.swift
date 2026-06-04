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
                                isClimateOn: isClimateOn,
                                targetTemp: targetTemp
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
                            // Battery Card
                            GlassCard {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Image(systemName: "bolt.fill")
                                            .foregroundColor(Theme.accent)
                                        Text("Battery")
                                            .font(.caption.bold())
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    Spacer(minLength: 16)
                                    
                                    Text("78")
                                        .font(.system(size: 42, weight: .black, design: .rounded))
                                    + Text("%")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    Spacer(minLength: 8)
                                    
                                    Text("Est. 312 mi")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(maxHeight: .infinity)
                            }
                            
                            // Climate Card
                            GlassCard {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Image(systemName: "fanblades.fill")
                                            .foregroundColor(isClimateOn ? colorForTemp(targetTemp) : Theme.textSecondary)
                                            .symbolEffect(.variableColor.iterative, options: .repeating, isActive: isClimateOn)
                                        Text(isClimateOn ? "CLIMATE ON" : "CLIMATE OFF")
                                            .font(.system(.caption, design: .rounded).bold())
                                            .foregroundColor(isClimateOn ? colorForTemp(targetTemp) : Theme.textSecondary)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            triggerHaptic()
                                            withAnimation(.spring()) {
                                                isClimateOn.toggle()
                                            }
                                        }) {
                                            Image(systemName: "power.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(isClimateOn ? colorForTemp(targetTemp) : .gray.opacity(0.5))
                                                .shadow(color: isClimateOn ? colorForTemp(targetTemp) : .clear, radius: 5)
                                        }
                                    }
                                    
                                    Spacer(minLength: 16)
                                    
                                    HStack {
                                        Button(action: {
                                            triggerHaptic()
                                            withAnimation(.spring()) {
                                                if targetTemp > 60 { targetTemp -= 1 }
                                                isClimateOn = true
                                            }
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.title2.bold())
                                                .foregroundColor(.cyan)
                                                .frame(width: 40, height: 40)
                                                .background(Color.white.opacity(0.05))
                                                .clipShape(Circle())
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(alignment: .top, spacing: 0) {
                                            Text("\(targetTemp)")
                                                .font(.system(size: 38, weight: .black, design: .rounded))
                                                .contentTransition(.numericText())
                                                .id(targetTemp)
                                            Text("°")
                                                .font(.title2.bold())
                                        }
                                        .foregroundColor(colorForTemp(targetTemp))
                                        .shadow(color: colorForTemp(targetTemp).opacity(0.5), radius: 10, x: 0, y: 0)
                                        .fixedSize() // Prevents wrapping completely
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            triggerHaptic()
                                            withAnimation(.spring()) {
                                                if targetTemp < 85 { targetTemp += 1 }
                                                isClimateOn = true
                                            }
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.title2.bold())
                                                .foregroundColor(.orange)
                                                .frame(width: 40, height: 40)
                                                .background(Color.white.opacity(0.05))
                                                .clipShape(Circle())
                                        }
                                    }
                                    
                                    Spacer(minLength: 16)
                                    
                                    HStack {
                                        Spacer()
                                        Image(systemName: targetTemp < 68 ? "snowflake" : (targetTemp > 75 ? "flame.fill" : "aqi.medium"))
                                            .font(.caption2)
                                            .foregroundColor(colorForTemp(targetTemp))
                                            .symbolEffect(.pulse, options: .repeating, isActive: isClimateOn)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(maxHeight: .infinity)
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true) // Forces HStack to fit the tallest item perfectly
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
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let hornURL = docs.appendingPathComponent("horn.wav")
        
        // Generate a mathematically realistic car horn (D#4 + F#4 square wave)
        if !fileManager.fileExists(atPath: hornURL.path) {
            let sampleRate: Int32 = 44100
            let duration: Double = 0.5
            let numSamples = Int(Double(sampleRate) * duration)
            
            var data = Data()
            // WAV Header
            data.append(contentsOf: [UInt8]("RIFF".utf8))
            data.append(contentsOf: withUnsafeBytes(of: Int32(36 + numSamples * 2)) { Array($0) })
            data.append(contentsOf: [UInt8]("WAVE".utf8))
            data.append(contentsOf: [UInt8]("fmt ".utf8))
            data.append(contentsOf: withUnsafeBytes(of: Int32(16)) { Array($0) }) // Subchunk1Size
            data.append(contentsOf: withUnsafeBytes(of: Int16(1)) { Array($0) })  // AudioFormat (PCM)
            data.append(contentsOf: withUnsafeBytes(of: Int16(1)) { Array($0) })  // NumChannels (Mono)
            data.append(contentsOf: withUnsafeBytes(of: sampleRate) { Array($0) }) // SampleRate
            data.append(contentsOf: withUnsafeBytes(of: sampleRate * 2) { Array($0) }) // ByteRate
            data.append(contentsOf: withUnsafeBytes(of: Int16(2)) { Array($0) })  // BlockAlign
            data.append(contentsOf: withUnsafeBytes(of: Int16(16)) { Array($0) }) // BitsPerSample
            data.append(contentsOf: [UInt8]("data".utf8))
            data.append(contentsOf: withUnsafeBytes(of: Int32(numSamples * 2)) { Array($0) })
            
            // Audio Data (Dissonant car horn chord)
            let freq1 = 311.13 // D#4
            let freq2 = 369.99 // F#4
            for i in 0..<numSamples {
                let t = Double(i) / Double(sampleRate)
                let v1 = sin(2.0 * .pi * freq1 * t) > 0 ? 1.0 : -1.0
                let v2 = sin(2.0 * .pi * freq2 * t) > 0 ? 1.0 : -1.0
                let sample = Int16((v1 + v2) * 8191) // Mix and scale volume
                data.append(contentsOf: withUnsafeBytes(of: sample) { Array($0) })
            }
            try? data.write(to: hornURL)
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: hornURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Could not load horn sound: \(error)")
        }
    }
    
    // Dynamic Temperature Color Helper
    private func colorForTemp(_ temp: Int) -> Color {
        if temp < 68 { return .cyan }
        else if temp > 75 { return .orange }
        else { return .white }
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
    var targetTemp: Int = 72
    
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
                    CabinClimateAura(targetTemp: targetTemp)
                        .mask(SleekCarWindows())
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

struct SleekCarWindows: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        
        // Start at base of windshield
        p.move(to: CGPoint(x: w * 0.35, y: h * 0.45))
        // Windshield curve
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.25), control: CGPoint(x: w * 0.42, y: h * 0.28))
        // Roof curve
        p.addQuadCurve(to: CGPoint(x: w * 0.7, y: h * 0.25), control: CGPoint(x: w * 0.6, y: h * 0.23))
        // Rear window curve
        p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.4), control: CGPoint(x: w * 0.78, y: h * 0.28))
        // Bottom window sill (straight line back to windshield base)
        p.addLine(to: CGPoint(x: w * 0.35, y: h * 0.45))
        
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

// MARK: - Advanced Custom Animations

struct CabinClimateAura: View {
    var targetTemp: Int
    @State private var isAnimating = false
    
    var flowColor: Color {
        targetTemp < 68 ? Color.cyan : (targetTemp > 75 ? Color.orange : Color.white)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 1. Air Vent Core Glow (Front Dashboard Vents)
                Capsule()
                    .fill(flowColor.opacity(isAnimating ? 0.6 : 0.2))
                    .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.08)
                    .blur(radius: 12)
                    .position(x: geo.size.width * 0.45, y: geo.size.height * 0.4)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                
                // 2. Sweeping Airflow Waves (Flowing Front to Back)
                ForEach(0..<3) { i in
                    Capsule()
                        .fill(LinearGradient(colors: [flowColor.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing))
                        .frame(
                            width: geo.size.width * (isAnimating ? 0.3 : 0.05),
                            height: geo.size.height * (isAnimating ? 0.15 : 0.02)
                        )
                        .position(
                            x: geo.size.width * (isAnimating ? 0.75 : 0.45),
                            y: geo.size.height * (isAnimating ? 0.32 : 0.4)
                        )
                        .blur(radius: 5)
                        .opacity(isAnimating ? 0 : 1)
                        .animation(
                            .easeOut(duration: 2.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 0.8),
                            value: isAnimating
                        )
                }
                
                // 3. Flowing Micro-Particles (Drifting from vents to rear)
                ForEach(0..<8) { i in
                    Circle()
                        .fill(flowColor)
                        .frame(width: 3, height: 3)
                        .blur(radius: 1)
                        .position(
                            x: geo.size.width * (isAnimating ? Double.random(in: 0.6...0.85) : 0.45),
                            y: geo.size.height * (isAnimating ? Double.random(in: 0.28...0.4) : 0.4)
                        )
                        .opacity(isAnimating ? 0 : 1)
                        .scaleEffect(isAnimating ? 2.0 : 0.1)
                        .animation(
                            .easeOut(duration: Double.random(in: 1.5...3.0))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2)),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

#Preview {
    DashboardView()
}

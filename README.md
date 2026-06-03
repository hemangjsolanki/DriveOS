# DriveOS
A premium Tesla-inspired Electric Vehicle dashboard built entirely with SwiftUI, featuring real-time vehicle telemetry, battery analytics, charging insights, trip history, custom gauges, Live Activities, and Apple-style animations.

## 🌟 Advanced UI & Animations

### Real-Life Car Physics Animations
- **Custom Vector Shapes:** Replaced standard icons with a fully custom, mathematically drawn `SleekCarBody`, `SleekFrunkLid`, and `SleekTrunkLid` using pure SwiftUI `Path` and `Shape`.
- **Frunk & Trunk Animations:** Implemented real-life physics! When tapping the Frunk or Trunk, the lids physically rotate upwards exactly at their hinges (`-45` degrees for the Frunk, `45` degrees for the Trunk) using `rotationEffect(anchor:)` and `.spring()` animations to simulate the weight and motion of real car doors.

### "Hypercharging" Lock Screen Live Activity
- **Creative Animated Car Track:** The Lock Screen widget features a stunning glowing cyan/blue neon energy track (`LinearGradient` with intense shadow drops). 
- **Real-Time Offset:** A sleek white car icon physically rides on top of the glowing track. As the battery percentage ticks up, the car's X-offset mathematically updates (`max(0, progressWidth - 32)`) so the car visually "drives" towards a 100% full charge!
- **Tick-up Typography:** Utilizes iOS 17's `.contentTransition(.numericText())` to make the large battery percentage smoothly tick up like a real digital racing dashboard.
- **Pulse Effects:** Intelligent `.symbolEffect(.pulse)` on the thunderbolt icons gives the widget a breathing, living feel while charging.

### Dynamic Island
- Fully implemented iOS 16/17 Dynamic Island tracking for charging states. Includes Compact Leading, Compact Trailing, Minimal, and fully Expanded UI regions for a seamless system integration.

## 🔐 Intelligent Authentication System

### Smart Persistence & Routing
- **Welcome vs Welcome Back:** DriveOS uses `@AppStorage` to detect if you've launched the app before, intelligently swapping the greeting text to "Welcome Back".
- **Zero-Friction Login:** Persistent authentication states automatically detect an active session on the Splash Screen, completely skipping the Auth flow and routing you directly into your vehicle dashboard.

### Premium UX Input Fields
- **Smart Keyboards:** Email input fields use custom `UIKeyboardType.emailAddress` so the `@` and `.` keys are immediately available without switching keyboard layouts.
- **Themed Password Visibility:** `CustomSecureField` includes an intuitive, theme-colored eye toggle (`eye.fill` / `eye.slash.fill`). Tapping it securely switches the underlying view between `SecureField` and `TextField` so users can verify their password.
- **IQKeyboardManager Integration:** Integrated `IQKeyboardManagerSwift` via SPM. The keyboard is globally forced into a sleek `.dark` theme. The toolbar and "Done" buttons are fully customized to match DriveOS's signature Orange Accent Color.

### Form Validation Rules
- **Login:** Immediate error handling for empty fields and invalid email regex formats.
- **Register:** Validates Name length (3+ chars), Email formats, Password length (8+ chars), and performs strict matching against the Confirm Password field.
- **Forgot Password:** Validates emails and presents a native iOS Alert upon successful reset request.

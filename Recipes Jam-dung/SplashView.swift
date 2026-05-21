import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.75
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Jamaican green background
            Color(red: 0.0, green: 0.55, blue: 0.18)
                .ignoresSafeArea()

            // Gold diagonal accent stripe
            GeometryReader { geo in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geo.size.height * 0.55))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.38))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.48))
                    path.addLine(to: CGPoint(x: 0, y: geo.size.height * 0.65))
                    path.closeSubpath()
                }
                .fill(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.25))
            }
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // App icon from assets
                if let icon = UIImage(named: "AppIcon") {
                    Image(uiImage: icon)
                        .resizable()
                        .frame(width: 110, height: 110)
                        .cornerRadius(26)
                        .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 8)
                } else {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }

                VStack(spacing: 6) {
                    Text("Jam-dung")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                    Text("Authentic Jamaican Recipes")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(0.5)
                }

                Text("🇯🇲")
                    .font(.system(size: 32))
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.65, dampingFraction: 0.7)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

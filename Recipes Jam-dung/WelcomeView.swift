import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                heroHeader
                featureList
                Spacer()
                getStartedButton
            }
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack {
            Color(red: 0.0, green: 0.55, blue: 0.18).ignoresSafeArea(edges: .top)

            // Subtle gold diagonal stripe
            GeometryReader { geo in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geo.size.height * 0.6))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.42))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.54))
                    path.addLine(to: CGPoint(x: 0, y: geo.size.height * 0.72))
                    path.closeSubpath()
                }
                .fill(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.2))
            }

            VStack(spacing: 18) {
                appIcon
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)

                VStack(spacing: 6) {
                    Text("Welcome to")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.85))
                        .opacity(appeared ? 1 : 0)

                    Text("Jam-dung 🇯🇲")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)

                    Text("Authentic Jamaican Recipes")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.75))
                        .tracking(0.3)
                        .opacity(appeared ? 1 : 0)
                }
            }
            .padding(.vertical, 44)
        }
        .frame(height: 300)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) {
                appeared = true
            }
        }
    }

    @ViewBuilder
    private var appIcon: some View {
        if let icon = UIImage(named: "AppIcon") {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 96, height: 96)
                .cornerRadius(22)
                .shadow(color: .black.opacity(0.3), radius: 14, x: 0, y: 6)
        } else {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 90))
                .foregroundColor(.white)
        }
    }

    // MARK: - Feature List

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 0) {
            FeatureRow(
                icon: "fork.knife",
                color: Color(red: 0.0, green: 0.55, blue: 0.18),
                title: "27 Authentic Recipes",
                subtitle: "Discover traditional dishes across breakfast, lunch & dinner"
            )
            Divider().padding(.leading, 70)
            FeatureRow(
                icon: "heart.fill",
                color: .red,
                title: "Save Your Favourites",
                subtitle: "Bookmark go-to meals and access them any time, even offline"
            )
            Divider().padding(.leading, 70)
            FeatureRow(
                icon: "list.number",
                color: .indigo,
                title: "Step-by-Step Cooking",
                subtitle: "Clear ingredients and numbered instructions for every recipe"
            )
        }
        .padding(.top, 8)
    }

    // MARK: - Get Started Button

    private var getStartedButton: some View {
        Button(action: onGetStarted) {
            HStack(spacing: 8) {
                if let icon = UIImage(named: "AppIcon") {
                    Image(uiImage: icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(6)
                }
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(red: 0.0, green: 0.55, blue: 0.18))
            .cornerRadius(16)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 46, height: 46)
                .background(color)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
}

#Preview {
    WelcomeView(onGetStarted: {})
}

import SwiftUI

@main
struct Recipes_Jam_dungApp: App {
    @StateObject private var favoritesStore = FavoritesStore()

    init() {
        // Larger disk cache so URLSession caches image responses between launches
        URLCache.shared = URLCache(
            memoryCapacity: 50 * 1024 * 1024,   // 50 MB memory
            diskCapacity: 250 * 1024 * 1024,     // 250 MB disk
            directory: nil
        )
    }
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @State private var showSplash = true
    @State private var showWelcome = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main app loads in background so data is ready when screens dismiss
                ContentView()
                    .environmentObject(favoritesStore)

                if showWelcome {
                    WelcomeView {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            showWelcome = false
                        }
                        hasSeenWelcome = true
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
                }

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(3)
                }
            }
            .task {
                // Show splash for 2.2 seconds
                try? await Task.sleep(nanoseconds: 2_200_000_000)
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
                // Wait for splash fade to finish, then show welcome if first launch
                try? await Task.sleep(nanoseconds: 600_000_000)
                if !hasSeenWelcome {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
                        showWelcome = true
                    }
                }
            }
        }
    }
}

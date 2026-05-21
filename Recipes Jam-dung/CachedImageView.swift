import SwiftUI

// MARK: - In-memory image cache (NSCache is thread-safe)

final class ImageCacheStore {
    static let shared = ImageCacheStore()
    private let cache: NSCache<NSURL, UIImage> = {
        let c = NSCache<NSURL, UIImage>()
        c.countLimit = 200
        c.totalCostLimit = 80 * 1024 * 1024 // 80 MB
        return c
    }()

    func get(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        let cost = image.jpegData(compressionQuality: 0.8)?.count ?? 0
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}

// MARK: - Drop-in AsyncImage replacement with caching

struct CachedImageView: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    @State private var uiImage: UIImage?
    @State private var failed = false

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if failed {
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.secondary.opacity(0.5))
                    )
            } else {
                SkeletonView()
            }
        }
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else { failed = true; return }

        // Serve from memory cache immediately
        if let cached = ImageCacheStore.shared.get(url) {
            uiImage = cached
            return
        }

        // Download with URLSession (uses URLCache on disk automatically)
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let img = UIImage(data: data) else {
            failed = true
            return
        }

        ImageCacheStore.shared.set(img, for: url)
        uiImage = img
    }
}

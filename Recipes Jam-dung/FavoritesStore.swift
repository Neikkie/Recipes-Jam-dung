import Foundation
import Combine

class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [Meal] = []

    private let storageKey = "savedFavorites"

    init() { load() }

    func toggle(_ meal: Meal) {
        if isFavorite(meal) {
            favorites.removeAll { $0.idMeal == meal.idMeal }
        } else {
            favorites.insert(meal, at: 0)
        }
        save()
    }

    func isFavorite(_ meal: Meal) -> Bool {
        favorites.contains { $0.idMeal == meal.idMeal }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Meal].self, from: data) else { return }
        favorites = saved
    }
}

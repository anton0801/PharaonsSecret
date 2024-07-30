import Foundation
import Combine

let itemCounts = [
    1: 3,
    2: 5,
    3: 7,
    4: 9,
    5: 10,
    6: 11,
    7: 12,
    8: 13,
    9: 14,
    10: 16,
    11: 16,
    12: 17,
    13: 18,
    14: 19,
    15: 20,
    16: 21,
    17: 22,
    18: 23,
    19: 24,
    20: 25
]

class LevelsViewModel: ObservableObject {
    @Published var levels: [Level]
    
    private let levelsKey = "levels"
    
    init() {
        self.levels = []
        loadLevels()
    }
    
    private func loadLevels() {
        if let data = UserDefaults.standard.data(forKey: levelsKey),
           let decodedLevels = try? JSONDecoder().decode([Level].self, from: data) {
            self.levels = decodedLevels
        } else {
            // Если данных нет, создаем уровни по умолчанию
            self.levels = (1...20).map { Level(id: $0, isUnlocked: $0 == 1, itemsCount: itemCounts[$0]!) }
        }
    }
    
    // Сохраняем уровни в UserDefaults
    private func saveLevels() {
        if let data = try? JSONEncoder().encode(levels) {
            UserDefaults.standard.set(data, forKey: levelsKey)
        }
    }
    
    // Разблокировка уровня
    func unlockLevel(_ id: Int) {
        if let index = levels.firstIndex(where: { $0.id == id }) {
            levels[index].isUnlocked = true
            saveLevels()
        }
    }
    
    // Проверка, доступен ли уровень к прохождению
    func isLevelUnlocked(_ id: Int) -> Bool {
        if let index = levels.firstIndex(where: { $0.id == id }) {
            return levels[index].isUnlocked
        }
        return false
    }
}

struct Level: Identifiable, Codable {
    let id: Int
    var isUnlocked: Bool
    let itemsCount: Int
}

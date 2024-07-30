import SwiftUI
import SpriteKit

struct SceneViewGame: View {
    
    @Environment(\.presentationMode) var prem
    var level: Level
    @State var levelForUse: Level!
    @State var scene: GameScene!
    @EnvironmentObject var lvlVm: LevelsViewModel
    @State var active: String = "game"
    
    var body: some View {
        ZStack {
            if let s = scene {
                SpriteView(scene: s)
                    .ignoresSafeArea()
            }
            
            switch (active) {
            case "lose":
                GameOverView()
            case "win":
                SecretWinGameView()
            default:
                EmptyView()
            }
        }
        .onAppear {
            levelForUse = level
            scene = GameScene(level: levelForUse)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("home_action"))) { _ in
            prem.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SORTED_ITEMS_FOUND"))) { _ in
            lvlVm.unlockLevel(level.id + 1)
            switchCurrentWin("win")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SORTED_ITEMS_NOT_FOUND"))) { _ in
            switchCurrentWin("lose")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restart_game"))) { _ in
            scene = scene.restartGame()
            switchCurrentWin("game")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("next_level"))) { notif in
            let nextLeve = lvlVm.levels.filter { $0.id == levelForUse.id + 1 }
            if nextLeve.count > 0 {
                levelForUse = nextLeve[0]
                self.scene = self.scene.restartGameWithLevel(level: levelForUse)
                switchCurrentWin("game")
            }
        }
    }
    
    private func switchCurrentWin(_ nextView: String) {
        withAnimation(.linear(duration: 0.5)) {
            self.active = nextView
        }
    }
}

#Preview {
    SceneViewGame(level: Level(id: 1, isUnlocked: true, itemsCount: 3))
        .environmentObject(LevelsViewModel())
}

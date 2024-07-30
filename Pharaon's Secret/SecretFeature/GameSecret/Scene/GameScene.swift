import SwiftUI
import SpriteKit

class GameScene: SKScene {
    
    var level: Level
    
    private var gameItems: [String] = []
    
    private var gameFieldItemPostions: [String: CGPoint] = [:]
    private var orderLabels: [SKNode] = []
    private var orderOfCards: [String] = []
    var cardNodes: [SKSpriteNode] = []
    private var cardOrderLabels: [SKLabelNode] = []
    private var cardsInGame: [String] = []
    private var errorNodes: [SKNode] = []
    
    func restartGameWithLevel(level: Level) -> GameScene {
        let new = GameScene(level: level)
        view?.presentScene(new)
        return new
    }
    
    func restartGame() -> GameScene {
        let new = GameScene(level: level)
        view?.presentScene(new)
        return new
    }
    
    private var cardsSorted = false
    
    private var winGame = false {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("SORTED_ITEMS_FOUND"), object: nil)
            isPaused = true
        }
    }
    
    private var loseGame = false {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("SORTED_ITEMS_NOT_FOUND"), object: nil)
            isPaused = true
        }
    }
    
    private var errors = 0 {
        didSet {
            setUpErrors()
            if errors == 3 {
                loseGame = true
            }
        }
    }
    
    init(level: Level) {
        self.level = level
        super.init(size: CGSize(width: 750, height: 1335))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpGameItemsList() {
        for i in 1...25 {
            gameItems.append("game_item_\(i)")
        }
    }
    
    override func didMove(to view: SKView) {
        setUpGameItemsList()
        
        let backgrou = SKSpriteNode(imageNamed: "game_view_back")
        backgrou.size = size
        backgrou.zPosition = -1
        backgrou.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgrou)
        let backgrou2 = SKSpriteNode(color: .black.withAlphaComponent(0.4), size: size)
        backgrou2.size = size
        backgrou2.zPosition = 0
        backgrou2.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgrou2)
        
        let gameField = SKSpriteNode(imageNamed: "game_field")
        gameField.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameField.size = CGSize(width: size.width - 100, height: 600)
        addChild(gameField)
        
        let pharaon = SKSpriteNode(imageNamed: "pharaon")
        pharaon.position = CGPoint(x: size.width / 2, y: 70)
        addChild(pharaon)
        
        if level.id == 1 {
            createFirstLevelUI()
        } else {
            createBasicGameUI()
        }
        
        positionateItemsInGameField()
        
    }
    
    private func createBasicGameUI() {
        let levelBack = SKSpriteNode(imageNamed: "level_placeholder")
        levelBack.position = CGPoint(x: size.width / 2, y: size.height - 150)
        levelBack.size = CGSize(width: 150, height: 150)
        addChild(levelBack)
        
        let levelLabel = SKLabelNode(text: "\(level.id)")
        levelLabel.fontName = "InknutAntiqua-Bold"
        levelLabel.fontSize = 82
        levelLabel.fontColor = .white
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 170)
        addChild(levelLabel)
        
        setUpErrors()
        
        let homeBtn = SKSpriteNode(imageNamed: "home")
        homeBtn.position = CGPoint(x: size.width - 100, y: size.height - 100)
        homeBtn.size = CGSize(width: 140, height: 120)
        homeBtn.name = "home"
        addChild(homeBtn)
    }
    
    private func setUpErrors() {
        if level.id > 1 {
            for errorNode in errorNodes {
                errorNode.removeFromParent()
            }
            errorNodes = []
            
            for i in 1...3 {
                var node: SKSpriteNode
                if i <= errors {
                    node = .init(imageNamed: "error_active")
                } else {
                    node = .init(imageNamed: "error_inactive")
                }
                node.size = CGSize(width: 100, height: 95)
                let startXPoint = CGFloat(i) * (node.size.width + 70) + 35
                node.position = CGPoint(x: startXPoint, y: size.height - 300)
                addChild(node)
                let action = SKAction.fadeIn(withDuration: 0.5)
                node.run(action)
                errorNodes.append(node)
            }
        }
    }
    
    private func createFirstLevelUI() {
        let tutorLabel1 = SKLabelNode(text: "THE GAME WILL SHOW ITEMS")
        tutorLabel1.fontName = "InknutAntiqua-Bold"
        tutorLabel1.fontSize = 32
        tutorLabel1.fontColor = .white
        tutorLabel1.position = CGPoint(x: size.width / 2, y: size.height - 150)
        addChild(tutorLabel1)
        
        let tutorLabel2 = SKLabelNode(text: "IN A CERTAIN ORDER,")
        tutorLabel2.fontName = "InknutAntiqua-Bold"
        tutorLabel2.fontSize = 32
        tutorLabel2.fontColor = .white
        tutorLabel2.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(tutorLabel2)
        
        let tutorLabel3 = SKLabelNode(text: "YOUR GOAL REPEAT THE")
        tutorLabel3.fontName = "InknutAntiqua-Bold"
        tutorLabel3.fontSize = 32
        tutorLabel3.fontColor = .white
        tutorLabel3.position = CGPoint(x: size.width / 2, y: size.height - 250)
        addChild(tutorLabel3)
        
        let tutorLabel4 = SKLabelNode(text: "ALGORITHM")
        tutorLabel4.fontName = "InknutAntiqua-Bold"
        tutorLabel4.fontSize = 32
        tutorLabel4.fontColor = .white
        tutorLabel4.position = CGPoint(x: size.width / 2, y: size.height - 300)
        addChild(tutorLabel4)
    }
    
    private func positionateItemsInGameField() {
        let listItems = gameItems.shuffled()
        var gameItemsForLevel = [String]()
        for i in 0..<level.itemsCount {
            gameItemsForLevel.append(listItems[i])
        }
        cardsInGame = gameItemsForLevel
        
        cardNodes = gameItemsForLevel.map { createCardNode(for: $0) }
        positionCardNodes()
        showNeededOrder()
    }
    
    private func createCardNode(for card: String) -> SKSpriteNode {
        let cardTexture = SKTexture(imageNamed: card)
        let cardNode = SKSpriteNode(texture: cardTexture)
        cardNode.name = card
        cardNode.size = CGSize(width: 100, height: 92)
        return cardNode
    }
    
    private func positionCardNodes() {
        let totalCards = cardNodes.count
        let maxColumns = 5
        
        let cardWidth: CGFloat = 100
        let cardHeight: CGFloat = 92
        let spacing: CGFloat = 12
        
        if totalCards <= 10 {
            positionCardsRandomly()
            return
        }
        
        let rows = (totalCards + maxColumns - 1) / maxColumns
        let totalWidth = CGFloat(maxColumns) * (cardWidth + spacing) - spacing
        let totalHeight = CGFloat(rows) * (cardHeight + spacing) - spacing
        
        let startX = (size.width - totalWidth) / 2 + cardWidth / 2
        let startY = (size.height + totalHeight) / 2 - cardHeight / 2
        
        for (index, cardNode) in cardNodes.enumerated() {
            let row = index / maxColumns
            let column = index % maxColumns
            
            let xPosition = startX + CGFloat(column) * (cardWidth + spacing)
            let yPosition = startY - CGFloat(row) * (cardHeight + spacing)
            
            cardNode.position = CGPoint(x: xPosition, y: yPosition)
            addChild(cardNode)
        }
    }

    private func positionCardsRandomly() {
        for cardNode in cardNodes {
            cardNode.position = positionInGameField()
            addChild(cardNode)
        }
    }
    
    private func positionInGameField() -> CGPoint {
        let minX: CGFloat = 90
        let maxX = size.width - 90
        let minY = size.height / 2 - 250
        let maxY = size.height - 400
        
        let point = getRandomPosition(minX, maxX, minY, maxY)
        let obj = atPoint(point)
        if obj.name?.contains("game_item") == true {
            return positionInGameField()
        }
        return point
    }
    
    private func getRandomPosition(_ minX: CGFloat, _ maxX: CGFloat, _ minY: CGFloat, _ maxY: CGFloat) -> CGPoint {
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        let point = CGPoint(x: randomX, y: randomY)
        return point
    }
    
    private func showNeededOrder() {
        for (index, card) in cardNodes.enumerated() {
            let cardPosition = card.position
            let cardNeedorderLabel: SKLabelNode = .init(text: "\(index + 1)")
            setLabelBaseData(cardNeedorderLabel, size: 72)
            cardNeedorderLabel.fontColor = .red
            cardNeedorderLabel.position = cardPosition
            cardNeedorderLabel.position.y -= 18
            addChild(cardNeedorderLabel)
            cardOrderLabels.append(cardNeedorderLabel)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            for label in self.cardOrderLabels {
                label.removeFromParent()
            }
            self.confuseCards()
        }
    }
    
    private func confuseCards() {
        var pointsOfCards = cardNodes.map { $0.position }
        for card in cardNodes {
            let actionMoveToCenterPoint = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.5)
            card.run(actionMoveToCenterPoint)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            for card in self.cardNodes {
                let cardPosition = pointsOfCards.randomElement() ?? pointsOfCards[0]
                let actionMoveToCenterPoint = SKAction.move(to: cardPosition, duration: 0.5)
                card.run(actionMoveToCenterPoint)
                if let pointIndex = pointsOfCards.firstIndex(of: cardPosition) {
                    pointsOfCards.remove(at: pointIndex)
                }
            }
            self.cardsSorted = true
        }
    }
    
    private func setLabelBaseData(_ labelNode: SKLabelNode, size: CGFloat = 42) {
        labelNode.fontName = "InknutAntiqua-Bold"
        labelNode.fontSize = size
        labelNode.fontColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "home" {
                NotificationCenter.default.post(name: Notification.Name("home_action"), object: nil)
            }
            
            if cardsSorted {
                if node.name?.contains("game_item") == true {
                    orderOfCards.append(node.name!)
                    addOrderLabel(node)
                    if orderOfCards.count == cardsInGame.count {
                        checkGameWin()
                    }
                }
            }
        }
    }
    
    private func checkGameWin() {
        var gameWin = true
        for (index, orderOfCard) in orderOfCards.enumerated() {
            if cardsInGame[index] != orderOfCard {
                gameWin = false
                break
            }
        }
        if gameWin {
            winGame = true
        } else {
            errors += 1
            for n in orderLabels {
                n.removeFromParent()
            }
            orderLabels = []
            orderOfCards = []
        }
    }
    
    private func addOrderLabel(_ node: SKNode) {
        let itemPosition = node.position
        let gameItemOrderLabel: SKLabelNode = .init(text: "\(orderOfCards.count)")
        setLabelBaseData(gameItemOrderLabel, size: 72)
        gameItemOrderLabel.fontColor = .white
        gameItemOrderLabel.position = itemPosition
        gameItemOrderLabel.position.y -= 18
        addChild(gameItemOrderLabel)
        orderLabels.append(gameItemOrderLabel)
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GameScene(level: Level(id: 2, isUnlocked: true, itemsCount: 3)))
            .ignoresSafeArea()
    }
}

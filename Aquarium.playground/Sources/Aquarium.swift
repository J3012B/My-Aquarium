import UIKit
import Foundation
import XCPlayground
import SpriteKit
import AVFoundation

public class Aquarium: SKScene {
    
    /*public var waterAmount = 100 {
        didSet {
            let maxHeight: CGFloat = 400.0
            var newHeight = CGFloat(waterAmount)
            
            if waterAmount > 100 {
                newHeight = CGFloat(100)
            } else if waterAmount < 0 {
                newHeight = CGFloat(0)
            }
            newHeight = maxHeight * newHeight * CGFloat(0.01)
            
            water.yScale = newHeight / water.frame.height
            water.position.y = ground.frame.maxY + water.frame.height * 0.5 - 40.0
        }
    }*/
    public var showNames: Bool = false {
        didSet {
            for fish in fishes {
                fish.label.isHidden = !showNames
            }
        }
    }
    public var lightOn: Bool = true {
        didSet {
            self.lightLayer.isHidden = lightOn
        }
    }
    
    public var water: SKSpriteNode!
    public var ground: SKSpriteNode!
    
    private var lightLayer = SKSpriteNode()
    private var endCard: SKSpriteNode?
    private var isParty = false
    private var isCrabRunning = false
    private var onElectricity = false
    
    private var bubbles = [Bubble]()
    private var fishes = [Fish]()
    private var confettis = [SKSpriteNode]()
    
    public var audioPlayer: AVAudioPlayer!
    public let electricityPlayer = getAudioPlayer(name: "Electric.mp3", vol: 0.5, count: 0)
    public let poseidonPlayer = getAudioPlayer(name: "Poseidon0.mp3", vol: 0.5, count: 0)
    public let poseidon2Player = getAudioPlayer(name: "Poseidon1.mp3", vol: 0.5, count: 0)
    
    private var currentTouch: CGPoint! {
        didSet {
            if currentTouch != nil && oldValue == nil {
                makeBubbles()
            }
        }
    }
    
    
    public init(fishes: [String : Int]) {
        super.init(size: CGSize())
        
        for fish in fishes {
            self.fishes.append(Fish(name: fish.key, type: fish.value))
        }
        
        addSound(songName: "UnderwaterSound.mp3", vol: 0.2)
    }
    

    override public func didMove(to view: SKView) {
        addElements()
        if isParty {
            addEndCard()
        }
    }
    
    // Party
    
    public func party() {
        isParty = true
        // Confetti
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(generateConfetti), userInfo: nil, repeats: true)
        // Under The Sea
        addSound(songName: "UnderTheSea.mp3", vol: 0.4)
    }
    @objc private func generateConfetti() {
        let colors = ["FF0D0D", "004BA1", "0AF019", "FACD05", "FC7D0D", "E505FA"]
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
        let confetti = SKSpriteNode(texture: nil, color: hexStringToUIColor(hex: color), size: CGSize(width: 10.0, height: 10.0))
        confetti.position = CGPoint(x: water.frame.width * randomFloat(), y: water.frame.maxY + 5.0)
        confetti.zPosition = ground.zPosition - 1
        confetti.zRotation = 2 * CGFloat(Double.pi) * randomFloat()
        
        confettis.append(confetti)
        addChild(confetti)
    }
    
    private func addEndCard() {
        let endCardTex = SKTexture(imageNamed: "EndCard")
        endCardTex.filteringMode = .nearest
        let endCardSiz = endCardTex.size().scaledSize(scale: 2.0)
        endCard = SKSpriteNode(texture: endCardTex, size: endCardSiz)
        endCard!.position = CGPoint(x: water.frame.width * 0.5, y: -5.0)
        endCard!.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        endCard!.zPosition = 200
        let rotation = CGFloat(Double.pi * 0.1)
        let left = SKAction.rotate(byAngle: -rotation, duration: 1.0)
        let right = SKAction.rotate(byAngle: rotation, duration: 1.0)
        endCard!.run(SKAction.repeatForever(SKAction.sequence([left, right, right, left])))
        addChild(endCard!)
    }
    // Update Methods
    
    public override func update(_ currentTime: TimeInterval) {
        updateBubbles()
        updateFishes()
        updateConfettis()
        updateEndCard()
    }
    private func updateBubbles() {
        var del = (index: 0, should: false)
        
        for i in 0..<bubbles.count {
            let bubble = bubbles[i]
            if bubble.position.y >= water.frame.maxY {
                bubble.removeFromParent()
                del = (i, true)
            } else {
                bubble.update()
            }
        }
        
        if del.should { bubbles.remove(at: del.index) }
    }
    private func updateFishes() {
        for i in 0..<fishes.count {
            let fish = fishes[i]
            
            if fish.frame.minX <= water.frame.minX || fish.frame.maxX >= water.frame.maxX {
                fish.velocity.x *= -1
                fish.flip()
            } else if fish.frame.minY <= water.frame.minY || fish.frame.maxY >= water.frame.maxY {
                fish.velocity.y *= -1
            }
            
            fish.update()
            keep(node: fish)
        }
    }
    private func updateConfettis() {
        var del = (index: 0, should: false)
        
        for i in 0..<confettis.count {
            let confetti = confettis[i]
            if confetti.position.y < -5.0 {
                confetti.removeFromParent()
                del = (i, true)
            } else {
                confetti.position.y -= 1.0
            }
        }
        
        if del.should { confettis.remove(at: del.index) }
    }
    private func updateEndCard() {
        if endCard != nil {
            if endCard!.frame.minY > water.frame.height + endCard!.frame.height {
                endCard!.removeFromParent()
            } else {
                endCard!.position.y += 0.8
            }
        }
    }
    private func keep(node: SKSpriteNode) {
        if node.frame.minX <= water.frame.minX {
            node.position.x = water.frame.minX + node.frame.width * 0.5
        } else if node.frame.maxX >= water.frame.maxX {
            node.position.x = water.frame.maxX - node.frame.width * 0.5
        } else if node.frame.minY <= water.frame.minY {
            node.position.y = water.frame.minY + node.frame.height * 0.5
        } else if node.frame.maxY >= frame.height {
            node.position.y = frame.height - node.frame.height * 0.5
        }
    }
    
    // Bubbles
    
    private func generateBubbles() {
        let xPos = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let spawn = Int(arc4random_uniform(4)) // 0,1,2,3
        
        if spawn != 0 {
            let bubble = getBubble(position: CGPoint(x: frame.width * xPos, y: ground.position.y))
            
            bubbles.append(bubble)
            addChild(bubble)
        }
    }
    private func getBubble(position: CGPoint) -> Bubble {
        let bubble = Bubble()
        bubble.zPosition = 7
        bubble.position = position
        
        return bubble
    }
    @objc private func makeBubbles() {
        if currentTouch != nil {
            let bubble = getBubble(position: currentTouch)
            bubbles.append(bubble)
            addChild(bubble)
            
            _ = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(makeBubbles), userInfo: nil, repeats: false)
        }
    }
    
    // Poseidon
    
    private func poseidonGetsAngry() {
        // Electricity On
        onElectricity = true
        // Sound
        electricityPlayer?.currentTime = 0.0
        electricityPlayer?.stop()
        electricityPlayer?.play()
        var laughPlayer = AVAudioPlayer()
        if arc4random_uniform(1) == 0 { laughPlayer = poseidonPlayer! } else { laughPlayer = poseidon2Player! }
        laughPlayer.pause()
        laughPlayer.currentTime = 0.0
        laughPlayer.play()
        // Scream
        print("- Ouchhh!\n- I am Poseidon, EARTH SHAKER, RULER OF THE BOUNDLESS SEA, CREATOR OF STORMS, SWALLOWER OF SHIPS")
        // Fishes
        for fish in fishes { fish.feelElectricity() }
        // Water
        let wait = SKAction.wait(forDuration: 0.2)
        let blue = SKAction.run { self.water.color = hexStringToUIColor(hex: "31A2F2") }
        let white = SKAction.run { self.water.color = UIColor.white }
        let shock = SKAction.sequence([white, wait, blue, wait])
        
        water.run(SKAction.repeat(shock, count: 5), completion: {
            self.onElectricity = false
        })
    }
    
    // Vase
    
    private func vaseToched() {
        let crabTextures = [SKTexture(imageNamed: "Crab0"), SKTexture(imageNamed: "Crab1")]
        for tex in crabTextures { tex.filteringMode = .nearest }
        let tex = crabTextures[0]
        let siz = tex.size().scaledSize(scale: 2.0)
        let crab = SKSpriteNode(texture: tex, size: siz)
        crab.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        crab.position = CGPoint(x: -50.0, y: 17.0)
        crab.zPosition = ground.zPosition + 4.0
        crab.xScale = -1.0
        let run = SKAction.repeatForever(SKAction.animate(with: crabTextures, timePerFrame: 0.08))
        let move = SKAction.moveTo(x: frame.width + 10.0, duration: 4.0)
        crab.run(move, completion: { crab.removeFromParent(); self.isCrabRunning = false })
        crab.run(run)
        isCrabRunning = true
        
        addChild(crab)
    }
    
    // Touches
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if let sprite = node as? SKSpriteNode {
                if sprite.name == "Neptun" && onElectricity == false {
                    poseidonGetsAngry()
                } else if sprite.name == "Vase" && isCrabRunning == false {
                    vaseToched()
                }
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if let fish = node as? Fish {
                fish.velocity = CGPoint(x: 0.0, y: 0.0)
                fish.position = location
                fish.timer.invalidate()
                
                keep(node: fish)
            } else {
                currentTouch = location
            }
            
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            print("Cancelled")
            
            if let fish = nodeTouched as? Fish {
                fish.think()
            } else {
                currentTouch = nil
            }
            
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if let fish = nodeTouched as? Fish {
                fish.think()
            } else {
                currentTouch = nil
            }
            
        }
    }
    
    // Sound
    
    func addSound(songName: String, vol: Float) {
        audioPlayer = setupAudioPlayerWithFile(file: songName, type: nil)
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume = vol
        audioPlayer.prepareToPlay()
    }
    
    // Create Methods
    
    func addElements() {
        // Self
        self.backgroundColor = hexStringToUIColor(hex: "96D0FA")
        
        // GroundLayers
        let groundLayers = SKSpriteNode(imageNamed: "GroundLayers")
        groundLayers.setScale(2.0)
        groundLayers.texture?.filteringMode = .nearest
        groundLayers.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        groundLayers.position = CGPoint(x: 0.0, y: 130.0)
        groundLayers.zPosition = 5
        
        addChild(groundLayers)
        
        // Ground
        ground = SKSpriteNode(imageNamed: "Ground")
        //ground = SKSpriteNode(color: hexStringToUIColor(hex: "FCDB6D"), size: CGSize(width: frame.width, height: 40.0))
        ground.setScale(2.0)
        ground.texture?.filteringMode = .nearest
        ground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        ground.position = CGPoint(x: -20.0, y: 60.0)
        ground.zPosition = 10
        
        addChild(ground)
        
        // Ground Body
        let groundBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.frame.width, height: ground.frame.height - 80.0), center: CGPoint(x: 0.0, y: -60.0))
        groundBody.affectedByGravity = false
        groundBody.allowsRotation = false
        groundBody.isDynamic = false

        ground.physicsBody = groundBody
        
        // Water
        water = SKSpriteNode(color: hexStringToUIColor(hex: "31A2F2"), size: CGSize(width: frame.width, height: self.frame.height - ground.frame.maxY + 40.0))
        water.position.x = frame.width * 0.5
        water.zPosition = 0
        //waterAmount = 100
        water.position.y = ground.frame.maxY + water.frame.height * 0.5 - 40.0
        
        addChild(water)
        
        // Bubbles
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in self.generateBubbles() })
        
        // Fish
        for i in 0..<fishes.count {
            let fish = fishes[i]
            let xPos = fish.frame.width * 0.5 + randomFloat() * (frame.width - fish.frame.width)
            let yPos = water.frame.minY + fish.frame.height * 0.5 + randomFloat() * (water.frame.height - fish.frame.height)
            
            fish.position = CGPoint(x: xPos, y: yPos)
            fish.zPosition = ground.zPosition + 50
            
            addChild(fish)
        }
        /*// Sea Weed
        let positions: [CGFloat] = [75.0, 130.0]
        
        for i in 0..<positions.count {
            let pos = positions[i]
            let seaweed = SKSpriteNode()
            seaweed.texture?.filteringMode = .nearest
            seaweed.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            seaweed.position = CGPoint(x: pos, y: ground.position.y - 30.0)
            seaweed.setScale(2.0)
            seaweed.zPosition = ground.zPosition - 1
            seaweed.run(SKAction.animate(with: [SKTexture(imageNamed: "seaweed0")], timePerFrame: 100.0))
            
            addChild(seaweed)
        }*/
        
        // Light
        lightLayer = SKSpriteNode(texture: nil, color: UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.9), size: frame.size)
        lightLayer.isHidden = lightOn
        lightLayer.position = position
        lightLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        lightLayer.isUserInteractionEnabled = true
        lightLayer.zPosition = 1000
        
        addChild(lightLayer)
        
        // Anchor
        let anchorTex = SKTexture(imageNamed: "Anchor")
        anchorTex.filteringMode = .nearest
        let siz = anchorTex.size().scaledSize(scale: 2.0)
        let anchor = SKSpriteNode(texture: anchorTex, color: UIColor.clear, size: siz)
        anchor.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        anchor.position = CGPoint(x: 200.0, y: ground.frame.maxY - 90.0)
        anchor.zPosition = ground.zPosition - 1.0
        
        addChild(anchor)
        
        
        // Stuff
        
        let vase = Stuff(from: "Vase", xPos: 150.0, zPos: ground.zPosition + 2.0, physics: true)
        vase.name = "Vase"
        let neptun = Stuff(from: "Neptun", xPos: 400.0, zPos: ground.zPosition + 2.0, physics: true)
        neptun.name = "Neptun"
        
        addChild(vase)
        addChild(neptun)
    }
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

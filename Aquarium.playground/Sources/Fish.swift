import SpriteKit

public class Fish: SKSpriteNode {
    
    var velocity: CGPoint!
    var type: Int!
    
    var label: SKLabelNode!
    public var timer: Timer!
    
    init(name: String, type: Int) {
        self.type = type
        if type > 6 { self.type = 6 } else if type < 1 { self.type = 1 }
        let tex = SKTexture(imageNamed: "Fish\(type)")
        tex.filteringMode = .nearest
        let siz = tex.size().scaledSize(scale: 2.0)
        
        super.init(texture: tex, color: UIColor.clear, size: siz)
        
        self.velocity = CGPoint(x: 0.0, y: 0.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.name = name
        self.addElements()
        self.think()
    }
    
    func flip() {
        
        var newScale: CGFloat = 0
        
        if velocity.x > 0 { newScale = -1 } else { newScale = 1 }
        if self.xScale > 0 { self.xScale = 1 } else { self.xScale = -1 }
        if newScale != self.xScale {
            let flip = SKAction.scaleX(to: newScale, duration: 0.2)
            self.run(flip, completion: {  })
        }
    }
    
   /* func flip() {
        self.removeAction(forKey: "fishFlipKey")
        
        if self.xScale > 0 { self.xScale = 1 } else { self.xScale = -1 }
        
        var newScale: CGFloat = 0
        if velocity.x <= 0 { newScale = -1 } else { newScale = 1 }
        if newScale != self.xScale {
            let flip = SKAction.scaleX(to: newScale, duration: 0.2)
            self.run(flip, withKey: "fishFlipKey")
        }

    } */
    
    func think() {
        let deltaX = (randomFloat() - 0.5) * 1.5
        let deltaY = deltaX * 0.5 * randomFloat()
        
        self.velocity = CGPoint(x: deltaX, y: deltaY)
        self.flip()
        
        timer = Timer.scheduledTimer(withTimeInterval: Double(randomFloat()) * 5.0 + 3.0, repeats: false, block: { _ in self.think() })
    }
    
    func update() {
        self.position.x += self.velocity.x
        self.position.y += self.velocity.y
        
        if xScale > 0 { label.xScale = 1 } else { label.xScale = -1 }
        
    }
    
    // Electric Shock
    
    public func feelElectricity() {
        if type != 3 {
            let boneTex = SKTexture(imageNamed: "Bones\(type!)")
            boneTex.filteringMode = .nearest
            
            let action1 = SKAction.setTexture(self.texture!)
            let action2 = SKAction.setTexture(boneTex)
            let actionWait = SKAction.wait(forDuration: 0.2)
            let actions = [action2, actionWait, action1, actionWait]
            
            run(SKAction.repeat(SKAction.sequence(actions), count: 5))/*, completion: {
                self.run(action1)
            })*/
        }
    }

    
    
    // Create
    
    func addElements() {
        // NameLabel
        label = SKLabelNode(text: self.name)
        label.fontColor = hexStringToUIColor(hex: "F2EFC4")
        label.fontName = "HelveticaNeue"
        label.fontSize = 12.0
        label.position = CGPoint(x: 0.0, y: frame.height * 0.6)
        
        addChild(label)
        
        
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


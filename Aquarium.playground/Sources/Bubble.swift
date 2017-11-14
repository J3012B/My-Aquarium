import SpriteKit




class Bubble : SKSpriteNode {
    
    var delta: CGPoint!
    
    init() {
        let tex = SKTexture(imageNamed: "Bubble\(Int(arc4random_uniform(3))+1)") // 1, 2, 3
        let siz = CGSize(width: 10.0, height: 10.0)
        
        super.init(texture: tex, color: UIColor.clear, size: siz)
        
        self.texture?.filteringMode = .nearest
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.delta = CGPoint(x: 0.1 * (CGFloat(arc4random_uniform(3)) - 1), y: 1.0 + 0.5 * CGFloat(arc4random_uniform(3)))
    }
    
    func update() {
        self.position.x += delta.x
        self.position.y += delta.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


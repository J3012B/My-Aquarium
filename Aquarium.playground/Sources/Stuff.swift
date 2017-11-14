import SpriteKit


public class Stuff: SKSpriteNode {
    
    
    public init(from image: String, xPos: CGFloat, zPos: CGFloat, physics: Bool) {
        let tex = SKTexture(imageNamed: image)
        tex.filteringMode = .nearest
        
        let siz = tex.size().scaledSize(scale: 2.0)
        
        super.init(texture: tex, color: UIColor.clear, size: siz)
        
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        position = CGPoint(x: xPos, y: 100.0)
        zPosition = zPos
        
        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = true
    }
    
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


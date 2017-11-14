import UIKit
import SpriteKit
import AVFoundation

public class Playground: UIView {
    
    public var underwaterSoundPlayer: AVAudioPlayer!
    
    public init(aquarium: Aquarium) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 520.0, height: 500.0))
        
        
        let skview = SKView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        
        aquarium.scaleMode = .resizeFill
        aquarium.size = skview.bounds.size
        
        skview.presentScene(aquarium)
        skview.ignoresSiblingOrder = true
        skview.showsFPS = false
        skview.showsNodeCount = false
        skview.showsPhysics = false
        
        self.addSubview(skview)
        
    }
    
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


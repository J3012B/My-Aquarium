import SpriteKit
import AVFoundation




func seaweedTextures() -> [SKTexture] {
    var textures = [SKTexture]()
    
    let atlas = SKTextureAtlas(named: "Seaweed.atlas")
    
    for i in 0..<atlas.textureNames.count {
        let tex = atlas.textureNamed("seaweed\(i)")
        
        textures.append(tex)
    }
    
    return textures
}




// Audio

func setupAudioPlayerWithFile(file: String, type: String?) -> AVAudioPlayer? {
    
    if let url = Bundle.main.url(forResource: file, withExtension: nil) {
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    return nil
}

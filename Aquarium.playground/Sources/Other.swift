import UIKit
import AVFoundation

public func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



extension CGSize {
    
    func scaledSize(scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
    
}


func randomFloat() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
}


public func getAudioPlayer(name: String, vol: Float, count: Int) -> AVAudioPlayer? {
    let audioPlayer = setupAudioPlayerWithFile(file: name, type: nil)
    audioPlayer?.numberOfLoops = count
    audioPlayer?.volume = vol
    audioPlayer?.prepareToPlay()
    
    return audioPlayer
}

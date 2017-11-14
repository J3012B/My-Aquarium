import UIKit
import SpriteKit
import PlaygroundSupport

/*:
 ## Aquarium in SpriteKit
 ### WWDC 2017 Scholarship Application - Josef Büttgen
 Hey, please be free and adjust the following values as you like. You can also interact with the objects by dragging and touching. It's an aquarium. It's your aquarium, so explore!
*/
/*:
 ### Hello darkness, my old friend...
 What!? There's nothing to see. Where are your pets? Wait, there's a light switch... (Assign the value 'true')
 */
let lightIsOn = true
/*:
 ### I'm sooo lonely here!
 No fish should be left alone. Put more fishes in there so that **Goldie** isn't so lonely anymore. Do this by adding more names. You also have to decide what type of fish you want to have in your little aquarium. There are 6 different types of fishes you can choose from, just type a number from 1 to 6. You can also add multiple fishes of one type.
 */
var fishes = ["Goldie" : 1]

// For Example:

 //fishes = ["Steve" : 1, "Tim" : 2, "Craig" : 3, "Jony" : 4, "Eddy" : 5, "Philip" : 6]



let aquarium = Aquarium(fishes: fishes)
/*: 
 ### Tell me your name!
 Huh, how can they be seperated?
 Just change this value to 'true'!
*/
aquarium.showNames = false
/*:
 ### I am Poseidon, ...
 Have you already tried to interact with the objects? This sculpture for example looks a bit creepy.
 If you're curious, uncomment the following line. See you at WWDC in June.
 */
aquarium.party()




// Scene Setup -------

let playground = Playground(aquarium: aquarium)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = playground

aquarium.audioPlayer.play()
aquarium.lightOn = lightIsOn

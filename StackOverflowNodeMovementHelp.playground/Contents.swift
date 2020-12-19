//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

//  the array has extensions .draw() and .addCard() in this dudes project
class Player {
    let node : SKSpriteNode
    var hand : [String] = []
    let id : Int8
    var playerName : String = ""

    init( node : SKSpriteNode, name : String, id : Int8) {
        self.node = node
        self.playerName = name
        self.id = id
    }
    func addCard( card : String) {
        hand.append(card)
        print("(just for debug) player recieved : " + card)
    }
    func setScale( scale : CGFloat) {
        node.size = CGSize(width : node.size.width * scale , height : node.size.height * scale )
    }
}



struct deckComp {
    let colors = [ "cloves","spades","diamonds", "hearts"]
    let suits = [ "2","3","4","5","6","7","8","9","10","J","Q","K","A" ]
}

class GameScene: SKScene {
let scale : CGFloat = 50
var deck : [String] = []
let composition = deckComp()
let numberOfPlayers = 3
    var players : [Player] = []
override func didMove(to view: SKView) {
        // creates deck
    for c in deckComp().colors {
        for s in deckComp().suits {
            deck.append( s + " of " + c )
           }
        }
    players = createPlayers(numberOfPlayers: numberOfPlayers, center : CGPoint(x : 25, y : 25))
    // setup the scales, and players
    for plyr in players {
        plyr.setScale(scale: (frame.width/10000) * scale)
        addChild( plyr.node)
        }
        }
    func createPlayers(numberOfPlayers : Int, center : CGPoint) -> [Player] {

        let radius = Float(5*scale)
        let two_pi = 2 * 3.14159
        let angular_positions = two_pi / Double(numberOfPlayers)
        var players_out : [Player] = []
        for i in 0...numberOfPlayers - 1 {
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "card_player.png"))
            sprite.zPosition = 1
            sprite.position = CGPoint( x : center.x + CGFloat(radius * sin( Float(angular_positions) * Float(i) )), y : center.y +  CGFloat(radius * cos( Float(angular_positions) * Float(i) )) )
            sprite.texture?.filteringMode = .nearest // .linear for blurry, .nearest for pixely
            let player_instance = Player(node : sprite, name : "Player " + String(i + 1), id : Int8(i + 1) )
            players_out.append(player_instance)
        }
        return players_out
    }
    func deal() {
             // I moved the setscale stuff for player sprites to didMove()
        // first check if there is enough in deck
        if deck.count > players.count {
        var i = 0
            repeat {
            // add the temp card
            let tempCard = SKSpriteNode(texture: SKTexture(imageNamed: "back"))
            tempCard.size = CGSize( width: tempCard.size.width * (frame.width/10000) * scale, height : tempCard.size.height * (frame.width/10000) * scale )
            tempCard.zPosition = 10
            tempCard.texture?.filteringMode = .nearest
            self.addChild(tempCard)
            // done adding temporary card
            let xPos = frame.width * (0.25 * CGFloat(i+1))
            tempCard.position = CGPoint(x : xPos, y : 0.75 * frame.height)
                let newCard = self.deck.popLast() // replaced dealOneCard() since I haven't defined it
                players[i].addCard(card: newCard!)  // removed hand.addCard(), since I don't have the array extensions
            //                player.name = "local player node"
            let moveCard = SKAction.move(to: players[i].node.position ,duration: 1.5)
                    //addChild(localPlayerNode) --using this instead of SKAction works
                tempCard.run(moveCard, completion: { () -> Void in tempCard.removeFromParent();                })
                i += 1
            } while i < players.count
        } else { print("not enough cards to deal to everyone")} // when deck is empty
    }
    
    override func mouseUp(with event: NSEvent) {
        deal()
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


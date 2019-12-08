//
//  GameScene.swift
//  CorcoranJames_Final
//
//  Created by Jimmy Corcoran on 3/15/19.
//  Copyright © 2019 Jimmy Corcoran. All rights reserved.
//

import SpriteKit
import GameplayKit

//from class
//we can use the idea of global variables, all parts of project can see it
//create a score and high score object here

struct ContactCategory
{
    //i have seen online, people left shifting 1 bit 'n' amount of times for 'n' type of nodes that can collide
    //not sure if i need none b/c all Sprites are defaulted to 0 anyway
    static let none:UInt32   = 0b0000;
    static let ball:UInt32   = 0b0001;
    static let player:UInt32 = 0b0010;
    static let wall:UInt32   = 0b0100;
    
}


//data to maintain state of game
var timer:Int = 20;
var score:Int = 0;
var bonus:Int = 0;
var bCheck:Bool = false;


//SKPhysicsContactDelegate is a protocol
//it will make the GameScene respond to collisions( ie when physics bodys come into contact with one another)
class GameScene: SKScene, SKPhysicsContactDelegate
{
    //----------------------------------------------------------------------------
    // GameScene width:752.0, height:1334.0, with the origin(0,0) at the center of the screen
    //----------------------------------------------------------------------------
    
    //kind of like a call-back in the hierarchy chain
    //Q: who's my parent?
    //maintain a data field for it
    var gViewController: UIViewController?;
    
    //i tried to do the image outside of didmove( ) and it didnt work
    //basically some persistent child nodes
    //var player:SKSpriteNode = SKSpriteNode();
    var player:UserSprite = UserSprite();
    var timerLabel:SKLabelNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold");
    var scoreLabel:SKLabelNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold");
    var starArray: [MySprite] = [];
    
    //getting lazy on sunday night before project is due
    var sTop: CGFloat = 0.0;
    var sBottom: CGFloat = 0.0;
    var sRight: CGFloat = 0.0;
    var sLeft: CGFloat = 0.0;
    //----------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------
    //Test walls
    //----------------------------------------------------------------------------
    //var leftWall:SKSpriteNode = SKSpriteNode();
    //var rightWall:SKSpriteNode = SKSpriteNode();
    
    
    func setWalls()
    {
        
        //Y-coordinates
        //----------------------------------------------------------------------------
        //sTop = 667
        //let sTop:CGFloat = self.size.height * 0.5;
        
        //sBottom = -667
        //let sBottom:CGFloat = sTop * -1.0;
        
        //----------------------------------------------------------------------------
        //X-Coordinates
        //----------------------------------------------------------------------------
        //sRight = 376
        //let sRight:CGFloat = self.size.width * 0.5;
        //sLeft = -376
        //let sLeft:CGFloat = sRight * -1.0;
        
        //----------------------------------------------------------------------------
        
        //RightWall w/physics
        //----------------------------------------------------------------------------
        //let box1:CGRect = CGRect(origin: CGPoint(x: sRight - 20, y: sBottom + 20), size: CGSize(width: 50, height: 50));
        //let rightWall:SKSpriteNode = SKSpriteNode(color: .red, size: CGSize(width: 50.0, height: 50.0));
        //let rightWall:MySprite = MySprite(right: "");
        let rightWall:MySprite = MySprite(rightside: CGPoint(x: sRight - 20.0 , y: 0.0), long: self.size.height);
        //rightWall.position = CGPoint(x: sRight - 50 , y: sBottom + 100);
        
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size);
        
        
        //we set this to false so that the object isgnores all forces and physics applied to it.
        //if set to true my character can move them hahaha by sheer force hahaha
        rightWall.physicsBody?.isDynamic = false;
        rightWall.physicsBody?.contactTestBitMask = ContactCategory.player;
        rightWall.physicsBody?.categoryBitMask = ContactCategory.wall;
        rightWall.physicsBody?.usesPreciseCollisionDetection = false;
        
        //----------------------------------------------------------------------------
        
        //LeftWall w/physics
        //----------------------------------------------------------------------------
        //let leftWall:SKSpriteNode = SKSpriteNode(color: .black, size: CGSize(width: 50.0, height: 50.0));
        //let leftWall:MySprite = MySprite(left: 1);
        let leftWall:MySprite = MySprite(leftside: CGPoint(x: sLeft + 20.0, y: 0.0), long: self.size.height);
        //leftWall.position = CGPoint(x: sLeft + 50 , y: sBottom + 100);
        
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size);
        
        //we set this to false so that the object isgnores all forces and physics applied to it.
        //if set to true my character can move them hahaha by sheer force hahaha
        leftWall.physicsBody?.isDynamic = false;
        leftWall.physicsBody?.contactTestBitMask = ContactCategory.player;
        leftWall.physicsBody?.categoryBitMask = ContactCategory.wall;
        leftWall.physicsBody?.usesPreciseCollisionDetection = false;
        
        
        //then add them
        addChild(leftWall);
        addChild(rightWall);
        
    }
    
    /*
     //old function for contact
     //----------------------------------------------------------------------------
     
     func collectBall(sprite ball:SKSpriteNode)
     {
     ball.removeFromParent();
     score += 2;
     scoreLabel.text = "Score: \(score)";
     print("caught ball");
     }
     */
    
    
    //Use of segues from lecture and reading Apple documentation
    //we set the 'identifier' variable in the interface builder,
    //https://developer.apple.com/documentation/uikit/uistoryboardsegue
    func GameOver()
    {
        //score = 0;
        //timer = 10;
        //and now we just look for the segue with the specified 'identifier' call it
        self.run(SKAction.playSoundFileNamed("rick_morty.wav", waitForCompletion: true));
        self.gViewController?.performSegue(withIdentifier: "GameOver", sender: self);
        
    }
    
    //re-word
    //pkysics contact is created when there is a logical & with the contactbit mask of one object
    //and the categorybitmask of the other. if non-zero value occurs it means they collide
    //https://developer.apple.com/documentation/spritekit/skphysicsbody/1519781-contacttestbitmask
    //now that we got the contact we need to find out which one is which.....
    //sort of like a double dispatch, where we determine which sprite is which
    //so we dont delete the player instead of the ball.
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        //print("//---------------------------------------------------------------");
        //print("Contact:")
        var firstBody: SKPhysicsBody;
        var secondBody: SKPhysicsBody;
        
        //we test their bits to help determine which sprite is which,
        //references: wall < player
        //            player < wall
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
            
        else
        {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA
        }
        
        if let sprite1 =  firstBody.node as? MySprite
        {
            if let sprite2 = secondBody.node as? MySprite
            {
                
                
                //sprite1 could be a ball or a player
                //print("sprite1:\(sprite1.sType.rawValue) collided with sprite2: \(sprite2.sType.rawValue)")
                sprite1.reactToContact(with: sprite2.sType);
                
                //sprite2 could be a player or wall
                sprite2.reactToContact(with: sprite1.sType);
                
                //a bit of a cheap spot to put the score update
                scoreLabel.text = "Score: \(score)";
            }
        }
        
        //----------------------------------------------------------------------------
        //old code to check contact
        //----------------------------------------------------------------------------
        /*
         //maybe do another check, but lets test it
         if let ball = firstBody.node as? SKSpriteNode
         {
         //just intial testing, but works
         collectBall(sprite: ball);
         if let player = secondBody.node as? SKSpriteNode
         {
         //basically an animation
         let action1 = SKAction.rotate(byAngle: 2.0, duration: 0.2);
         let action2 = SKAction.rotate(byAngle: -2.0, duration: 0.2);
         player.run(SKAction.sequence([action1, action2]));
         }
         }
         */
        
    }
    
    //creates the objects
    func sendIso()
    {
        
        //print("//---------------------------------------------------------------");
        //let ball = SKSpriteNode(imageNamed: "circle");
        let iso = EnemySprite();
        
        let farLeft = sLeft + 40;
        let farRight = sRight - 40;
        let originX = CGFloat.random(in: farLeft ..< farRight );
        
        //print("ball starts at x:\(originX), y:\(self.size.height + ball.size.height)");
        iso.position = CGPoint(x: originX, y: self.size.height + iso.size.height );
        
        //----------------------------------------------------------------------------
        //depending on the 'duration' variable we will determine how fast the object moves
        //they will stay on whatever x-coordinate they start from and will travel down
        //to the bottom of the screen. Once there they will be removed from the tree of nodes
        //from an efficiency standpoint.... maybe just set a specific amount of "lanes",
        //so i dont have to use the random( )
        //----------------------------------------------------------------------------
        let actualDuration = CGFloat.random(in: 5 ..< 10);
        let actionMove = SKAction.move(to: CGPoint(x: originX, y: -700.00),  duration: TimeInterval(actualDuration) );
        
        //action that removes Node froom parent
        let actionDone = SKAction.removeFromParent();
        //----------------------------------------------------------------------------
        //Need to add the physics stuff here
        iso.physicsBody = SKPhysicsBody(circleOfRadius: iso.size.width * 0.5);
        iso.physicsBody?.isDynamic = false;
        
        iso.physicsBody?.contactTestBitMask = ContactCategory.player;
        iso.physicsBody?.categoryBitMask = ContactCategory.ball;
        iso.physicsBody?.usesPreciseCollisionDetection = true;
        //----------------------------------------------------------------------------
        
        //add the ball to the tree/scene, and have it runs its two actions in squence
        addChild(iso);
        iso.run(SKAction.sequence([actionMove, actionDone]));
        
    }
    
    func toHide() -> Bool
    {
        var bHide = true;
        let randBin = Int.random(in: 0 ... 1);
        if(randBin == 1)
        {
            bHide = true;
        }
        
        else{bHide = false;}
        
        return bHide;
    }
    
    func animateStars()
    {
        var bHide = true;
        for i in 0 ..< starArray.count
        {
            bHide = toHide();
            starArray[i].isHidden = bHide;
        }
        
    }
    
    func buildBackground()
    {
        backgroundColor = .black;
        //Y-coordinates
        //----------------------------------------------------------------------------
        //sTop = 667
        //let sTop:CGFloat = self.size.height * 0.5;
        
        //sBottom = -667
        //let sBottom:CGFloat = sTop * -1.0;
        
        //----------------------------------------------------------------------------
        //X-Coordinates
        //----------------------------------------------------------------------------
        //sRight = 376
        //let sRight:CGFloat = self.size.width * 0.5;
        //sLeft = -376
        //let sLeft:CGFloat = sRight * -1.0;
        
        
        //var xIn:CGFloat = sRight + 100.0;
        var xIn:CGFloat = sLeft + 100.0;
        var yIn:CGFloat = sTop - 100.0;
        
        var temp:MySprite = MySprite(type: .STAR);
        
        
        temp.position = CGPoint(x: xIn, y: yIn);
        starArray.append(temp);
        addChild(temp);
        //print("Node #\(0): " + "X: \(temp.position.x) and Y: \(temp.position.y)");
        
        for i in 1 ... 10
        {
            temp = MySprite(type: .STAR);
            
            switch (i)
            {
            case 3:
                xIn = -300.0;
                yIn -= 200.0;
            case 5:
                xIn = -200.0;
                yIn -= 200.0;
            case 7:
                xIn = -350.0;
                yIn -= 200.0;
            case 9:
                xIn = -350.0;
                yIn -= 200.0;
                
            default:
                //print(i);
                let bHide = toHide();
                temp.isHidden = bHide;
            }
            
            xIn += 200.0;
            
            temp.position = CGPoint(x: xIn, y: yIn);
            starArray.append(temp);
            addChild(temp);
            //print("Node #\(i): " + "X: \(temp.position.x) and Y: \(temp.position.y)");
        }
        
    }
    
    func setupPlayer()
    {
        //old code...back up
        //player = SKSpriteNode(imageNamed: "character");
        
       
        
        //players starting position, maybe change later
        player.position = CGPoint(x: 0.0, y: sBottom + 250);
        //player.origX = -50.0;
        //player.origY = -560.0;
        //----------------------------------------------------------------------------
        //Need to add the physics stuff here
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size);
        //not sure if i need next line, do more reading
        player.physicsBody?.isDynamic = true;
        
        //testing the addition of more collision partners
        //player.physicsBody?.contactTestBitMask = ContactCategory.ball
        player.physicsBody?.contactTestBitMask = ContactCategory.ball | ContactCategory.wall;
        
        player.physicsBody?.categoryBitMask = ContactCategory.player;
        player.physicsBody?.usesPreciseCollisionDetection = true;
        
    }
    
    func setupDisplay()
    {
        //FontSizes are small..
        timerLabel.text = "Timer: \(timer)";
        timerLabel.fontSize = 30;
        timerLabel.fontColor = SKColor.red
        
        timerLabel.position = CGPoint(x: sRight - 200, y: sTop - 100);
        //timerLabel.position = CGPoint(x: 0.0, y: size.height * 0.5 - 20);
        
        scoreLabel.text = "Score: \(score)";
        scoreLabel.fontSize = 30;
        scoreLabel.fontColor = SKColor.green;
        
        scoreLabel.position = CGPoint(x: sLeft  + 200, y: sTop - 100);
        //scoreLabel.position = CGPoint(x: -300.0, y: size.height * 0.5 - 20);
        
    }
    
    override func didMove(to view: SKView)
    {
        //set up screen and variables
        //a bit laxy, but just trying to get this project done now
        
        self.sTop = self.size.height * 0.5;
        self.sBottom = sTop * -1.0;
        self.sRight = self.size.width * 0.5;
        self.sLeft = sRight * -1.0;
        
        //set up Scene
        //i could set up a black screen and put a bunch of 'star' sprties in it
        //have an array where i randomly turn them on/off with '.ishidden'
        buildBackground();
        //backgroundColor = .gray
        physicsWorld.gravity = .zero;
        physicsWorld.contactDelegate = self;
        //print("scene top:\(self.sTop), bottom:\(self.sBottom)");
        //print("scene leftSide:\(self.sLeft), rightSide:\(self.sRight)");
        //print("scene width:\(self.size.width), height:\(self.size.height)");
        
        
        
        //----------------------------------------------------------------------------
        //set up the player, walls/bumpers, timer, and score.... then add them to the GameScene hierarchy
        //----------------------------------------------------------------------------
        setupPlayer();
        setupDisplay();
        //walls are added inside setWalls( )
        setWalls();
        
        
        addChild(player);
        addChild(timerLabel);
        addChild(scoreLabel);
        //----------------------------------------------------------------------------
        //actions that will dictate the game..... i hope
        //----------------------------------------------------------------------------
        
        //with timer at 90 this was kind of long... play with options
        let actionWait = SKAction.wait(forDuration: 2.0);
        let timeDecrease = SKAction.run
        {
            if (timer > 0)
            {
                timer -= 1
                self.timerLabel.text = "Timer: \(timer)";
            }
            else
            {
                //send us to the next scene
                //print("Game Over");
                
                //remove actions with specified names, i may not be using this particularly well
                self.removeAction(forKey: "timerOver");
                self.removeAction(forKey: "stopBalls");
                //self.timer = 5;
                //self.timerLabel.text = "Timer: \(self.timer)";
                self.GameOver();
                //Q: what do i think will happen?
                //A: i believe the the timer action will stop
                //even though the timer will be set to 5
                //----------------------------------------------------------------------------
                //also maybe make an SKAction to segue from here to another scene/view
            }
        }
        
        let timerSequence = SKAction.sequence([actionWait, timeDecrease]);
        
        /*
         //when we use the run( ) it adds an action to the node, in this case the GameScene
         //both actions run forever and they have a key or signature attached to each of them
         //we can remove the actions using the key
         */
        //not sure if the key names for the actions are aptly named
        run(SKAction.repeatForever(timerSequence), withKey: "timerOver");
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(sendIso), SKAction.wait(forDuration: 2.0)])), withKey: "stopBalls");

        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(animateStars), SKAction.wait(forDuration: 2.0)])), withKey: "stopStars");
    }
    
    /*
     //on my iphone its running at 60fps
     //so this update is being called 60 times a second... thats alot.
     //I dont think i want tooo many things in here
     */
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        
        //Bad hack:
        //honestly not a fan of this check in here, but the physics and collisions are tough to deal with
        if (player.position.y > self.sBottom)
        {
            //do nothing
        }
            
        else
        {
            let xIn = player.position.x;
            //went to far
            player.position = CGPoint(x: xIn, y: sBottom + 100);
        }
    }
    
    func moveRight()
    {
        player.MoveRight();
        
        //let moveAction:SKAction = SKAction.moveBy(x: 70.0, y: 0.0, duration: 1.0);
        //player.run(moveAction);
        
    }
    
    func moveLeft()
    {
        player.moveLeft();
        
        //let moveAction:SKAction = SKAction.moveBy(x: -70.0, y: 0.0, duration: 1.0);
        //player.run(moveAction);
        
    }
    
    //touch Controls and Responses
    //TODO: work/play with this
    //----------------------------------------------------------------------------
    //----------------------------------------------------------------------------
    func touchDown(atPoint pos : CGPoint)
    {
        //print("touch at x:\(pos.x), y:\(pos.y)");
        
        //these checks cut scene vertically, right down the middle
        if pos.x > 0
        {
            //print("move right");
            moveRight();
            
        }
            
        else
        {
            //print("move left");
            moveLeft();
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    //----------------------------------------------------------------------------
    //----------------------------------------------------------------------------
    
}

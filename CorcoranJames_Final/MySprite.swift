//
//  MySprite.swift
//  CorcoranJames_Final
//
//  Created by Jimmy Corcoran on 3/15/19.
//  Copyright © 2019 Jimmy Corcoran. All rights reserved.
//

import Foundation
import SpriteKit


//trivial little dictionary that holds two different sound Actions
let soundActions = [
    0 : SKAction.playSoundFileNamed("aw_geez.wav", waitForCompletion: true),
    1 : SKAction.playSoundFileNamed("my_man2.wav", waitForCompletion: true)
];

//this is a personal subclass of Sprites that hold a 'Type' variable
//this should help me with collisions i hope.
//all of sprites will perform  ReacttoCOntact( )
// as part of the contact, we will determine what kind of action
//they take depending on the other sprites 'Type'
class MySprite: SKSpriteNode
{
    
    enum `Type`: String
    {
        case NONE = "no type";
        case STAR = "star";
        case BALL   = "iso322";
        case L_WALL = "left wall";
        case R_WALL = "right wall";
        case PLAYER   = "morty2";
    }
    
    var sType:Type = .BALL;
    
    init()
    {
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 50.0, height: 50.0));
        sType = .NONE;
    }
    
    init(leftside location:CGPoint ,long length :CGFloat)
    {
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 10.0, height: length));
        sType = .L_WALL;
        self.position = CGPoint(x: location.x, y: location.y);
    }
    
    init(rightside  location:CGPoint ,long length :CGFloat)
    {
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 10.0, height: length));
        sType = .R_WALL;
        self.position = CGPoint(x: location.x, y: location.y);
    }
    /*
    init(left wall:Int)
    {
        print("left wall created: \(wall)");
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 15.0, height: 100.0));
        sType = .L_WALL;
    }
    
    init(right wall:String)
    {
        print("right wall created: \(wall)");
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 15.0, height: 100.0));
        sType = .R_WALL;
    }
    */
    
    init(type variant:Type)
    {
        sType = variant;
        let texture = SKTexture(imageNamed: variant.rawValue);
        super.init(texture: texture, color: UIColor.clear, size: texture.size());
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this will sort of serve as a an action that  all my sprites will perform when they interact
    //but each subclass will have something different...
    //ex: player.collisionAction( ) is just a state change
    // and the ball.collisionAction ( ) is a removefromparent( )
    //override this function in the subclass
    func reactToContact(with object:Type)
    {
        //print("\(self.sType) made contact with \(object.rawValue) ");
    }
    
    
    
}

class EnemySprite: MySprite
{
    
    override init()
    {
        super.init(type: .BALL);
    }
    
    override init(type variant:Type)
    {
        super.init(type: variant);
        //sType = variant;
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkScore()
    {
        switch(score)
        {
        case 10:
            timer += 10;
            print("added 10 points to timer");
        case 20:
            timer += 20;
            print("added 20 points to timer");
        case 30:
            timer += 30;
            print("added 30 points to timer");
        default:
            bonus += 1;
        }
    }
    
    override func reactToContact(with object: Type)
    {
    
        self.isHidden = true;
        //let playSound = SKAction.playSoundFileNamed("aw_geez.wav", waitForCompletion: false);
        let actionWait = SKAction.wait(forDuration: 1.0);
        let actionRemove = {() -> Void in self.removeFromParent()}
    
        let num = Int.random(in: 0 ... 1);
        
        print("contact made with \(object.rawValue)");
        
        if let soundEffect = soundActions[num]
        {
            
            score += 1;
            checkScore();
            self.run(SKAction.sequence([soundEffect, actionWait,SKAction.run(actionRemove)]));
        }
        
        
    }
}

class UserSprite: MySprite
{
    //var origX: CGFloat = 0;
    //var origY: CGFloat = 0;
    
    enum Movement: String
    {
        case MOVE_LEFT_ONLY  = "left only";
        case MOVE_RIGHT_ONLY = "right only";
        case MOVE_BOTH_WAYS  = "both directions";
    }
    
    var moveState:Movement = .MOVE_BOTH_WAYS;
    
    override init()
    {
        super.init(type: .PLAYER);
        moveState = .MOVE_BOTH_WAYS;
        
    }
    
    override init(type variant:Type)
    {
        super.init(type: variant);
        moveState = .MOVE_BOTH_WAYS;
        sType = variant;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Move(direction by:CGFloat)
    {
        //let fY:CGFloat = self.position.y + (self.origY * -1.0);
        //let moveAction:SKAction = SKAction.moveBy(x: 70.0 * by, y: fY, duration: 1.0);
        
        let moveAction = SKAction.moveBy(x: 70.0 * by, y: 2.0, duration: 1.0);
        self.run(moveAction);
    }
    
    func changeMoveState(to this:Movement)
    {
        self.moveState = this;
    }
    
    func moveLeft()
    {
        switch self.moveState
        {
        case .MOVE_RIGHT_ONLY:
            print("movement state: \(self.moveState.rawValue)");
            //print("character at:\(self.position.x), y:\(self.position.y)");
            
        case .MOVE_LEFT_ONLY:
            changeMoveState(to: Movement.MOVE_BOTH_WAYS);
            Move(direction: -1.0);
            
        default:
            Move(direction: -1.0);
        }
        
    }
    
    func MoveRight()
    {
        switch self.moveState
        {
        case .MOVE_LEFT_ONLY:
            print("movement state: \(self.moveState.rawValue)");
            //print("character at:\(self.position.x), y:\(self.position.y)");
            
        case .MOVE_RIGHT_ONLY:
            changeMoveState(to: Movement.MOVE_BOTH_WAYS);
            Move(direction: 1.0);
            
        default:
            Move(direction: 1.0);
        }
    }
    
    //stipulation, it has to react to another object/instance of mySprite class
    override func reactToContact(with other:Type)
    {
        
        switch other
        {
        case .L_WALL:
            changeMoveState(to: .MOVE_RIGHT_ONLY);
            
        case .R_WALL:
            changeMoveState(to: .MOVE_LEFT_ONLY);
            
        default:
            //also add the animation
            //print("character at:\(self.position.x), y:\(self.position.y)");
            //print("\(self.sType.rawValue) made contact with \(other.rawValue) ");
            
            /*
            let action1 = SKAction.rotate(byAngle: 0.1, duration: 0.2);
            let action2 = SKAction.rotate(byAngle: -0.1, duration: 0.2);
            let resistance = SKAction.moveBy(x: 0.0, y: self.size.width, duration: 0.2);
            self.run(SKAction.sequence([action1, action2, resistance]));
            */
            let resistance = SKAction.moveBy(x: 0.0, y: 20.0, duration: 0.2);
            self.run(resistance);
        }
        
    }
}


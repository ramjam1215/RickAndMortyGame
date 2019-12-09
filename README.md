# RickAndMortyGame
- Copyright &copy; by James Corcoran
- A basic 2D game made for iOS using Swift, Xcode, and the SpriteKit.
- Created this game as a side hustle to learn and develop a mobile app for iOS.
- I had a lot of fun an its a midly entertaining game hahaha.

- Check out the Demo at the link below:
YouTube: https://youtu.be/vt18P1Xw8lM 

# Notable bugs
- physics push player sprite down , so I made it that each time the screen is tapped he moves upwards just a small amount

# 03-17-2019 -> 03-18-2019
- I went about basing the game off of a television show called “Rick and Morty”. I snatched up some video clips and used the QuickTime app on the Mac to capture the audio and trim it down. Then used iTunes to convert the files to .wav files….. not sure if that was necessary. But, then I implemented them once the collision occurs between the player sprite and the space objects 
- Also used the auto layout to organize the screens, and most of the runs have turned out relatively well. I have primarily tested the game on Iphone XS, 8, 8 plus, and I think XR.  

# 03-15-2019 -> 03-16-2019
- Trying to add a little polish
- Changing overall concept art from a garbage collector in a park setting to a galactic setting with materials falling.
- created a better background that has ‘star’ sprites which ‘flicker’ in the background using the builtin properties of sprites object(ie .isHidden ) and the SKactions.
- My wife helped with the texture art and I used GIMP to scale them down.
- I played around with making the App move from a tab bar controller to the Gameview controller, but I think it would be too confusing for a user. So I should keep it in the titleView -> gameView -> EndView type loop

# 03-10-2019
- finally implemented my sub class hierarchy of the SKSpriteNode, and then replaced all instances of the SKSpriteNode using my new hierarchy. Which is as follows
			  SKSpriteNode
				      |
			      MySprite
			    /		       \
		UserSprite		EnemySprite

- I created this hierarchy to help with the double dispatching in the contact delegate to determine what should happen to specific sprites when they come in contact with certain other sprites

-implemented “wall” sprites to stop the player sprite from going off the sides of the screen
But it had some interesting developments/side-effects, if u gather enough momentum the player can push the walls. I must check if I can shut those physics off…….  ( Physics body?.isDynamic = false )

# 03-08-2019  -> 03-09-2019
- started working on a Sprite hierarchy so I can have a more complicated collision system.
- Basically the player needs to be able to stop from going off the walls. So I wanted to create bumpers/walls

# 03-03-2019 -> 03-05-2019
- figuring out how to try and implement the transition between a game view controller to a regular view controller. 
- I used lecture as reference and remembered to use segues and put little filler views in for now
- essentially I created a segue and gave it an identifier. Then in connection with an SKAction occurring from my Timer I already implemented. I have the current, game view controller perform the segue to the “Game Over” view controller. From there, you press a button to segue into the title screen again

# 02-23-2019 -> 02-27-2019
- I really started getting my hands dirty in the project
- I looked online for some tutorials on the SKScenes and GameViewControllers
- I learned about SKActions and I kind of use it as a quasi-timer where I create actions that occur every so often, and sometimes forever
-needed  to incorporate inheritance orin swift implement  protocols to do things like the collision system 
- Also learned about the collision system, well part of it without the major physics like velocity and such of the object. But ultimately when two objects physics body’s are set (usually use the rectangle of sprite) the contact delegate creates a physics contact object holding the two object that made contact. We try to determine which one is which and decide what each object should do.


# 02-16-2019 -> 02-18-2019
- more of concepts being started;
- I came up with a simple game idea of the player moving a sprite, at the bottom of the screen, along the x-axis. Which, ‘catches’ other sprites that fall down to the bottom of the screen. 
- I want to add a score, timer, and transitions to a high score and game over and title screen


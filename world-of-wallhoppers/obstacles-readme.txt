This is how to use obstacles for the project (for developers)

To add obstacles to a level:

The Obstacles scene has various types of obstacles (like Static-squares). If you want an obstacle of a certain type, copy the node of the type and paste it into the level you want to put it in. (for example, you would copy the Static-squares node and paste that into the scene, and the children come with it). 
From there, connect the on_body_entered signal from the default obstacle's Area2D to the type node (like Static-squares). And to change the obstacles texture, click on the AnimatedSprite2D and select the desired texture from the SpriteFrames menu below (to be clear, this is IN THE SCENE THAT CONTAINS THE LEVEL YOU ARE EDITING). 
To add more obstacles of that type, simply copy the default obstacle (for example, Static-square1) and paste it as a child of the type node (Static-squares) AFTER applying the above instructions to the default obstacle. 

To add more obstacle types: 

In the Obstacles scene, create a Node2D to act as the type, and attach the obstacles script to it. 
Create a default obstacle of that type (usually with a Node2D as a root) with an AnimatedSprite2D and an Area2D with a CollisionShape2D of the desired shape. 

To add more textures to an obstacle type:

Go to the Obstacles scene and find the type of obstacle you want to add the texture to. 
Go to the AnimatedSprite2D of the default obstacle of that type. 
Go to the SpriteFrames menu at the bottom. 
Create a new animation using the "Add Animation" button. 
Add your texture (either a still image or a whole animation). 

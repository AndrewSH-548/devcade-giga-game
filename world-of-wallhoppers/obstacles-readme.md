# How to use obstacles (for developers)

## Add obstacles to a level:

1. The Obstacles scene has various types of obstacles (like Static-squares). If you want an obstacle of a certain type, copy the node of the type and paste it into the level you want to put it in. (for example, you would copy the Static-squares node and paste that into the scene, and the children come with it). 
2. From there, connect the on_body_entered signal from the default obstacle's Area2D to the type node (like Static-squares). And to change the obstacles texture, click on the AnimatedSprite2D and select the desired texture from the SpriteFrames menu below (to be clear, this is IN THE SCENE THAT CONTAINS THE LEVEL YOU ARE EDITING). 
3. To add more obstacles of that type, simply copy the default obstacle (for example, Static-square1) and paste it as a child of the type node (Static-squares) AFTER applying the above instructions to the default obstacle. 

## Add more obstacle types: 

1. In the Obstacles scene, create a Node2D to act as the type, and attach the obstacles script to it. 
2. Create a default obstacle of that type (usually with a Node2D as a root) with an AnimatedSprite2D and an Area2D with a CollisionShape2D of the desired shape. 
3. Optionally, if your obstacle requires specific behaviour, create a script for it and attach it to the root of the default obstacle 

## Add more textures to an obstacle type:

1. Go to the Obstacles scene and find the type of obstacle you want to add the texture to. 
2. Go to the AnimatedSprite2D of the default obstacle of that type. 
3. Go to the SpriteFrames menu at the bottom. 
4. Create a new animation using the "Add Animation" button. 
5. Add your texture (either a still image or a whole animation). 

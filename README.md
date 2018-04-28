# Space-Blasters-iOS

**By: Irving Waisman**

**For Mobile Programming 2 course at Humber College**

**[Game Play Footage](https://youtu.be/JJ2zZgzdXJk)** 

2D Space Shooter game made for iOS with Swift via xcode.

## Overall Objective:
Try to kill as many enemy ships as you can without letting them past you or take you out. **Survive as long as you can!**

## Controls:
**Movement:**  Move your ship left or right by dragging your finger anywhere on the screen.

**Attack:**   Push on your ship to fire your blasters.

## Additional Goals:
- Increase your score by shooting down enemy ships.
- Avoid collision with kamikaze ships.
- Try not to lose all your HP from the enemy boss blasters.
- Get through as many levels as you can by defeating the enemy boss at the end of each level.

## Gameplay:
**Enemy Kamakize Ships**
- Enemy kamakize ships will fly at you in random order and try to collide with your ship.
- If an kamakize ship collides with you it's game over.
- Every enemy ship that flies past you will increase a counter in the bottom left corner.

**Enemy Boss Ships**
- At the end of each level, once a certain amount of enemy kamikaze ships have been killed, an enemy boss ship will appear which you must fight. 
- These enemy bosses will have blasters which can be used against you and will cost you HP if you get hit.
- When you kill an enemy boss a random item will spawn which can give you additional perks.

**Items**

- [x] No Item `No Item is Spawned`

- [x] One Plus HP `Increases player's HP by 1`

- [ ] Double Laser Add On `Allows the player two shoot an additional laser as long as no HP is lost`

- [ ] Over Shield `Allows you to crash through kamakize ships a certian amount of times`

`Check marks are items that have been implemented into the Game`

## Additional Features
- High Scores are saved and are checked to be updated after every game and are displayed on the game over screen.
- How many enemy bosses were killed is also checked and displayed on the game over screen.
- As well as how many enemy ships passed through.
- Networking component is Google Ad Mod displayed at the bottom of the screen in the view controller.

## Assets

**Images taken Online**

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39208550-5364b47c-47d1-11e8-89d1-7806f46b8446.png"  height="250" width="250" ></a> 


`Player Ship` [Image Source](https://www.google.ca/search?biw=1214&bih=1227&tbm=isch&sa=1&ei=LXjfWvrAGfCmggfn_qOwDw&q=2d+player+spaceships&oq=2d+player+spaceships&gs_l=psy-ab.3...350469.353531.0.353642.17.16.0.1.1.0.93.879.16.16.0....0...1c.1.64.psy-ab..0.9.444...0j0i67k1j0i8i30k1j0i24k1j0i30k1.0.v464ZW_0Duo#imgrc=y688ecpeTD1wtM:)

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390618-358b4268-4a65-11e8-8738-ee2e63ada67c.png"  height="200" width="300" ></a>


`Kamakize Ship` [Image Source](https://www.google.ca/search?tbm=isch&q=2d+spaceships&spell=1&sa=X&ved=0ahUKEwiy-ZvdxdPaAhVpZN8KHfz_AXoQBQimASgA&biw=1214&bih=1270&dpr=2#imgrc=8bRHPYxrRkJ9oM:)

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390640-83a6e4b6-4a65-11e8-9d56-4cc4a0c7e3dd.png" height="250" width="250" ></a>


`Enemy Boss Ship` [Image Source](https://www.google.ca/search?biw=1214&bih=1270&tbm=isch&sa=1&ei=7nffWtTRJKjv_QbW_JWADw&q=2d+enemy+boss+ships&oq=2d+enemy+boss+ships&gs_l=psy-ab.3...242919.245845.0.245988.16.16.0.0.0.0.60.820.16.16.0....0...1c.1.64.psy-ab..0.6.315...0j0i67k1j0i8i30k1j0i24k1j0i30k1.0.X_6SjN6qXVQ#imgrc=CUYX6G8zo97TQM:)

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390652-a3b256c8-4a65-11e8-88c9-64ac675355e7.png"  height="250" width="250" ></a>
  
  
`Explosion Image` [Image Source](https://www.google.ca/search?q=2d+explosion&tbm=isch&source=lnt&tbs=ic:trans&sa=X&ved=0ahUKEwjfjMXLzNPaAhUEON8KHRz3Bo4QpwUIHg&biw=1214&bih=1227&dpr=2#imgdii=RX69pqkVxsGWDM:&imgrc=JiP5eJ_WTcEMTM:)
  
<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390667-c7a4f36a-4a65-11e8-9019-e428e32198c4.png"  height="300" width="200" ></a>


`Background Space` [Image Source](https://www.google.ca/search?q=www.toxsoft.com+space+background&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiWn7PtyNPaAhVIPN8KHbwuA1UQ_AUICigB&biw=1214&bih=1227#imgrc=SIh6eCYeqRW8-M:)

**Images Created**

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390915-b417eed4-4a69-11e8-8a13-dfdc59d715dd.png"  height="150" width="150" ></a>


`Player Laser Shot`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390949-3793e04c-4a6a-11e8-84fe-b61e1bb424b3.png"  height="150" width="150" ></a>


`Double Laser Shot`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390924-d922093a-4a69-11e8-8e78-9adf402ea3ae.png"  height="150" width="150" ></a>


`Enemy Laser Shot`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390939-0ee633ac-4a6a-11e8-85db-e49815742cde.png"  height="150" width="150" ></a>


`One Plus HP Item`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390943-22ac3e2c-4a6a-11e8-8518-b94c23a1c269.png"  height="150" width="150" ></a>


`Double Laser Item`


**Sprite Sheets Created**

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390977-af601780-4a6a-11e8-8b2b-e633f896fb0d.gif"  height="150" width="150" ></a>


`Player Laser Sprite Sheet`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390972-9f915490-4a6a-11e8-8c72-774fdf1005b8.gif"  height="150" width="150" ></a>


`Double Laser Sprite Sheet`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39390995-eec23822-4a6a-11e8-9f1b-3a3665875814.gif"  height="150" width="150" ></a>


`Enemy Laser Sprite Sheet`

<a href="url"><img src="https://user-images.githubusercontent.com/22323399/39391001-02126fa0-4a6b-11e8-8d12-0a5264b25666.gif"  height="150" width="150" ></a>


`Player Hit Sprite Sheet`


**Audio taken Online**

`Laser Shot` [Audio Source](https://freesound.org/people/bubaproducer/sounds/151022/)

`Explosion Sound` [Audio Source](https://freesound.org/people/bareform/sounds/218721/)

`Background Music` [Audio Source](https://freesound.org/people/levelclearer/sounds/259324/)


**Font Used**

`Moon Heavy Font` [Font Source](https://www.dafont.com/moon-get.font) 

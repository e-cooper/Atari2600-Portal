 rem Generated 11/21/2013 1:53:31 AM by Visual bB Version 1.0.0.554
 rem **********************************
 rem * portal.bas
 rem *
 rem * Atari 2600 demake of 
 rem * Valve's Portal game for
 rem * Georgia Tech
 rem * LCC 2700 Project 6
 rem *           
 rem * Producer: Kirsten Carella
 rem * Designer: Derek Aldrich
 rem * Programmer: Eli Cooper
 rem *
 rem * Contact 
 rem * elicooper18@gmail.com
 rem * with any questions
 rem *
 rem * MIT License
 rem **********************************

 set romsize 4k
 set smartbranching on

 rem the game level, time (in milliseconds), and time (in seconds)
 dim level = l
 dim time = t
 dim passes = p

 rem helps move the player
 dim p1_x = a
 dim p1_fall = f
 dim p1_dir = q

 rem see which way missile0 is heading
 dim m0_dir = o

 rem see which way missile1 is heading
 dim m1_dir = w

 rem see which way the player is facing
 dim p1_left = d
 dim p1_right = d

 rem see which missile was shot
 dim m0_shot = m
 dim m1_shot = m

 rem see which missiles are accessible
 dim m0_persistence = b
 dim m1_persistence = b

 rem the duration of a note and whether MusicSetup has been run for the first time
 dim duration = h
 dim first_time = r
 duration = 1
 first_time{0}=1

 rem setup the initial variables
 player1x = 24 : player1y = 80
 p1_dir = 1 : p1_right{1}=1
 missile0height = 6 : missile1height = 6

 rem the font for the score
 const font = alarmclock

 goto level_select



 rem check the level and start the screen drawing stuff
level_select
 if level > 4 then level = 0
 if z = 1 then score = score + 1
 on level gosub level1 level2 level3 level4 level5
 z = 0
 if level = 0 && first_time{0} then goto MusicSetup
 goto mainloop

level1
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 X.XXX...XX..XXX.XXXXX.XX..X....X
 X.X..X.X..X.X..X..X..X..X.X....X
 X.X..X.X..X.X..X..X..XXXX.X....X
 X.XXX..X..X.XXX...X..X..X.X....X
 X.X....X..X.X.X...X..X..X.X....X
 X.X.....XX..X..X..X..X..X.XXXX.X
 X..............................X
 X...............................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 144 : bally = 75
 return

level2 
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXX..................X
 XXXXXXXXXXXXX..................X
 XXXXXXXXXXXXX..................X
 XXXXXXXXXXXXX.......XXX........X
 X...................XXX........X
 X...................XXX........X
 X.........XX........XXX........X
 X.........XX........XXX........X
 X.........XX........XXX.........
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 144 : bally = 75
 return

level3
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 ...............................X
 XXXXXXXXXXXXXXXXXX.............X
 X..............................X
 X..............................X
 X......................XXXXXXXXX
 X..............................X
 X.....XXXXXXXXXXX..............X
 X..............................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 19 : bally = 19
 return

level4
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXX........XX........X
 XXXXXXXXXXXXX........XX.........
 XXXXXXXXXXXXXXXX............XXXX
 X..............................X
 X..............................X
 X..........XX.....XXXXXXX...XXXX
 XXX....XXXXXX..................X
 X..........XX..................X
 X..........XX..................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 144 : bally = 19
 return

level5
 if z = 1 then passes = 0 : z = 0 : s = 1
 playfield:
 ................................
 X......XXXXX.X...X.XXX.........X
 X......X.....XX..X.X..X........X
 X......XXX...X.X.X.X...X.......X
 X......X.....X..XX.X..X........X
 X......XXXXX.X...X.XXX.........X
 X..............................X
 X............X.X.X.............X
 X...........XXXXXXX............X
 X...........XXXXXXX............X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 255 : bally = 255
 rem wait 6 seconds to transition back to the start
 if passes > 6 then level = 5 : score = 0 : time = 0 : player1x = 24 : player1y = 80 : missile0x = 255 : missile0y = 255 : m0_persistence{0}=0 : missile1x = 240 : missile1y = 240 : m1_persistence{1}=0 
 if passes > 6 then s = 0
 return



 rem the main stuff the game needs to know about
mainloop

 rem the background and playfield colors
 COLUBK = $0C
 COLUPF = $02

 rem instantiate the missiles
 NUSIZ0 = $10 : NUSIZ1 = $10
 
 rem colors of player0 / missile0 and player1 / missile1 
 COLUP0 = $88 :  COLUP1 = $26

 rem the pixel just below the player's x and y coords 
 x = (player1x - 14) / 4
 y = player1y / 8

 rem there is no active pixel below the player, make her fall
 if !pfread(x, y) then player1y = player1y + 1

 rem see if missile1 has not collided and move it in the right direction
 if !collision(missile1,playfield) && m1_shot{1} && m1_dir = 5 then missile1x = missile1x - 1 : missile1y = missile1y - 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_dir = 4 then missile1x = missile1x - 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_dir = 3 then missile1x = missile1x - 1 : missile1y = missile1y + 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_dir = 2 then missile1x = missile1x + 1 : missile1y = missile1y - 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_dir = 1 then missile1x = missile1x + 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_dir = 0 then missile1x = missile1x + 1 : missile1y = missile1y + 1

 rem see if missile0 has not collided and move it in the right direction
 if !collision(missile0,playfield) && m0_shot{0} && m0_dir = 5 then missile0x = missile0x - 1 : missile0y = missile0y - 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_dir = 4 then missile0x = missile0x - 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_dir = 3 then missile0x = missile0x - 1 : missile0y = missile0y + 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_dir = 2 then missile0x = missile0x + 1 : missile0y = missile0y - 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_dir = 1 then missile0x = missile0x + 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_dir = 0 then missile0x = missile0x + 1 : missile0y = missile0y + 1

 rem check for portal collision and overwrite the initial portal with the new one
 if collision(missile0,missile1) && m0_shot{0} then missile1x = 255 : missile1y = 255 : m1_persistence{1}=0
 if collision(missile0, missile1) && m1_shot{1} then missile0x = 255 : missile0y = 255 : m0_persistence{0}=0

 if collision(missile0,ball) then missile0x = 255 : missile0y = 255 : m0_persistence{0}=0
 if collision(missile1,ball) then missile1x = 255 : missile1y = 255 : m1_persistence{1}=0

 rem check to see if a moving portal hit the playfield and if so then stop moving and make it active
 rem also disregard portals that are designated inactive
 if collision(missile1,playfield) && missile1x < 255 then m1_shot{1}=0 : m1_persistence{1}=1
 if collision(missile0,playfield) && missile0x < 255 then m0_shot{0}=0 : m0_persistence{0}=1

 rem see if the player is accessing a portal and change their position to the other one
 if collision(player1,missile0) && m1_persistence{1} then gosub player_pos1
 if collision(player1,missile1) && m0_persistence{0} then gosub player_pos0

 rem make sure the player moves correctly from side to side
 p1_x = 0
 if joy0left then p1_x = 255 : s = 1
 if joy0right then p1_x = 1 : s = 1
 player1x = player1x + p1_x

 rem joystick commands which change the sprite
 if joy0up && p1_dir < 5 && p1_dir <> 2 && e = 0 then p1_dir = p1_dir + 1 : e = 1 : s = 1
 if joy0down && p1_dir > 0 && p1_dir <> 3 && e = 0 then p1_dir = p1_dir - 1 : e = 1 : s = 1
 if joy0left && !p1_left{0} then p1_dir = p1_dir + 3 : p1_left{0}=1 : p1_right{1}=0
 if joy0right && !p1_right{1} then p1_dir = p1_dir - 3 : p1_left{0}=0 : p1_right{1}=1

 rem fire the missiles
 if joy0fire then gosub player_fire1
 if joy1fire then gosub player_fire0

 rem play theme for title screen and end screen
 if level = 0 || level = 4 then goto GetMusic

 rem see if note is done playing for sound effects, if not decrement the f value, otherwise mute the sound
 if k > 0 then AUDF0 = k : AUDF1 = k : k = k - 1 else AUDV0 = 0 : AUDV1 = 0
 
 rem this will go to the next bit if it is a normal level
 goto GotMusic



 rem prepare to draw the screen
GotMusic

 rem prevents the player from holding the direction to change position
 rem otherwise it is tough to go back to steady
 if !joy0up && !joy0down then e = 0

 rem change all this stuff if the level has been completed because the player collided with the ball
 if collision(player1,ball) then z = 1 : level = level + 1 : player1x = 24 : player1y = 80 : missile0x = 255 : missile0y = 255 : m0_persistence{0}=0 : missile1x = 240 : missile1y = 240 : m1_persistence{1}=0
 if z = 1 then gosub success_sound : s = 0

 on p1_dir gosub player_rdown player_right player_rup player_ldown player_left player_lup

 drawscreen

 rem player and playfield collision and gentle knockback
 if collision(player1,playfield) then gosub knock_player_back

 rem make sure the timer is called
 gosub timer

 rem check for new level at each frame
 rem THIS ENDS THE CURRENT FRAME
 goto level_select




 rem BELOW ARE HELPER SUB-METHODS



 rem calculates time if a directional move has been hit
timer
 if s > 0 then time = time + 1 else time = 0
 if time = 59 && level = 4 then time = 0 : passes = passes + 1
 if time = 59 && level <> 4 then time = 0 : score = score + 1000 : passes = passes + 1
 return



 rem fire missile1 in the right direction
player_fire1
 gosub fire_sound
 if p1_dir = 4 then missile1x = player1x : missile1y = player1y - 1 : m1_dir = 4
 if p1_dir = 5 then missile1x = player1x : missile1y = player1y - 1 : m1_dir = 5
 if p1_dir = 3 then missile1x = player1x : missile1y = player1y - 1 : m1_dir = 3
 if p1_dir = 1 then missile1x = player1x + 7 : missile1y = player1y - 1 : m1_dir = 1
 if p1_dir = 2 then missile1x = player1x + 7 : missile1y = player1y - 1 : m1_dir = 2
 if p1_dir = 0 then missile1x = player1x + 7 : missile1y = player1y - 1 : m1_dir = 0
 m1_shot{1} = 1
 return



 rem fire missile0 in the right direction
player_fire0
 gosub fire_sound
 if p1_dir = 4 then missile0x = player1x : missile0y = player1y - 1 : m0_dir = 4
 if p1_dir = 5 then missile0x = player1x : missile0y = player1y - 1 : m0_dir = 5
 if p1_dir = 3 then missile0x = player1x : missile0y = player1y - 1 : m0_dir = 3
 if p1_dir = 1 then missile0x = player1x + 7 : missile0y = player1y - 1 : m0_dir = 1
 if p1_dir = 2 then missile0x = player1x + 7 : missile0y = player1y - 1 : m0_dir = 2
 if p1_dir = 0 then missile0x = player1x + 7 : missile0y = player1y - 1 : m0_dir = 0
 m0_shot{0} = 1
 return



 rem left and steady sprite
player_left
 player1:
 %00011000
 %00011000
 %00011000
 %00011000
 %01111100
 %00011100
 %00011000
 %00011000
end
 return

 rem right and steady sprite
player_right
 player1:
 %00110000
 %00110000
 %00110000
 %00110000
 %01111100
 %01110000
 %00110000
 %00110000
end
 return
 
 rem left and up sprite
player_lup
 player1:
 %00011000
 %00011000
 %00011000
 %00011100
 %00011100
 %00111100
 %01011000
 %00011000
end
 return

 rem left and down sprite
player_ldown
 player1:
 %00011000
 %00011000
 %00011000
 %01011000
 %00111100
 %00011100
 %00011100
 %00011000
end
 return

 rem right and up sprite
player_rup
 player1:
 %00110000
 %00110000
 %00110000
 %01110000
 %01110000
 %01111000
 %00110100
 %00110000
end
 return

 rem right and down sprite
player_rdown
 player1:
 %00110000
 %00110000
 %00110000
 %00110100
 %01111000
 %01110000
 %01110000
 %00110000
end
 return



 rem gently knock the player back to the inside of the playfield
knock_player_back
 player1x = player1x - p1_x
 return



 rem change where the player spawns once she goes through a portal
 rem this determines where she will spawn in relation to missile0 after going through missile1
player_pos0
 gosub portal_sound
 if m0_dir = 5 then player1x = missile0x - 1 : player1y = missile0y + 7
 if m0_dir = 4 || m0_dir = 3 then player1x = missile0x - 1 : player1y = missile0y
 if m0_dir = 2 then player1x = missile0x - 8 : player1y = missile0y + 7
 if m0_dir = 1 || m0_dir = 0 then player1x = missile0x - 8 : player1y = missile0y
 return



 rem this determines where she will spawn in relation to missile1 after going through missile 0
player_pos1
 gosub portal_sound
 if m1_dir = 5 then player1x = missile1x - 1 : player1y = missile1y + 7
 if m1_dir = 4 || m1_dir = 3 then player1x = missile1x - 1: player1y = missile1y
 if m1_dir = 2 then player1x = missile1x - 8 : player1y = missile1y + 7
 if m1_dir = 1 || m1_dir = 0 then player1x = missile1x - 8 : player1y = missile1y
 return



 rem the sound when a portal is fired
fire_sound
 AUDV0 = 3
 AUDC0 = 6
 k = 11
 return



 rem the sound when the player goes through the portal
portal_sound
 AUDV1 = 3
 AUDC1 = 12
 k = 11
 return



 rem the sound when a level is beaten
success_sound
 AUDV0 = 3
 AUDC0 = 4
 k = 11
 return



 rem  Music code generated by VbB Music and Sound Editor
GetMusic

 rem  *  Check for end of current note
 duration = duration - 1
 if duration>0 then GotMusic


 rem  *  Retrieve channel 0 data
 temp4 = sread(musicData)
 temp5 = sread(musicData)
 temp6 = sread(musicData)


 rem  *  Check for end of data
 if temp4=255 then duration = 1 : goto MusicSetup


 rem  *  Play channel 0
 AUDV0 = temp4
 AUDC0 = temp5
 AUDF0 = temp6


 rem  *  Retrieve channel 1 data
 temp4 = sread(musicData)
 temp5 = sread(musicData)
 temp6 = sread(musicData)


 rem  *  Play channel 1
 AUDV1 = temp4
 AUDC1 = temp5
 AUDF1 = temp6


 rem  *  Set duration
 duration = sread(musicData)
 goto GotMusic




   rem  *****************************************************
   rem  *  Music Data Block
   rem  *  Generated by VbB Music and Sound Editor
   rem  *****************************************************
   rem  *  Format:
   rem  *  v,c,f (channel 0)
   rem  *  v,c,f (channel 1) 
   rem  *  d
   rem  *
   rem  *  Explanation:
   rem  *  v - volume (0 to 15)
   rem  *  c - control [a.k.a. tone, voice, and distortion] (0 to 15)
   rem  *  f - frequency (0 to 31)
   rem  *  d - duration

MusicSetup
  sdata musicData=u
  0,0,0
  0,0,0
  8  
  4,4,19
  0,0,0
  14
  4,4,20
  0,0,0
  14
  4,4,23
  0,0,0
  14
  4,4,23
  0,0,0
  14
  4,4,20
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14  
 4,4,31
  0,0,0
  14
  4,4,19
  0,0,0
  14
  4,4,20
  0,0,0
  14
  4,4,23
  0,0,0
  14
  4,4,23
  0,0,0
  12
  1,4,23
  0,0,0
  8
  4,4,20
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  4,4,26
  0,0,0
  12
  1,4,26
  0,0,0
  8
  4,4,23
  0,0,0
  14
  4,4,31
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  0,0,0
  0,0,0
  14
  4,4,31
  0,0,0
  14
  4,4,23
  0,0,0
  12
  1,4,23
  0,0,0
  8
  4,4,20
  0,0,0
  14
  4,4,19
  0,0,0
  20
  1,4,19
  0,0,0
  8
  4,4,23
  0,0,0
  14
  4,4,27
  0,0,0
  12
  1,4,27
  0,0,0
  8
  4,4,26
  0,0,0
  18
  1,4,26
  0,0,0
  8
  4,4,23
  0,0,0
  12
  1,4,23
  0,0,0
  8
  4,4,31
  0,0,0
  14
  0,0,0
  0,0,0
  2
  4,4,31
  0,0,0
  12
  1,4,31
  0,0,0
  8
  4,4,20
  0,0,0
  12
  1,4,20
  0,0,0
  8
  0,0,0
  0,0,0
  20
  0,0,0
  0,0,0
  20
  0,0,0
  0,0,0
  20
  0,0,0
  0,0,0
  20

  255
end
 first_time{0}=0
   goto GotMusic


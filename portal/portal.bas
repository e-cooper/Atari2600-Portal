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

 rem the game level
 dim level = l

 rem helps move the player
 dim p1_x = a
 dim p1_fall = f

 rem see which way the player is facing
 dim p1_left = d
 dim p1_right = d
 dim p1_steady = d
 dim p1_up = d
 dim p1_down = d

 rem see which missile was shot
 dim m0_shot = m
 dim m1_shot = m

 rem see which way missile0 is heading
 dim m0_left = i
 dim m0_right = i
 dim m0_steady = i
 dim m0_up = i
 dim m0_down = i

 rem see which way missile1 is heading
 dim m1_left = j
 dim m1_right = j
 dim m1_steady = j
 dim m1_up = j
 dim m1_down = j

 rem see which missiles are accessible
 dim m0_persistence = b
 dim m1_persistence = b

 rem setup the initial variables
 player1x = 24 : player1y = 80
 p1_right{1}=1 : p1_steady{2}=1 : score = 1
 missile0height = 6 : missile1height = 6
 ballheight = 0
 const font = alarmclock

 rem the player's beginning sprite
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

 goto level_select

level_select
 if z = 1 then score = score + 1
 z = 0
 on level gosub level1 level2
 goto mainloop

level1 
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXX...................X
 XXXXXXXXXXXX...................X
 XXXXXXXXXXXX...................X
 XXXXXXXXXXXX.......XXXX........X
 X..................XXXX........X
 X..................XXXX........X
 X........XX........XXXX........X
 X........XX........XXXX........X
 X........XX........XXXX.........
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 144 : bally = 75
 return

level2 
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXX........XX........X
 XXXXXXXXXXXXX........XX........X
 XXXXXXXXXXXXXXXX............XXXX
 X..............................X
 X..............................X
 X..........XX...XXXXXXXXX...XXXX
 XXX....XXXXXX..................X
 X..........XX..................X
 X..........XX..................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 ballx = 136 : bally = 20
 return

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
 if !collision(missile1,playfield) && m1_shot{1} && m1_left{0} && m1_steady{2} then missile1x = missile1x - 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_left{0} && m1_up{3} then missile1x = missile1x - 1 : missile1y = missile1y - 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_left{0} && m1_down{4} then missile1x = missile1x - 1 : missile1y = missile1y + 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_right{1} && m1_steady{2} then missile1x = missile1x + 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_right{1} && m1_up{3} then missile1x = missile1x + 1 : missile1y = missile1y - 1
 if !collision(missile1,playfield) && m1_shot{1} && m1_right{1} && m1_down{4} then missile1x = missile1x + 1 : missile1y = missile1y + 1

 rem see if missile0 has not collided and move it in the right direction
 if !collision(missile0,playfield) && m0_shot{0} && m0_left{0} && m0_steady{2} then missile0x = missile0x - 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_left{0} && m0_up{3} then missile0x = missile0x - 1 : missile0y = missile0y - 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_left{0} && m0_down{4} then missile0x = missile0x - 1 : missile0y = missile0y + 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_right{1} && m0_steady{2} then missile0x = missile0x + 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_right{1} && m0_up{3} then missile0x = missile0x + 1 : missile0y = missile0y - 1
 if !collision(missile0,playfield) && m0_shot{0} && m0_right{1} && m0_down{4} then missile0x = missile0x + 1 : missile0y = missile0y + 1

 rem check for portal collision and overwrite the initial portal with the new one
 if collision(missile0,missile1) && m0_shot{0} then missile1x = 255 : missile1y = 255 : m1_persistence{1}=0
 if collision(missile0, missile1) && m1_shot{1} then missile0x = 255 : missile0y = 255 : m0_persistence{0}=0

 rem check to see if a moving portal hit the playfield and if so then stop moving and make it active
 rem also disregard portals that are designated inactive
 if collision(missile1,playfield) && missile1x < 255 then m1_shot{1}=0 : m1_persistence{1}=1
 if collision(missile0,playfield) && missile0x < 255 then m0_shot{0}=0 : m0_persistence{0}=1

 rem see if the player is accessing a portal and change their position to the other one
 if collision(player1,missile0) && m1_persistence{1} then gosub player_pos1
 if collision(player1,missile1) && m0_persistence{0} then gosub player_pos0

 rem make sure the player moves correctly from side to side
 p1_x = 0
 if joy0left then p1_x = 255
 if joy0right then p1_x = 1
 player1x = player1x + p1_x

 rem joystick commands which change the sprite
 if joy0up && p1_left{0} && p1_steady{2} && e = 0 then gosub player_lup : e = 1
 if joy0up && p1_left{0} && p1_down{4} && e = 0 then gosub player_left : e = 1
 if joy0up && p1_right{1} && p1_steady{2} && e = 0 then gosub player_rup : e = 1
 if joy0up && p1_right{1} && p1_down{4} && e = 0 then gosub player_right : e = 1
 if joy0down && p1_left{0} && p1_steady{2} && e = 0 then gosub player_ldown : e = 1
 if joy0down && p1_left{0} && p1_up{3} && e = 0 then gosub player_left : e = 1
 if joy0down && p1_right{1} && p1_steady{2} && e = 0 then gosub player_rdown : e = 1
 if joy0down && p1_right{1} && p1_up{3} && e = 0 then gosub player_right : e = 1
 if joy0left && p1_steady{2} then gosub player_left
 if joy0left && p1_up{3} then gosub player_lup
 if joy0left && p1_down{4} then gosub player_ldown
 if joy0right && p1_steady{2} then gosub player_right
 if joy0right && p1_up{3} then gosub player_rup
 if joy0right && p1_down{4} then gosub player_rdown

 rem fire the missiles
 if joy0fire then gosub player_fire1
 if joy1fire then gosub player_fire0

 rem prevents the player from holding the direction to change position
 rem otherwise it is tough to go back to steady
 if !joy0up && !joy0down then e = 0

 rem change all this stuff if the level has been completed because the player collided with the ball
 if collision(player1,ball) then z = 1 : level = level + 1 : player1x = 24 : player1y = 80 : missile0x = 255 : missile0y = 255 : m0_persistence{0}=0 : missile1x = 240 : missile1y = 240 : m1_persistence{1}=0

 drawscreen

 rem player and playfield collision and gentle knockback
 if collision(player1,playfield) then gosub knock_player_back

 rem check for new level at each frame
 goto level_select

 rem fire missile1 in the right direction
player_fire1
 if p1_left{0} && p1_steady{2} then missile1x = player1x : missile1y = player1y - 1 : m1_left{0}=1 : m1_right{1}=0 : m1_steady{2}=1 : m1_up{3}=0 : m1_down{4}=0
 if p1_left{0} && p1_up{3} then missile1x = player1x : missile1y = player1y - 1 : m1_left{0}=1 : m1_right{1}=0 : m1_steady{2}=0 : m1_up{3}=1 : m1_down{4}=0
 if p1_left{0} && p1_down{4} then missile1x = player1x : missile1y = player1y - 1 : m1_left{0}=1 : m1_right{1}=0 : m1_steady{2}=0 : m1_up{3}=0 : m1_down{4}=1
 if p1_right{1} && p1_steady{2} then missile1x = player1x + 7 : missile1y = player1y - 1 : m1_left{0}=0 : m1_right{1}=1 : m1_steady{2}=1 : m1_up{3}=0 : m1_down{4}=0
 if p1_right{1} && p1_up{3} then missile1x = player1x + 7 : missile1y = player1y - 1 : m1_left{0}=0 : m1_right{1}=1 : m1_steady{2}=0 : m1_up{3}=1 : m1_down{4}=0
 if p1_right{1} && p1_down{4} then missile1x = player1x + 7 : missile1y = player1y - 1 : m1_left{0}=0 : m1_right{1}=1 : m1_steady{2}=0 : m1_up{3}=0 : m1_down{4}=1
 m1_shot{1} = 1
 return

 rem fire missile0 in the right direction
player_fire0
 if p1_left{0} && p1_steady{2} then missile0x = player1x : missile0y = player1y - 1 : m0_left{0}=1 : m0_right{1}=0 : m0_steady{2}=1 : m0_up{3}=0 : m0_down{4}=0
 if p1_left{0} && p1_up{3} then missile0x = player1x : missile0y = player1y - 1 : m0_left{0}=1 : m0_right{1}=0 : m0_steady{2}=0 : m0_up{3}=1 : m0_down{4}=0
 if p1_left{0} && p1_down{4} then missile0x = player1x : missile0y = player1y - 1 : m0_left{0}=1 : m0_right{1}=0 : m0_steady{2}=0 : m0_up{3}=0 : m0_down{4}=1
 if p1_right{1} && p1_steady{2} then missile0x = player1x + 7 : missile0y = player1y - 1 : m0_left{0}=0 : m0_right{1}=1 : m0_steady{2}=1 : m0_up{3}=0 : m0_down{4}=0
 if p1_right{1} && p1_up{3} then missile0x = player1x + 7 : missile0y = player1y - 1 : m0_left{0}=0 : m0_right{1}=1 : m0_steady{2}=0 : m0_up{3}=1 : m0_down{4}=0
 if p1_right{1} && p1_down{4} then missile0x = player1x + 7 : missile0y = player1y - 1 : m0_left{0}=0 : m0_right{1}=1 : m0_steady{2}=0 : m0_up{3}=0 : m0_down{4}=1
 m0_shot{0} = 1
 return

 rem left and steady sprite
player_left
 p1_left{0} = 1
 p1_right{1} = 0
 p1_steady{2} = 1
 p1_up{3} = 0 
 p1_down{4} = 0
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
 p1_left{0} = 0 
 p1_right{1} = 1
 p1_steady{2} = 1
 p1_up{3} = 0
 p1_down{4} = 0
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
 p1_left{0} = 1
 p1_right{1} = 0
 p1_steady{2} = 0
 p1_up{3} = 1
 p1_down{4} = 0
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
 p1_left{0} = 1
 p1_right{1} = 0
 p1_steady{2} = 0
 p1_up{3} = 0
 p1_down{4} = 1
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
 p1_left{0} = 0
 p1_right{1} = 1
 p1_steady{2} = 0
 p1_up{3} = 1
 p1_down{4} = 0
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
 p1_left{0} = 0
 p1_right{1} = 1
 p1_steady{2} = 0
 p1_up{3} = 0
 p1_down{4} = 1
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
 if m0_left{0} && m0_steady{2} then player1x = missile0x - 1 : player1y = missile0y
 if m0_left{0} && m0_up{3} then player1x = missile0x - 1 : player1y = missile0y + 4
 if m0_left{0} && m0_down{4} then player1x = missile0x - 1 : player1y = missile0y
 if m0_right{1} && m0_steady{2} then player1x = missile0x - 8 : player1y = missile0y
 if m0_right{1} && m0_up{3} then player1x = missile0x - 8 : player1y = missile0y + 4
 if m0_right{1} && m0_down{4} then player1x = missile0x - 8 : player1y = missile0y
 return

 rem this determines where she will spawn in relation to missile1 after going through missile 0
player_pos1
 if m1_left{0} && m1_steady{2} then player1x = missile1x - 1: player1y = missile1y
 if m1_left{0} && m1_up{3} then player1x = missile1x - 1 : player1y = missile1y + 4
 if m1_left{0} && m1_down{4} then player1x = missile1x - 1 : player1y = missile1y
 if m1_right{1} && m1_steady{2} then player1x = missile1x - 8 : player1y = missile1y
 if m1_right{1} && m1_up{3} then player1x = missile1x - 8 : player1y = missile1y + 4
 if m1_right{1} && m1_down{4} then player1x = missile1x - 8 : player1y = missile1y
 return





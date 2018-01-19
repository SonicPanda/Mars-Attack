%V 1.0 - Spaceship game, Ben and Michael
%In "cheat codes", type "pew pew" to have unlimited use of weapons
%Alternatively, you can type "fair play" to disable this cheat
setscreen ("offscreenonly,graphics:800,500")
View.Update

type coordinates :
record
    x, y : int
end record

type sprites :
record
    sprite, x1, x2, y1, y2, delaytime, speed, picnum, piccount, pic, waitcount, oncount,onupper,ondiv : int
    center : coordinates
    gif : array 1 .. 3 of int
    fieldgif : array 1 .. 11 of int
    health, hpdiv : real
    offx1, offx2, onscreen, on, off, alive : boolean
    model : string
end record

%General Variables
var hard, medium, easy, multiplayer, done, restart, quitgame,spacedone,nolimit,noasteroids,paused : boolean := false
var marsx:=maxx+40
var starttime:=0
var cheatcode,lowercaseAnswer:string:=""
var chars : array char of boolean
var oddeven : int := 8
var runcount,points : int := 0
var font, font1, titlefont, buttonfont : int
font := Font.New ("system:20")
font1 := Font.New ("system:15")
titlefont := Font.New ("system:30")
buttonfont := Font.New ("system:25")
%Asteroid variables
var astnum, astpic : int := 0
var astframes : int

astframes := Pic.Frames ("objects/asteroid.gif")

var astgif : array 1 .. astframes of int
var asteroid : flexible array 1 .. 0 of sprites
%Ship Variables
var ship : array 1 .. 2 of sprites
var numships := 1

%Projectile Variables
var lightsaber : array 1 .. 2 of sprites
var laserknife : array 1 .. 2 of sprites
var field : array 1 .. 2 of sprites
var knife : array 1 .. 2 of boolean

%Star Background Variables
type background :
record
    x1, x2, y, pic, width : int
end record

var stars : array 1 .. 2 of background

%constants
const longx1 := 30
const longx2 := 88
const longy := 10
const longhp := 3000
const longdelay := 15
const longspeed := 4

const fatshotx := 6
%both are under the ship
const fatshoty1 := 35
const fatshoty2 := 12

const smally1 := 5
const smally2 := 8
const smallx2 := 72
const smallx1 := 8
const smallhp := 2000
const smalldelay := 10
const smallspeed := 6

const faty1 := 15
const faty2 := 25
const fatx1 := 108
const fatx2 := 120
const fathp := 10000
const fatdelay := 30
const fatspeed := 2

const billx1 := 5
const billx2 := 35
const billy := 10

include "asteroid.t"
include "shootystuff.t"
include "start.t"

process PlayMusic
    loop
        Music.PlayFile("music/track1.wav")
        Music.PlayFile("music/track2.wav")
    end loop
end PlayMusic

proc LoadMars
    marsx-=4
    Pic.ScreenLoad("objects/mars.bmp",marsx,-20,picMerge)
    if marsx<maxx-100 then
        spacedone:=true
    end if
    View.Update
end LoadMars

%Spaceship Stuff
proc ShipInit (id : int)
    ship (id).picnum := 1
    ship (id).on := false
    ship (id).off := false
    ship (id).offx1 := false
    ship (id).offx2 := false
    ship (id).alive := true
    ship (id).delaytime := 0
    ship (id).oncount := 0
    ship (id).waitcount := 0
    if ship (id).model = "fat" then
        Pic.FileNewFrames ("objects/fatship1.gif", ship (id).gif, ship (id).delaytime)
        ship (id).sprite := Sprite.New (ship (id).gif (1))
        ship (id).health := fathp
        ship (id).hpdiv := 50
        ship (id).speed := fatspeed
        ship (id).piccount := 10
        ship(id).onupper:=500
        ship(id).ondiv:=5
        FieldInit (id)
    elsif ship (id).model = "long" then
        Pic.FileNewFrames ("objects/longship2.gif", ship (id).gif, ship (id).delaytime)
        ship (id).sprite := Sprite.New (ship (id).gif (1))
        ship (id).health := longhp
        ship (id).hpdiv := 15
        ship (id).speed := longspeed
        ship (id).piccount := 16
        ship(id).onupper:=400
        ship(id).ondiv:=4
        KnifeInit (id)
    elsif ship (id).model = "small" then
        Pic.FileNewFrames ("objects/smallship.gif", ship (id).gif, ship (id).delaytime)
        ship (id).sprite := Sprite.New (ship (id).gif (1))
        ship (id).health := smallhp
        ship (id).hpdiv := 10
        ship (id).speed := smallspeed
        ship (id).piccount := 8
        ship(id).onupper:=300
        ship(id).ondiv:=3
        LaserInit (id)
    end if
    Sprite.SetHeight (ship (id).sprite, 1)
    ship (id).center.x := 150
    ship (id).center.y := 150*id
end ShipInit

proc Init
    quitgame:=false
    restart:=false
    spacedone:=false
    marsx:=maxx+40
    starttime:=Time.Elapsed
    for i : 1 .. numships
        ShipInit (i)
    end for
        drawfillbox (0, maxy - 50, 240, maxy, gray)
    drawfillbox (10, maxy - 40, 210, maxy - 20, red)
    if multiplayer = true then
        drawfillbox (maxx - 240, maxy - 50, maxx, maxy, gray)
        drawfillbox (maxx - 210, maxy - 40, maxx - 10, maxy - 20, red)
    end if
    StarInit
end Init

proc SideCheck (id : int)
    if ship (id).model not= "fat" then
        if ship (id).y2 - 10 > maxy then
            ship (id).center.y := 0 + (ship (id).center.y - ship (id).y1) + 10
        elsif ship (id).y1 + 10 < 0 then
            ship (id).center.y := maxy + (ship (id).y2 - ship (id).center.y) - 10
        end if
    elsif ship (id).model = "fat" then
        if ship (id).y2 - 20 > maxy then
            ship (id).center.y := 0 + (ship (id).center.y - ship (id).y1) - 10
        elsif ship (id).y1 + 20 < 0 then
            ship (id).center.y := maxy + (ship (id).y2 - ship (id).center.y) - 30
        end if
    end if
    if ship (id).x1 <= 0 then
        ship (id).offx1 := true
    elsif ship (id).x1 > 0 then
        ship (id).offx1 := false
    end if
    if ship (id).x2 >= maxx then
        ship (id).offx2 := true
    elsif ship (id).x2 < maxx then
        ship (id).offx2 := false
    end if
end SideCheck

proc CrashCheck (id : int)
    for i : 1 .. numships
        %Checking if the ships crash into asteroids
        if ship (i).x1 < asteroid (id).x2 and ship (i).x2 > asteroid (id).x2 and ship (i).y1 < asteroid (id).y1 and ship (i).y2 > asteroid (id).y1 then
            ship (i).health -= 1
        end if
        if ship (i).x1 < asteroid (id).x1 and ship (i).x2 > asteroid (id).x1 and ship (i).y1 < asteroid (id).y1 and ship (i).y2 > asteroid (id).y1 then
            ship (i).health -= 1
        end if
        if ship (i).x1 < asteroid (id).x2 and ship (i).x2 > asteroid (id).x2 and ship (i).y1 < asteroid (id).y2 and ship (i).y2 > asteroid (id).y2 then
            ship (i).health -= 1
        end if
        if ship (i).x1 < asteroid (id).x1 and ship (i).x2 > asteroid (id).x1 and ship (i).y1 < asteroid (id).y2 and ship (i).y2 > asteroid (id).y2 then
            ship (i).health -= 1
        end if
        if ship (i).x2 > asteroid (id).x1 and ship (i).x1 < asteroid (id).x1 and ship (i).y1 < asteroid (id).y2 and ship (i).y2 > asteroid (id).y1 then
            ship (i).health -= 1
        end if
        if ship (i).model = "long" then
            %Checking if the laser touches an asteroid
            if laserknife (i).x1 < asteroid (id).x2 and laserknife (i).x2 > asteroid (id).x2 and laserknife (i).y1 < asteroid (id).y1 and laserknife (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
            if laserknife (i).x1 < asteroid (id).x1 and laserknife (i).x2 > asteroid (id).x1 and laserknife (i).y1 < asteroid (id).y1 and laserknife (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
            if laserknife (i).x1 < asteroid (id).x2 and laserknife (i).x2 > asteroid (id).x2 and laserknife (i).y1 < asteroid (id).y2 and laserknife (i).y2 > asteroid (id).y2 then
                ShotAst (id)
                points+=5
            end if
            if laserknife (i).x1 < asteroid (id).x1 and laserknife (i).x2 > asteroid (id).x1 and laserknife (i).y1 < asteroid (id).y2 and laserknife (i).y2 > asteroid (id).y2 then
                ShotAst (id)
                points+=5
            end if
            if laserknife (i).x2 > asteroid (id).x1 and laserknife (i).x1 < asteroid (id).x1 and laserknife (i).y1 < asteroid (id).y2 and laserknife (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
        elsif ship (i).model = "small" then
            if lightsaber (i).x1 < asteroid (id).x2 and lightsaber (i).x2 > asteroid (id).x2 and lightsaber (i).y1 < asteroid (id).y1 and lightsaber (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
            if lightsaber (i).x1 < asteroid (id).x1 and lightsaber (i).x2 > asteroid (id).x1 and lightsaber (i).y1 < asteroid (id).y1 and lightsaber (i).y2 > asteroid (id).y1 then
                points+=5
                ShotAst (id)
            end if
            if lightsaber (i).x1 < asteroid (id).x2 and lightsaber (i).x2 > asteroid (id).x2 and lightsaber (i).y1 < asteroid (id).y2 and lightsaber (i).y2 > asteroid (id).y2 then
                ShotAst (id)
                points+=5
            end if
            if lightsaber (i).x1 < asteroid (id).x1 and lightsaber (i).x2 > asteroid (id).x1 and lightsaber (i).y1 < asteroid (id).y2 and lightsaber (i).y2 > asteroid (id).y2 then
                ShotAst (id)
                points+=5
            end if
            if lightsaber (i).x2 > asteroid (id).x1 and lightsaber (i).x1 < asteroid (id).x1 and lightsaber (i).y1 < asteroid (id).y2 and lightsaber (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
        elsif ship (i).model = "fat" then
            if field (i).x1 < asteroid (id).x2 and field (i).x2 > asteroid (id).x2 and field (i).y1 < asteroid (id).y1 and field (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
            if field (i).x1 < asteroid (id).x1 and field (i).x2 > asteroid (id).x1 and field (i).y1 < asteroid (id).y1 and field (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                
            end if
            if field (i).x1 < asteroid (id).x2 and field (i).x2 > asteroid (id).x2 and field (i).y1 < asteroid (id).y2 and field (i).y2 > asteroid (id).y2 then
                ShotAst (id)
                points+=5
            end if
            if field (i).x1 < asteroid (id).x1 and field (i).x2 > asteroid (id).x1 and field (i).y1 < asteroid (id).y2 and field (i).y2 > asteroid (id).y2 then
                ShotAst (id)
                points+=5
            end if
            if field (i).x2 > asteroid (id).x1 and field (i).x1 < asteroid (id).x1 and field (i).y1 < asteroid (id).y2 and field (i).y2 > asteroid (id).y1 then
                ShotAst (id)
                points+=5
            end if
        end if
    end for
end CrashCheck

proc ShipDead (id : int)
    ship (id).center.y := 1000
    ship (id).center.x := 1000
    Sprite.Animate (ship (id).sprite, ship (id).gif (ship (id).picnum), ship (id).center.x, ship (id).center.y, true)
    Sprite.Show (ship (id).sprite)
end ShipDead

proc DeadScreen
    var x, y, z : int
    loop
        MoveStar
        Font.Draw ("You died! Play Again?", 200, maxy - 60, titlefont, white)
        drawbox (120, 130, 280, 195, white)
        Font.Draw ("Yes", 150, 150, titlefont, white)
        drawbox (maxx - 120, 130, maxx - 280, 195, white)
        Font.Draw ("No", maxx - 230, 150, titlefont, white)
        if buttonmoved ("down") then
            buttonwait ("down", x, y, z, z)
            if ptinrect (x, y, 120, 130, 280, 195) then
                restart := true
            elsif ptinrect (x, y, maxx - 280, 130, maxx - 120, 195) then
                quitgame := true
            end if
        end if
        
        View.Update
        cls
    end loop
end DeadScreen

proc BarStuff
Font.Draw(intstr(round(40-(Time.Elapsed-starttime)/1000)),maxx div 2 -20, maxy-50,titlefont,white)
Font.Draw("seconds to Mars",maxx div 2-100,maxy-80,buttonfont,white)
    drawfillbox (0, maxy - 70, 240, maxy, gray)
    drawfillbox (10, maxy - 30, 10 + (ship (1).health div ship (1).hpdiv), maxy - 20, 40)
    Font.Draw ("player 1", 20, maxy - 20, font, white)
    if ship (1).off = true then
        drawfillbox(10,maxy-45,10+(ship(1).waitcount div 3),maxy-35,53)
        Font.Draw ("Weapon charging", 10, maxy - 50, font1, white)
    else 
        drawfillbox(10,maxy-45,10+(ship(1).onupper-ship(1).oncount)div ship(1).ondiv,maxy-35,53)
        Font.Draw ("Weapon Ready", 10, maxy - 50, font1, white)
    end if
    if multiplayer = true then
        drawfillbox (maxx - 240, maxy - 70, maxx, maxy, gray)
        drawfillbox (maxx - 210, maxy - 30, maxx - 210 + (round (ship (2).health / ship (2).hpdiv)), maxy - 20, 40)
        Font.Draw ("player 2", maxx - 200, maxy - 20, font, white)
        if ship (2).off = true then
            drawfillbox(maxx-210,maxy-45,maxx-210+(ship(2).waitcount div 3),maxy-35,53)
            Font.Draw ("Weapon charging", maxx - 210, maxy - 50, font1, white)
        else
            drawfillbox(maxx-210,maxy-45,maxx-210+(ship(2).onupper-ship(2).oncount)div ship(2).ondiv,maxy-35,53)
            Font.Draw ("Weapon Ready", maxx - 210, maxy - 50, font1, white)
        end if
    end if
    for i : 1 .. numships
        if ship (i).health <= 0 then
            ship (i).alive := false
            ShipDead (i)
        end if
    end for
        if multiplayer = true then
        if ship (1).alive = false and ship (2).alive = false then
            DeadScreen
        end if
    elsif multiplayer = false then
        if ship (1).alive = false then
            DeadScreen
        end if
    end if
end BarStuff

proc SetPositions
    for i : 1 .. numships
        if ship (i).model = "fat" then
            ship (i).x1 := ship (i).center.x - fatx1
            ship (i).x2 := ship (i).center.x + fatx2
            ship (i).y1 := ship (i).center.y - faty1
            ship (i).y2 := ship (i).center.y + faty2
        elsif ship (i).model = "long" then
            ship (i).x1 := ship (i).center.x - longx1
            ship (i).x2 := ship (i).center.x + longx2
            ship (i).y1 := ship (i).center.y - longy
            ship (i).y2 := ship (i).center.y + longy
        elsif ship (i).model = "small" then
            ship (i).x1 := ship (i).center.x - smallx1
            ship (i).x2 := ship (i).center.x + smallx2
            ship (i).y1 := ship (i).center.y - smally1
            ship (i).y2 := ship (i).center.y + smally2
        end if
    end for
end SetPositions

proc Pause
    var x,y,z:int
    paused:=true
    delay(50)
    loop
        MoveStar
        for i:1..3
            drawbox(maxx div 2-90,100+i*80,maxx div 2+90,160+i*80,white)
        end for
            Font.Draw("Cheats",maxx div 2 -70,100+175,titlefont,white)
        Font.Draw("Continue",maxx div 2-85,100+95,titlefont,white)
        Font.Draw("Quit",maxx div 2-60,100+255,titlefont,white)
        Input.KeyDown (chars)
        if buttonmoved("down")then
            buttonwait("down",x,y,z,z)
            if ptinrect (x,y,maxx div 2-90,100+80,maxx div 2+90,160+80) then
                exit
            elsif ptinrect(x,y,maxx div 2-90, 100+160,maxx div 2+90, 320)then
                GetCheats
            elsif ptinrect(x,y,maxx div 2-90,100+3*80,maxx div 2+90,160+3*80)then
            restart:=true
            delay(100)
            exit
            end if
        end if
        View.Update
        delay(50)
    end loop
    paused:=false
end Pause

proc InputStuff
    Input.KeyDown (chars)
    if chars (KEY_UP_ARROW) then
        ship (1).center.y += ship (1).speed
    end if
    if chars (KEY_DOWN_ARROW) then
        ship (1).center.y -= ship (1).speed
    end if
    if chars (KEY_LEFT_ARROW) and ship (1).offx1 = false then
        ship (1).center.x -= ship (1).speed
    end if
    if chars (KEY_RIGHT_ARROW) and ship (1).offx2 = false then
        ship (1).center.x += ship (1).speed
    end if
    if chars (KEY_CTRL) then
        ShootWhat (1)
    elsif ship (1).model = "long" then
        ship (1).on := false
        KnifeCheck (1)
        if ship (1).off = true then
            ship (1).waitcount += 1
        end if
    elsif ship (1).model = "small" then
        ship (1).on := false
        LaserCheck (1)
        if ship (1).off = true then
            ship (1).waitcount += 1
        end if
    elsif ship (1).model = "fat" then
        ship (1).on := false
        FieldCheck (1)
        if ship (1).off = true then
            ship (1).waitcount += 1
        end if
    end if
    if chars (KEY_ESC) then
        Pause
    end if
    if multiplayer = true then
        if chars ('w') then
            ship (2).center.y += ship (2).speed
        end if
        if chars ('s') then
            ship (2).center.y -= ship (2).speed
        end if
        if chars ('a') and ship (2).offx1 = false then
            ship (2).center.x -= ship (2).speed
        end if
        if chars ('d') and ship (2).offx2 = false then
            ship (2).center.x += ship (2).speed
        end if
        if chars (' ') then
            ShootWhat (2)
        elsif ship (2).model = "long" then
            ship (2).on := false
            KnifeCheck (2)
            if ship (2).off = true then
                ship (2).waitcount += 1
            end if
        elsif ship (2).model = "small" then
            ship (2).on := false
            LaserCheck (2)
            if ship (2).off = true then
                ship (2).waitcount += 1
            end if
        elsif ship (2).model = "fat" then
            ship (2).on := false
            FieldCheck (2)
            if ship (2).off = true then
                ship (2).waitcount += 1
            end if
        end if
    end if
    for id : 1 .. numships
        if ship (id).waitcount >= 300 then
            ship (id).off := false
            ship (id).waitcount := 0
            ship (id).oncount := 0
        end if
    end for
end InputStuff

proc PlayGame
    fork PlayMusic
    loop
        StartScreen
        Init
        fork asteroidstuff
        loop
            runcount += 1
            BarStuff
            %Loading Mars on the screen
            if Time.Elapsed-starttime>40000 then
                LoadMars
            end if
            exit when restart = true or spacedone=true
            View.Update
            InputStuff
            SetPositions
            for i : 1 .. numships
                SideCheck (i)
            end for
                for k : 1 .. numships
                Sprite.Animate (ship (k).sprite, ship (k).gif (ship (k).picnum), ship (k).center.x, ship (k).center.y, true)
                Sprite.Show (ship (k).sprite)
            end for
                oddeven += 1
            if oddeven > 100 then
                oddeven := 1
            end if
            for i : 1 .. numships
                if oddeven mod ship (i).piccount = 0 then
                    ship (i).picnum += 1
                    if ship (i).picnum > 3 then
                        ship (i).picnum := 1
                    end if
                end if
            end for
                for i : 1 .. upper (asteroid)
                AstCoord (i)
                CrashCheck (i)
            end for
                MoveStar
        end loop
        Font.Draw("You made it to Mars!",200,maxy-200,titlefont,white)
        View.Update
        delay(1000)
        if spacedone=true then
        end if
        loop
            if noasteroids=true then
                for i:1..numships
                    Sprite.Free(ship(i).sprite)
                    if ship(i).model="fat" then
                        Sprite.Free(field(i).sprite)
                    elsif ship(i).model="long" then
                        Sprite.Free(laserknife(i).sprite)
                    elsif ship(i).model="small" then
                        lightsaber(i).center.x:=1000
                        lightsaber(i).center.y:=1000
                        View.Update
                    end if
                end for
                    for i:1..upper(asteroid)
                    %Sprite.Free(asteroid(i).sprite)
                    Sprite.Animate (asteroid(i).sprite, astgif(1), 1000, 1000, true)
                    Sprite.Show (asteroid(i).sprite)
                end for
                    exit
            end if
            delay(50)
        end loop
        exit when quitgame = true
    end loop
end PlayGame

%Debugging stuff
var fieldarray : array 1 .. 11 of int
proc wherefat
    Pic.FileNewFrames ("objects/longship2.gif", ship (1).gif, ship (1).delaytime)
    ship (1).sprite := Sprite.New (ship (1).gif (1))
    Sprite.SetHeight (ship (1).sprite, 0)
    loop
        for i : 1 .. 11
            Sprite.Animate (ship (1).sprite, ship (1).gif (i), maxx div 2, maxy div 2, true)
            Sprite.Show (ship (1).sprite)
            ship (1).center.x := maxx div 2
            ship (1).center.y := maxy div 2
            drawdot (maxx div 2, maxy div 2, yellow)
            drawbox (maxx div 2 - 30, maxy div 2 - 38, maxx div 2 + 88, maxy div 2 + 88, yellow)
            delay (40)
        end for
    end loop
end wherefat
proc testlaser
    Pic.ScreenLoad ("objects/bluelaser.bmp", maxx div 2, maxy div 2, picCopy)
    View.Update
    drawbox (maxx div 2, maxy div 2, maxx div 2 + 195, maxy div 2 + 5, yellow)
end testlaser
PlayGame
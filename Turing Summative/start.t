%Background Stars Moving
function ptinrect (h, v, x1, v1, x2, v2 : int) : boolean
    result (h > x1) and (h < x2) and (v > v1) and (v < v2)
end ptinrect

proc StarInit
    for i : 1 .. 2
        stars (i).pic := Pic.FileNew ("notsprite/stars" + intstr (i) + ".bmp")
        stars (i).width := Pic.Width (stars (i).pic)
        randint (stars (i).y, -30, 0)
    end for
        stars (1).x1 := -20
    stars (1).x2 := stars (1).x1 + stars (1).width
    stars (2).x1 := stars (1).x2
    stars (2).x2 := stars (2).x1 + stars (2).width
end StarInit

proc MoveStar
    for i : 1 .. 2
        stars (i).x1 -= 1
        stars (i).x2 := stars (i).x1 + stars (i).width
        Pic.Draw (stars (i).pic, stars (i).x1, stars (i).y, picCopy)
    end for
        if stars (1).x2 <= 0 then
        stars (1).x1 := stars (2).x2
        randint (stars (1).y, -30, 0)
    elsif stars (2).x2 <= 0 then
        stars (2).x1 := stars (1).x2
        randint (stars (2).y, -30, 0)
    end if
end MoveStar

procedure LowerCase
    lowercaseAnswer := ""
    for i : 1 .. length (cheatcode)
        if ord (cheatcode (i)) >= 65 and ord (cheatcode (i)) <= 90 then
            lowercaseAnswer += chr (ord (cheatcode (i)) + 32)
        else
            lowercaseAnswer += cheatcode (i)
        end if
    end for
end LowerCase

proc PickShip
    var sprite1, sprite2, sprite3, pic, delaytime, evenodd, x, y, z : int
    var gif1, gif2, gif3 : array 1 .. 3 of int
    var picked : boolean := false
    pic := 1
    evenodd := 0
    delaytime := 0
    Pic.FileNewFrames ("objects/fatship1.gif", gif1, delaytime)
    sprite1 := Sprite.New (gif1 (1))
    Pic.FileNewFrames ("objects/longship2.gif", gif2, delaytime)
    sprite2 := Sprite.New (gif2 (1))
    Pic.FileNewFrames ("objects/smallship.gif", gif3, delaytime)
    sprite3 := Sprite.New (gif3 (1))
    for i : 1 .. numships
        loop
            MoveStar
            if multiplayer=true then
                Font.Draw("Player "+intstr(i)+": Pick Your Ship",200,maxy-50,titlefont,white)
            else
                Font.Draw("Pick Your Ship",300,maxy-50,titlefont,white)
            end if
            picked:=false
            evenodd += 1
            if evenodd mod 10 = 0 then
                pic += 1
                if pic > 3 then
                    pic := 1
                end if
            end if
            drawbox (150 - 125, 160, 150 + 125, 90, white)
            drawbox (410 - 80, 140, 410 + 95, 100, white)
            drawbox (580, 140, 740, 100, white)
            Sprite.Animate (sprite1, gif1 (pic), 150, 120, true)
            Sprite.Show (sprite1)
            Sprite.Animate (sprite2, gif2 (pic), 410, 120, true)
            Sprite.Show (sprite2)
            Sprite.Animate (sprite3, gif3 (pic), 660, 120, true)
            Sprite.Show (sprite3)
            if buttonmoved ("down") then
                buttonwait ("down", x, y, z, z)
                if ptinrect (x, y, 150 - 125, 90, 150 + 125, 160) then
                    ship (i).model := "fat"
                    picked := true
                elsif ptinrect (x, y, 410 - 80, 100, 410 + 95, 140) and z = 1 then
                    ship (i).model := "long"
                    picked := true
                elsif ptinrect (x, y, 580, 100, 740, 140) and z = 1 then
                    ship (i).model := "small"
                    picked := true
                end if
            end if
            View.Update
            cls
            exit when picked = true
        end loop
    end for
        Sprite.Free (sprite1)
    Sprite.Free (sprite2)
    Sprite.Free (sprite3)
end PickShip

proc Instructions
    var x,y,z,healthfont:int
    var doneinstructions,back:boolean:=false
    healthfont:=Font.New("system:25")
    cls
    doneinstructions:=false
    loop
        back:=false
        loop
            cls
            MoveStar
            Font.Draw("Instructions",300,maxy-50,titlefont,white)
            Font.Draw("Player 1", 100,maxy-100,titlefont,white)
            Font.Draw("Player 2", maxx - 250, maxy-100,titlefont,white)
            Font.Draw("WASD to move", 60,maxy-150,titlefont,white)
            Font.Draw("CTRL to shoot", 60,maxy-200,titlefont,white)
            Font.Draw("Arrows to move", maxx-310,maxy-150,titlefont,white)
            Font.Draw("SPACE to shoot", maxx-310,maxy-200,titlefont,white)
            Font.Draw("ESC to pause", maxx div 2 - 100,maxy-300,titlefont, white)
            Font.Draw("Survive 40 seconds to make it to mars",175,maxy-350,buttonfont,white)
            drawbox(maxx div 2-190, 70,maxx div 2-20,120,white)
            drawbox(maxx div 2-10,70,maxx div 2+170,120,white)
            Font.Draw("Exit",maxx div 2-180, 80, titlefont, white)
            Font.Draw("Next",maxx div 2,80,titlefont,white)
            View.Update 
            if buttonmoved("down") then
                buttonwait("down",x,y,z,z)
                if ptinrect(x,y,maxx div 2-190, 70,maxx div 2-20,120)then
                    doneinstructions:=true
                elsif ptinrect(x,y,maxx div 2-10,70,maxx div 2+170,120)then
                    exit
                end if
            end if
            exit when doneinstructions=true
        end loop
        loop
            cls
            MoveStar
            Font.Draw("Instructions",300,maxy-50,titlefont,white)
            Font.Draw("The red bar is health",200,maxy-100,titlefont,white)
            Font.Draw("The blue bar is your weapon's charge",150,maxy-150,healthfont,white)
            drawbox(maxx div 2-190, 70,maxx div 2-20,120,white)
            drawbox(maxx div 2-10,70,maxx div 2+170,120,white)
            Font.Draw("Exit",maxx div 2-180, 80, titlefont, white)
            Font.Draw("Go Back",maxx div 2,80,titlefont,white)
            View.Update
            if buttonmoved("down") then
                buttonwait("down",x,y,z,z)
                if ptinrect(x,y,maxx div 2-190, 70,maxx div 2-20,120)then         
                doneinstructions:=true 
                   exit  
                elsif ptinrect(x,y,maxx div 2-10,70,maxx div 2+170,120)then
                  exit
                end if
            end if
        end loop
        exit when doneinstructions=true
    end loop
end Instructions

proc GetCheats
    var x,y,z:int
    var temp:string
    cls
    done:=false
    loop
        cheatcode:=""
        loop
            temp:=""
            lowercaseAnswer:=""
            Pic.ScreenLoad("notsprite/cheatpage.bmp",0,0,picCopy)
            Input.KeyDown(chars)
            for i:65..90
                if chars(chr(i))then 
                    cheatcode+=(chr(i))
                elsif chars(chr(i+32)) then
                    cheatcode+=(chr(i+32))
                    delay(10)
                end if
            end for
                %drawbox(290,0,520,100,white)
            if length(cheatcode)>0 then
                Font.Draw(cheatcode,200,200,buttonfont,white)
            end if
            if chars(KEY_ENTER) then
                exit
            elsif chars(' ') then
                cheatcode+=" "
            elsif chars(KEY_BACKSPACE)then
                for i:1..length(cheatcode)-1
                    temp+=cheatcode(i)
                end for
                    cheatcode:=temp
            end if
            if buttonmoved("down") then
                buttonwait("down",x,y,z,z)
                if ptinrect(x,y,290,0,520,100)then
                    done:=true
                    exit
                end if
            end if
            View.Update
            delay(75)
        end loop
        
        if length(cheatcode)>0 then
            LowerCase
        end if
        if index(lowercaseAnswer,"pew pew")=1then
            Font.Draw("cheat code recognized",200,maxy-250,titlefont,white)
            nolimit:=true
        elsif index(lowercaseAnswer,"fair play")=1 then
            Font.Draw("cheat code recognized",200,maxy-250,titlefont,white)
            nolimit:=false
        elsif length(cheatcode)>0 then
            Font.Draw("cheat not recognized",200,maxy-250,titlefont,white)
        else
        end if
        View.Update
        delay(200)
        cls
        if buttonmoved("down") then
            buttonwait("down",x,y,z,z)
            if ptinrect(x,y,290,0,520,100)then
                done:=true
            end if
        end if
        exit when done=true
    end loop
end GetCheats

proc StartScreen
    var x, y, z : int
    var startfont:int:=Font.New("system:50")
    StarInit
    loop
        MoveStar
        Font.Draw ("Journey to Mars", 200, maxy - 60, startfont, white)
        drawbox (120, 130, 280, 195, white)
        Font.Draw ("Instructions", 125, 150, buttonfont, white)
        drawbox (maxx - 200, 130, maxx - 360, 195, white)
        drawbox (maxx - 180, 130, maxx - 20, 195, white)
        drawbox(300,130,420,195,white)
        Font.Draw("Cheats",305,150,buttonfont,white)
        Font.Draw ("One Player", maxx - 350, 150, buttonfont, white)
        Font.Draw ("Two Player", maxx - 170, 150, buttonfont, white)
        if buttonmoved ("down") then
            buttonwait ("down", x, y, z, z)
            if ptinrect (x, y, 120, 130, 280, 195) then
                Instructions
            elsif ptinrect(x,y,300,130,420,195) then
                GetCheats
            elsif ptinrect (x, y, maxx - 360, 130, maxx - 200, 195) then
                multiplayer := false
                exit
            elsif ptinrect (x, y, maxx - 180, 130, maxx - 20, 195) then
                multiplayer := true
                exit
            end if
        end if
        View.Update
        cls
    end loop
    if multiplayer = true then
        numships := 2
    else
        numships := 1
    end if
    PickShip
end StartScreen

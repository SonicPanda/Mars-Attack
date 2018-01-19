% asteroid generation and collision detection

proc AstCoord(id:int)
    asteroid(id).x1:=asteroid(id).center.x-35
    asteroid(id).x2:=asteroid(id).center.x+35
    asteroid(id).y1:=asteroid(id).center.y-35
    asteroid(id).y2:=asteroid(id).center.y+35
end AstCoord

proc InitAst(id:int)
    asteroid(id).center.x:=maxx+40
    randint(asteroid(id).center.y,0,450)
    randint(asteroid(id).speed,10,20)
end InitAst

proc NewAst(id:int)
    asteroid(id).delaytime:=0
    Pic.FileNewFrames("objects/asteroid.gif",astgif,asteroid(id).delaytime)
    asteroid(id).sprite:=Sprite.New(astgif(1))
    Sprite.SetHeight(asteroid(id).sprite,2)
end NewAst

proc DrawAst
    astpic+=1
    if astpic>astframes then
        astpic:=1
    end if
    for i:1..upper(asteroid)
        asteroid(i).center.x-=asteroid(i).speed
        if asteroid(i).center.x<=-40 then
            InitAst(i)
        end if
        Sprite.Animate(asteroid(i).sprite,astgif(astpic),asteroid(i).center.x,asteroid(i).center.y,true)
        Sprite.Show(asteroid(i).sprite)
        delay(10)
    end for
end DrawAst

process asteroidstuff
    runcount:=1
    astnum:=0
    noasteroids:=false
    loop
        if runcount mod 20=0 or runcount=1 then
            if astnum=7 then
                astnum:=7
            else
                astnum+=1
                new asteroid,astnum
                NewAst(astnum)
                InitAst(astnum)
            end if
        end if
        if paused=true then
            loop
                if paused = false then
                    exit
                end if
            end loop
        end if
        if spacedone=true or restart = true or quitgame=true then
            exit
        else
            DrawAst
        end if
    end loop
    noasteroids:=true
end asteroidstuff

proc ShotAst(id:int)
    InitAst(id)
end ShotAst

proc whereast
    new asteroid,1
    asteroid(1).delaytime:=0
    Pic.FileNewFrames("objects/asteroid.gif",astgif,asteroid(1).delaytime)
    asteroid(1).sprite:=Sprite.New(astgif(1))
    InitAst(1)
    loop
        for i:1..astframes
            Sprite.Animate(asteroid(1).sprite,astgif(i),maxx div 2,maxy div 2,true)
            Sprite.Show(asteroid(1).sprite)
            drawdot(maxx div 2,maxy div 2,yellow)
            drawbox(maxx div 2-35,maxy div 2-35,maxx div 2+35,maxy div 2+35,yellow)
            delay(10)
        end for
    end loop
end whereast
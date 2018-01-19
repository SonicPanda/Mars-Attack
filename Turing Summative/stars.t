setscreen("offscreenonly")
colorback(black)
class star
    export setplace, movestar
    var starx,stary,start:int

    proc setplace
        randint(starx,5,maxx-5)
        randint(stary,5,maxy-5)
        start:=maxx-(maxx-starx)
    end setplace
    
    process movestar
        for i:1..start
            drawdot(starx-(i-1),stary,white)
            delay(5)
            drawdot(starx-(i-1),stary,black)
            delay(5)
            View.Update
        end for
    end movestar
end star

var stars:array 1..30 of ^star
proc initstars
for i:1..upper(stars)
new stars(i)
end for
end initstars

loop
initstars
for i:1..30
stars(i)->setplace
end for
for i:1..5
fork stars(i)->movestar
end for
end loop

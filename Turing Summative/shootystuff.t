%Procedures that shoot stuff

proc FieldInit (id : int)
    field (id).on := false
    field (id).off := false
    field (id).oncount := 0
    field (id).waitcount := 0
    field (id).delaytime := 0
    Pic.FileNewFrames ("objects/field1.gif", field (id).fieldgif, field (id).delaytime)
    field (id).sprite := Sprite.New (field (id).fieldgif (1))
    Sprite.SetHeight (field (id).sprite, 1)
    field (id).picnum := 1
    field (id).piccount := 8
    field (id).center.x := 1000
    field (id).center.y := 1000
    field (id).x1 := field (id).center.x - 25
    field (id).x2 := field (id).center.x + 15
    field (id).y1 := field (id).center.y - 38
    field (id).y2 := field (id).center.y + 38
end FieldInit

proc KnifeInit (i : int)
    knife (i) := false
    laserknife (i).off := false
    laserknife (i).delaytime := 0
    laserknife (i).oncount := 0
    laserknife (i).waitcount := 0
    Pic.FileNewFrames ("objects/laserknife1.gif", laserknife (i).gif, laserknife (i).delaytime)
    laserknife (i).sprite := Sprite.New (laserknife (i).gif (1))
    Sprite.SetHeight (laserknife (i).sprite, 1)
    laserknife (i).picnum := 1
    laserknife (i).piccount := 8
    laserknife (i).center.x := 1000
    laserknife (i).center.y := 1000
    laserknife (i).x1 := laserknife (i).center.x
    laserknife (i).x2 := laserknife (i).center.x + 82
    laserknife (i).y1 := laserknife (i).center.y + 7
    laserknife (i).y2 := laserknife (i).center.y + 23
end KnifeInit

proc LaserInit (id : int)
    lightsaber (id).on := false
    lightsaber (id).off := false
    lightsaber (id).oncount := 0
    lightsaber (id).waitcount := 0
    lightsaber (id).pic := Pic.FileNew ("objects/bluelaser.bmp")
    lightsaber (id).sprite := Sprite.New (lightsaber (id).pic)
    Sprite.SetHeight (lightsaber (id).sprite, 1)
    lightsaber (id).center.x := 1000
    lightsaber (id).center.y := 1000
    lightsaber (id).x1 := lightsaber (id).center.x
    lightsaber (id).x2 := lightsaber (id).center.x + 195
    lightsaber (id).y1 := lightsaber (id).center.y
    lightsaber (id).y2 := lightsaber (id).center.y + 5
end LaserInit

proc LaserKnife (id : int)
    laserknife (id).on := true
    if oddeven mod laserknife (id).piccount = 0 then
        laserknife (id).picnum += 1
        if laserknife (id).picnum > 3 then
            laserknife (id).picnum := 1
        end if
    end if
    laserknife (id).center.x := ship (id).x2 + 7
    laserknife (id).center.y := ship (id).center.y - 13
    laserknife (id).x1 := laserknife (id).center.x
    laserknife (id).x2 := laserknife (id).center.x + 82
    laserknife (id).y1 := laserknife (id).center.y + 7
    laserknife (id).y2 := laserknife (id).center.y + 23
    Sprite.Animate (laserknife (id).sprite, laserknife (id).gif (laserknife (id).picnum), laserknife (id).center.x, laserknife (id).center.y, false)
    Sprite.Show (laserknife (id).sprite)
    laserknife (id).oncount += 1
end LaserKnife

proc ShootLaser (id : int)
    lightsaber (id).on := true
    lightsaber (id).center.x := ship (id).x2 - 3
    lightsaber (id).center.y := ship (id).center.y - 6
    lightsaber (id).x1 := lightsaber (id).center.x
    lightsaber (id).x2 := lightsaber (id).center.x + 195
    lightsaber (id).y1 := lightsaber (id).center.y
    lightsaber (id).y2 := lightsaber (id).center.y + 5
    Sprite.Animate (lightsaber (id).sprite, lightsaber (id).pic, lightsaber (id).center.x, lightsaber (id).center.y, false)
    Sprite.Show (lightsaber (id).sprite)
    lightsaber (id).oncount += 1
end ShootLaser

proc ForceField (id : int)
    field (id).on := true
    if oddeven mod field (id).piccount = 0 then
        field (id).picnum += 1
        if field (id).picnum > 11 then
            field (id).picnum := 1
        end if
    end if
    field (id).center.x := ship (id).x2
    field (id).center.y := ship (id).center.y + 3
    field (id).x1 := field (id).center.x - 25
    field (id).x2 := field (id).center.x + 15
    field (id).y1 := field (id).center.y - 38
    field (id).y2 := field (id).center.y + 38
    Sprite.Animate (field (id).sprite, field (id).fieldgif (field (id).picnum), field (id).center.x, field (id).center.y, true)
    Sprite.Show (field (id).sprite)
    field (id).oncount += 1
end ForceField

proc KnifeCheck (i : int)
    if ship (i).on = false then
        laserknife (i).center.x := 1000
        laserknife (i).center.y := 1000
        laserknife (i).x1 := laserknife (i).center.x
        laserknife (i).x2 := laserknife (i).center.x + 82
        laserknife (i).y1 := laserknife (i).center.y + 7
        laserknife (i).y2 := laserknife (i).center.y + 23
        Sprite.Animate (laserknife (i).sprite, laserknife (i).gif (laserknife (i).picnum), laserknife (i).center.x, laserknife (i).center.y, false)
        Sprite.Show (laserknife (i).sprite)
    end if
end KnifeCheck

proc LaserCheck (id : int)
    if ship (id).on = false then
        lightsaber (id).center.x := 1000
        lightsaber (id).center.y := 1000
        lightsaber (id).x1 := lightsaber (id).center.x
        lightsaber (id).x2 := lightsaber (id).center.x + 195
        lightsaber (id).y1 := lightsaber (id).center.y
        lightsaber (id).y2 := lightsaber (id).center.y + 5
        Sprite.Animate (lightsaber (id).sprite, lightsaber (id).pic, lightsaber (id).center.x, lightsaber (id).center.y, false)
        Sprite.Show (lightsaber (id).sprite)
    end if
end LaserCheck

proc FieldCheck (id : int)
    if ship (id).on = false then
        field (id).center.x := 1000
        field (id).center.y := 1000
        field (id).x1 := field (id).center.x
        field (id).x2 := field (id).center.x + 195
        field (id).y1 := field (id).center.y
        field (id).y2 := field (id).center.y + 5
        Sprite.Animate (field (id).sprite, field (id).fieldgif (1), field (id).center.x, field (id).center.y, false)
        Sprite.Show (field (id).sprite)
    end if
end FieldCheck


proc ShootWhat (id : int)
    ship (id).oncount += 1
    if ship (id).model = "fat" then
        if nolimit=false then
            if ship (id).oncount >= 500 then
                ship (id).waitcount += 1
                ship (id).on := false
                ship (id).off := true
                FieldCheck (id)
                if ship (id).waitcount >= 300 then
                    ship (id).off := false
                    ship (id).waitcount := 0
                    ship (id).oncount := 0
                end if
            else
                ForceField (id)
            end if
        else
            ForceField(id)
        end if
    elsif ship (id).model = "long" then
        if nolimit=false then
            if ship (id).oncount >= 400 then
                ship (id).waitcount += 1
                ship (id).on := false
                ship (id).off := true
                KnifeCheck (id)
                if ship (id).waitcount >= 300 then
                    ship (id).off := false
                    ship (id).waitcount := 0
                    ship (id).oncount := 0
                end if
            else
                LaserKnife (id)
            end if
        else
            LaserKnife(id)
        end if
    elsif ship (id).model = "small" then
        if nolimit=false then
            if ship (id).oncount >= 300 then
                ship (id).waitcount += 1
                ship (id).on := false
                ship (id).off := true
                LaserCheck (id)
                if ship (id).waitcount >= 300 then
                    ship (id).off := false
                    ship (id).waitcount := 0
                    ship (id).oncount := 0
                end if
            else
                ShootLaser (id)
            end if
        else
            ShootLaser(id)
        end if
    end if
end ShootWhat


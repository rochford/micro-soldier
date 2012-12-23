/*
    This file is part of Micro Soldier.

    Foobar is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Micro Soldier.  If not, see <http://www.gnu.org/licenses/>.
  */
function dead(e, x, y) {
    if (((e.x > (x-10) ) && e.x < (x+10)) && ((e.y > (y-10) ) && e.y < (y+10)))
        return true;
    else
        return false;
}

function check_mine_explode(e, x, y) {
    if (((e.x > (x-10) ) && e.x < (x+10)) && ((e.y > (y-10) ) && e.y < (y+10)))
        return true;
    else
        return false;
}

function shoot(x, y) {
    if (gameFinishedDelay.running)
        return
    // check that the distance is not too far
    var minX = soldiers.itemAt(focusedSolider).x - shootRange
    var maxX = soldiers.itemAt(focusedSolider).x + shootRange
    var minY = soldiers.itemAt(focusedSolider).y - shootRange
    var maxY = soldiers.itemAt(focusedSolider).y + shootRange
    if ( (minX < x) && (x < maxX)
            && (minY < y) && (y < maxY) ) {
        bullet.x = x
        bullet.y = y
        bullet.visible = true;
        bulletTimer.start()
        for (var i=0; i<n2.count; i++) {
            if (GameState.dead(n2.itemAt(i),x,y))
                n2.itemAt(i).state = "dead";
        }
        for (var i=0; i<civilian_repeater.count; i++) {
            if (GameState.dead(civilian_repeater.itemAt(i),x,y))
                civilian_repeater.itemAt(i).state = "dead";
        }
        for (var i=0; i<mine_repeater.count; i++) {
            if ((mine_repeater.itemAt(i).state === "active") && GameState.check_mine_explode(mine_repeater.itemAt(i),x,y))
                mine_repeater.itemAt(i).state = "exploded";
        }
    }
}

function gameInitialze()
{
    gameScene.focus = true
    soldierModel.clear()
    gameFinishedDelay.stop()
    gameMouseArea.enabled= true
    gameTimer.gameWon = false
    moveDestination.visible = false
    bullet.visible = false
    bulletTimer.stop()
    for (var i=0; i<n2.count; i++) {
        n2.itemAt(i).state = "alive"
    }
    for (var i=0; i<civilian_repeater.count; i++) {
        civilian_repeater.itemAt(i).state = "alive"
    }
    for (var i=0; i<soldiers.count; i++) {
        soldiers.itemAt(i).name = names[i]
        soldiers.itemAt(i).state = "alive"
        soldiers.itemAt(i).visible= true
        soldiers.itemAt(i).x = Math.floor((Math.random()*land.width)%land.width)
        soldiers.itemAt(i).y = Math.floor((Math.random()*land.height)%land.height)
        soldierModel.append({"name":names[i], "image":'images/red/pN.pNG' })
        console.debug('gameInitialize soldier')
    }
    gameTimer.start();
    endButton.state = "PLAYING"
}


/*
    This file is part of Micro Soldier.

    Micro Solider is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Micro Solider is distributed in the hope that it will be useful,
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
            if ((mine_repeater.itemAt(i).state === "active") && GameState.check_mine_explode(mine_repeater.itemAt(i),x,y)) {
                mine_repeater.itemAt(i).state = "exploded";
                mine_repeater.itemAt(i).exploded(mine_repeater.itemAt(i).x, mine_repeater.itemAt(i).y);
            }
        }
    }
}

function gameInitialize()
{
    // copy the value to the soldierModel
    for (var i=0; i<mainWindow.soldierCount; i++) {
        for (var j=0; j<missionSoldierModel.count; j++) {
            if (missionSoldierModel.get(j).name === soldierModel.get(i).name) {
                soldierModel.get(i).alive = missionSoldierModel.get(j).alive
                soldierModel.get(i).rank = missionSoldierModel.get(j).rank
                soldiers.itemAt(j).rank = missionSoldierModel.get(j).rank
                console.debug("initalizing soldier ", soldierModel.get(i).name,  missionSoldierModel.get(j).rank)
            }
        }
    }
    missionSoldierModel.clear()
    gameScene.focus = true
    gameFinishedDelay.stop()
    gameMouseArea.enabled= true
    gameTimer.gameWon = false
    moveDestination.visible = false
    bullet.visible = false
    bulletTimer.stop()
    for (var i=0; i<n2.count; i++) {
        n2.itemAt(i).state = "alive"
        n2.itemAt(i).x = Math.floor((Math.random()*land.width)%land.width)
        n2.itemAt(i).y = Math.floor((Math.random()*land.height)%land.height)
    }
    for (var i=0; i<civilian_repeater.count; i++) {
        civilian_repeater.itemAt(i).state = "alive"
    }
    var soldierCount = 0
    // TODO: soldiers for each mission should be config item
    for (var i=0; (i<soldierModel.count) && (soldierCount < mainWindow.soldierCount); i++) {
        console.debug('gameInitialize soldier', soldiers.itemAt(soldierCount).name)
        if (soldierModel.get(i).alive === true) {
            soldiers.itemAt(soldierCount).name = soldierModel.get(i).name
            soldiers.itemAt(soldierCount).state = "alive"
            soldiers.itemAt(soldierCount).visible= true
            soldiers.itemAt(soldierCount).rank = soldierModel.get(i).rank
            soldiers.itemAt(soldierCount).x = Math.floor((Math.random()*land.width)%land.width)
            soldiers.itemAt(soldierCount).y = Math.floor((Math.random()*land.height)%land.height)
    //        soldierModel.append({"name":names[i], "image":'images/red/pN.pNG', "rank":0 })
            missionSoldierModel.append({"name":names[i], "image":'images/red/pN.pNG', "rank":soldierModel.get(i).rank, "alive":true })
            soldierCount++
        }
    }
    for (var i=0; i<mineCount; i++) {
        mine_repeater.itemAt(i).state = "active"
        mine_repeater.itemAt(i).visible= true
        mine_repeater.itemAt(i).x = Math.floor((Math.random()*land.width)%land.width)
        mine_repeater.itemAt(i).y = Math.floor((Math.random()*land.height)%land.height)
        //console.debug('gameInitialize mine')
    }
    gameTimer.start();
    endButton.state = "PLAYING"
}

function onLoaded() {
    endMissionText = "Honouring\n\n";
    for (var i= 0; i < missionSoldierModel.count; i++) {
        if (missionSoldierModel.get(i).alive === false)
            endMissionText += "R.I.P. ";
        endMissionText += missionSoldierModel.get(i).name +
                " Rank: " + missionSoldierModel.get(i).rank;
        console.debug(missionSoldierModel.get(i).name, missionSoldierModel.get(i).alive)
        endMissionText += "\n\n"
    }
}

function soldierModelAlive() {
    if ( !mainWindow.applicationInitialized) {
        // setup the soldierModel
        initializeSoldierModel()
    }

    var total = 0
    for (var i= 0; i < soldierModel.count; i++) {
        if (soldierModel.get(i).alive === true) {
            total++
        }
    }
    return total
}

function updateSoldierModel(missionCompleted) {
    console.debug("updateSoldierModel()" )
    for (var i= 0; i < missionSoldierModel.count; i++) {
        if (missionSoldierModel.get(i).alive === true && missionCompleted) {
            missionSoldierModel.get(i).rank += 1
            missionSoldierModel.get(i).rank = Math.min(10,missionSoldierModel.get(i).rank)
            // now find this soldier in the main model
            for (var j= 0; j < soldierModel.count; j++) {
                if (soldierModel.get(j).name === missionSoldierModel.get(i).name) {
                    soldierModel.get(j).rank = missionSoldierModel.get(i).rank
                    break
                }
            }
        } else {
            // now find this soldier in the main model
            for (var j= 0; j < soldierModel.count; j++) {
                if (soldierModel.get(j).name === missionSoldierModel.get(i).name) {
                    soldierModel.get(j).alive = missionSoldierModel.get(i).alive
                    break
                }
            }
        }
    }
}


function initializeSoldierModel() {
    if (mainWindow.applicationInitialized)
        return

    console.debug(names.length)
    soldierModel.clear()
    missionSoldierModel.clear()
    for (var i= 0; i < names.length; i++) {
        soldierModel.append({"name":names[i],
                             "image":'images/red/pN.pNG',
                             "rank":1,
                             "alive": true})
        console.debug("created soldier ",soldierModel.get(i).name)
    }
    mainWindow.applicationInitialized = true
}

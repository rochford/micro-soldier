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
import QtQuick 1.1
import Qt.labs.particles 1.0

Item {
    id: mine;
    visible: false
    signal exploded (int explodedX, int explodedY)
    onExploded: {
        console.debug("Exploded x=", explodedX, ",y=", explodedY)
        /*
        var minX = mine.x - mines.proxmity
        var maxX = mine.x + mines.proxmity
        var minY = mine.y - mines.proxmity
        var maxY = mine.y + mines.proxmity
        if ( (minX <  explodedX) && (explodedX < maxX) &&
             (minY <  explodedY) && (explodedY < maxY) )
            {
            console.debug("mine exploded")
            exploded(x, y)
            }
            */
    }

    Particles {
        id: mineParticles

        width: 1; height: 1
        anchors.centerIn: parent

        emissionRate: 0
        lifeSpan: 500; lifeSpanDeviation: 100
        angle: 0; angleDeviation: 360;
        velocity: 100; velocityDeviation: 30
        source:"images/dead_enemy.png"
    }
    Image {
        id:mineImage
        visible: true
        source:"images/mine_active.png"
        sourceSize.height: 10
        sourceSize.width: 10
        }
    x: Math.floor((Math.random()*land.width)%land.width)
    y: Math.floor((Math.random()*land.height)%land.height)
    state: "active"
    states: [
        State {
            name: "active"
            PropertyChanges { target: mine; visible:true }
            PropertyChanges { target: mineImage; visible:true }
        },
        State {
            name: "exploded"
            PropertyChanges { target: mineImage; visible:false }
            StateChangeScript { script: mineParticles.burst(10); }
        }
    ]
}


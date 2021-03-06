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
    id: civilian;
    x: Math.floor((Math.random()*land.width)%land.width)
    y: Math.floor((Math.random()*land.height)%land.height)
    property url baseImagePath: "images/civilian/"
    property url civilianImagex: "civilian.PNG"
    Particles {
        id: civilianParticles
        width: 2; height: 3
        anchors.centerIn: parent

        emissionRate: 0
        lifeSpan: 500; lifeSpanDeviation: 100
        angle: 0; angleDeviation: 360;
        velocity: 20; velocityDeviation: 10
        source:"images/dead_enemy.png"
    }
    Image {
        id:civilianImage
        source:baseImagePath+"civilian.PNG"
        sourceSize.height: 24
        sourceSize.width: 24
        }
    state: "alive"
    states: [
        State {
            name: "alive"
            PropertyChanges { target: civilianImage; source:baseImagePath+"civilian.PNG" }
        },
        State {
            name: "dead"
            StateChangeScript { script: civilianParticles.burst(4); }
            PropertyChanges { target: civilianImage; source:baseImagePath+'dead.PNG' }
        }
    ]
}

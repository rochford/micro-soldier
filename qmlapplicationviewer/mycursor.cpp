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
#include "mycursor.h"
#include <QCursor>
#include <QCursorShape>
#include <QApplication>
#include <QPixmap>
#include <QDebug>

MyCursor::MyCursor()
    : QObject()
{
}

bool MyCursor::cursor(QString str) const
{
    if (str == "normal") {
        QApplication::setOverrideCursor (QCursor(Qt::PointingHandCursor));
    }
    else if (str == "target")
        QApplication::setOverrideCursor (QCursor(QPixmap("images/cursor_crosshairs.png")));
    return true;
}

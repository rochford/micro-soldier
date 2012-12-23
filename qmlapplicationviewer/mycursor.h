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
#ifndef STOPWATCH_H
#define STOPWATCH_H
#include <QObject>
#include <QString>

class MyCursor : public QObject {
  Q_OBJECT
public:
    MyCursor();
    Q_INVOKABLE bool cursor(QString str) const;
};

#endif // STOPWATCH_H

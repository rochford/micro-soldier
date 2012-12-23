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

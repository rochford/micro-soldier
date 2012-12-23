#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QDeclarativeContext>
#include "mycursor.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("mycursor", new MyCursor());
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/micro-soldier/soldier_qml.qml"));
    viewer.showExpanded();

    return app->exec();
}

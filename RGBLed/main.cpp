#include <QObject>
#include "app.h"


int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	App * myApp = new App();
	myApp->start();

	return app.exec();
}


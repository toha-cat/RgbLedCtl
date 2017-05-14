#ifndef APP_H
#define APP_H

#include <QObject>
#include <QFile>
#include <QStringList>
#include "client.h"
#include "comtranslator.h"
#include "uibackend.h"

#define SERVER_HOST "192.168.1.201"
#define SERVER_PORT 5050

class App : public QObject
{
	Q_OBJECT
public:
	explicit App(QObject *parent = 0);
	void start();

signals:
    void viewLoginForm();

public slots:
	void clientConnected();
	void clientDisconected();
    void addFavorite(QString color);

private:
	Client *client;
	ComTranslator *comTranslator;
	UiBackend *ui;
    QStringList favoritesList;

    void initComponents();
    void configUi();
    void connectComponents();
    void readFavorites();
    void saveFavorites();
};

#endif // APP_H

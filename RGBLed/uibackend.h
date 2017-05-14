#ifndef UIBACKEND_H
#define UIBACKEND_H

#include <QObject>
#include <QDebug>
#include <QScreen>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStringList>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

class UiBackend : public QObject
{
	Q_OBJECT
public:
	explicit UiBackend(QObject *parent = 0);
	void createUi();
    void show();

signals:
    void changeColor(QString color);
    void addFavorite(QString color);

public slots:
    void setColor(QString color);
    void alertConnected();
    void alertDiConnected();
    void showMess(QString mess);
    void setFavoritesModel(QStringList model);

protected:
    void regMetrics();

	QObject *viewer;
	QQmlApplicationEngine engine;
    QQmlContext *rootContext;
};

#endif // UIBACKEND_H

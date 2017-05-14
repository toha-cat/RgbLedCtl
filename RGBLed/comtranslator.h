#ifndef COMTRANSLATOR_H
#define COMTRANSLATOR_H

#include <QObject>
#include <QByteArray>
#include <QDataStream>
#include <QList>


class ComTranslator : public QObject
{
	Q_OBJECT
public:
	explicit ComTranslator(QObject *parent = 0);

signals:
    void sendMess(QString mess);
    void changeColor(QString color);

public slots:
    void inputMess(QString mess);
    void setColor(QString mess);
};

#endif // COMTRANSLATOR_H

#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QByteArray>
#include <QDataStream>

#define MESS_HEADER_SIZE 4

#define LOGIN_RESULT_SUCESS 0x0F
#define LOGIN_RESULT_ERROR 0x01

class Client : public QObject
{
	Q_OBJECT

public:
	explicit Client(QObject *parent = 0);

public slots:
	void connect(QString host, int port);
    void send(QString mess);

signals:
    void newMess(QString mess);
    void connectedSucces();
	void closeConnect();

private slots:
	void readyRead();
	void connected();
	void disconnected();
    void error();

private:
    QTcpSocket *socket;
};

#endif // CLIENT_H

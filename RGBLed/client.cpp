#include "client.h"

Client::Client(QObject *parent) : QObject(parent)
{
    socket = new QTcpSocket(this);
    QObject::connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
    QObject::connect(socket, SIGNAL(connected()), this, SLOT(connected()));
    QObject::connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));
}

void Client::connect(QString host, int port)
{
    socket->connectToHost(host, port);
}

void Client::send(QString mess)
{
    if(!mess.isEmpty())
    {
        qDebug() << "send " << mess;
        socket->write(QString(mess + "\n").toUtf8());
    }
}

void Client::readyRead()
{
    while(socket->canReadLine())
    {
        QString line = QString::fromUtf8(socket->readLine()).trimmed();
        // в переменной line сообщения от сервера
        emit newMess(line);
    }
}

// При удачном конекте к серверу вызывается эта функция
void Client::connected()
{
    qDebug() << "connected";
    emit connectedSucces();
    //socket->write(QString("/me: \n").toUtf8());
}

// При разрыве связи с сервером вызывается эта функция
void Client::disconnected()
{
    qDebug() << "diconnected";
    emit closeConnect();
}

void Client::error()
{
    qDebug()<< "ERROR " << socket->errorString();
}

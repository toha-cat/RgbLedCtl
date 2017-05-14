#include "comtranslator.h"

ComTranslator::ComTranslator(QObject *parent) : QObject(parent)
{

}

void ComTranslator::inputMess(QString mess)
{
    if(mess.at(0)=='g'){
        mess.replace(0,1,'#');
        emit changeColor(mess);
    }
}

void ComTranslator::setColor(QString mess)
{
    mess.replace(0,1,'s');
    emit sendMess(mess);
}



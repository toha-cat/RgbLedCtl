#include "app.h"

App::App(QObject *parent) : QObject(parent)
{

}

void App::start()
{
    initComponents();

    readFavorites();

    ui->createUi();

    configUi();

    ui->show();

    connectComponents();
    qDebug() << "start connect";

    client->connect(SERVER_HOST, SERVER_PORT);
}

void App::initComponents()
{
    client = new Client(this);
    comTranslator = new ComTranslator(this);
    ui = new UiBackend(this);
}

void App::configUi()
{
    ui->setFavoritesModel(favoritesList);
}

void App::connectComponents()
{
    connect(client, &Client::connectedSucces, this, &App::clientConnected);

    connect(client, &Client::closeConnect, this, &App::clientDisconected);

    connect(ui, &UiBackend::changeColor, comTranslator, &ComTranslator::setColor);
    connect(comTranslator, &ComTranslator::changeColor, ui, &UiBackend::setColor);

    connect(ui, &UiBackend::addFavorite, this, &App::addFavorite);
}

void App::readFavorites()
{
    QFile loadFile("save.dat");

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open save file.");
        return;
    }

    QString saveData = loadFile.readAll();

    favoritesList = saveData.split(';');
}

void App::saveFavorites()
{
    QFile saveFile("save.dat");

    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("Couldn't open save file.");
        return;
    }
    QString data = favoritesList.join(';');
    saveFile.write(data.toLatin1());
}

void App::clientConnected()
{
    connect(client, &Client::newMess, comTranslator, &ComTranslator::inputMess);
    connect(comTranslator, &ComTranslator::sendMess, client, &Client::send);
    ui->alertConnected();
}

void App::clientDisconected()
{
    disconnect(client, &Client::newMess, comTranslator, &ComTranslator::inputMess);
    disconnect(comTranslator, &ComTranslator::sendMess, client, &Client::send);
    ui->alertDiConnected();
}

void App::addFavorite(QString color)
{
    favoritesList.append(color);
    ui->setFavoritesModel(favoritesList);
    saveFavorites();
}

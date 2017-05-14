QT += qml


TEMPLATE = app

TARGET = RGBLed

CONFIG += c++11

SOURCES += main.cpp \
    client.cpp \
    comtranslator.cpp \
    app.cpp \
    uibackend.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    client.h \
    comtranslator.h \
    app.h \
    uibackend.h

DISTFILES +=


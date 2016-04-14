TEMPLATE = app
CONFIG += console
CONFIG += c++11
CONFIG -= app_bundle
CONFIG -= qt
SOURCES += main.cpp

DESTDIR = Build

unix {
 TARGET = Practica1.exe
} else {
  TARGET = Practica1
}

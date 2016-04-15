TEMPLATE = app
CONFIG += console
CONFIG += c++11
CONFIG -= app_bundle
CONFIG -= qt
SOURCES += main.cpp

DESTDIR = Build

QMAKE_CXXFLAGS += -Os

unix {
 TARGET = Practica1.exe
} else {
  TARGET = Practica1
}

DISTFILES += \
    tests.sh

#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_aboutButton_clicked()
{
    QMessageBox about(this);

    about.setWindowTitle("About PNEngine Model Converter");
    about.setTextFormat(Qt::RichText);
    about.setText("<b><a href='https://github.com/Schwungus-Software/PNMC'>PNEngine Model Converter</a> 2.0</b><br>Created by <a href='https://cantsleep.cc'>Can't Sleep</a> for <a href='https://schwungus.software'>Schwungus Software</a><br><br>Written in C++ using <a href='https://qt.io'>Qt Framework</a>");
    about.exec();
}

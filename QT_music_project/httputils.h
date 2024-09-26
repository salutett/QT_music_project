#ifndef HTTPUTILS_H
#define HTTPUTILS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>


class HttpUtils : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtils(QObject *parent = nullptr);

    Q_INVOKABLE void connet(QString url);
    Q_INVOKABLE void replyFinished(QNetworkReply *reply);
signals:
    void replySignal(QString reply);

public:
    QNetworkAccessManager * manager;
    QString BASE_URL = "http://localhost:3000/"; //默认的url

};

#endif // HTTPUTILS_H

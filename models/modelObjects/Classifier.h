#pragma once

#include <QObject>
#include <QString>
#include "utils/PropertyHelpers.h"

class Classifier : public QObject
{
    Q_OBJECT
    AUTO_PROPERTY(QString, name, name, setName, nameChanged);

public:
    explicit Classifier(const QString& name):m_name(name){};
};

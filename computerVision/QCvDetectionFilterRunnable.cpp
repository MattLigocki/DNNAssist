#include "QCvDetectionFilterRunnable.h"

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>
#include <QTemporaryFile>
#include <QTime>
#include <chrono>
#include <future>

#include "computerVision/NetFrameworks/INeurNetFramework.h"


#include "models/modelObjects/Classifier.h"
#include "models/modelObjects/DetectedObjects.h"
#include "managers/ComputerVisionManager/AiManager.h"

using namespace cv;

QCvDetectionFilterRunnable::QCvDetectionFilterRunnable(QCvDetectFilter* filter) :
                                                        m_filter(filter)
{
    emit(m_filter->initialize());
}

QVideoFrame QCvDetectionFilterRunnable::run(
    QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat,
    RunFlags flags) {
  Q_UNUSED(flags);

  auto start = std::chrono::high_resolution_clock::now();

  input->map(QAbstractVideoBuffer::ReadOnly);

  if (surfaceFormat.handleType() == QAbstractVideoBuffer::NoHandle) {
    // Convert QVideoFrame to QImage
    QImage image = input->image();
    image = image.convertToFormat(QImage::Format_RGB888);

    AiManager::getInstance().processImageByFrameworks(image);

  } else {
    qDebug() << "Other surface formats are not supported yet!";
  }

  input->unmap();

  auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::high_resolution_clock::now() - start);

  float fps = duration.count()?1000.00/duration.count():0;
  m_filter->setMediaFPS(fps);

  return *input;
}


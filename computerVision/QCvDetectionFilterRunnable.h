#pragma once

#include "QCvDetectFilter.h"
#include <QAbstractVideoFilter>
#include <QObject>
#include <type_traits>
#include <variant>

#include "DetectionParameters.h"
#include "DetectionRectangle.h"
#include "utils/PropertyHelpers.h"

#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/opencv.hpp"

class QCvDetectionFilterRunnable : public QVideoFilterRunnable {

private:
  /**
   * @brief m_filter - pointer to creating class
   */
  QCvDetectFilter* m_filter;
public:
  QCvDetectionFilterRunnable(QCvDetectFilter* filter);
  QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat,
                  RunFlags flags);
};

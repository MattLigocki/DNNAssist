#pragma once

#include <utility>
#include <utils/Common.h>
#include <vector>

class OpenCvFramework;

/**
 * @brief The DetectionParameters struct
 * This ctructure holds parameters for detection setion of  opencv
 */

typedef std::pair<uint16_t, uint16_t> resolution_t;
typedef struct DetectionParameters detectionParameters_t;

struct DetectionParameters {
  /**
   * @brief videoSource: camera, mediaStream, RSTP
   */
  QString mediaSource = "camera";

  /**
   * @brief detectConfidenceLevel
   * Assumed max confidence lvl to 4
   * If set greater than 0 than recognized object with lower confidence
   * will be dropper. Else everything will be passed. Use for filter false
   * detections
   */
  double detectConfidenceLevel{0};

  /**
   * @brief imageDetectionResolution
   * Image taken from video source are shrinked to this resolution
   * to boost up performance (smaller is better)
   */
  std::pair<uint16_t, uint16_t> imageDetectionResolution{320, 240};

  /**
   * @brief userBwConversion
   * Use image converstion to grayscale
   */
  bool userGrayScaleConversion{false};

  /**
   * @brief usedFramework
   * framework used to process media: OpenCv, Darknet, OpenMp
   */
  QString usedFramework{"OpenCv"};

  DetectionParameters() {}
  DetectionParameters(
      std::pair<uint16_t, uint16_t> imageDetectionResolution,
      double detectConfidenceLevel,
      bool userGrayScaleConversion,
      QString videoSource,
      QString usedFramework)
      : mediaSource(videoSource),
        detectConfidenceLevel(detectConfidenceLevel),
        imageDetectionResolution(imageDetectionResolution),
        userGrayScaleConversion(userGrayScaleConversion),
        usedFramework(usedFramework){}
};

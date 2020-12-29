#pragma once

#include "opencv2/opencv.hpp"

template<typename T>
struct DetectionRectangle{
    T x, y, h, w;
    DetectionRectangle(cv::Mat& mat, T x = 0 , T y = 0 , T h = 0, T w = 0) :
        x(x / float(mat.cols)),
        y(y/ float(mat.rows)),
        h(h/ float(mat.cols)),
        w(w/ float(mat.rows)){};

    DetectionRectangle(cv::Mat& mat, cv::Rect rect) :
        x(rect.x / float(mat.cols)),
        y(rect.y/ float(mat.rows)),
        h(rect.height/ float(mat.cols)),
        w(rect.width/ float(mat.rows)){};

    bool isRectangeOutOFDelayBound(DetectionRectangle<T>& rect, int detectedObjectMovementDelay) noexcept{
       return (isDimensionOufOfBound(rect.x, x, detectedObjectMovementDelay) &&
               isDimensionOufOfBound(rect.y, y, detectedObjectMovementDelay) &&
               isDimensionOufOfBound(rect.h, h, detectedObjectMovementDelay) &&
               isDimensionOufOfBound(rect.w, w, detectedObjectMovementDelay) )? true: false;
    }

private:
    bool isDimensionOufOfBound(T& lhs, T& rhs, int detectedObjectMovementDelay){
            int difference = abs((lhs-rhs)*10000);

         return (difference > detectedObjectMovementDelay)? true: false;
    }
};
typedef DetectionRectangle<float> rect_float_t ;

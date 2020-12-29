import QtQuick 2.0

ListModel {
    ListElement { name: "ExposureAuto"}
    ListElement { name: "ExposureManual"}
    ListElement { name: "ExposurePortrait"}
    ListElement { name: "ExposureNight"}
    ListElement { name: "ExposureBacklight"}
    ListElement { name: "ExposureSpotlight"}
    ListElement { name: "ExposureSports"}
    ListElement { name: "ExposureSnow"}
    ListElement { name: "ExposureBeach"}
    ListElement { name: "ExposureLargeAperture"}
    ListElement { name: "ExposureSmallAperture"}
    ListElement { name: "ExposureAction"}
    ListElement { name: "ExposureLandscape"}
    ListElement { name: "ExposureNightPortrait"}
    ListElement { name: "ExposureTheatre"}
    ListElement { name: "ExposureSunset"}
    ListElement { name: "ExposureSteadyPhoto"}
    ListElement { name: "ExposureFireworks"}
    ListElement { name: "ExposureParty"}
    ListElement { name: "ExposureCandlelight"}
    ListElement { name: "ExposureBarcode"}
    ListElement { name: "ExposureModeVendor"}

    function getCameraExposure(exposure){
        switch(exposure){
            case "ExposureAuto":
                return camera.exposure.ExposureAuto
            case "ExposureManual":
                return camera.exposure.ExposureManual
            case "ExposurePortrait":
                return camera.exposure.ExposurePortrait
            case "ExposureNight":
                return camera.exposure.ExposureNight
            case "ExposureBacklight":
                return camera.exposure.ExposureBacklight
            case "ExposureSpotlight":
                return camera.exposure.ExposureSpotlight
            case "xxx":
                return camera.exposure.ExpoxxxsureManual
            case "ExposureSports":
                return camera.exposure.ExposureSports
            case "ExposureSnow":
                return camera.exposure.ExposureSnow
            case "ExposureBeach":
                return camera.exposure.ExposureBeach
            case "ExposureLargeAperture":
                return camera.exposure.ExposureLargeAperture
            case "ExposureSmallAperture":
                return camera.exposure.ExposureSmallAperture
            case "ExposureAction":
                return camera.exposure.ExposureAction
            case "ExposureLandscape":
                return camera.exposure.ExposureLandscape
            case "ExposureNightPortrait":
                return camera.exposure.ExposureNightPortrait
            case "ExposureTheatre":
                return camera.exposure.ExposureTheatre
            case "ExposureSunset":
                return camera.exposure.ExposureSunset
            case "ExposureSteadyPhoto":
                return camera.exposure.ExposureSteadyPhoto
            case "ExposureFireworks":
                return camera.exposure.ExposureFireworks
            case "ExposureParty":
                return camera.exposure.ExposureParty
            case "ExposureCandlelight":
                return camera.exposure.ExposureCandlelight
            case "ExposureBarcode":
                return camera.exposure.ExposureBarcode
            case "ExposureModeVendor":
                return camera.exposure.ExposureModeVendor
        }
    }
}

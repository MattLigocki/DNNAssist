import QtQuick 2.0

QtObject {
    function navigateToItem(item){
        switch(item){
            case "media":
                if(stackView.currentItem !== mediaScreen)
                {
                    stackView.replace(mediaScreen)
                }
                break;

            case "data":
                if(stackView.currentItem !== dataScreen)
                    stackView.replace(dataScreen)
                break;

            case "aigym":
                if(stackView.currentItem !== aiGymScreen)
                    stackView.replace(aiGymScreen)
                break;

            case "statistics":
                if(stackView.currentItem !== statisticsScreen)
                    stackView.replace(statisticsScreen)
                break;

            case "ai":
                if(stackView.currentItem !== aiScreen)
                    stackView.replace(aiScreen)
                break;
        }
    }
}

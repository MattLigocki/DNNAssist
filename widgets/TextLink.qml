import QtQuick 2.0

Text {
   property string linkText: "http://www.google.com"
   text: isValidURL(linkText) ? ("<a href='"+linkText+"'>"+linkText+"</a>") : linkText
   onLinkActivated:{
       if (isValidURL(linkText)){
          Qt.openUrlExternally(linkText)
       }
   }
   function isValidURL(str) {
      var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
      return regexp.test(str);
   }
}

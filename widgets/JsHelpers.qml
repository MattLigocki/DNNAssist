import QtQuick 2.0

Item {
    id: root
    function getVideoInfo(vidId) {
      const url = `https://www.youtube.com/get_video_info?video_id=${vidId}`;
      return fetch(url, {
        mode: "no-cors",
      })
        .then(res => res.text())
        .then(body => body);
    }

    function extractYoutubeMp4Link(vidId) {
      const regex = /type=video\/mp4.*?&url=(.*?),/; // find first mp4 link
      const findStr = 'url_encoded_fmt_stream_map=';
      const findStrLen = findStr.length;

      const vidInfo = getVideoInfo(vidId);
      const decodedInfo = decodeURIComponent(decodeURIComponent(vidInfo));
      const streamMap = decodedInfo.substr(decodedInfo.indexOf(findStr) + findStrLen);
      return regex.exec(streamMap)[1];
    }



    function getYoutubeMp4Link(vidId) {
      extractYoutubeMp4Link(vidId)
        .then(url => console.log(url))
        .catch(err => console.error(err));
    }


}

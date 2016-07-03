 /*
  *Youtube API : https://developers.google.com/youtube/iframe_api_reference
  */
(function($, win) {

$(function () {
    console.log('jQuery Handler');

var player;
function onYouTubeIframeAPIReady() {
    console.log('AutoCall');
    player = new YT.Player('iframe', {
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });
}

function onPlayerReady(event) {
    console.log('READY NOW');
    player = event.target;
    document.getElementById('iframe').style.borderColor = '#DD2C00';
}

function onPlayerStateChange(event) {
    console.log('STATE', event.data);
    var status = event.data;
    var color;
    if (status == 1) {
        color = "#33691E";
    } else {
        color = "#DD2C00";
    }

    if (color) {
        document.getElementById('iframe').style.borderColor = color;
    }
}

function play() {
    player.playVideo();
}

function pause() {
    player.pauseVideo();
}

function seek(seconds) {
    player.seekTo(seconds);
}

function time() {
    return player.getCurrentTime();
}

function load(id) {
    player.loadVideoById(id);
}

win.play = play;
win.pause = pause;
win.seek = seek;
win.time = time;
win.load = load;
win.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;

});

}($, this));

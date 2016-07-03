 /*
  *Youtube API : https://developers.google.com/youtube/iframe_api_reference
  */
(function($, win, app) {

$(function () {
console.log('jQuery Handler');

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";

var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
    console.log('BUILDING YOUTUBE FRAME');
    player = new YT.Player('iframe', {
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });
}

function onPlayerReady(event) {
    console.log('READY NOW');
}

function onPlayerStateChange(event) {
    console.log('STATE', event.data);
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

function total() {
    return player.getDuration();
}

win.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;
win.play = play;
win.pause = pause;
win.seek = seek;
win.time = time;
win.load = load;
win.total = total;

});

}($, this));

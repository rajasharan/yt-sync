(function($, win) {

$(function () {
console.log('jQuery Handler');

/*
 * Elm Ports
 */
var app = Elm.Main.fullscreen();

app.ports.play.subscribe(function() {
    try {
        play();
        app.ports.played.send(time());
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }
});

app.ports.pause.subscribe(function() {
    try {
        pause();
        app.ports.paused.send(time());
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }
});

app.ports.seek.subscribe(function(pos) {
    try {
        seek(pos);
        app.ports.seeked.send(time());
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }
});

app.ports.total.subscribe(function() {
    try {
        app.ports.totaled.send(total());
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }
});

app.ports.width.subscribe(function() {
    var w = $('.seekbar').width();
    app.ports.seekbarWidth.send(w);
});

app.ports.time.subscribe(function() {
    try {
        var t = time();
        app.ports.getTime.send(t);
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }
});


 /*
  *Youtube API : https://developers.google.com/youtube/iframe_api_reference
  */
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
    try {
        app.ports.totaled.send(total());
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }
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

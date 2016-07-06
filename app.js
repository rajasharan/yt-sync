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
    //var w = $('.seekbar').width();
    var w = $('#video-wrapper').width();
    console.log('#video-wrapper width: ', w);
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

app.ports.nextVideo.subscribe(function(index) {
    nextVideo(index);
});

var firsttime = true;
var videoId;
app.ports.load.subscribe(function(vId) {
    if (firsttime) {
        videoId = vId;
        loadYouTubeAPI();
    } else {
        load(vId);
    }
});

function loadVideoIdFirstTime() {
    if (firsttime) {
        load(videoId);
        firsttime = false;
    }
}

 /*
  *Youtube API : https://developers.google.com/youtube/iframe_api_reference
  */

//console.log("PLAYER FOUND: ", $('#player').length);

function loadYouTubeAPI() {
    console.log('LOADING YOUTUBE API');
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";

    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

var player;
function onYouTubeIframeAPIReady() {
    console.log('BUILDING YOUTUBE FRAME');
    player = new YT.Player('player', {
        //videoId: 'GIimRbcOvM8',
        playerVars: {
            'enablejsapi': 1,
            'controls': 0,
            'fs': 1,
            'showinfo': 1,
            'autoplay': 0
        },
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });
}

function onPlayerReady(event) {
    console.log('READY NOW');
    loadVideoIdFirstTime();
    win.player = player;
}

function onPlayerStateChange(event) {
    //console.log('STATE', playerState(event.data));
    try {
        app.ports.playing.send(event.data === YT.PlayerState.PLAYING);
        if (event.data === YT.PlayerState.CUED) {
            var videoList = player.getPlaylist().map(function(v, i) {
                return { id: v, author: "", title: "", index: i };
            });
            app.ports.cued.send(videoList);
        }
    } catch (e) {
        console.log(e);
        app.ports.errored.send(e.toString());
    }

    if (event.data > 0) {
        try {
            t = total();
            //console.log('TOTAL TIME: ', t);
            app.ports.totaled.send(t);
        } catch (e) {
            console.log(e);
            app.ports.errored.send(e.toString());
        }
    }
}

function playerState(data) {
    if (data === YT.PlayerState.UNSTARTED) {
        return 'UNSTARTED';
    } else if (data === YT.PlayerState.ENDED) {
        return 'ENDED';
    } else if (data === YT.PlayerState.PLAYING) {
        return 'PLAYING';
    } else if (data === YT.PlayerState.PAUSED) {
        return 'PAUSED';
    } else if (data === YT.PlayerState.BUFFERING) {
        return 'BUFFERING';
    } else if (data === YT.PlayerState.CUED) {
        return 'CUED';
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
    player.cuePlaylist({listType: 'search', list: id});
    //player.loadVideoById(id);
}

function total() {
    return player.getDuration();
}

function nextVideo(index) {
    player.playVideoAt(index);
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

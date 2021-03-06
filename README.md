# Youtube Sync & Watch together

### [Live Demo Link](https://rajasharan.github.io/yt-sync)

### Dev setup
```sh
$ npm install -g elm
$ git clone https://github.com/rajasharan/yt-sync
$ cd yt-sync

$ elm reactor
Listening on http://localhost:8000/
```

### Compilation
```sh
$ elm make Main.elm --output elm.js

# Start local server
$ lite-server
# OR
$ python -m SimpleHTTPServer 3002
```

### Start WebSocket server
```sh
$ cd server
$ npm install
$ node server.js
yt-sync websocket opened on port 5000
```

## Connect to WebSocket Server
```html
Now append the <server-ip>:<port> as a hash Location
For e.g: if the elm frontend server is running in localhost:2000
and websocket server in localhost:3000 then url is: http://localhost:2000/#ws://localhost:3000

Open in multiple browsers to test.
```

### [License](/LICENSE)
The MIT License (MIT)

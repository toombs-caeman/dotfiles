little web games

recreations of table top games

# purpose
experiment with p2p web games

Could be an experiment in matchmaking with [webrtc](https://webrtc.github.io/samples/src/content/datachannel/basic/)
https://shanetully.com/2014/09/a-dead-simple-webrtc-example/
plus a look at table-top games as state machines + nice UI

# tech
* game engine - the underlying state
    * transitions (moves) are serialized as text and sent over webrtc
    * start with turn-based games so that time sync isn't important
    * don't bother with anti-cheat
* extras
    * replay games by saving the wire format + seed
    * chat?
    * username/stats saved in cookie?
    * random matches?
    * bots?
* UI
    * landing page is a 'start game' button that generates a guid and redirects
    * matchmaking is done by simply sharing the link.
* connect webrtc (p2p) through aws lambda
* svg graphics?

# chess
# chinese chess
# sovereign chess 
an extension of chess.

https://www.youtube.com/channel/UCKWbUBrlHFkbj8p0ndivJgQ
https://news.ycombinator.com/item?id=30896250
https://www.infinitepigames.com/sovereign-chess

# opulence (splendor rip-off)
https://www.youtube.com/watch?v=MvhqaA2RLr0 

# hanafuda
https://fudawiki.org/en/hanafuda/games

# cards
card games in general would be a good fit here

# tanks
this would be a bit more complicated to get animations synced, but its still technically turn based
https://www.mathsisfun.com/games/tanks.html

a virtual assistant

# capabilities
* always on
* collect points of interest periodically
* send reminder notifications

# major technical components
* scraper - collect data from the internet
  * wikipedia article of the day
  * wttr.in - daily weather
  * manga updates
  * pull targets from index
  * shallow 'reader mode' version of sites that might disappear
    * edit the bookmark to inject the cached version and [redirect if available](https://stackoverflow.com/questions/6220644/redirect-browser-only-if-a-web-site-is-available)
* index of points of interest (aka bookmarks)
  * firefox bookmarks
    * specialized behavior to scrape urls in a particular folder to cache
  * youtube playlists
    * youtube-dl, and convert music playlist to audio only
* interface
  * discord/email bot
* language - should be available to python and zsh while remaining human editable
  * templating
  * markdown
  * config
  * matching - (regex) find strings that follow template
* datastore/cache
  * sqlite based probably
  * a 'cache' of remote content + local content
* auth
* server - what hardware, what url?
* logging


# features
* contact management
  * http://jakobgreenfeld.com/stay-in-touch
  * grist? as backing store
  * see zendesk/salesforce https://www.zendesk.com/blog/contact-management-101/
  * notify two names each day that have fallen out of touch. One, the most out of touch, and one random.
  * expert pipeline
    * how to find interesting people to have conversation with?
      * local network - find local interest groups
      * hire / reach out for consultation to academics etc.
      * reading academic papers/whitepapers
    * positive validation for genius - rather than 'losing respect' for those professing crank ideas, treat them as
      a hypothesis producing black box
* to-done tracking
  * did things actually get done?
* quantified self
  * mood/sleep tracking
* daily news aggregation
* weather report
  * https://wttr.in/:help
  * https://wttr.in/?1nq

# external bits - hardware and services
* server - desktop or AWS
* phone
* domain name
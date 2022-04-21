#!/usr/bin/env python

"""
Use a python script to collect feeds into a digest akin to [FraidyCat](https://fraidyc.at/)
and send it through the same channel as other virtual assistant stuff (email or discord, not sure yet)

channels:
* RSS - handled by feedparser library
* manga -
"""

from flask import Flask
from flask import render_template
import feedparser

# creates a Flask application, named app
app = Flask(__name__)
feeds = [
    "http://feeds.arstechnica.com/arstechnica/technology-lab",
    "https://www.reddit.com/r/i3wm/.rss",
    "https://hnrss.org/frontpage",
]

@app.route("/")
def hello():
    entries = sorted([e for url in feeds for e in feedparser.parse(url).entries],
                     key=lambda e:e.updated_parsed,
                     reverse=True,
                     )

    r = render_template("rss.html", entries=entries)
    print(r)
    return r

# run the application
if __name__ == "__main__":
    app.run(debug=True)

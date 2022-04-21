
TMPDIR="$(mktemp -d)"
BM="bookmarks.tab"
widths=($(t widths < "$BM"))
### get bookmarks from firefox
FF="$TMPDIR/firefox.sqlite"
cp ~/.mozilla/firefox/*.default/places.sqlite "$FF"

SEP="$(printf '\001')" # non-printable separator won't be in data
sqlite3 "$FF" -separator "$SEP" -header <<FF | column -t -s "$SEP" >> "$BM"
select b.title, url from moz_places as p join moz_bookmarks as b on b.fk=p.id;
FF


### get bookmarks from chrome
### merge

### cleanup
rm -r "$TMPDIR"

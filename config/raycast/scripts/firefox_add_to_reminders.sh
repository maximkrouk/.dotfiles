#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.icon 🦊
# @raycast.title Add To Reminders
# @raycast.description Add current tab URL to Apple Reminders
# @raycast.packageName Firefox
# @raycast.mode silent

# only encode ` ` as %20 for now
function url_encode() {
    local raw_url
    raw_url="$1"
    local url_encoded
    url_encoded="${raw_url// /%20}"
    echo "$url_encoded"
}

LANG="en_US.UTF-8"

# [Getting URL and Tab Title from Firefox with AppleScript · Matt's programming blog](https://matthewbilyeu.com/blog/2018-08-24/getting-url-and-tab-title-from-firefox-with-applescript)
# [macos - Get URL of opened Firefox tabs from terminal - Ask Different](https://apple.stackexchange.com/questions/404841/get-url-of-opened-firefox-tabs-from-terminal)

name=$( osascript -e 'tell application "System Events" to tell process "Firefox" to get name of front window')
link=$( osascript -e  'tell application "System Events" to tell process "Firefox" to get value of UI element 1 of combo box 1 of toolbar "Navigation" of first group of front window' )

# if url is http - firefox copies it in format `path/` instead of `http://path/` and here is a fix
if [[ ! "$link" =~ "(https)+" ]]; then
	link="http://$link"
fi

osascript >/dev/null << EOF
	tell app "Reminders"
		make new reminder in default list with properties {name:"$name", body:"$link"}
	end tell
EOF
echo "Done"
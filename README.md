# Roblox slot insertion
 This is a Roblox script which allows users to insert their own slots using a GUI. \
 Shoutout to `outrun917` and `sjark` for the original GUI, scripts, and idea.

[![Static Badge](https://img.shields.io/badge/download_rbxm-here?style=for-the-badge&color=blue)](https://github.com/Hypurrnating/Roblox-slot-inserter/raw/main/SlotInserter.rbxm) \
If you wish to suggest improve meants to the code, you can create a pull request and edit the .lua scripts in /src

 The script creates a record of what models where insert by who and when in a lua table. It then uses that data to set a cool-down (or debounce) on each player. \
 The script also logs the insert to a discord webhook, although you should also specify a guilded webhook as fallback (will be introduced later).

 Everything happens on the server side, the local script only sends a request to the server.

 > [!IMPORTANT]
 > Although the script does help enhance security, it is not an alternative for manually checking the slots that are inserted.
 
 I do aim to introduce better security features in the future, but as the warning above says, you have to be aware of what you are allowing into the game.

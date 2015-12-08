# Snatch N' Grab
============

CSCI 3308 - Fall 2015

About the game:
------------

An easy to pick up, fast paced game where you compete with your friends to get the high score.

Start on a large maze looking downwards at your avatar. Try to collect the most tokens against 3 other players. Use swipe gestures to turn. Physics stops the player when they hit a wall or obstacle. A tracker keeps count of players’ scores until time runs out.

Goal: To learn how to create an app in iOS using Swift	

Vision Statement: Bring people together competitively through a mobile game.

Repo Organization:
------------

The Xcode project is located in the Snatch directory: ./Snatch/Snatch.Xcodeproj . Note that the Snatch N' Grab directory is NOT functional. Please just ignore ./Snatch N' Grab/

The core of the project (.swift files, .sks file, etc.) are located in ./Snatch/Snatch/

Tests are located in ./Snatch/SnatchTests/SnatchTests.swift

The snatchgrab directory contains the early stages of a Django server. This was originally planned to work with the snatch.db sqlite database. We later decided to use a mySQL database hosted on Google Cloud to store all data.

Docs:
------------

tbd

How to Run:
------------

1. Ensure you have access to Xcode (this was developed on version 6.4)
	* Mac users, just download Xcode
	* Windows and Linux: Find a way to access an OSX environment. A place to start using VirtualBox: https://www.youtube.com/watch?v=DYMEb0ZCfes
2. Clone the repo
3. Open ./Snatch/Snatch.Xcodeproj in Xcode
4. Change the OS simulator to "iPhone 4s" by clicking the icon labeled "Snatch" at the top of the Xcode window (immediately to the right of the stop button) and scrolling to "iPhone 4s".
4. Press the play button in the upper left corner
5. Once the simulation starts, you are ready to play. Use your mouse to emulate swipe controls by clicking and dragging in the desired direction

Note that tests run automatically during the build process. Tests are located in ./Snatch/SnatchTests/SnatchTests.swift. Alternatively, click "Show the Test Navigator" on the left panel in Xcode to view tests.

# amodeus-client

Alternative MODEUS app for UTMN Students.

**DISCLAIMER:** THIS APP IS IN WORK IN PROGRESS, EVERYTHING CAN CHANGE OR
BREAK ANY TIME. USE IT AT YOUR OWN RISK.

## Features
  - Get timetable of any user without logging in
  - Dark and light theme
  - In-app authentication via system password or fingerprint
  - Bugs

## Installation

### Building from sources

  - Clone this repo
  - Make sure Flutter is installed
  - Run `flutter build <flavor>`
    Where `<flavor>` is one of:
    - `apk` — build Android app
    - `web` — build web app

## Usage
  - Navigate to https://api.amodeus.evgfilim1.me/docs
  - Select `/search`
  - Click "Try it out"
  - Enter your full name and click "Execute"
  - Copy your ID (should look like 11223344-5566-7788-9900-aabbccddeeff)
  - Start an app, navigate to settings
  - Long tap on "О программе"
  - Paste your ID into "personUuid" field, then press Enter

## Roadmap
  - [x] Dark/Light theme
  - [x] Get timetable for any user (partially implemented)
  - [ ] Search user
  - [ ] Login
    - [ ] Get timetable for self
    - [ ] Get marks for self
  - [ ] Other features coming soon...

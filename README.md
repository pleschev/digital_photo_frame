
# Raspberry Pi powered Digital Photo frame
that displays images that have been sent to it via email, painlessly deployed via [resin.io](https://resin.io/).

## Required materials
- LCD screen that supports HDMI
- Raspberry Pi 2 Model B with internet connectivity (either Wifi or ethernet)
- An IMAP enabled Google gmail account specifically setup to send images to
- A resin.io account

## Setup
- Follow the resin.io [getting started guide](http://docs.resin.io/#/pages/installing/gettingStarted.md)
- Create a new resin application, eg PhotoGallery, and define the following environment variables
  - IMAP_USER_NAME (the full email address)
  - IMAP_PASSWORD  
  - LCD_RESOLUTION (Eg 1920x1200)
- Associate your Raspberry Pi device to the resin application
- Clone this repository
- Add your resin.io applications remote endpoint
```
git add remote resin <username>@git.resin.io:<username>/<app-name>.git
```
- Push the application to your device
```
git push resin master
```
- Send an email with photo attachement/s to the specified email address 

## Current limitations
- [ ] Assumes the use of google mail
- [ ] Trusts all emails sent to the specified email address (you might want to make the email address non-obvious)
- [ ] Images are never expired

## Future improvements
- [ ] Airdrop support

# Le Baluchon - travel iOS app [![forthebadge](https://forthebadge.com/images/badges/made-with-swift.svg)](https://forthebadge.com) [![Generic badge](https://img.shields.io/badge/version-v1.0-blue)](https://shields.io/)

Le Baluchon is an iOS app that use APIs to reach 3 main functionality : currency conversion, translation, and weather.

## Technologies

- Xcode 12.5.1
- Swift 5
- UIKit

## Compatibility

- iOS 13+
- iPhone SE (2nd gen) to current devices
- Run on Portrait and Landscape

## Features

- Make currency conversion with 9 mainly used currencies
- Translate from french to english or auto-detect input language
- Check the weather of New York and your city using your actual position

## Launch

For this app to work as expected, you will need to add your own APIKey.swift file with 3 constants for your API Keys :
- EXCHANGE_KEY constant for Fixer API : https://fixer.io/
- TRANSLATE_KEY constant for Google's Cloud Translation API : https://cloud.google.com/translate/docs/
- WEATHER_KEY constant for OpenWeatherMap API : https://openweathermap.org/current

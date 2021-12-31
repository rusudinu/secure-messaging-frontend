# Secure Messaging (Frontend)

This is the frontend for a broadcast-based, encrypted secure messaging app. This allows for chatting anonymously due to the fact that messages are encrypted and never stored, neither on your phone, nor on the server.

## Usage

You can and should self-build the frontend, to guarantee that the messages are not leaked. This is not a requirement, but it is recommended. Then, you connect to the backend by updating the server url in the app configuration (lib/data/backend_server.dart).

The repo for the backend can be found [here](https://github.com/xrusu/secure-messaging-backend).

## How to build

Build this app as any other Flutter app.

Run `flutter build ios` or `flutter build android` to build the app in the root directory of the repo. Make sure you have downloaded the dependencies using`flutter pub get`.

## Others
For other projects / cool stuff, follow me on
[GitHub](https://github.com/xrusu)

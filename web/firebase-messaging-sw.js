importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyAKOiQ19NIE1AhXhsRLvn8c16cbJoRnweQ",
    projectId: "zyn-app",
    messagingSenderId: "444496284422",
    appId: "zyn-app"
});

const messaging = firebase.messaging();
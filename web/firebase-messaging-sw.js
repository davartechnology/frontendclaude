importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAAy0EgeFbP3bk03wiKi-XicG8bmLNHqes",
  authDomain: "zyn-app.firebaseapp.com",
  projectId: "zyn-app",
  storageBucket: "zyn-app.firebasestorage.app",
  messagingSenderId: "444496284422",
  appId: "1:444496284422:web:1d9c0c9a2c0d1d78266c87"
});

const messaging = firebase.messaging();
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js').then((reg) => {
        console.log('Yay, service worker is live!', reg);
    }).catch((err) => {
        console.log('No oats for you.', err);
    });
}
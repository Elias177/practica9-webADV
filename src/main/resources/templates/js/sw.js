const version = "v1::" //Change if you want to regenerate cache
const staticCacheName = version +'static-resources'

const offlineStuff = [
    'form.ftl',
    'css/demo.css',
    'css/form-mini.css',
    'css/bootstrap.min.css',
    'js/bootstrap.min.js',
    'js/jquery-3.3.1.slim.js',
    'js/script.js'
];

self.addEventListener('activate', function (event) {
    event.waitUntil(
        caches
            .keys()
            .then((keys) => {
                return Promise.all(
                    keys
                        .filter((key) => {
                            //If your cache name don't start with the current version...
                            return !key.startsWith(version);
                        })
                        .map((key) => {
                            //...YOU WILL BE DELETED
                            return caches.delete(key);
                        })
                );
            })
            .then(() => {
                console.log('WORKER:: activation completed. This is not even my final form');
            })
    )
});

self.addEventListener('install', (event) => {
    console.log('in install');
    event.waitUntil(
        caches
            .open(staticCacheName)
            .then((cache) => {
                cache.add('//cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react.min.js')
                return cache.addAll(offlineStuff);
            })
            .then(() => {
                console.log('WORKER:: install completed');
            })
    )
});

self.addEventListener('fetch', function(event) {
    event.respondWith(
        // Try the cache
        caches.match(event.request).then(function(response) {
            return response || fetch(event.request);
        }).catch(function() {
            //Error stuff
        })
    );
});
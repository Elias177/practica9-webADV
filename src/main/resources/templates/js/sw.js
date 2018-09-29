self.addEventListener('install', function(event) {
    event.waitUntil(
        caches.open('v1').then(function(cache) {
            return cache.addAll([
                '/form.ftl',
                '/css/demo.css',
                '/css/form-mini.css',
                '/css/bootstrap.min.css',
                '/js/bootstrap.min.js',
                '/js/jquery-3.3.1.slim.js',
                '/js/script.js',
                '/fonts/glyphicons-halflings-regular.eot',
                '/fonts/glyphicons-halflings-regular.svg',
                '/fonts/glyphicons-halflings-regular.ttf',
                '/fonts/glyphicons-halflings-regular.woff'

            ]);
        })
    );
});

self.addEventListener('fetch', function(event) {
    event.respondWith(caches.match(event.request).then(function(response) {
        if (response !== undefined) {
            return response;
        } else {
            return fetch(event.request).then(function (response) {
                var responseClone = response.clone();

                caches.open('v1').then(function (cache) {
                    cache.put(event.request, responseClone);
                });
                return response;
            }).catch(function () {
                return caches.match('/js/script.js');
            });
        }
    }));
});
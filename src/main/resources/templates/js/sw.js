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
                '/js/script.js'
            ]);
        })
    );
});

self.addEventListener('fetch', function (event) {
    var requestURL = new URL(event.request.url);
    var freshResource = fetch(event.request).then(function (response) {
        var clonedResponse = response.clone();
        // Don't update the cache with error pages!
        if (response.ok) {
            // All good? Update the cache with the network response
            caches.open('v1').then(function (cache) {
                cache.put(event.request, clonedResponse);
            });
        }
        return response;
    });
    var cachedResource = caches.open('v1').then(function (cache) {
        return cache.match(event.request).then(function(response) {
            return response || freshResource;
        });
    }).catch(function (e) {
        return freshResource;
    });
    event.respondWith(cachedResource);
});
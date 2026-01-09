'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "ed763e4937f937c269f02d51af9f7a01",
"index.html": "66b368d80519c22f3d56e87de537cb47",
"/": "66b368d80519c22f3d56e87de537cb47",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "8abe379f8cf626b61a21606485e13d1f",
"assets/assets/svg/svg_qr.svg": "3fb64c20d0f810e522071d2e912496fb",
"assets/assets/svg/svg_lock.svg": "7bbb15edd6daea974e9827c048c54337",
"assets/assets/svg/svg_chart.svg": "99d34d3beaa096da58896b4e6956bb3f",
"assets/assets/svg/svg_arrow_right.svg": "cb1fef89431adaae0bd790f137b1e279",
"assets/assets/svg/svg_success.svg": "4ce5de4f4290279226e9fcf5507db5a2",
"assets/assets/svg/svg_search.svg": "cf412569542f04d10eb14ec217fbf409",
"assets/assets/svg/svg_upload.svg": "7544ebc2852a7222f5688057d9bd9e1d",
"assets/assets/svg/svg_email.svg": "ebdf427fe8bb657941bf847edf8313ac",
"assets/assets/svg/svg_shirt.svg": "4063943ef94602da6f117b15dc1931dd",
"assets/assets/svg/svg_edit.svg": "9fb9fd4af226ddf36613ee98140324f0",
"assets/assets/svg/svg_logout.svg": "222459072409b8da915d1458be29ebf3",
"assets/assets/svg/svg_camera.svg": "3c876d6237f5d825d9ed84a380486332",
"assets/assets/svg/svg_filter.svg": "e936dad09dbbf4348c95aefa9383a990",
"assets/assets/svg/svg_image.svg": "b5f2d859dc5e7d597456d199fed412ef",
"assets/assets/svg/svg_home.svg": "055cf8aa533988c68ba079115717ba7a",
"assets/assets/svg/svg_calendar_days.svg": "b6a16fe3e7c8f8a6c9b4f831059ba96f",
"assets/assets/svg/svg_phone.svg": "038fda626daac772a6e13d6929ac9058",
"assets/assets/svg/svg_shield.svg": "4e8767b05d89561f691bd8f357325e5d",
"assets/assets/svg/svg_printer.svg": "7f57a92e649b65feac6da12fb26e23bc",
"assets/assets/svg/svg_profile.svg": "ee529daf93fb96b79ac78c714556ee6e",
"assets/assets/svg/svg_sparkles.svg": "7d4bf6d4597703eded7b8251671923cd",
"assets/assets/svg/svg_setting.svg": "b5f45b72f36eed06474c60f50c0ca9e7",
"assets/assets/svg/svg_dot.svg": "84fdad074907cca79f812cf569c26e8b",
"assets/assets/svg/svg_idcard.svg": "428591ee2a5939cd85b830913fdb1a1d",
"assets/assets/svg/svg_error.svg": "eb916f5294c7dbc9b0bfe969d5905a21",
"assets/assets/svg/svg_store.svg": "4063ccc568dd857d403fdd760b003af1",
"assets/assets/svg/svg_pin.svg": "ddaf751e2a5fecfc78bbeca4b23e57bb",
"assets/assets/svg/svg_calendar.svg": "d0d6cd6bf0e1a7cf2e9968b4d8550c09",
"assets/assets/svg/svg_wallet.svg": "eff344be43da73737dbc0f5b9d16f155",
"assets/assets/svg/svg_spark.svg": "7d4bf6d4597703eded7b8251671923cd",
"assets/assets/svg/svg_no_connection.svg": "96340635fe6ce433e461a45d0c18c59f",
"assets/assets/svg/svg_question.svg": "e0048bd5e9e90d03aeefbc5b1c956e0e",
"assets/assets/svg/svg_trash.svg": "3decd32cd9e5e7065418fa5067a947a5",
"assets/assets/svg/svg_clock.svg": "eb2201b50cbd489b0bbcf4aff2079d3e",
"assets/assets/svg/svg_blueprint.svg": "b14ef2e881f691772ceb4104b91e4c8f",
"assets/assets/svg/svg_user.svg": "09c23fa5a7553ba047b7f4bed4d7b1f4",
"assets/assets/svg/svg_more.svg": "3f9f59f116fa70b1baca38d442dc887e",
"assets/assets/svg/svg_users.svg": "f93859e6d477561edb9dad5b3ffc2512",
"assets/assets/svg/svg_package.svg": "93578c29f2665e6895da8a51e32f3c7b",
"assets/assets/svg/svg_order.svg": "53b69cb4fdc73fecac4f8a6cddf063af",
"assets/assets/svg/svg_notification.svg": "b4c8a7e709be9ae97eba490ec031d0f7",
"assets/assets/svg/svg_alert_circle.svg": "856db60d6bed72ec26c584941be58226",
"assets/assets/svg/svg_box.svg": "b72ffede98738138114c794906909dd3",
"assets/assets/svg/svg_key.svg": "e1257e6c27839f40075f1dbc3b6dd995",
"assets/assets/svg/svg_plus.svg": "33d3fcf5251a72f1eef80aaa19f7ab55",
"assets/assets/svg/svg_download.svg": "3eb5522e9a59b36b77fe299b55696f8a",
"assets/assets/svg/svg_check_circle.svg": "87ef69a7ce00c877830333ffdcce40d6",
"assets/assets/svg/svg_share.svg": "228757e7143c092a92639c61d8eeaac8",
"assets/assets/svg/svg_eye.svg": "eefa80619d19b2c9471d44c0734f4e82",
"assets/assets/svg/svg_lucide_award.svg": "a2ea7bc7f7dd597b844ee37efb2d4567",
"assets/assets/svg/svg_face.svg": "3e27c2959b8a1b69bd99844ac2caff1c",
"assets/assets/fonts/DMSans-Regular.ttf": "74f9bb7405caec741a24db735b2c5733",
"assets/fonts/MaterialIcons-Regular.otf": "3c233bbfb7eab602e8d9a0ca54d10495",
"assets/NOTICES": "99b901026b75893a0deb59e00bc29244",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "55a6e9a0424a1b23c4c51bf97546ae03",
"assets/AssetManifest.bin": "7e91b2d689f288dc58145c4e0b155cfe",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "ae3ce07dddea26599cec5c3ce61a77b2",
"version.json": "b3168113c30c2cf2143da4e15a6c6089",
"main.dart.js": "65911bee9d84f77def70f13adc401063"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

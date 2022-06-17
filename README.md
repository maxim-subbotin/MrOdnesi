# MrOdnesi
The simplest delivery app prototype.

## TODO List

1. Data structures are not optimal, some string params could be turned into enums.
2. Errors are catched, but there are no correct alerts in case of web request error or default error images in case of failed image downloading.
3. Closed stores and other inactive items should be marked with color (e.g. b-w images for closed store cells).
4. Get-all-stores command works pretty slow, so we should show spinner. Also we can load stores from the local cache firstly and refresh them later.
5. Data refreshing on pull-down could be a good thing.
6. Some label are not optimized for long titles.
7. Need to think about light and dark color schemes. There is static color scheme now.
8. Data caching is not optimal. We should save stores from the responses in local sqlite db or CoreData and use it in case of offline mode. It's trivial task but more time-consuming so I put all responses in cache and deserialize them if necessary. The simplest and most stupid solution, but implemented it out in five minutes.
9. Data refreshing should be smoother. Need to avoid direct reloadData calls. The better idea is neat merge of old and updated datasets, creating of the lists with updated/deleted/inserted items and view refreshing via performBatchUpdates and other advanced funcstions.
10. Map view consumes a lot of memory, I have no idea if it's possible to decrease this leak. Maybe it's OK for Apple Maps. Looks maps don't like polygons drawing.
11. App has low unit-test coverage.
12. Need to implement good lightweight helper for constraint applying, it could reduce code base by 50%.
13. Web-request wrapper is the simplest, it has the function of data receiving only. It could be extended easily.
14. List of items inside store detail view should be optimized. This view should react on scroll gestures, header must be decreased on scroll up, item categories bar should be shown on scroll to list etc.
15. App should be optimized for small iphone screens (like iPhone SE) and ipads.

## Notes

App is built on MVVM-like pattern, model could be adapted rapidly for SwiftUI.

App supports device location, but this feature has been disabled because my current location returns a few stores only and it's better to use coordinates of Belgrade's center for testing.

## Screenshots

<img src="https://raw.githubusercontent.com/maxim-subbotin/MrOdnesi/master/Demo/screen_home.jpg" width="400">
<img src="https://raw.githubusercontent.com/maxim-subbotin/MrOdnesi/master/Demo/screen_details.jpg" width="400">
<img src="https://raw.githubusercontent.com/maxim-subbotin/MrOdnesi/master/Demo/screen_info.jpg" width="400">

Video:

![Demo video](https://raw.githubusercontent.com/maxim-subbotin/MrOdnesi/master/Demo/demo.mp4)

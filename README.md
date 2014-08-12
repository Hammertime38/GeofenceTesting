GeofenceTesting
===============

Purely for testing behaviors between real devices and the iPhone simulator for geofencing

I took a few shortcuts to make this because it was purely for testing. To create a new geofenced region, simply long tap on the map. To remove, long tap on the region and select "Remove Region X" where 'X' represents the tagged region number. It also hooks into a custom logger that writes to the view controller on the second tab as well as a persistent file logger.  CocoaLumberjack++

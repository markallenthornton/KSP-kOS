

declare function escape {
// escape current SOI while lowering ("down") or raising ("up") orbit in parent SOI

declare parameter escape_dir is "down".

set cv to ship.
sas off.

set parent to body:orbit:body.
set curdist to parent:distance.
wait 1.
set warp to 7.
if escape_dir = "up" {
	print "waiting for optimal up escape".
	if parent:distance > curdist {
		until parent:distance < curdist {
			set curdist to parent:distance.
		}.
	}.
	until parent:distance > curdist{
		set curdist to parent:distance.
	}.
} else {
	print "waiting for optimal down escape".
	if parent:distance < curdist {
		until parent:distance > curdist {
			set curdist to parent:distance.
		}.
	}.
	until parent:distance < curdist{
		set curdist to parent:distance.
	}.
}.
set warp to 0.

// perform burn
print "starting escape burn".
set steer to ship:prograde.
lock steering to steer.
lock throttle to 1.
until cv:orbit:hasnextpatch {
	set steer to ship:prograde.
}.
lock throttle to 0.
set cv:control:pilotmainthrottle to 0.
unlock steering.
sas on.
print "escape burn complete".

}.

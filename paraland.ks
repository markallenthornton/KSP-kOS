
declare function paraland {

declare parameter targheight is body:atm:height/2, jettison is 0, decel is 0, paraheight is 2000.

set cv to ship.
sas off.
chg_peri(targheight,30,.5,100).
sas off.
print "deorbit burn complete".

if cv:orbit:hasnextpatch {
	print "incidental intercept - deorbit must be corrected".
	set curbody to cv:body. 
	wait 1.
	kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
	wait until not(cv:body = curbody).
	kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
	wait until cv:body = curbody.
	chg_peri(targheight,30,.5,100).
	sas off.
}.

wait 1.
if jettison = 1 and decel = 0 {
	stage.
	print "jettisoning non-reentry stage".
}

wait 1.
set warp to 7.
wait until cv:altitude < body:atm:height.
set warp to 0.
panels off.
gear off.
print "entering the atmosphere".

if decel = 1 {
	set steer to cv:srfretrograde.
	lock steering to steer.
	set deceltime to time + eta:periapsis*3/4.
	until time > deceltime {
		set steer to cv:srfretrograde.
	}.
	print "beginning atmospheric deceleration burn".
	lock throttle to 1.0.
	until cv:liquidfuel < .1{
		set steer to cv:srfretrograde.
	}.
	lock throttle to 0.
	print "atmospheric deceleration burn complete".
	if jettison = 1 {
		stage.
		print "jettisoning non-engine stage".
	}.
}

set steer to cv:srfretrograde.
lock steering to steer.
until alt:radar < paraheight {
	set steer to cv:srfretrograde.
}.

chutessafe on.
print "deploying parachutes".
print "deploying landing gear".
gear on.

wait until cv:status = "landed".
print "landing sequence complete".
set cv:control:pilotmainthrottle to 0.
unlock steering.
sas on.
panels on.
}.

declare function rockland {

declare parameter burnstart is 2500.

sas off.
gear on.
set cv to ship.

// check if staging is needed
when (cv:maxthrust = 0) and (cv:liquidfuel > 0) then {
	stage.
	preserve.
}.


set steer to cv:srfretrograde.
lock steering to steer.
print "starting deorbit burn".
lock throttle to 1.0.
until cv:groundspeed < 10{
	set steer to cv:srfretrograde.
}
lock throttle to 0.
print "deorbit burn complete".

wait 1.
set warp to 4.
until alt:radar < burnstart{
	set steer to cv:srfretrograde.
}
set warp to 0.

print "starting vertical burn".
lock throttle to 1.0.
until (cv:groundspeed < .5) and (abs(cv:verticalspeed) < 20){
	set steer to cv:srfretrograde.
}
lock throttle to 0.
print "vertical burn complete".

until alt:radar < 300{
	set steer to cv:srfretrograde.
}
print "final landing sequence".
until cv:status = "landed" {
	set steer to cv:srfretrograde.
	if -cv:verticalspeed > max(alt:radar/10,2) {
		lock throttle to 1.0.
	} else {
		lock throttle to 0.
	}.
}

set cv:control:pilotmainthrottle to 0.
unlock steering.
print "landing sequence complete".
sas on.

}.
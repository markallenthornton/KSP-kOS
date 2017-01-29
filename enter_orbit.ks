
declare function enter_orbit {

declare parameter targheight is body:atm:height+10000, aerobrake is 0, aeroheight is body:atm:height - 5000.

sas off.
set cv to ship.

// check if staging is needed
when (cv:maxthrust = 0) and (cv:liquidfuel > 0) then {
	stage.
	preserve.
}.

if aerobrake = 0 {
	if cv:periapsis < targheight {
		print "raising periapsis to avoid collision".
		set cNode to node(time:seconds + 10,100,0,0).
		add cNode.
		sas off.
		set steer to cNode:burnvector.
		lock steering to steer.
		wait until dirmax(steer:direction-cv:facing) < 20.
		lock throttle to 1.
		until cv:periapsis > targheight{
			set burnTo to cNode:burnvector..
		}.
		lock throttle to 0.
		remove cNode.
	} else {
		circularize().
		chg_peri(targheight,30,.5,100).
	}.
	circ_pe().
} else {
	if cv:periapsis < aeroheight {
		print "raising periapsis to avoid collision".
		set cNode to node(time:seconds + 10,100,0,0).
		add cNode.
		sas off.
		set steer to cNode:burnvector.
		lock steering to steer.
		wait until dirmax(steer:direction-cv:facing) < 20.
		lock throttle to 1.
		until cv:periapsis > aeroheight{
			set burnTo to cNode:burnvector.
		}.
		lock throttle to 0.
		remove cNode.
		set warp to 7.
		wait until cv:altitude < body:atm:height.
		set warp to 0.
		wait until cv:altitude > body:atm:height.
	} else {
		print "lowering periapsis into atmosphere".
		set cNode to node(time:seconds + 10,-100,0,0).
		add cNode.
		sas off.
		set steer to cNode:burnvector.
		lock steering to steer.
		lock throttle to 1.
		until cv:periapsis > aeroheight{
			set burnTo to cNode:burnvector.
		}.
		lock throttle to 0.
		remove cNode.
		set warp to 7.
		wait until cv:altitude < body:atm:height.
		set warp to 0.
		wait until cv:altitude > body:atm:height.
	}.
	circ_ap().
}

lock throttle to 0.
set cv:control:pilotmainthrottle to 0.
unlock steering.
print "orbit achieved".
sas on.

}.
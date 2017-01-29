
declare function toorbit {

declare parameter targheight is body:atm:height + 20000, ldir is 90.

set cv to ship.
sas off.
lock throttle to 1.0.

// initial stage
print "launching".
set steer to heading(ldir,90).
lock steering to steer.
until cv:maxthrust > 0 {
    stage.
}
gear off.

// check if staging is needed
when (cv:maxthrust = 0) and (cv:liquidfuel > 0) then {
	stage.
	preserve.
}.

// launch loop
if body:atm:exists {
	set turnalt to body:atm:height/5.
	wait until cv:altitude > turnalt.
	until cv:apoapsis > targheight {
		set steer to heading(ldir, 10 + 80*(1-(cv:apoapsis/targheight))).
	}.
} else {
	wait 2.
	until cv:apoapsis > targheight {
		set steer to heading(ldir,10).
	}.
}.

set steer to heading(ldir,0).
lock steering to steer.
lock throttle to 0.
print "launch burn complete".

// circularization burn
set deltaA to maxthrust/mass.
set g to constant:G*body:mass/body:radius^2.
set orbitalVelocity to body:radius * sqrt(g/(body:radius + targheight)).
set apVelocity to sqrt(body:mu * ((2/(cv:apoapsis+body:radius))-(1/cv:obt:semimajoraxis))).
set deltaV to (orbitalVelocity - apVelocity).
set timeToBurn to deltaV/deltaA.
set circNode to node(time:seconds + eta:apoapsis,0,0,deltaV).
add circNode.

set burnTo to circNode:burnvector.
wait until cv:altitude > 6000.
exec_node(circNode,burnTo,timeToBurn).
remove circNode.
print "circularization burn complete".


// correction burn if thrust drops during burn
if cv:periapsis < body:atm:height {
	
	set deltaA to maxthrust/mass.
	set orbitalVelocity to body:radius * sqrt(9.8/(body:radius + cv:periapsis)).
	set curVelocity to sqrt(body:mu * ((2/(cv:altitude+body:radius))-(1/cv:obt:semimajoraxis))).
	set deltaV to (orbitalVelocity - curVelocity) + 50.
	set timeToBurn to deltaV/deltaA.
	set normshare to min((cv:orbit:period-eta:apoapsis)/cv:orbit:period,.25)/.25.
	set corNode to node(time:seconds + timeToBurn/2+5,deltaV*(1-normshare),0,deltaV*normshare).
	add corNode.
	set burnTo to corNode:burnvector.
	exec_node(corNode,burnTo,timeToBurn).
	remove corNode.
	print "correction burn complete".
}.

lock throttle to 0.
set cv:control:pilotmainthrottle to 0.
unlock steering.
print "launch sequence complete".
sas on.
panels on.
}.

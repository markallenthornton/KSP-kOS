

declare function intercept {

declare parameter apsis is "apo", orbfrac is .01.

set cv to ship.
sas off.

set tolerance to target:soiradius.
set targheight to (target:orbit:apoapsis + target:orbit:periapsis)/2.
if targheight < cv:apoapsis {
	set apsis to "peri".
}
set inc to target:orbit:period*orbfrac.
set n to round(1/orbfrac).
set wait to 0.
set dv to .5.
set dv to titrate(apsis,targheight,wait,dv,tolerance).
from {local i is 1.} until i = n step {set i to i+1.} do {
	set cNode to node(time:seconds + wait,0,0,dv).
	add cNode.
	if cNode:orbit:hasnextpatch {
		if cNode:orbit:nextpatch:body = target {
			break.
		}
	}
	remove cNode.
	set wait to wait + inc.
}

// calculate dv
set deltaA to maxthrust/mass.
set timeToBurn to dv/deltaA.

// perform burn
set burnTo to cNode:burnvector.
exec_node(cNode,burnTo,timeToBurn).
remove cNode.
print "transfer burn complete".

}.

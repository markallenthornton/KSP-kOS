

declare function circularize {

set cv to ship.
sas off.

// determine closest apsis
if cv:orbit:hasnextpatch {
	set etapsis to eta:periapsis.
	set apsis to cv:periapsis.
} else {
	if eta:periapsis < eta:apoapsis {
		set etapsis to eta:periapsis.
		set apsis to cv:periapsis.
	} else {
		set etapsis to eta:apoapsis.
		set apsis to cv:apoapsis.
	}
}

// prepare node
set targheight to apsis.
set deltaA to maxthrust/mass.
set g to constant:G*body:mass/body:radius^2.
set orbitalVelocity to body:radius * sqrt(g/(body:radius + targheight)).
set apsisVelocity to sqrt(body:mu * ((2/(apsis+body:radius))-(1/cv:obt:semimajoraxis))).
set deltaV to (orbitalVelocity - apsisVelocity).
set timeToBurn to deltaV/deltaA.
set circNode to node(time:seconds + etapsis,0,0,deltaV).
add circNode.

// perform burn
set burnTo to circNode:burnvector.
exec_node(circNode,burnTo,timeToBurn).
remove circNode.
sas on.
print "circularization burn complete".

}.

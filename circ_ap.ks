

declare function circ_ap {

set cv to ship.
sas off.

// prepare node
set targheight to cv:apoapsis.
set deltaA to maxthrust/mass.
set g to constant:G*body:mass/body:radius^2.
set orbitalVelocity to body:radius * sqrt(g/(body:radius + targheight)).
set apVelocity to sqrt(body:mu * ((2/(cv:apoapsis+body:radius))-(1/cv:obt:semimajoraxis))).
set deltaV to (orbitalVelocity - apVelocity).
set timeToBurn to deltaV/deltaA.
set circNode to node(time:seconds + eta:apoapsis,0,0,deltaV).
add circNode.

// perform burn
set burnTo to circNode:burnvector.
exec_node(circNode,burnTo,timeToBurn).
remove circNode.
print "circularization burn complete".

}.

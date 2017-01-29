

declare function circ_pe {

set cv to ship.
sas off.

// prepare node
set targheight to cv:periapsis.
set deltaA to maxthrust/mass.
set g to constant:G*body:mass/body:radius^2.
set orbitalVelocity to body:radius * sqrt(g/(body:radius + targheight)).
set peVelocity to sqrt(body:mu * ((2/(cv:periapsis+body:radius))-(1/cv:obt:semimajoraxis))).
set deltaV to (orbitalVelocity - peVelocity).
set timeToBurn to deltaV/deltaA.
set circNode to node(time:seconds + eta:periapsis,0,0,deltaV).
add circNode.

// perform burn
set burnTo to circNode:burnvector.
exec_node(circNode,burnTo,timeToBurn).
remove circNode.
print "circularization burn complete".

}.



declare function chg_apo {
// change apoapsis height

declare parameter targheight is ship:orbit:apoapsis, wait is 60, dv is .5, tolerance is 1000.

if targheight < ship:orbit:periapsis {
	print "Error! Target apoapsis cannot be below current periapsis".
	return.
}

set cv to ship.
sas off.

// calculate dv
set dv to titrate("apo",targheight,wait,dv,tolerance).
set deltaA to maxthrust/mass.
set timeToBurn to dv/deltaA.

// create node
set cNode to node(time:seconds + wait,0,0,dv).
add cNode.

// perform burn
set burnTo to cNode:burnvector.
exec_node(cnode,burnTo,timeToBurn).
remove cNode.
print "apoapsis change burn complete".

}.

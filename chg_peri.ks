

declare function chg_peri {
// change periapsis height

declare parameter targheight is ship:orbit:periapsis, wtime is 60, dv is .5, tolerance is 1000.

if targheight > ship:orbit:apoapsis {
	print "Error! Target periapsis cannot be below current apoapsis".
	return.
}

set cv to ship.
sas off.

// calculate dv
set dv to titrate("peri",targheight,wtime,dv,tolerance).
set deltaA to maxthrust/mass.
set timeToBurn to dv/deltaA.

// create node
set cNode to node(time:seconds + wtime,0,0,dv).
add cNode.

// perform burn
set burnTo to cNode:burnvector.
exec_node(cnode,burnTo,timeToBurn).
remove cNode.
print "periapsis change burn complete".

}.

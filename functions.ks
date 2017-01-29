declare function sign {
	declare parameter x.
	if x >= 0 {
		set out to 1.
	} else {
		set out to -1.
	}.
	return out.
}.

declare function dirmax {
	declare parameter vec.
	return max(abs(vec:pitch),abs(vec:yaw)).
}.


declare function titrate {
	declare parameter apsis, targheight is ship:orbit:apoapsis, wait is 0, dv is .5, tolerance is 1000.
	if apsis = "apo" {
		set dv to titrate_ap(targheight, wait, dv, tolerance).
	} else {
		set dv to titrate_pe(targheight, wait, dv, tolerance).
	}
	return dv.
}

declare function titrate_ap {
	declare parameter targheight is ship:orbit:apoapsis, wait is 0, dv is .5, tolerance is 1000.
	
	set dirsign to sign(targheight - ship:orbit:apoapsis).
	set error to dirsign.
	set etanode to time:seconds + wait.
	
	// find bracket via doubling
	until not (dirsign = sign(error)) {
		set pdv to dv.
		set dv to dv*1.1.
		set cNode to node(etanode,0,0,dv*dirsign).
		add cNode.
		set error to targheight - cNode:orbit:apoapsis.
		if cNode:orbit:apoapsis < 0 {
			if cNode:orbit:nextpatch:body = sun{
				set error to targheight - body:soiradius.
			}
		}
		remove cNode.
	}
	
	print "optimizing".
	
	// optimize via titration
	set diff to (dv-pdv)/2.
	set diffsign to sign(error).
	until abs(error) < tolerance {
		set dv to dv + diffsign*diff.
		set cNode to node(etanode,0,0,dv*dirsign*dirsign).
		add cNode.
		set error to targheight - cNode:orbit:apoapsis.
		if cNode:orbit:apoapsis < 0 {
			if cNode:orbit:nextpatch:body = sun{
				set error to targheight - body:soiradius.
			}
		}
		remove cNode.
		if not (sign(error) = diffsign){
			set diff to diff/2.
			set diffsign to sign(error).
		}
	}
	
	return dv.
	
}

declare function titrate_pe {
	declare parameter targheight is ship:orbit:periapsis, wait is 0, dv is .5, tolerance is 1000.
	
	set dirsign to sign(targheight - ship:orbit:periapsis).
	set error to dirsign.
	set etanode to time:seconds + wait.
	// find bracket via doubling
	until not (dirsign = sign(error)) {
		set pdv to dv.
		set dv to dv*1.1.
		set cNode to node(etanode,0,0,dv*dirsign).
		add cNode.
		set error to targheight - cNode:orbit:periapsis.
		remove cNode.
	}
	
	print "optimizing dv".
	
	// optimize via titration
	set diff to (dv-pdv)/2.
	set diffsign to sign(error).
	until abs(error) < tolerance {
		set dv to dv + diffsign*diff.
		set cNode to node(etanode,0,0,dv*dirsign*dirsign).
		add cNode.
		set error to targheight - cNode:orbit:periapsis.
		remove cNode.
		if not (sign(error) = diffsign){
			set diff to diff/2.
			set diffsign to sign(error).
		}
	}
	
	return dv.
	
}

declare function exec_node {

declare parameter eNode, burnTo, timeToBurn.

lock steering to burnTo.
wait until dirmax(burnTo:direction-cv:facing) < 15.
print "burn orientation achieved".
kuniverse:timewarp:warpto(time:seconds + eNode:eta - abs(timeToBurn/2)).
wait until eNode:eta < abs(timeToBurn/2).

print "starting node burn".
lock throttle to 1.
until eNode:deltav:mag < 10{
	set burnTo to eNode:burnvector.
}.
lock throttle to .1.
until eNode:deltav:mag < .5{
	set burnTo to eNode:burnvector.
}.
wait .2.
lock throttle to 0.
set cv:control:pilotmainthrottle to 0.
unlock steering.
sas on.

}.

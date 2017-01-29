

declare function match_incline {

set cv to ship.
sas off.

// calculate angular momentums
set vtgt to target:velocity:orbit.
set pm to target:position-target:body:position.
set amm to vcrs(pm, vtgt).  
set ps to ship:position-body:position.
set ams0 to vcrs(ps, ship:velocity:orbit).
set ams1 to ams0:mag*amm:normalized.

//inclination between angular momentum
set inc to vang(ams0,ams1).

// calculate steering vector
set amp to vcrs(ams0,ams1):normalized.   // perpendicular to angular momentums; points to node
set amdelta to ams1 - ams0.
set dir to vcrs(amdelta, amp):normalized.
lock steering to R(0,0,0)*dir.

// calculate angle to maneuver and eta
set amp2ps to vang(amp, ps).             // angle between node and ship position
set side to vdot(amp,velocity:orbit).    // positive when orbiting towards node, negative away
if side > 0 {
    set aburn to amp2ps.
} else {
    set aburn to 360-amp2ps.
}
set smas to ps:mag.                       
set ops to 2*constant:pi*sqrt(smas^3/body:mu).         // ship orbital period
set etab to aburn/360*ops.

// calculate maneuver deltav
set dv to amdelta:mag/ps:mag.            // math: dL = r x m dv, with r & dv perpendicular: dL/(r m) = dv, amdelta = dL/m
set nd to node(time:seconds + etab, 0, -dv*cos(inc/2), -dv*sin(inc/2)).
add nd.

// calculate burntime
set deltaA to maxthrust/mass.
set timeToBurn to dv/deltaA.

// execute node
print "starting inclination burn".
set burnTo to nd:burnvector.
exec_node(nd,burnTo,timeToBurn).
remove nd.
print "inclination burn complete".
}.

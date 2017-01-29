// read in functions
run functions.
run chg_apo.
run chg_peri.
run circ_ap.
run circ_pe.
run toorbit.
run paraland.
run rockland.
run match_incline.
run circularize.
run intercept.
run escape.
run enter_orbit.

toorbit(150000).

print "targeting munar intercept".
set target to mun.
intercept().

wait 1.
kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
wait until body = mun.
print "preparing for munar capture".
enter_orbit(6000).

stage.
print "preparing for munar landing".
rockland(2000).
wait 6.
print "Onwards and upwards!".

toorbit(30000).

escape("up").
wait 1.
kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
wait until body = kerbin.

circ_ap().
print "targeting minmus intercept".
set target to minmus.
match_incline().
intercept().

wait 1.
kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
wait until body = minmus.
print "preparing for minmar capture".
enter_orbit(6000).

print "preparing for minmar landing".
rockland(2000).
wait 6.
print "Well, been there, done that. Let's go home".

toorbit(30000).

escape("up").
wait 1.
kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
wait until body = kerbin.
kuniverse:timewarp:warpto(time:seconds + 3600*5*10).
print "initiating return sequence".
paraland(30000,1,0,1000).
print "Home, sweet home!".


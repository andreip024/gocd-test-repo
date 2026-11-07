// Parametric twist-off (lug) cap for glass jars, Ø58 mm mouth
// Print top-down (flat top on the bed), no supports. PETG recommended.
// Measure the OUTER diameter of the glass threads on your jar and set glass_d.

/* [Fit] */
glass_d   = 58;    // outer diameter of the glass threads (mm)
clearance = 0.6;   // diametral clearance between threads and cap skirt
lug_depth = 1.5;   // how far the lugs reach inward (must reach under the glass threads)
lug_z     = 5.5;   // distance from inner top surface to lug bearing face (mm)
lugs      = 4;     // number of lugs (TO finishes use 4; 6 also common on 58+)
lug_arc   = 24;    // angular length of each lug (deg)
pitch     = 8;     // lug ramp, mm of travel per full turn (right-hand)

/* [Body] */
wall      = 2.0;   // skirt wall thickness
top_t     = 2.0;   // top thickness
skirt_h   = 9.0;   // inner skirt height
ribs      = 60;    // grip ribs (0 = smooth)
rib_d     = 0.7;   // rib height

/* [Gasket] */
make_gasket = false; // true = export the TPU gasket instead of the cap
gasket_id   = 48;    // gasket inner diameter
gasket_t    = 1.5;   // gasket thickness

$fn = 180;
R_in  = (glass_d + clearance) / 2;
R_out = R_in + wall;
H     = top_t + skirt_h;

module body() {
  difference() {
    union() {
      // shell with chamfered bed edge (prevents elephant foot)
      hull() {
        translate([0,0,0.6]) cylinder(r=R_out, h=H-0.6);
        cylinder(r=R_out-0.6, h=H-0.6);
      }
      if (ribs > 0)
        for (i=[0:ribs-1]) rotate(i*360/ribs)
          translate([R_out-0.3, 0, 1.2])
            cylinder(r=rib_d, h=H-1.2-0.4, $fn=12);
    }
    translate([0,0,top_t]) cylinder(r=R_in, h=H);
    // lead-in chamfer at the open end
    translate([0,0,H-0.8]) cylinder(r1=R_in, r2=R_in+0.8, h=0.81);
  }
}

// One lug swept along an arc with a right-hand ramp and tapered ends.
// Its face toward the cap top is 45° so it prints without supports.
module lug() {
  n  = 24;
  Rw = R_in + 0.5;               // anchored inside the wall
  function d(t)  = lug_depth * min(1, min(t, 1-t) / 0.2);    // taper ends
  function sec(t) = let(a = t*lug_arc, zb = top_t + lug_z + pitch*a/360,
                        dd = max(d(t), 0.15), Rt = R_in - dd, tip = 0.8)
    [ for (p = [[Rw, zb-0.5], [Rt, zb+dd], [Rt, zb+dd+tip], [Rw, zb+2*dd+tip+0.5]])
        [p[0]*cos(a), p[0]*sin(a), p[1]] ];
  pts = [ for (i=[0:n]) each sec(i/n) ];
  faces = concat(
    [[0,1,2],[0,2,3]],
    [[4*n+2,4*n+1,4*n],[4*n+3,4*n+2,4*n]],
    [ for (i=[0:n-1], k=[0:3], f=[0:1]) let(a=4*i+k, b=4*i+(k+1)%4)
        f==0 ? [a, a+4, b+4] : [a, b+4, b] ]
  );
  polyhedron(points=pts, faces=faces, convexity=4);
}

module cap() {
  body();
  intersection() {
    for (i=[0:lugs-1]) rotate(i*360/lugs) lug();
    cylinder(r=R_in+0.4, h=H-0.8);  // keep lugs out of the lead-in chamfer
  }
}

module gasket() {
  difference() {
    cylinder(r=R_in-0.3, h=gasket_t);
    translate([0,0,-1]) cylinder(d=gasket_id, h=gasket_t+2);
  }
}

if (make_gasket) gasket(); else cap();

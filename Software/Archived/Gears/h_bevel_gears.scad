
/* [Basic Gear Parameters] */
Module = 1; // 0.01

Gear_type = "spur_gear"; // ["rack":Rack, "spur_gear":Spur gear, "herringbone_gear":Herringbone gear, "rack_and_pinion": Rack and pinion, "annular_spur_gear":Annular/Internal spur gear, "annular_herringbone_gear":Annular/Internal herrinbone gear, "planetary_gear":Planetary gear, "bevel_gear":Bevel gear, "bevel_gears":Bevel gears, "herringbone_bevel_gear":Herringbone bevel gear, "herringbone_bevel_gears":Herringbone bevel gears, "worm":Worm, "worm_drive":Worm drive]

width = 5.0; // 0.01
teeth = 30;
bore = 3; // 0.01
straight = false;

/* [Advanced Parameters] */
hub = true;
hub_diameter = 6; // 0.01
hub_thickness = 5; // 0.01

mount_hole_size = 3;
mount_hole_distnce = 20;

// (Weight optimization if applicable)
optimized = false;
pressure_angle = 20; // 0.01
helix_angle = 20; // 0.01
clearance = 0.05; // 0.01

/* [Multi-gear configurations] */
idler_teeth = 36;
idler_bore = 3; // 0.01
assembled = true;

/* [Rack parameters] */
rack_length = 50; // 0.01
rack_height = 4; // 0.01

/* [Worm parameters] */
// Worm lead angle                                                                (For final worm diameter, see also number of starts.)
lead_angle = 4; // 0.01
// Number of starts                                                                (For final worm diameter, see also lead angle.)
worm_starts = 1;
// Worm bore                                             (Please note: The bore in Basic Gear Parameters is used for the bore of the worm gear, not the worm.)
worm_bore = 3; // 0.01
worm_length = 6; // 0.01

/* [Bevel gear parameters] */
bevel_angle = 45; // 0.01
bevel_width = 5; // 0.01
shaft_angle = 90; // 0.01

/* [Annular/internal gear parameters] */
rim_width = 3; // 0.01

/* [Planetary gear parameters] */
solar_teeth = 20;
planet_teeth = 10;
number_of_planets = 3;


module customizer_separator() {}

finalHelixAngle = straight ? 0 : helix_angle;
final_hub_diameter = hub ? hub_diameter : 0;
final_hub_thickness = hub ? hub_thickness : 0;

$fn = 50;

/* Library for Involute Gears, Screws and Racks

This library contains the following modules
- rack(modul, length, height, width, pressure_angle=20, helix_angle=0)
- mountable_rack(modul, length, height, width, pressure_angle=20, helix_angle=0, fastners, profile, head)
- herringbone_rack(modul, length, height, width, pressure_angle = 20, helix_angle=45)
- mountable_herringbone_rack(modul, length, height, width, pressure_angle=20, helix_angle=45, fastners, profile, head) 
- spur_gear(modul, tooth_number, width, bore, pressure_angle=20, helix_angle=0, optimized=true)
- herringbone_gear(modul, tooth_number, width, bore, pressure_angle=20, helix_angle=0, optimized=true)
- rack_and_pinion (modul, rack_length, gear_teeth, rack_height, gear_bore, width, pressure_angle=20, helix_angle=0, together_built=true, optimized=true)
- ring_gear(modul, tooth_number, width, rim_width, pressure_angle=20, helix_angle=0)
- herringbone_ring_gear(modul, tooth_number, width, rim_width, pressure_angle=20, helix_angle=0)
- planetary_gear(modul, sun_teeth, planet_teeth, number_planets, width, rim_width, bore, pressure_angle=20, helix_angle=0, together_built=true, optimized=true)
- bevel_gear(modul, tooth_number,  partial_cone_angle, tooth_width, bore, pressure_angle=20, helix_angle=0)
- bevel_herringbone_gear(modul, tooth_number, partial_cone_angle, tooth_width, bore, pressure_angle=20, helix_angle=0)
- bevel_gear_pair(modul, gear_teeth, pinion_teeth, axis_angle=90, tooth_width, bore, pressure_angle = 20, helix_angle=0, together_built=true)
- bevel_herringbone_gear_pair(modul, gear_teeth, pinion_teeth, axis_angle=90, tooth_width, bore, pressure_angle = 20, helix_angle=0, together_built=true)
- worm(modul, thread_starts, length, bore, pressure_angle=20, lead_angle=10, together_built=true)
- worm_gear(modul, tooth_number, thread_starts, width, length, worm_bore, gear_bore, pressure_angle=20, lead_angle=0, optimized=true, together_built=true)

Examples of each module are commented out at the end of this file

Author:     Dr Jörg Janssen
Contributions By:   Keith Emery, Chris Spencer
Last Verified On:      1. June 2018
Version:    2.2
License:     Creative Commons - Attribution, Non Commercial, Share Alike

Permitted modules according to DIN 780:
0.05 0.06 0.08 0.10 0.12 0.16
0.20 0.25 0.3  0.4  0.5  0.6
0.7  0.8  0.9  1    1.25 1.5
2    2.5  3    4    5    6
8    10   12   16   20   25
32   40   50   60

*/


// General Variables
pi = 3.14159;
rad = 57.29578;
 
/*  Converts Radians to Degrees */
function grad(pressure_angle) = pressure_angle*rad;

/*  Converts Degrees to Radians */
function radian(pressure_angle) = pressure_angle/rad;

/*  Converts 2D Polar Coordinates to Cartesian
    Format: radius, phi; phi = Angle to x-Axis on xy-Plane */
function polar_to_cartesian(polvect) = [
    polvect[0]*cos(polvect[1]),  
    polvect[0]*sin(polvect[1])
];

/*  Circle Involutes-Function:
    Returns the Polar Coordinates of an Involute Circle
    r = Radius of the Base Circle
    rho = Rolling-angle in Degrees */
function ev(r,rho) = [
    r/cos(rho),
    grad(tan(rho)-radian(rho))
];

/*  Sphere-Involutes-Function
    Returns the Azimuth Angle of an Involute Sphere
    theta0 = Polar Angle of the Cone, where the Cutting Edge of the Large Sphere unrolls the Involute
    theta = Polar Angle for which the Azimuth Angle of the Involute is to be calculated */
function sphere_ev(theta0,theta) = 1/sin(theta0)*acos(cos(theta)/cos(theta0))-acos(tan(theta0)/tan(theta));

/*  Converts Spherical Coordinates to Cartesian
    Format: radius, theta, phi; theta = Angle to z-Axis, phi = Angle to x-Axis on xy-Plane */
function sphere_to_cartesian(vect) = [
    vect[0]*sin(vect[1])*cos(vect[2]),  
    vect[0]*sin(vect[1])*sin(vect[2]),
    vect[0]*cos(vect[1])
];

/*  Check if a Number is even
    = 1, if so
    = 0, if the Number is not even */
function is_even(number) =
    (number == floor(number/2)*2) ? 1 : 0;

/*  greatest common Divisor
    according to Euclidean Algorithm.
    Sorting: a must be greater than b */
function ggt(a,b) = 
    a%b == 0 ? b : ggt(b,a%b);

/*  Polar function with polar angle and two variables */
function spiral(a, r0, phi) =
    a*phi + r0; 

/*  Copy and rotate a Body */
module copier(vect, number, distance, winkel){
    for(i = [0:number-1]){
        translate(v=vect*distance*i)
            rotate(a=i*winkel, v = [0,0,1])
                children(0);
    }
}







/*  Bevel Gear
    modul = Height of the Tooth Tip over the Partial Cone; Specification for the Outside of the Cone
    tooth_number = Number of Gear Teeth
    partial_cone_angle = (Half)angle of the Cone on which the other Ring Gear rolls
    tooth_width = Width of the Teeth from the Outside toward the apex of the Cone
    bore = Diameter of the Center Hole
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle, Standard = 0° */
module bevel_gear(modul, tooth_number, partial_cone_angle, tooth_width, bore, pressure_angle = 20, helix_angle=0) {

     

    // Dimension Calculations
    d_outside = modul * tooth_number;                                    // Part Cone Diameter at the Cone Base,
                                                                    // corresponds to the Chord in a Spherical Section
    r_outside = d_outside / 2;                                        // Part Cone Radius at the Cone Base
    rg_outside = r_outside/sin(partial_cone_angle);                      // Large-Cone Radius for Outside-Tooth, corresponds to the Length of the Cone-Flank;
    rg_inside = rg_outside - tooth_width;                              // Large-Cone Radius for Inside-Tooth  
    r_inside = r_outside*rg_inside/rg_outside;
    alpha_spur = atan(tan(pressure_angle)/cos(helix_angle));// Helix Angle in Transverse Section
    delta_b = asin(cos(alpha_spur)*sin(partial_cone_angle));          // Base Cone Angle     
    da_outside = (modul <1)? d_outside + (modul * 2.2) * cos(partial_cone_angle): d_outside + modul * 2 * cos(partial_cone_angle);
    ra_outside = da_outside / 2;
    delta_a = asin(ra_outside/rg_outside);
    c = modul / 6;                                                  // Tip Clearance
    df_outside = d_outside - (modul +c) * 2 * cos(partial_cone_angle);
    rf_outside = df_outside / 2;
    delta_f = asin(rf_outside/rg_outside);
    rkf = rg_outside*sin(delta_f);                                   // Radius of the Cone Foot
    height_f = rg_outside*cos(delta_f);                               // Height of the Cone from the Root Cone
    
    echo("Part Cone Diameter at the Cone Base = ", d_outside);
    
    // Sizes for Complementary Truncated Cone
    height_k = (rg_outside-tooth_width)/cos(partial_cone_angle);          // Height of the Complementary Cone for corrected Tooth Length
    rk = (rg_outside-tooth_width)/sin(partial_cone_angle);               // Foot Radius of the Complementary Cone
    rfk = rk*height_k*tan(delta_f)/(rk+height_k*tan(delta_f));        // Tip Radius of the Cylinders for 
                                                                    // Complementary Truncated Cone
    height_fk = rk*height_k/(height_k*tan(delta_f)+rk);                // height of the Complementary Truncated Cones

    echo("Bevel Gear Height = ", height_f-height_fk);
    
    phi_r = sphere_ev(delta_b, partial_cone_angle);                      // Angle to Point of Involute on Partial Cone
        
    // Torsion Angle gamma from Helix Angle
    gamma_g = 2*atan(tooth_width*tan(helix_angle)/(2*rg_outside-tooth_width));
    gamma = 2*asin(rg_outside/r_outside*sin(gamma_g/2));
    
    step = (delta_a - delta_b)/16;
    tau = 360/tooth_number;                                             // Pitch Angle
    start = (delta_b > delta_f) ? delta_b : delta_f;
    mirrpoint = (180*(1-clearance))/tooth_number+2*phi_r;

    // Drawing
    rotate([0,0,phi_r+90*(1-clearance)/tooth_number]){                      // Center Tooth on X-Axis;
                                                                    // Makes Alignment with other Gears easier
        translate([0,0,height_f]) rotate(a=[0,180,0]){
            union(){
                translate([0,0,height_f]) rotate(a=[0,180,0]){                               // Truncated Cone                          
                    difference(){
                        linear_extrude(height=height_f-height_fk, scale=rfk/rkf) circle(rkf*1.001); // 1 permille Overlap with Tooth Root
                        translate([0,0,-1]){
                            cylinder(h = height_f-height_fk+2, r = bore/2);                // bore
                               
                        }
                    }   
                }
                for (rot = [0:tau:360]){
                    rotate (rot) {                                                          // Copy and Rotate "Number of Teeth"
                        union(){
                            if (delta_b > delta_f){
                                // Tooth Root
                                flankpoint_under = 1*mirrpoint;
                                flankpoint_over = sphere_ev(delta_f, start);
                                polyhedron(
                                    points = [
                                        sphere_to_cartesian([rg_outside, start*1.001, flankpoint_under]),    // 1 permille Overlap with Tooth
                                        sphere_to_cartesian([rg_inside, start*1.001, flankpoint_under+gamma]),
                                        sphere_to_cartesian([rg_inside, start*1.001, mirrpoint-flankpoint_under+gamma]),
                                        sphere_to_cartesian([rg_outside, start*1.001, mirrpoint-flankpoint_under]),                               
                                        sphere_to_cartesian([rg_outside, delta_f, flankpoint_under]),
                                        sphere_to_cartesian([rg_inside, delta_f, flankpoint_under+gamma]),
                                        sphere_to_cartesian([rg_inside, delta_f, mirrpoint-flankpoint_under+gamma]),
                                        sphere_to_cartesian([rg_outside, delta_f, mirrpoint-flankpoint_under])                                
                                    ],
                                    faces = [[0,1,2],[0,2,3],[0,4,1],[1,4,5],[1,5,2],[2,5,6],[2,6,3],[3,6,7],[0,3,7],[0,7,4],[4,6,5],[4,7,6]],
                                    convexity =1
                                );
                            }
                            // Tooth
                            for (delta = [start:step:delta_a-step]){
                                flankpoint_under = sphere_ev(delta_b, delta);
                                flankpoint_over = sphere_ev(delta_b, delta+step);
                                polyhedron(
                                    points = [
                                        sphere_to_cartesian([rg_outside, delta, flankpoint_under]),
                                        sphere_to_cartesian([rg_inside, delta, flankpoint_under+gamma]),
                                        sphere_to_cartesian([rg_inside, delta, mirrpoint-flankpoint_under+gamma]),
                                        sphere_to_cartesian([rg_outside, delta, mirrpoint-flankpoint_under]),                             
                                        sphere_to_cartesian([rg_outside, delta+step, flankpoint_over]),
                                        sphere_to_cartesian([rg_inside, delta+step, flankpoint_over+gamma]),
                                        sphere_to_cartesian([rg_inside, delta+step, mirrpoint-flankpoint_over+gamma]),
                                        sphere_to_cartesian([rg_outside, delta+step, mirrpoint-flankpoint_over])                                   
                                    ],
                                    faces = [[0,1,2],[0,2,3],[0,4,1],[1,4,5],[1,5,2],[2,5,6],[2,6,3],[3,6,7],[0,3,7],[0,7,4],[4,6,5],[4,7,6]],
                                    convexity =1
                                );
                            }
                        }
                    }
                }   
            }
        }
    }
}

/*  Bevel Herringbone Gear; uses the Module "bevel_gear"
    modul = Height of the Tooth Tip beyond the Pitch Circle
    tooth_number = Number of Gear Teeth
    partial_cone_angle, tooth_width
    bore = Diameter of the Center Hole
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle, Standard = 0° */
module bevel_herringbone_gear(modul, tooth_number, partial_cone_angle, tooth_width, bore, pressure_angle = 20, helix_angle=0){

    // Dimension Calculations
    
    tooth_width = tooth_width / 2;
    
    d_outside = modul * tooth_number;                                // Part Cone Diameter at the Cone Base,
                                                                // corresponds to the Chord in a Spherical Section
    r_outside = d_outside / 2;                                    // Part Cone Radius at the Cone Base
    rg_outside = r_outside/sin(partial_cone_angle);                  // Large-Cone Radius, corresponds to the Length of the Cone-Flank;
    c = modul / 6;                                              // Tip Clearance
    df_outside = d_outside - (modul +c) * 2 * cos(partial_cone_angle);
    rf_outside = df_outside / 2;
    delta_f = asin(rf_outside/rg_outside);
    height_f = rg_outside*cos(delta_f);                           // Height of the Cone from the Root Cone

    // Torsion Angle gamma from Helix Angle
    gamma_g = 2*atan(tooth_width*tan(helix_angle)/(2*rg_outside-tooth_width));
    gamma = 2*asin(rg_outside/r_outside*sin(gamma_g/2));
    
    echo("Part Cone Diameter at the Cone Base = ", d_outside);
    
    // Sizes for Complementary Truncated Cone
    height_k = (rg_outside-tooth_width)/cos(partial_cone_angle);      // Height of the Complementary Cone for corrected Tooth Length
    rk = (rg_outside-tooth_width)/sin(partial_cone_angle);           // Foot Radius of the Complementary Cone
    rfk = rk*height_k*tan(delta_f)/(rk+height_k*tan(delta_f));    // Tip Radius of the Cylinders for 
                                                                // Complementary Truncated Cone
    height_fk = rk*height_k/(height_k*tan(delta_f)+rk);            // height of the Complementary Truncated Cones
    
    modul_inside = modul*(1-tooth_width/rg_outside);
    difference(){
            union(){
            bevel_gear(modul, tooth_number, partial_cone_angle, tooth_width, bore,          pressure_angle, helix_angle);        // bottom Half
            translate([0,0,height_f-height_fk])
                rotate(a=-gamma,v=[0,0,1])
                    bevel_gear(modul_inside, tooth_number, partial_cone_angle, tooth_width, bore, pressure_angle, -helix_angle); // top Half
        
            //kp hub reverse should be at top with -helix
            difference(){
            // hub         
            translate([0,0,-final_hub_thickness])
            cylinder(h=final_hub_thickness,r=df_outside/2);
            // bore
            translate([0,0,-final_hub_thickness-1])
            cylinder(h=final_hub_thickness+10,r=bore/2);
                
            
                
                
            }//end different    
        }//end union
        
        
        //mount holes
        for (a =[0:3])
        {
            translate([0,0,-final_hub_thickness-2])
            rotate((a*90),[0,0,1])
            translate([0,mount_hole_distnce/2,0])
            cylinder(h = height_f+final_hub_thickness, r = mount_hole_size/2);
        }
        
        //hex nut embedd
        nut_offset = 0.4;
        nut_depth = 5;
        
        //translate([0,0,-final_hub_thickness-1])
        //cylinder($fn = 6, h=nut_depth+1,r=(13/2)+(nut_offset/2));
        
        
    }//end difference
    
    //translate([0,0,-3])
    //cylinder(h=3,r=r_outside);
}

/*  Spiral Bevel Gear; uses the Module "bevel_gear"
    modul = Height of the Tooth Tip beyond the Pitch Circle
    tooth_number = Number of Gear Teeth
    height = Height of Gear Teeth
    bore = Diameter of the Center Hole
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle, Standard = 0° */
module spiral_bevel_gear(modul, tooth_number, partial_cone_angle, tooth_width, bore, pressure_angle = 20, helix_angle=30){

    steps = 16;

    // Dimension Calculations
    
    b = tooth_width / steps;  
    d_outside = modul * tooth_number;                                // Part Cone Diameter at the Cone Base,
                                                                // corresponds to the Chord in a Spherical Section
    r_outside = d_outside / 2;                                    // Part Cone Radius at the Cone Base
    rg_outside = r_outside/sin(partial_cone_angle);                  // Large-Cone Radius, corresponds to the Length of the Cone-Flank;
    rg_center = rg_outside-tooth_width/2;

    echo("Part Cone Diameter at the Cone Base = ", d_outside);

    a=tan(helix_angle)/rg_center;
    
    union(){
    for(i=[0:1:steps-1]){
        r = rg_outside-i*b;
        helix_angle = a*r;
        modul_r = modul-b*i/rg_outside;
        translate([0,0,b*cos(partial_cone_angle)*i])
            
            rotate(a=-helix_angle*i,v=[0,0,1])
                bevel_gear(modul_r, tooth_number, partial_cone_angle, b, bore, pressure_angle, helix_angle);   // top Half
        }
    }
}

/*  Bevel Gear Pair with any axis_angle; uses the Module "bevel_gear"
    modul = Height of the Tooth Tip over the Partial Cone; Specification for the Outside of the Cone
    gear_teeth = Number of Gear Teeth on the Gear
    pinion_teeth = Number of Gear Teeth on the Pinion
    axis_angle = Angle between the Axles of the Gear and Pinion
    tooth_width = Width of the Teeth from the Outside toward the apex of the Cone
    gear_bore = Diameter of the Center Hole of the Gear
    pinion_bore = Diameter of the Center Bore of the Gear
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle, Standard = 0°
    together_built = Components assembled for Construction or separated for 3D-Printing */
module bevel_gear_pair(modul, gear_teeth, pinion_teeth, axis_angle=90, tooth_width, gear_bore, pinion_bore, pressure_angle=20, helix_angle=0, together_built=true){
 
    // Dimension Calculations
    r_gear = modul*gear_teeth/2;                           // Cone Radius of the Gear
    delta_gear = atan(sin(axis_angle)/(pinion_teeth/gear_teeth+cos(axis_angle)));   // Cone Angle of the Gear
    delta_pinion = atan(sin(axis_angle)/(gear_teeth/pinion_teeth+cos(axis_angle)));// Cone Angle of the Pinion
    rg = r_gear/sin(delta_gear);                              // Radius of the Large Sphere
    c = modul / 6;                                          // Tip Clearance
    df_pinion = pi*rg*delta_pinion/90 - 2 * (modul + c);    // Bevel Diameter on the Large Sphere 
    rf_pinion = df_pinion / 2;                              // Root Cone Radius on the Large Sphere
    delta_f_pinion = rf_pinion/(pi*rg) * 180;               // Tip Cone Angle
    rkf_pinion = rg*sin(delta_f_pinion);                    // Radius of the Cone Foot
    height_f_pinion = rg*cos(delta_f_pinion);                // Height of the Cone from the Root Cone
    
    echo("Cone Angle Gear = ", delta_gear);
    echo("Cone Angle Pinion = ", delta_pinion);
 
    df_gear = pi*rg*delta_gear/90 - 2 * (modul + c);          // Bevel Diameter on the Large Sphere 
    rf_gear = df_gear / 2;                                    // Root Cone Radius on the Large Sphere
    delta_f_gear = rf_gear/(pi*rg) * 180;                     // Tip Cone Angle
    rkf_gear = rg*sin(delta_f_gear);                          // Radius of the Cone Foot
    height_f_gear = rg*cos(delta_f_gear);                      // Height of the Cone from the Root Cone

    echo("Gear Height = ", height_f_gear);
    echo("Pinion Height = ", height_f_pinion);
    
    rotate = is_even(pinion_teeth);
    
    // Drawing
    // Rad
    rotate([0,0,180*(1-clearance)/gear_teeth*rotate])
        bevel_gear(modul, gear_teeth, delta_gear, tooth_width, gear_bore, pressure_angle, helix_angle);
    
    // Ritzel
    if (together_built)
        translate([-height_f_pinion*cos(90-axis_angle),0,height_f_gear-height_f_pinion*sin(90-axis_angle)])
            rotate([0,axis_angle,0])
                bevel_gear(modul, pinion_teeth, delta_pinion, tooth_width, pinion_bore, pressure_angle, -helix_angle);
    else
        translate([rkf_pinion*2+modul+rkf_gear,0,0])
            bevel_gear(modul, pinion_teeth, delta_pinion, tooth_width, pinion_bore, pressure_angle, -helix_angle);
 }

/*  Herringbone Bevel Gear Pair with arbitrary axis_angle; uses the Module "bevel_herringbone_gear"
    modul = Height of the Tooth Tip over the Partial Cone; Specification for the Outside of the Cone
    gear_teeth = Number of Gear Teeth on the Gear
    pinion_teeth = Number of Gear Teeth on the Pinion
    axis_angle = Angle between the Axles of the Gear and Pinion
    tooth_width = Width of the Teeth from the Outside toward the apex of the Cone
    gear_bore = Diameter of the Center Hole of the Gear
    pinion_bore = Diameter of the Center Bore of the Gear
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle, Standard = 0°
    together_built = Components assembled for Construction or separated for 3D-Printing */
module bevel_herringbone_gear_pair(modul, gear_teeth, pinion_teeth, axis_angle=90, tooth_width, gear_bore, pinion_bore, pressure_angle = 20, helix_angle=10, together_built=true){
 
    r_gear = modul*gear_teeth/2;                           // Cone Radius of the Gear
    delta_gear = atan(sin(axis_angle)/(pinion_teeth/gear_teeth+cos(axis_angle)));   // Cone Angle of the Gear
    delta_pinion = atan(sin(axis_angle)/(gear_teeth/pinion_teeth+cos(axis_angle)));// Cone Angle of the Pinion
    rg = r_gear/sin(delta_gear);                              // Radius of the Large Sphere
    c = modul / 6;                                          // Tip Clearance
    df_pinion = pi*rg*delta_pinion/90 - 2 * (modul + c);    // Bevel Diameter on the Large Sphere 
    rf_pinion = df_pinion / 2;                              // Root Cone Radius on the Large Sphere
    delta_f_pinion = rf_pinion/(pi*rg) * 180;               // Tip Cone Angle
    rkf_pinion = rg*sin(delta_f_pinion);                    // Radius of the Cone Foot
    height_f_pinion = rg*cos(delta_f_pinion);                // Height of the Cone from the Root Cone
    
    echo("Cone Angle Gear = ", delta_gear);
    echo("Cone Angle Pinion = ", delta_pinion);
 
    df_gear = pi*rg*delta_gear/90 - 2 * (modul + c);          // Bevel Diameter on the Large Sphere 
    rf_gear = df_gear / 2;                                    // Root Cone Radius on the Large Sphere
    delta_f_gear = rf_gear/(pi*rg) * 180;                     // Tip Cone Angle
    rkf_gear = rg*sin(delta_f_gear);                          // Radius of the Cone Foot
    height_f_gear = rg*cos(delta_f_gear);                      // Height of the Cone from the Root Cone

    echo("Gear Height = ", height_f_gear);
    echo("Pinion Height = ", height_f_pinion);
    
    rotate = is_even(pinion_teeth);
    
    // Gear
    rotate([0,0,180*(1-clearance)/gear_teeth*rotate])
        bevel_herringbone_gear(modul, gear_teeth, delta_gear, tooth_width, gear_bore, pressure_angle, helix_angle);
    
    // Pinion
    if (together_built)
        translate([-height_f_pinion*cos(90-axis_angle),0,height_f_gear-height_f_pinion*sin(90-axis_angle)])
            rotate([0,axis_angle,0])
                bevel_herringbone_gear(modul, pinion_teeth, delta_pinion, tooth_width, pinion_bore, pressure_angle, -helix_angle);
    else
        translate([rkf_pinion*2+modul+rkf_gear,0,0])
            bevel_herringbone_gear(modul, pinion_teeth, delta_pinion, tooth_width, pinion_bore, pressure_angle, -helix_angle);

}


if(Gear_type == "herringbone_bevel_gear" )
{

bevel_herringbone_gear(modul=Module, tooth_number=teeth, partial_cone_angle=bevel_angle, tooth_width=bevel_width, bore=bore, pressure_angle=pressure_angle, helix_angle=finalHelixAngle);
 

    
}

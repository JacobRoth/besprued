acceptable_epsilon=0.0001; // how much bigger to make some cuts out of the top surface. Mostly just to see it better in preview with less graphical artifacts. Can probably bet set to zero without anything bad happening.

module mold_shell(horizontal_thickness, vertical_thickness, hull_mode) {
	minkowski() {
		if (hull_mode) { 
			hull() 
				children();
		} else {
			children();
		}
		cylinder(r=horizontal_thickness, h=vertical_thickness*2, center=true);
	} 
}

module pour_sprue(pour_sprue_contact_diameter=2.5,pour_sprue_pour_diameter=25,pour_sprue_height=15) {
	cylinder(d1=pour_sprue_contact_diameter,d2=pour_sprue_pour_diameter,h=pour_sprue_height);
}

module mold_with_sprues(
	pour_sprue_locations=[]
	, air_sprue_locations=[]
	, horizontal_thickness=5
	, vertical_thickness=3
	, pour_sprue_contact_diameter=2.5
	, pour_sprue_pour_diameter=25
	, pour_sprue_height=15
	, pour_sprue_edge_thickness=3
	, air_sprue_diameter = 2
	, hull_mode = false
	) {
	difference() {  // We'll make the mold and cut out the appropriate sprue holes
		union() { // the solid part.
			mold_shell(horizontal_thickness, vertical_thickness,hull_mode) {
				children();
			}
			for (loc = pour_sprue_locations) {
				translate(loc) {
					cylinder(d1 = pour_sprue_contact_diameter+ 2*pour_sprue_edge_thickness,
					d2 = pour_sprue_pour_diameter + 2*pour_sprue_edge_thickness, 
					h = pour_sprue_height);
				}
			}
		} 
		union() {
			children();
			for (loc = pour_sprue_locations) {
				translate(loc) {
					pour_sprue(pour_sprue_contact_diameter,pour_sprue_pour_diameter,pour_sprue_height+acceptable_epsilon);
				}
			}
			for (loc = air_sprue_locations) {
				translate(loc) {
					cylinder(d = air_sprue_diameter, h = vertical_thickness + acceptable_epsilon);
				}
			}

		}
	}
}

mold_with_sprues(pour_sprue_locations = [ [2, 2, 10] ], air_sprue_locations = [ [10, 10, 10] ]) 
	cube([40,50,10]);

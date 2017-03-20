//Pizza pendant
//by Ming-Dao Chia

crust_thickness=5;
pizza_diameter=100;
overlap=0.001;
circle_res = 20;
pepperoni=15;
slice_angle=60;
random_seed=70;

module torus(radius, thickness){
    rotate_extrude(convexity = 10)
    translate([radius,0,0])
    circle(r = thickness, $fn=circle_res);
}

module pizza_base(){
    union(){
        cylinder(r=(pizza_diameter/2)-overlap,h=crust_thickness/1.5);
        translate([0,0,crust_thickness/1.5])
        torus(pizza_diameter/2, crust_thickness/1.5);
    }
}

module pepperoni(){
    cylinder(r=pizza_diameter/20, h=crust_thickness/5);
}

module pepperoni_spread(amount){
    translate([0,0,crust_thickness/2+crust_thickness/5])
    union(){
        for(i=[1:amount]){
            coords=rands(-pizza_diameter/2,pizza_diameter/2,2,i+random_seed*2);
            translate([coords[0], coords[1], 0])
            pepperoni();
        }
    }
}

module pepperoni_clean(){
    difference(){
        pepperoni_spread(pepperoni);
        translate([0,0,-1])
        difference(){
            cylinder(r=(pizza_diameter)-overlap,h=crust_thickness*2, $fn=circle_res);
            translate([0,0,-1])
            cylinder(r=(pizza_diameter/2),h=crust_thickness*3);
        }
    }
}

module pizza_cutter(angle){
    translate([0,0,-1])
    linear_extrude(height=crust_thickness*2){
    rotate(angle-90) square(pizza_diameter/2+crust_thickness);
    rotate(180) square(pizza_diameter/2+crust_thickness);
    rotate(90) square(pizza_diameter/2+crust_thickness);
        square(pizza_diameter/2+crust_thickness);
    }
}

module pizza(){
    union(){
        pizza_base();
        pepperoni_clean();
    }
}

module pizza_slice(){
    difference(){
        pizza();
        pizza_cutter(slice_angle);
    }
}

module pizza_necklace(){
    union(){
        translate([7,-55,2])
        torus(6,2);
        pizza_slice();
    }
}

pizza_necklace();
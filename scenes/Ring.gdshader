shader_type canvas_item;
uniform float onoff ;

void fragment() {
	//if(COLOR == vec4(0.0,0.0,0.0,1.0)){
	if(onoff == 1.0){
		if(COLOR.r == 0.0){
			COLOR.r = 0.9;
		} 
		else if (COLOR.r <= 0.2) {
			COLOR.r += 0.6;
		}
	}
	else if(onoff == 0.5){
		//if(COLOR == vec4(0.0,0.0,0.0,1.0)){
			COLOR += vec4(0.5,0.3,0.1,0.0);
		//}
	}
	//}
		
}

shader_type canvas_item;
uniform vec3 color; // you can assign a default value to uniforms

void fragment(){
	COLOR = texture(TEXTURE, UV); //read from texture
	vec2 pixel = UV / TEXTURE_PIXEL_SIZE;
	if (mod(pixel.x + pixel.y, 2.0)<1.0){
		COLOR.r = color.r;
		COLOR.g = color.g;
		COLOR.b = color.b;
	}
	
}

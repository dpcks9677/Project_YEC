shader_type canvas_item;

uniform vec4 hit_color: source_color = vec4(1.0);
uniform float hit_modifier: hint_range(0.0, 1.0) = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, hit_color.rgb, hit_modifier);
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

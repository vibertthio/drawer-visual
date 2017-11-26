#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 offset;

void main(void)
{
	float dx = offset.s;
	float dy = offset.t;
	vec2 st = gl_TexCoord[0].st;

	// Apply 3x3 gaussian filter
	vec4 color	 = 4.0 * texture2D(texture, st);
	color		+= 2.0 * texture2D(texture, st + vec2(+dx, 0.0));
	color		+= 2.0 * texture2D(texture, st + vec2(-dx, 0.0));
	color		+= 2.0 * texture2D(texture, st + vec2(0.0, +dy));
	color		+= 2.0 * texture2D(texture, st + vec2(0.0, -dy));
	color		+= texture2D(texture, st + vec2(+dx, +dy));
	color		+= texture2D(texture, st + vec2(-dx, +dy));
	color		+= texture2D(texture, st + vec2(-dx, -dy));
	color		+= texture2D(texture, st + vec2(+dx, -dy));

	gl_FragColor = color / 16.0;
}

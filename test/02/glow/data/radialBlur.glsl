#ifdef GL_ES
  precision mediump float;
#endif

float hash(in vec2 p) { return fract(sin(dot(p,vec2(283.6,127.1))) * 43758.5453);}

#define SAMPLES 10
#define RADIUS  .01

uniform sampler2D texture;
uniform float time;
uniform float vol;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void ) {
    vec2 uv = vertTexCoord.st;
    vec3  res = vec3(0);
    float invert;
    if(vol>0.7){
      invert=-1.0;
    }else{
      invert=1.0;
    }
    for(int i = 0; i < SAMPLES; ++i) {
        res += texture2D(texture, uv).xyz;
        vec2 d = vec2(0.5,0.5)-uv;

        d *= .5 + .01*hash(d*time);

        if(vol>0.87){
            uv += d * (vol*0.01+0.0001);
          }
    }

    gl_FragColor = vec4(res/float(SAMPLES)*1.2, 1);
}

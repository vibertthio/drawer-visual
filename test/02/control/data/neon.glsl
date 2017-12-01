#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform vec2 texOffset;
uniform float brt;
uniform float amt;
uniform int time;
uniform int rad;

void main(void) {
  int i = 0;
  int j = 0;
  vec4 sum = vec4(0.0);

  float br = amt * 0.2 * sin(float(time) / 1000.0) * sin(float(time) / 1000.0);

  for( i=-rad;i<rad;i++) {
    for( j=-rad;j<rad;j++) {
        // sum += texture2D( texture, vertTexCoord.st + vec2(j,i)*texOffset.st)*brt;
        sum += texture2D( texture, vertTexCoord.st + vec2(j,i)*texOffset.st)*br;
    }
  }

  gl_FragColor = sum*sum+ vec4(texture2D( texture, vertTexCoord.st).rgb, 1.0);
}

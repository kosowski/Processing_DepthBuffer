uniform sampler2D texture;
uniform sampler2D depthTexture;

// varying vec4 vertexture;
varying vec4 vertTexCoord;

	    
uniform float maxBlur; // max blur amount
uniform float aperture; // aperture - bigger values for shallower depth of field

uniform float focus;
uniform float aspect;
uniform float zfar;
uniform float znear;

float LinearizeDepth(float zoverw){
    float n = znear; // camera z near   
    float f = zfar; // camera z far   
    return (2.0 * n) / (f + n - zoverw * (f - n));
}

void main() {
    vec2 vUv = vertTexCoord.st;
				    
    vec2 aspectcorrect = vec2( 1.0, aspect );
		
    float depth1 = LinearizeDepth(texture2D( depthTexture, vUv ).r);
    
    float factor = depth1 - focus;
    
    vec2 dofblur = vec2 ( clamp( factor * aperture, -maxBlur, maxBlur ) );
    
    vec2 dofblur9 = dofblur * 0.9;
    vec2 dofblur7 = dofblur * 0.7;
    vec2 dofblur4 = dofblur * 0.4;
    
    vec4 col = vec4( 0.0 );
    
    col += texture2D( texture, vUv.xy );
    col += texture2D( texture, vUv.xy + ( vec2( 0.0, 0.4 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.15, 0.37 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.29, 0.29 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.37, 0.15 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.40, 0.0 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.37, -0.15 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.29, -0.29 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.15, -0.37 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.0, -0.4 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.15, 0.37 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.29, 0.29 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.37, 0.15 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.4, 0.0 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.37, -0.15 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( -0.29, -0.29 ) * aspectcorrect ) * dofblur );
    col += texture2D( texture, vUv.xy + ( vec2( 0.15, -0.37 ) * aspectcorrect ) * dofblur );
    
    col += texture2D( texture, vUv.xy + ( vec2( 0.15, 0.37 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.37, 0.15 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.37, -0.15 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.15, -0.37 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.15, 0.37 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.37, 0.15 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.37, -0.15 ) * aspectcorrect ) * dofblur9 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.15, -0.37 ) * aspectcorrect ) * dofblur9 );
    
    col += texture2D( texture, vUv.xy + ( vec2( 0.29, 0.29 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.40, 0.0 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.29, -0.29 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.0, -0.4 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.29, 0.29 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.4, 0.0 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.29, -0.29 ) * aspectcorrect ) * dofblur7 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.0, 0.4 ) * aspectcorrect ) * dofblur7 );
    
    col += texture2D( texture, vUv.xy + ( vec2( 0.29, 0.29 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.4, 0.0 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.29, -0.29 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.0, -0.4 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.29, 0.29 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.4, 0.0 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( -0.29, -0.29 ) * aspectcorrect ) * dofblur4 );
    col += texture2D( texture, vUv.xy + ( vec2( 0.0, 0.4 ) * aspectcorrect ) * dofblur4 );
    
    gl_FragColor.rgb = pow(col.rgb / 41.0, vec3(1. / 2.2)); //gamma correction
    gl_FragColor.a = 1.0;
}


uniform sampler2D depthTexture;

varying vec4 vertTexCoord;


void main() {  
	vec4 depth = texture2D(depthTexture, vertTexCoord.st); 
	gl_FragColor = depth;
}



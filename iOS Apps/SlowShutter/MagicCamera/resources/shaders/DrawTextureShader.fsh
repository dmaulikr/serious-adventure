////////////////////////////////
// [Ttv Camera fragment code]
// viewfinder pic * videoframe + contrast + brightness
precision mediump float;
varying vec2 textureCoordinate;
uniform sampler2D videoFrame;
uniform sampler2D mixFrame;

uniform float Alpha;
uniform float inputContrast;
uniform float inputBrightness;
uniform float inputSaturation;
uniform bool enableBW;
uniform bool enableSepia;
uniform int  screenMode;

const float factor = 1.0;
const vec4 AverageLuminance = vec4(0.5, 0.5, 0.5, 1.0); 

void main() {
	vec4 texColour		= texture2D(videoFrame, textureCoordinate);
    
    if (screenMode != 8) {
        gl_FragColor = vec4(texColour.rgb, Alpha);
    } else {
        float k = (1.0 + inputContrast);
        gl_FragColor = vec4(texColour.rgb, Alpha) * vec4(k, k ,k, 1.0);
    }
////	vec4 outputColor	= mix(texColour * inputBrightness, mix(AverageLuminance, texColour, inputContrast), 0.5);
//	
//    // Convert RGB to grayscale
//    if (screenMode == 1) {//Noir
////        float gray = dot(outputColor.rgb, vec3(0.3, 0.59, 0.11));
//		gl_FragColor = vec4(gray, gray, gray, Alpha);
//    }
//    else if (screenMode == 2) {//60s
////		gl_FragColor = vec4(outputColor.rgb * vec3(0.953, 0.953, 0.74), Alpha);
//    }
//    else if (screenMode == 3) {//Siena
////		gl_FragColor = vec4(outputColor.rgb * vec3(0.9375, 0.71, 0.543), Alpha);
//    }
//    else if (screenMode == 4) {//1920
////        float gray = dot(outputColor.rgb, vec3(0.3, 0.59, 0.11));
//		gl_FragColor = vec4(gray, gray, gray, Alpha);
//    }
//    else if (screenMode == 5) {//70
////		gl_FragColor = vec4(outputColor.rgb * vec3(0.77, 0.71, 0.68), Alpha);
//    }
//    else if (screenMode == 6) {
////		gl_FragColor = vec4(outputColor.rgb * vec3(0.808, 0.64, 0.62), Alpha);
//    }
//    else if (screenMode == 7) {
//        gl_FragColor = vec4(texColour.rgb, Alpha);
//    } else if (screenMode == 8) {
//        float k = (1.0 + inputContrast);
//        gl_FragColor = vec4(texColour.rgb, Alpha) * vec4(k, k ,k, 1.0);
//    } else {
//        gl_FragColor = texColour;
//    }
    
}
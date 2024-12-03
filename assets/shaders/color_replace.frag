#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 resolution;
uniform sampler2D image;
uniform vec4 uColor; // The target color to check against, including alpha

void main() {
    vec2 uv = (FlutterFragCoord().xy / resolution.xy);
    vec3 imageColor = texture(image, uv).xyz;

    // Check if imageColor matches uColor (ignoring alpha)
    bool isColorMatch = all(lessThan(abs(imageColor - uColor.xyz), vec3(0.3))); // Tolerance of 0.01

    if (isColorMatch) {
        // If the color matches, set fragColor to transparent
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        // Otherwise, retain the luminance effect
        fragColor = vec4(imageColor, 1.0);
    }
}

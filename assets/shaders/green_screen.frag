// assets/shaders/green_screen.frag
#version 460 core

#include <flutter/runtime_effect.glsl>

precision highp float;

uniform sampler2D uTexture; // Input video texture
uniform vec4 uKeyColor;     // Color to remove (e.g., green)
uniform float uThreshold;   // Threshold for color matching

void main() {
  vec4 videoColor = texture2D(uTexture, gl_FragCoord.xy / vec2(1.0, 1.0));

  // Calculate the difference between the video color and the key color
  float diff = length(videoColor.rgb - uKeyColor.rgb);

  if (diff < uThreshold) {
    // Replace the matched color with transparent black
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    // Keep the original color
    gl_FragColor = videoColor;
  }
}

#version 100

// Uniforms
uniform mat4 u_projectionMatrix;
uniform mat4 u_modelViewMatrix;

// Attributes
attribute vec4 a_pos;
attribute vec2 a_coord;

// Varyings
varying vec2 v_coord;

void main ()
{
  gl_Position = u_projectionMatrix * u_modelViewMatrix * a_pos;
  v_coord = a_coord;
}

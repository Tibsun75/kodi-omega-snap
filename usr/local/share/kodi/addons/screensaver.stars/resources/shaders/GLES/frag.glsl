#version 100

precision mediump float;

// varying
varying vec4 v_color;

void main()
{
  gl_FragColor = v_color;
}

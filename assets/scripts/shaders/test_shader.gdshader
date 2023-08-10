/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/pixelate

This shader is under CC0 license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform int amount = 40;

void fragment(){
  COLOR = vec4(0.4, 0.6, 0.9, 1.0);
}
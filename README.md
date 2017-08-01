# ShaderDump
Just a place to dump some shaders (Unity 5+).
Some of these are for undisclosed projects under NDAs, so I'm not able to include other source files.

*This isn't an exhaustive list of shaders, just some ones I have lying around that I'm able to distribute*


**Two-Paint Shader**
Allows you to use an alpha channel as a two-colour mask to recolour objects using a variety of blend modes and custom colours.

**Sprite Shadows**
These are for situations where you want some dynamic 2D shadows.
For example: 
  You have a character sprite and a mesh where it's shadow should be.
  Apply the character's sprite texture to a material with the Shadow shader to get a shadow effect
  Use the ShadowMask shaders to control if this only gets masked on to other sprites
  
The original usage had scripts that are under NDA, but you can see a little preview here:
https://twitter.com/lord_zargon/status/861893849647636481

**Wireframe**
Does what you might imagine...

**Scanlines**
Simple CRT scanline effect. You'll need a tileable scanline texture. Works well with Bloom and Chromatic Aberration shaders.

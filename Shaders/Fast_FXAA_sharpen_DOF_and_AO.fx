/*------------------.
| :: Description :: |
'-------------------/

Fast_FXAA_sharpen_DOF_and_AO (version 1.0)
======================================

Author: Robert Jessop
License: MIT
	
Copyright 2021 Robert Jessop

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	

	
About
=====
	
Designed for speed, this shader for ReShade is for people who can't just run everything at max settings but want good enough post-processing without costing much framerate. It runs in under a millisecond at 2560x1440 on a 13" laptop's NVIDIA GTX 1650 Max-Q. The FXAA about twice as fast as standard FXAA, and Ambient occlusion more than twice as fast.
	
It combines 4 effects in one shader for speed. Each can be enabled or disabled.
	
1. Fast FXAA (fullscreen approximate anti-aliasing). Fixes jagged edges. It's about twice as fast as normal FXAA and it preserves fine details and GUI elements a bit better. However, long edges very close to horizontal or vertical aren't fixed quite so smoothly.
2. Intelligent Sharpening. Improves clarity of texture details.
3. Subtle Depth of Field. Softens distant objects. A sharpened background can distract from the foreground action; softening the background can make the image feel more real too. 
4. Fast ambient occlusion. Shades concave areas that would receive less scattered ambient light. This is faster than typical implementations (e.g. SSAO, HBAO+). The algorithm gives surprisingly good quality with few sample points. It's designed for speed, not perfection - for highest possible quality you might want to try the game's built-in AO options, or a different ReShade shader instead. There is also the option, AO shine, for it to highlight convex areas, which can make images more vivid, add depth, and prevents the image overall becoming too dark.
	
3 and 4 require depth buffer access.

Tested in Toussaint :)
	
Setup
=====
	
1. Install ReShade and configure it for your game (See https://reshade.me)
2. Copy Fast_FXAA_sharpen_DOF_and_AO.fx to ReShade's Shaders folder within the game's folder (e.g. C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\reshade-shaders\Shaders)
3. Run the game
4. Turn off the game's own FXAA, sharpen, depth of field & AO/SSAO/HBAO options (if it has them).
5. Call up ReShade's interface in game and enable Fast_FXAA_sharpen_DOF_and_AO
6. Check if depth buffer is working and set up correctly. If not, then set depth of field and AO strength to 0. 
	- Check ReShade's supported games list to see any notes about depth buffer first. 
	- Check in-game (playing, not in a menu or video cutscene):
	- Use the built-in "Debug: show depth buffer" for a quick check, or ReShade's DisplayDepth shader for guidance and configuration.
	- Close objects should be black and distant ones white. It should align with image.
		* If it looks different it may need configuration - Use ReShade's DisplayDepth shader to help find and set the right "global preprocessor definitions" to fix the depth buffer.
			- If you get no depth image, set Depth of field and Ambient Occlusion to off, as they won't work.
7. (Options) Adjust based on personal preference and what works best & looks good in the game. 
	- Note: turn off "performance mode" in Reshade (bottom of panel) to configure, Turn it on when you're happy with the configuration.
		
Enabled/disable effects
=======================
	
"Fast FXAA" - Fullscreen approximate anti-aliasing. Fixes jagged edges.
    
"Intelligent Sharpen" - Sharpens image, but working with FXAA and depth of field instead of fighting them. It darkens pixels more than it brightens them; this looks more realistic.

"Depth of field (DOF) (requires depth buffer)" - Softens distant objects subtly, as if slightly out of focus. 
    
"Fast Ambient Occlusion (AO) (requires depth buffer)" - Ambient occlusion shades pixels that are surrounded by pixels closer to the camera - concave shapes. It's a simple approximation of the of ambient light reaching each area (i.e. light just bouncing around the world, not direct light.)
    

Fine Tuning
===========

"Sharpen strength" - For values > 0.5 I suggest depth of field too.

"DOF blur" - Depth of field. Applies subtle smoothing to distant objects. If zero it just cancels out sharpening on far objects. It's a small effect (1 pixel radius).
	
"AO strength" - Ambient Occlusion. Higher mean deeper shade in concave areas.
	
"AO shine" - Normally AO just adds shade; with this it also brightens convex shapes. Maybe not realistic, but it prevents the image overall becoming too dark, makes it more vivid, and makes some corners clearer. 

"AO quality" - Ambient Occlusion. Number of sample points. The is your speed vs quality knob; higher is better but slower. TIP: Hit reload button after changing this (performance bug workaround).

"AO radius" - Ambient Occlusion affected area, in screen-space pixels. Bigger means larger areas of shade, but too big and you lose detail in the shade around small objects. Bigger can be slower too. May need adjusting based on your screen resolution.

"AO max distance" - The ambient occlusion effect fades until it is zero at this distance. Helps avoid avoid artefacts if the game uses fog or haze. If you see deep shadows in the clouds then reduce this. If the game has long, clear views then increase it.";

Debugging
=========

"Output mode" - Debug view helps understand what the algorithms are doing. Especially handy when tuning ambient occlusion settings.

Tips: 
	- Check if game provides depth buffer! if not turn of depth of field and ambient occlusion for better performance.
	- If the game uses lots of dithering (i.e. ░▒▓ patterns), sharpen may exagerate it, so use less sharpenning. (e.g. Witcher 2's lighting & shadows.)		
	- If you don't like an effect then reduce it or turn it off. Disabling effects improves performance, except sharpening, which is basically free if FXAA or depth of field is on.	
	- If the game uses lots of semi-transparent effects like smoke or fog, and you get incorrect shadows/silluettes then you may need to tweak AO max distance. Alternatively, you could use the game's own slower SSAO option if it has one. This is a limitation of ReShade and similar tools, ambient occlusion should be drawn before transparent objects, but ReShade can only work with the output of the game and apply it afterwards.
	- You can mix and match with in-game options or other ReShade shaders, though you lose some the performance benefits of a combined shader.
	- Experiment!
		* How much sharpen and depth of field is really a matter of personal taste. 
		* Don't be afraid to try lower AO quality levels if you want maximum performance. Even a little bit of AO can make the image look less flat.
		* Be careful with ambient occlusion settings; what looks good in one scene may be too much in another. Try to test changes in different areas of the game with different fog and light levels. It looks cool at the maximum but is it realistic? Less can be more; even a tiny bit of AO makes everything look more three-dimensional.
		
	
Advanced options 
================
	
You should not need to tweak these and doing so will probably make it look worse.
	
"AO -> AO²" - Squares the amount ambient occlusion applied to each pixel. Looks more realistic, but the AO may become too subtle in some areas. At lower AO strength levels or if you have low-contrast screen you might want to turn it off. 
		
"AO shape modifier" - Ambient occlusion. If you have a good, high-contrast depth buffer, you can increase to reduce excessive shading in nearly flat areas. May want to reduce to 2 if using ambient shine.
	
"AO max depth diff" - Ambient occlusion biggest depth difference to allow. Prevents nearby objects casting shade on distant objects. Decrease if you get dark halos around objects. Increase if holes that should be shaded are not.
	
"Fast FXAA threshold" - Shouldn't need to change this. Smoothing starts when the step shape is stronger than this. Too high and some steps will be visible. Too low and subtle textures will lose detail.
	
"Sharpen lighten ratio" - Sharpening looks most realistic if highlights are weaker than shade. The change in colour is multiplied by this if it's getting brighter.

	
Tech details
============
	
Combining FXAA, sharpening and depth of field in one shader works better than separate ones because the algorithms work together. Each pixel is sharpened or softened only once, and where FXAA detects strong edges they're not sharpened. With seperate shaders sometimes sharpening can undo some of the good work of FXAA. More importantly, it's much faster because we only read the pixels only once.
	
GPUs are so fast that memory is the performance bottleneck. While developing I found that number of texture reads was the biggest factor in performance. Interestingly, it's the same if you're reading one texel, or the bilinear interpolation of 4 adjacent ones (interpolation is implemented in hardware such that it is basically free). Each pass has noticable cost too. Therefore everything is combined in one pass, with the algorithms designed to use as few reads as possible. Fast FXAA makes 7 reads per pixel. Sharpen uses 5 reads, but 5 already read by FXAA so if both are enabled it's basically free. Depth of field also re-uses the same 5 pixels, but adds 3 reads from the depth buffer. If Depth of field is enabled, ambient occlusion adds just 1-9 more depth buffer reads (depending on quality level set). 
	
FXAA starts with the centre pixel, plus 4 samples each half a pixel away diagonally; each of the 4 samples is the average of four pixels. Based on their shape it then samples two more points 3.5 pixels away horizontally or vertically. We look at the diamond created ◊ and look at the change along each side of the diamond. If the change is bigger on one pair of parallel edges and small on the other then we have an edge. The size of difference determines the score, and then we blend between the centre pixel and a smoothed using the score as the ratio. 

The smooth option is the four nearby samples minus the current pixel. Effectively this is convolution:
1 2 1
2 0 2  / 12;
1 2 1
	
Sharpening increases the difference between the centre pixel and it's neighbors. We want to sharpen small details in textures but not sharpen object edges, creating annoying lines. To achieve this it calculates two sharp options: It uses the two close points in the diamond FXAA uses, and calculates the difference to the current pixel for each. It then uses the median of zero and the two sharp options. It also has a hard limit on maximum change in pixel value of 25%. It darkens pixels more than it brightens them; this looks more realistic. FXAA is calculated before but applied after sharpening. If FXAA decides to smooth a pixel the maximum amount then sharpening is cancelled out completely.
	
Depth of field is subtle; this implementation isn't a fancy cinematic focus effect. Good to enable if using strong sharpening, as it takes the edge of the background and helps emphasise the foreground. If DOF blur is set to zero, then it just reduces the strength of sharpening, so sharpening gradually disappears in the distance. If DOF blur is higher, it also blurs pixels, increasing blur with distance - at 1 pixels at maximum depth as set to the smooth value. Depth of field is applied before sharpening.
		
Ambient occlusion adds shade to concave areas of the scene. It's a screen space approximation of the amount of ambient light reaching every pixel. It uses the depth buffer generated by the rasterisation process. Without ambient occlusion everything looks flat. However, ambient occlusion should be subtle and not be overdone. Have a look around in the real world - the bright white objects with deep shading you see in research papers just aren't realistic. If you're seeing black shade on bright objects, or if you can't see details in dark scenes then it's too much. However, exagerating it just a little bit compared to the real-world is good - it's another depth clue for your brain and makes the flat image on the flat screen look more 3D.  
	
Fast Ambient occlusion is pretty simple, but has a couple of tricks that make it look like it's using more samples than it does. Unlike well known techniques like SSAO and HBAO it doesn't try to adapt to the local normal vector of the pixel - it picks sample points in a simple circle around the pixel. Samples that are in closer to the camera than the current pixel add shade, ones further away don't. At least half the samples must be closer for any shade to be cast (so pixels on flat surfaces don't get shaded, as they'll be half in-front at most). It has 3 tricks to improve on simply counting how many samples are closer.
	1. Any sample more than 5% closer is set to be equal to current pixel's depth, and any more than 5% further away is set to just be 5% further. We want to measure shade from close objects and surface contours; distant objects should not affect it.
	2. Our 3-9 samples are equally spaced in a circle (well, it's a polygon approximating a circle.) We approximate a circle by doing linear interpolation between adjacent points. Textbook algorithms do random sampling; with few sample points that is noisy and requires a lot of blur; also it's less cache efficient.
	3. Pixels are split into two groups in a checkerboard pattern (▀▄▀▄▀▄). Alternatve pixels use a circle of samples half of the radius. With small pixels, the eye sees a half-shaded checkerboard as grey, so this is almost as good taking twice as many samples per pixel. More complex dithering patterns were tested but don't look good (░░).
Amazingly, this gives quite decent results even with only 3 points in the circle (4 depth reads in total, including the centre one shared with depth of field.)
	
Ideas for future improvement:
Fog detection and adjust ambient occlusion range dynamically.
			
History:
(*) Feature (+) Improvement	(x) Bugfix (-) Information (!) Compatibility
Version 1.0 - initial public release

	
*/


/*---------------.
| :: Includes :: |
'---------------*/

#include "ReShade.fxh"
#include "ReShadeUI.fxh"

uniform bool fxaa_enabled <
    ui_category = "Enabled Effects";
    ui_label = "Fast FXAA";
    ui_tooltip = "Fullscreen approximate anti-aliasing. Fixes jagged edges";
    ui_type = "radio";
> = true;

uniform bool sharp_enabled <
    ui_category = "Enabled Effects";
    ui_label = "Intelligent Sharpen";
    ui_tooltip = "Sharpens image, but working with FXAA and depth of field instead of fighting them. It darkens pixels more than it brightens them; this looks more realistic. ";
    ui_type = "radio";
> = true;

uniform bool dof_enabled <
    ui_category = "Enabled Effects";
    ui_label = "Depth of field (DOF) (requires depth buffer)";
    ui_tooltip = "Softens distant objects subtly, as if slightly out of focus. ";
    ui_type = "radio";
> = true;

uniform bool ao_enabled <
    ui_category = "Enabled Effects";
    ui_label = "Fast Ambient Occlusion (AO) (requires depth buffer)";
    ui_tooltip = "Ambient occlusion shades pixels that are surrounded by pixels closer to the camera - concave shapes. It's a simple approximation of the of ambient light reaching each area (i.e. light just bouncing around the world, not direct light.) ";
    ui_type = "radio";
> = true;

//////////////////////////////////////


uniform float sharp_strength < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Tuning and Configuration";
	ui_min = 0; ui_max = 1; ui_step = .05;
	ui_tooltip = "For values > 0.5 I suggest depth of field too. ";
	ui_label = "Sharpen strength";
> = .5;

uniform float dof_strength < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Tuning and Configuration";
	ui_min = 0; ui_max = 1; ui_step = .05;
	ui_tooltip = "Depth of field. Applies subtle smoothing to distant objects. If zero it just cancels out sharpening on far objects. It's a small effect (1 pixel radius).";
	ui_label = "DOF blur";
> = 0;


//Diminishing returns after 9 points. More would need a more sophisticated sampling pattern.
#ifndef AO_MAX_POINTS
	#define AO_MAX_POINTS 9
#endif




uniform float ao_strength < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Tuning and Configuration";
	ui_min = 0.0; ui_max = 1.0; ui_step = .05;
	ui_tooltip = "Ambient Occlusion. Higher mean deeper shade in concave areas.";
	ui_label = "AO strength";
> = 0.5;


uniform float ao_shine_strength < __UNIFORM_SLIDER_FLOAT1
    ui_category = "Tuning and Configuration";
	ui_min = 0.0; ui_max = .5; ui_step = .05;
    ui_label = "AO shine";
    ui_tooltip = "Normally AO just adds shade; with this it also brightens convex shapes. Maybe not realistic, but it prevents the image overall becoming too dark, makes it more vivid, and makes some corners clearer.";
> = 0;


uniform int ao_points < __UNIFORM_SLIDER_INT1
	ui_category = "Tuning and Configuration";
	ui_min = 3; ui_max = AO_MAX_POINTS; ui_step = 1;
	ui_tooltip = "Ambient Occlusion. Number of sample points. The is your speed vs quality knob; higher is better but slower. Tip: Hit reload button after changing this (performance bug workaround). ";
	ui_label = "AO quality";
> = 6;

uniform float ao_radius < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Tuning and Configuration";
	ui_min = 0.0; ui_max = 50; ui_step = 1;
	ui_tooltip = "Ambient Occlusion affected area, in screen-space pixels. Bigger means larger areas of shade, but too big and you lose detail in the shade around small objects. Bigger can be slower too. May need adjusting based on your screen size/resolution";
	ui_label = "AO radius";
> = 15.0;

uniform float ao_fog_fix < __UNIFORM_SLIDER_FLOAT1
    ui_category = "Tuning and Configuration";
	ui_min = 0.0; ui_max = 1; ui_step = .05;
    ui_label = "AO max distance";
    ui_tooltip = "The ambient occlusion effect fades until it is zero at this distance. Helps avoid avoid artefacts if the game uses fog or haze. If you see deep shadows in the clouds then reduce this. If the game has long, clear views then increase it.";
> = 0.5;

uniform int debug_mode <
    ui_category = "Output mode";
	ui_type = "radio";
    ui_label = "Output mode";
    ui_items = "Normal\0"
	           "Debug: show FXAA edges\0"
			   "Debug: show ambient occlusion shade\0"
	           "Debug: show depth buffer\0"
			   "Debug: show depth and AO\0"
			   "Debug: show depth and image\0";
	ui_tooltip = "Handy when tuning ambient occlusion settings.";
> = 0;


uniform bool ao_square<
    ui_category = "Advanced Options";
    ui_label = "AO -> AO²";
    ui_tooltip = "Squares the amount ambient occlusion applied to each pixel. Looks more realistic, but the AO may become too subtle in some areas. At lower AO strength levels or if you have low-contrast screen you might want to turn it off. ";
    ui_type = "radio";
> = true;

uniform float ao_shape_modifier < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Options";
	ui_min = 1; ui_max = 50; ui_step = 1;
	ui_tooltip = "Ambient occlusion. If you have a good, high-contrast depth buffer, you can increase to reduce excessive shading in nearly flat areas. May want to reduce to 1 or 2 if using ambient shine.";
	ui_label = "AO shape modifier";
> = 5;

uniform float ao_range < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Options";
	ui_min = 0; ui_max = .1; ui_step = 0.01;
	ui_tooltip = "Ambient occlusion biggest depth difference to allow. Prevents nearby objects casting shade on distant objects. Decrease if you get dark halos around objects. Increase if holes that should be shaded are not.";
	ui_label = "AO max depth diff";
> = 0.05;

uniform float step_detect_threshold < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Options";
	ui_min = 0.000; ui_max = 0.1; ui_step = .001;
	ui_tooltip = "Shouldn't need to change this. Smoothing starts when the step shape is stronger than this. Too high and some steps will be visible. Too low and subtle textures will lose detail. ";
	ui_label = "Fast FXAA threshold";
> = 0.05;


uniform float lighten_ratio < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Options";
	ui_min = 0.000; ui_max = 1; ui_step = .01;
	ui_tooltip = "Sharpening looks most realistic if highlights are weaker than shade. The change in colour is multiplied by this if it's getting brighter.";
	ui_label = "Sharpen lighten ratio";
> = 0.25;

uniform bool abtest <
    ui_category = "Advanced Options";
    ui_label = "A/B test";
    ui_tooltip = "Ignore this. Used by developer when testing and comparing algorithm changes.";
    ui_type = "radio";
> = false;


/*
Not used. This is now varied from .1 t o .25 based on sharp_strength.
uniform float max_sharp < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Options";
	ui_min = 0.000; ui_max = 0.5; ui_step = .01;
	ui_tooltip = "Maximum change in any pixel from sharpen or DOF. Increase for more sharpness, decrease to reduce artefacts such as visible lines on horizontal or vertical edges. ";
	ui_label = "Maximum sharpen";
> = 0.25;
*/

//////////////////////////////////////////////////////////////////////

//Smallest possible number in a float
#define FLT_EPSILON 1.1920928955078125e-07F

sampler2D samplerColor
{
	// The texture to be used for sampling.
	Texture = ReShade::BackBufferTex;

	// Enable converting  to linear colors when sampling from the texture.
	SRGBTexture = true;
};

sampler2D samplerDepth
{
	// The texture to be used for sampling.
	Texture = ReShade::DepthBufferTex;

	// The method used for resolving texture coordinates which are out of bounds.
	// Available values: CLAMP, MIRROR, WRAP or REPEAT, BORDER
	AddressU = CLAMP;
	AddressV = CLAMP;
	AddressW = CLAMP;

	// The magnification, minification and mipmap filtering types.
	// Available values: POINT, LINEAR
	MagFilter = POINT;
	MinFilter = POINT;
	MipFilter = POINT;
};

	
// This is copy of reshade's getLinearizedDepth but using POINT sampling (LINEAR interpolation can cause artefacts - thin ghost of edge one radius away.)
float pointDepth(float2 texcoord)
{
#if RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN
		texcoord.y = 1.0 - texcoord.y;
#endif
		texcoord.x /= RESHADE_DEPTH_INPUT_X_SCALE;
		texcoord.y /= RESHADE_DEPTH_INPUT_Y_SCALE;
#if RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET
		texcoord.x -= RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET * BUFFER_RCP_WIDTH;
#else // Do not check RESHADE_DEPTH_INPUT_X_OFFSET, since it may be a decimal number, which the preprocessor cannot handle
		texcoord.x -= RESHADE_DEPTH_INPUT_X_OFFSET / 2.000000001;
#endif
#if RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET
		texcoord.y += RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET * BUFFER_RCP_HEIGHT;
#else
		texcoord.y += RESHADE_DEPTH_INPUT_Y_OFFSET / 2.000000001;
#endif
		float depth = (float)tex2D(samplerDepth, texcoord) * RESHADE_DEPTH_MULTIPLIER;

#if RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
		const float C = 0.01;
		depth = (exp(depth * log(C + 1.0)) - 1.0) / C;
#endif
#if RESHADE_DEPTH_INPUT_IS_REVERSED
		depth = 1 - depth;
#endif
		const float N = 1.0;
		depth /= RESHADE_DEPTH_LINEARIZATION_FAR_PLANE - depth * (RESHADE_DEPTH_LINEARIZATION_FAR_PLANE - N);

		return depth;
}

float3 medianof4(in float3 a, in float3 b, in float3 c, in float3 d) {
	float3 min1 = min(a, b);
	float3 max1 = max(a, b);
	float3 min2 = min(c, d);
	float3 max2 = max(c, d);
	float3 mid1 = max(min1,min2);
	float3 mid2 = min(max1, max2);
		
	return (mid1+mid2)/2;
}

float3 Fast_FXAA_sharpen_DOF_and_AO_PS(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{	
	//centre (original pixel)
	float3 c = tex2D(samplerColor, texcoord).rgb;
	
	//centre pixel depth
	float depth=0;
	
	if(ao_enabled || dof_enabled || debug_mode == 3) {
		depth = pointDepth(texcoord);					
	}
	
	// multiplier to convert rgb to perceived brightness	
	static const float3 luma = float3(0.2126, 0.7152, 0.0722);
	
	
	if(fxaa_enabled || sharp_enabled || dof_enabled ) {
	
		//Average of the four nearest pixels to each diagonal.
		float3 ne = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(.5,.5)).rgb;
		float3 sw = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(-.5,-.5)).rgb;
		float3 se = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(.5,-.5)).rgb;
		float3 nw = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(-.5,.5)).rgb;
		
		float ratio=0;
		
		// Average of surrounding pixels, both smoothing edges (FXAA) 
		float3 smooth = ((ne+nw)+(se+sw)-c)/3;	
		
		//Do we have horizontal or vertical line?
		float dy = dot(luma,abs((ne+nw)-(se+sw)));
		float dx = dot(luma,abs((ne+se)-(nw+sw)));
		bool horiz =  dy > dx;
			
		//We will proceed as if line is east to west. If it's north to south then rotate everything by 90 degrees.
		//First we get and approximation of the line of 3 pixels above and below c.
		float3 n2=horiz ? ne+nw : ne+se;
		float3 s2=horiz ? se+sw : nw+sw;
		n2-=c;
		s2-=c;
			
		//Calculate FXAA before sharpening
		if(fxaa_enabled) {	
			//Get two more pixels further away on the possible line.
			float dist = 3.5;
			float2 wwpos = horiz ? float2(-dist, 0) : float2(0, +dist) ;
			float2 eepos = horiz ? float2(+dist, 0) : float2(0, -dist) ;
						
			float3 ww = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*wwpos).rgb;	
			float3 ee = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*eepos).rgb;
				
			// We are looking for a step ███▄▄▄▄▄___ which should be smoothed to look like a slope. 
			// We have a diamond of 4 values. We look for the strength of each diagonal. If one is significantly bigger than the other we have a step!
			//       n2
			//ww            ee
			//       s2
				
			float3 d1 = abs((ww-n2)-(ee-s2));
			float3 d2 = abs((ee-n2)-(ww-s2));
				  
				
			// We compare the biggest diff to the total. The bigger the difference the stronger the step shape.
			// Add step_detect_threshold to avoid blurring where not needed and to avoid divide by zero. We're in linear colour space, but monitors and human vision isn't. Darker pixels need smaller threshold than light ones, so we adjust the threshold.
				
			float3 total_diff = (d1+d2) + step_detect_threshold*sqrt(smooth);					
			float3 max_diff = max(d1,d2);
				
			//score between 0 and 1
			float score = dot(luma,(max_diff/total_diff));			
								
			//ratio of sharp to smooth
			//If score > 0.5 then smooth. Anything less goes to zero,
			ratio = max( 2*score-1, 0);	
		}
		
		float sharp_multiplier = sharp_strength;
		
		// If DOF enabled, we adjust sharpening/bluring based on depth.
		if(dof_enabled) {
			sharp_multiplier = lerp(sharp_multiplier,0,depth);		
			c = lerp(c,smooth,dof_strength*depth);		
		}
			
		if(sharp_enabled) {
			float3 sharp_diff1 = (c-n2);
			float3 sharp_diff2 = (c-s2);
			
			//median of diff1, diff2 and 0 - this is to avoid making a solid line along horizontal or vertical edge
			float3 sharp_diff = clamp(sharp_diff1, min(sharp_diff2,0), max(sharp_diff2,0))*4;
								
			//If pixel will get brighter, then weaken the amount. Looks better.
			if(dot(luma,sharp_diff) >= 0) sharp_diff *= lighten_ratio;
				
			sharp_diff *= sharp_multiplier;
				
			// now sharpen c but no more than 25% of way
			float max_sharp = sharp_strength*.15+.1;
			c = clamp(c + sharp_diff, c*(1-max_sharp), c*(1-max_sharp*lighten_ratio)+max_sharp*lighten_ratio); 					
		}
		
		
		// Debug mode: make the smoothed option more highlighted in green.		
		if(debug_mode==1) { c.r=c.g; c.b=c.g; smooth=lerp(c,float3(0,1,0),ratio);  } 
		
		//Now apply FXAA after sharpening		
		c = lerp(c, smooth, ratio);			
	}
	
	//Fast screen-space ambient occlusion. It does a good job of shading concave corners facing the camera, even with few samples.
	//depth check is to minimize performance impact on games that don't give us depth, if AO left on by mistake.
	if(ao_enabled && depth>0 && depth<1) {
		
		// Checkerboard pattern of 1s and 0s ▀▄▀▄▀▄. Single layer of dither works nicely to allow us to use 2 radii without doubling the samples per pixel. More complex dither patterns are noticable and annoying.
		uint square =  (uint(vpos.x+vpos.y)) % 2;
		
		//our sample points. 
		const uint points=ao_points;		
		float s[AO_MAX_POINTS+1]; //must compile time constant
		
		float radius = ao_radius;	
		// Every other square half the radius 
		if(square) radius *= 0.5;
				
		float ao=0;
		
		// Minimum difference in depth - this is to prevent shading areas that are only slighly concave.
		const float shape = radius*FLT_EPSILON*ao_shape_modifier; 
		
		//This is the angle between the same point on adjacent pixels, or half the angle between adjacently points on this pixel.
		const float pi = radians(180);
		const float angle = pi/points;
	
		[unroll]
		for(uint i = 1; i<=points; i++) {
			// We want (i*2+square)*angle, but this is a trick to help the optimizer generate constants instead of trig functions.
			float2 the_vector = square ? ao_radius*.5*BUFFER_PIXEL_SIZE*float2( sin((i*2+1)*angle), cos((i*2+1)*angle) ) : ao_radius*BUFFER_PIXEL_SIZE*float2( sin((i*2)*angle), cos((i*2)*angle) );
			
			//Get the depth at each point - must use POINT sampling, not LINEAR to avoid ghosting artefacts near object edges.
			s[i] = pointDepth( texcoord+the_vector);	
				
			//If s[i] is much closer than depth then it's a different object and we don't let it cast shadow - set it to = depth of centre.
			if( s[i] < depth*(1-ao_range) ) s[i] = depth;
								
			//If s[i] is much farther than depth then bring it closer so that one distance point have too much effect.
			s[i] = min( s[i], depth*(1+ao_range) );
		}
			
		s[0]=s[points];			//Avoid mod operation later			
		float total=0;
						
		[unroll]
		for(uint i = 0; i<points; i++) {
			// naive algorithm is to just add up all the sample points that cast shade. Instead we interpolate between adjacent points in the circle. Imagine the arc between two ajacent points - we're estimating the fraction of it that is in front of the centre point.
			float near=min(s[i],s[i+1]);
			float far=max(s[i],s[i+1]) + shape;
			float crossing = (depth-near)/(far-near);
			total += clamp(crossing,0,1);											
		}
			
		//average total/points will be 0.5	- average level of AO needs to be 0;			
		ao=2*total/points -1;
		
		if(ao_square) ao = abs(ao)*ao;
			
		
		//debug Show ambient occlusion mode
		if(debug_mode==2) c=.5;
		
		//debug: depth & ao mode
		if(debug_mode==4) c=depth;
		
		
		//If ao is negative it's an exposed area to be brightened (or set to 0 if shine is).
		ao *= (ao<0) ? ao_shine_strength : ao_strength;
		
		//Weaken the AO effect depth is a long way away. This is to avoid artefacts when there is fog/haze/darkness in the distance.
		ao *= max(0, 1-depth/ao_fog_fix);
		
		//Now adjust the pixel, but no more than 50% of the way  to prevent overdoing it.
		c = clamp( c*(1-ao), c*.5, 0.5*c +0.5 );									
	}	
	
	//Show depth buffer mode
	if(debug_mode == 3) c = depth ; 
	if(debug_mode==5) c = (c+depth) /2;
			
	return c;	
}


technique Fast_FXAA_sharpen_DOF_and_AO
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = Fast_FXAA_sharpen_DOF_and_AO_PS;
		
		// Enable gamma correction applied to the output.
		SRGBWriteEnable = true;
	}		
}

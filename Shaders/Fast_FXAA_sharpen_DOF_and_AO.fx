/*------------------.
| :: Description :: |
'-------------------/

Fast_FXAA_sharpen_DOF_and_AO (version 1.2.3)
======================================

**New in 1.2:** Better Ambient Occlusion quality - smoother shade increase close to occluding surfaces. Tweaked defaults - slightly faster default.

Author: Robert Jessop 

License: MIT
	
Copyright 2021 Robert Jessop

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	


About
-----
	
Designed for speed and quality, this shader for ReShade is for people who can't just run everything at max settings and want good enough post-processing without costing too much framerate. The FXAA quite a bit faster than as standard FXAA, and ambient occlusion more than twice as fast as other algorithms.
	
It combines several effects in one shader for speed. Each can be enabled or disabled.
	
1. Fast FXAA (fullscreen approximate anti-aliasing). Fixes jagged edges. Almost twice as fast as normal FXAA, and it preserves fine details and GUI elements a bit better. However, long edges very close to horizontal or vertical aren't fixed quite so smoothly.
2. Intelligent Sharpening. Improves clarity of texture details.
3. Fast ambient occlusion. Shades concave areas that would receive less scattered ambient light. This is faster than typical implementations (e.g. SSAO, HBAO+). The algorithm gives surprisingly good quality with few sample points. It's designed for speed, not perfection - for highest possible quality you might want to try the game's built-in AO options, or a different ReShade shader instead. It has an optional "bounce lighting" mode, which blends in the reflected colour from a nearby surface. There is also the option, AO shine, for it to highlight convex areas, which can make images more vivid, adds depth, and prevents the image overall becoming too dark.
4. Bounce lighting. A very fast indirect lighting implementation that gives surfaces some coloured light reflected from nearby. It makes colours and shade much more realistic than Ambient Occlusion alone.
5. Subtle Depth of Field. Softens distant objects. A sharpened background can distract from the foreground action; softening the background can make the image feel more real too. 
	
3, 4 & 5 require depth buffer access.

Tested in Toussaint :)

![Screenshot](Fast_FXAA_sharpen_DOF_and_AO.jpg "Settings menu, Palace Gardens, Beauclair, The Witcher 3")

Comparison (version 1.1)
----------

No postprocessing:
![Screenshot](no_postprocessing.png "Beauclair, The Witcher 3")

This shader, default settings:
![Screenshot](default_settings.png "Beauclair, The Witcher 3")

This shader, Maximum strength:
![Screenshot](max_strength.png "Beauclair, The Witcher 3")
	
Setup
-----
	
1. Install ReShade and configure it for your game (See https://reshade.me)
2. Copy Fast_FXAA_sharpen_DOF_and_AO.fx to ReShade's Shaders folder within the game's folder (e.g. C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\reshade-shaders\Shaders)
3. Run the game
4. Turn off the game's own FXAA, sharpen, depth of field & AO/SSAO/HBAO options (if it has them).
	- Some games do not have individual options, but have a single "post-processing" setting. Setting that to the lowest value will probably disable them all.
5. Call up ReShade's interface in game and enable Fast_FXAA_sharpen_DOF_and_AO ("Home" key by default)
6. Check if depth buffer is working and set up correctly. If not, disable the Depth of field and Ambient Occlusion effects for a small performance improvement. 
	- Check ReShade's supported games list to see any notes about depth buffer first. 
	- Check in-game (playing, not in a menu or video cutscene):
	- Use the built-in "Debug: show depth buffer" to check it's there and "Debug: show depth and FXAA edges" to check it's aligned.		
	- Close objects should be black and distant ones white. It should align with shapes in the image.
		* If it looks different it may need configuration - Use ReShade's DisplayDepth shader to help find and set the right "global preprocessor definitions" to fix the depth buffer.
			- If you get no depth image, set Depth of Field, Ambient Occlusion and Detect Menus to off, as they won't work.	
	- If it depth buffer work in all areas of gameplay, then you probably want to enable "Detect menus & videos" too.
7. (Optional) Adjust based on personal preference and what works best & looks good in the game. 
	- Note: turn off "performance mode" in Reshade (bottom of panel) to configure, Turn it on when you're happy with the configuration.  
	- To make it faster, reduce FAST_AO_POINTS preprocessor definition (minimum: 2). For better quality, increase FAST_AO_POINTS! Default is 6 but 2-12 are all good options.
		
Enabled/disable effects
-----------------------
	
**Fast FXAA** - Fullscreen approximate anti-aliasing. Fixes jagged edges.

**Intelligent Sharpen** - Sharpens details but not straight edges (avoiding artefacts). It works with FXAA and depth of field instead of fighting them. It darkens pixels more than it brightens them; this looks more realistic.

**Fast Ambient Occlusion (AO) (requires depth buffer)** - Ambient occlusion shades pixels that are surrounded by pixels closer to the camera - concave shapes. It's a simple approximation of the of ambient light reaching each area (i.e. light just bouncing around the world, not direct light.)

**Bounce Lighting (requires AO)** - Approximates local ambient light colour. A bright red pillar by a white wall will make the wall a bit red. Makes Ambient Occlusion use two samples of colour data as well as depth. Fast Ambient Occlusion must be enabled too.

**Depth of Field (DOF) (requires depth buffer)** - Softens distant objects subtly, as if slightly out of focus. 

**Detect menus & videos (requires depth buffer)** - Skip all processing if depth value is 0 or 1 (per pixel). Full-screen videos and 2D menus probably do not need anti-aliasing nor sharpenning, and may lose worse with them. Only enable if depth buffer always available in gameplay!
    

Effects Intensity
-----------------

**Sharpen strength** - For high values I suggest depth of field too.

**AO strength** - Ambient Occlusion. Higher mean deeper shade in concave areas.

**Bounce strength** - Multiplier for local bounced light. A bright red pillar by a white wall will make the wall a bit red, but how red? 

**AO shine** - Normally AO just adds shade; with this it also brightens convex shapes. Maybe not realistic, but it prevents the image overall becoming too dark, makes it more vivid, and makes some corners clearer. Higher than 0.5 looks a bit unrealistic.

**DOF blur** - Depth of field. Applies subtle smoothing to distant objects. If zero it just cancels out sharpening on far objects. It's a small effect (1 pixel radius).

Quality
-------

**FAST_AO_POINTS** (preprocessor definition - bottom of GUI). Number of sample points. The is your speed vs quality knob; higher is better but slower. Minimum is 2; don't go above 12 - algorithm isn't designed to take advantage of more points. If you break it by setting an invalid value you may need to go into the game's directory and edit the value in ReShadePreset.ini to fix it.

Output mode
-----------

**Normal** - Normal output

**Debug: show FXAA edges** - Highlights edges that are being smoothed by FXAA. The brighter green the more smoothing is applied. Don't worry if moderate smoothing appears where you don't think it should - sharpening will compensate.

**Debug: show ambient occlusion shade** - Shows amount of shading AO is applying against a grey background. Use this if tweaking AO settings to help get them just right see the effect of each setting clearly. However, don't worry if it doesn't look perfect - it exaggerates the effect and many issues won't be noticable in the final image. The best final check after changing settings is to go back to normal but with AO strength at max.

**Debug: show depth buffer** - This image shows the distance to each pixel. However not all games provide it and there are a few different formats they can use. Use to check if it works and is in the correct format. Close objects should be black and distant ones white. If it looks different it may need configuration - Use ReShade's DisplayDepth shader to help find and set the right "global preprocessor definitions" to fix the depth buffer. If you get no depth image, set Depth of Field, Ambient Occlusion and Detect Menus to off, as they won't work.		

**Debug: show depth and edges** - Shows depth buffer and highlights edges - it helps you check if depth buffer is correctly aligned with the image. Some games (e.g. Journey) do weird things that mean it's offset and tweaking ReShade's depth buffer settings might be required. It's as if you can see the Matrix.


Advanced Tuning and Configuration
------------------------

**AO max distance** - The ambient occlusion effect fades until it is zero at this distance. Helps avoid avoid artefacts if the game uses fog or haze. If you see deep shadows in the clouds then reduce this. If the game has long, clear views then increase it.

**AO radius** - Ambient Occlusion area size, as percent of screen. Bigger means larger areas of shade, but too big and you lose detail in the shade around small objects. Bigger can be slower too. 	
		
**AO shape modifier** - Ambient occlusion - weight against shading flat areas. Increase if you get deep shade in almost flat areas. Decrease if you get no-shade in concave areas areas that are shallow, but deep enough that they should be occluded. 
	
**AO max depth diff** - Ambient occlusion biggest depth difference to allow, as percent of depth. Prevents nearby objects casting shade on distant objects. Decrease if you get dark halos around objects. Increase if holes that should be shaded are not.


Tips
----

- Check if game provides depth buffer! If not turn of depth of field, ambient occlusion and detect menus for better performance (they won't affect the image if left on by mistake).
- Bounce lighting is off by default because it makes AO twice as slow, and is slightly more likely to have artefacts due to low sample count. However, most of the time it really makes shading look more realistic so turn it on if you can spare 2 fps.
- If depth is always available during gameplay then enabling Detect menus and videos is recommended to make non-gamplay parts clearer. 
- If the game uses lots of dithering (i.e. ░▒▓ patterns), sharpen may exagerate it, so use less sharpenning. (e.g. Witcher 2's lighting & shadows.)		
- If you don't like an effect then reduce it or turn it off. Disabling effects improves performance, except sharpening, which is basically free if FXAA or depth of field is on.	
- If the game uses lots of semi-transparent effects like smoke or fog, and you get incorrect shadows/silluettes then you may need to tweak AO max distance. Alternatively, you could use the game's own slower SSAO option if it has one. This is a limitation of ReShade and similar tools, ambient occlusion should be drawn before transparent objects, but ReShade can only work with the output of the game and apply it afterwards.
- You can mix and match with in-game options or other ReShade shaders, though you lose some the performance benefits of a combined shader.
- Don't set FAST_AO_POINTS higher than 12 - the algorithm is designed for few points and won't use the extra points wisely.
- Experiment!
	* How much sharpen and depth of field is really a matter of personal taste. 
	* Don't be afraid to try lower AO quality levels if you want maximum performance. Even a little bit of AO can make the image look less flat.
	* Be careful with ambient occlusion settings; what looks good in one scene may be too much in another. Try to test changes in different areas of the game with different fog and light levels. It looks cool at the maximum but is it realistic? Less can be more; even a tiny bit of AO makes everything look more three-dimensional.
		
Benchmark
---------
- Game: Witcher 3 
- Scene: [Beauclair looking at the water feature opposite the bank](/Comparison%20Screenshots%20Witcher%203/Benchmark%20Location.png) 
- Settings: 1080p, Graphics settings low
- Hardware: Razer Blade Stealth 13 Late 2019 Laptop with NVIDIA GeForce GTX 1650 with Max-Q design
- Shader version: 1.0

**Baseline**

	FPS	Settings
	86	No post-processing

**Fast_FXAA_sharpen_DOF_and_AO results**

	FPS	Settings
	82	default (Fast FXAA + sharpen + Fast AO + bounce + DOF)
	84	Fast FXAA only
	84	Fast FXAA + sharpen
	83	Fast AO only
	82	Fast AO only, quality 12
	83	Fast AO + bounce
	81	Fast AO + bounce, quality 12
	80	All max, quality 12

**Witcher 3 builtin post-processing**

	FPS	Settings
	83	Anti-Aliasing
	82	Anti-Aliasing, sharpening
	79	SSAO
	74	Anti-Aliasing, sharpening, SSAO
	72	HBAO+
	68	Anti-Aliasing, sharpening, HBAO+

**Comparison to other Reshade shaders**

SMAA and FXAA are anti-aliasing. MXAO and SSDO and ambient occlusion.

	FPS	Shader and settings
	81	SMAA
	82	FXAA
	75	MXAO very low (4 samples)
	71	MXAO default (16 samples)
	69	MXAO default plus MXAO_ENABLE_IL on
	68	PPFX SSDO
	67	FXAA + MXAO (default quality)
	64	FXAA + PPFX SSDO

Similar results (relatively) are seen in other locations and graphic settings and resolutions.
	
Tech details
------------
	
Combining FXAA, sharpening and depth of field in one shader works better than separate ones because the algorithms work together. Each pixel is sharpened or softened only once, and where FXAA detects strong edges they're not sharpened. With seperate shaders sometimes sharpening can undo some of the good work of FXAA. More importantly, it's much faster because we only read the pixels only once.
	
GPUs are so fast that memory is the performance bottleneck. While developing I found that number of texture reads was the biggest factor in performance. Interestingly, it's the same if you're reading one texel, or the bilinear interpolation of 4 adjacent ones (interpolation is implemented in hardware such that it is basically free). Each pass has noticable cost too. Therefore everything is combined in one pass, with the algorithms designed to use as few reads as possible. Fast FXAA makes 7 reads per pixel. Sharpen uses 5 reads, but 5 already read by FXAA so if both are enabled it's basically free. Depth of field also re-uses the same 5 pixels, but adds a read from the depth buffer. Ambient occlusion adds 3-9 more depth buffer reads (depending on quality level set). 
	
FXAA starts with the centre pixel, plus 4 samples each half a pixel away diagonally; each of the 4 samples is the average of four pixels. Based on their shape it then samples two more points 3.5 pixels away horizontally or vertically. We look at the diamond created ◊ and look at the change along each side of the diamond. If the change is bigger on one pair of parallel edges and small on the other then we have an edge. The size of difference determines the score, and then we blend between the centre pixel and a smoothed using the score as the ratio. 

The smooth option is the four nearby samples minus the current pixel. Effectively this convolution matrix:

	1 2 1
	2 0 2  / 12;
	1 2 1
	
Sharpening increases the difference between the centre pixel and it's neighbors. We want to sharpen small details in textures but not sharpen object edges, creating annoying lines. To achieve this it calculates two sharp options: It uses the two close points in the diamond FXAA uses, and calculates the difference to the current pixel for each - if both are positive or both negative then if adds them together and sharpens the texture; if the signs don't match then we have an edge and it doesn't sharpen. It darkens pixels more than it brightens them; this looks more realistic - the amount of brightening is automatically adjusted based on the light, so in dark areas pixels can become lighter, but it bright areas they cannot. FXAA is calculated before but applied after sharpening. If FXAA decides to smooth a pixel the maximum amount then sharpening is cancelled out completely.
	
Depth of field is subtle; this implementation isn't a fancy cinematic focus effect. Good to enable if using sharpening, as it takes the edge of the background and helps emphasise the foreground. If DOF blur is set to zero, then it just reduces the strength of sharpening, so sharpening gradually disappears in the distance. If DOF blur is higher, it also blurs pixels, increasing blur with distance - at 1 pixels at maximum depth as set to the smooth value. The total change in each pixel is limited to 50% to reduce problems at near-to-far edges when blur is high.
		
Ambient occlusion adds shade to concave areas of the scene. It's a screen space approximation of the amount of ambient light reaching every pixel. It uses the depth buffer generated by the rasterisation process. Without ambient occlusion everything looks flat. However, ambient occlusion should be subtle and not be overdone. Have a look around in the real world - the bright white objects with deep shading you see in research papers just aren't realistic. If you're seeing black shade on bright objects, or if you can't see details in dark scenes then it's too much. However, exagerating it just a little bit compared to the real-world is good - it's another depth clue for your brain and makes the flat image on the flat screen look more 3D.  
	
Fast Ambient occlusion is pretty simple, but has a couple of tricks that make it look good with few samples. Unlike well known techniques like SSAO and HBAO it doesn't try to adapt to the local normal vector of the pixel - it picks sample points in a simple circle around the pixel. Samples that are in closer to the camera than the current pixel add shade, ones further away don't. At least half the samples must be closer for any shade to be cast (so pixels on flat surfaces don't get shaded, as they'll be half in-front at most). It has 4 tricks to improve on simply counting how many samples are closer.

1. Any sample significantly closer is discarded and replaced with an estimated sample based on the opposite point. This prevents nearby objects casting unrealistic shadows and far away ones. Any sample more than significantly further away is clamped to a maximum. AO is a local effect - we want to measure shade from close objects and surface contours; distant objects should not affect it.
2. Our 2-10 samples are equally spaced in a circle. We approximate a circle by doing linear interpolation between adjacent points. Textbook algorithms do random sampling; with few sample points that is noisy and requires a lot of blur; also it's less cache efficient.
3. The average difference between adjacent points is calculated. This variance value is used to add fuzziness to the linear interpolation in step 2 - we assume points on the line randomlyh vary in depth by this amount. This makes shade smoother so you don't get solid bands of equal shade. 
4. Pixels are split into two groups in a checkerboard pattern (▀▄▀▄▀▄). Alternatve pixels use a circle of samples half of the radius. With small pixels, the eye sees a half-shaded checkerboard as grey, so this is almost as good taking twice as many samples per pixel. More complex dithering patterns were tested but don't look good (░░).

Amazingly, this gives quite decent results even with very few points in the circle.

There are two optional variations that change the Fast Ambient Occlusion algorithm:

1. Shine. Normally AO is used only to make pixels darker. With the AO Shine setting (which is set quite low by default), we allow AO amount to be negative. This brightens convex areas (corners and bumps pointing at the camera.) Not super realistic but it really helps emphasise the shapes. This is basically free - instead of setting negative AO to zero we multiply it by ao_shine_strength.
2. Bounce lighting. This is good where two surfaces of different colour meet. However, most of the time this has little effect so it's not worth sampling many nearby points. We want to find a point on the adjacent surface to sample the colour of. To do that we take the point in the circle closest to the camera, and the one opposite - one is probably the same as the centre and one an adjacent surface. We take the minimum of the two samples values to approximate the nearby surface's colour, erring on the side of less light. Next we estimate the light in the area, using the maximum of our samples and c. This is used to adjust c to estimate how much light it will reflect. We multiply this modified c with the bounce light, to get the light bouncing of the nearby surface, to c, then to the camera. The value is multiplied by our AO value too, which is a measure of shape and makes sure only concave areas get bounced light added.

**Ideas for future improvement**

Auto-tuning for AO - detect fog, smoke, depth buffer type, and adapt.

**History**

(*) Feature (+) Improvement	(x) Bugfix (-) Information (!) Compatibility

1.2.3 (x) Regression fix: AO shade colour when not using bounce. Actually tweaked this whole section so it works like bounce lighting but using the current pixel instead of reading nearby ones, and simplified the code in places too. 

1.2.2 (+) bounce_lighting performance improvement!

1.2.1 (x) Bugfix: didn't compile in OpenGL games.

1.2 (+) Better AO. Smoother shading transition at the inner circle of depth sample points - less artefacts at high strength. Tweaked defaults - The shading improvements enabled me go back to default FAST_AO_POINTS=6 for better performance. Allow slightly deeper shade at max.

1.1 (+) Improved sharpening. Tweaked bounce lightling strength. Tweaked defaults. Simplified settings. Quality is now only set in pre-processor - to avoid problems.

1.0 (-) Initial public release

Thank you macron & AlucardDH on ReShade forum for bug reports.
	
*/


/*---------------.
| :: Includes :: |
'---------------*/

#include "ReShade.fxh"
#include "ReShadeUI.fxh"


// This is your quality/speed trade-off. Miniumum 2, maximum 12 (you can go higher but it's not worth it - and above 20 it might break.). Feel free to go down to 3, or even 2 for some basic shading with minimal cost (but maybe not at max AO strength!)
#ifndef FAST_AO_POINTS
	#define FAST_AO_POINTS 6
#endif

//This was a GUI slider, but it caused problems with DirectX 9 games failing to compile it. Have to use pre-processor.


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


uniform bool ao_enabled <
    ui_category = "Enabled Effects";
    ui_label = "Fast Ambient Occlusion (AO) (requires depth buffer)";
    ui_tooltip = "Ambient occlusion shades pixels that are surrounded by pixels closer to the camera - concave shapes. It's a simple approximation of the of ambient light reaching each area (i.e. light just bouncing around the world, not direct light.)\n\nFor quality adjustment, set preprocessor definition FAST_AO_POINTS. Higher is better quality but slower. Minimum is 2; don't go above 12 - algorithm isn't designed to take advantage of more points.";
    ui_type = "radio";
> = true;


uniform bool bounce_lighting <
    ui_category = "Enabled Effects";
    ui_label = "Bounce Lighting (requires AO)";
    ui_tooltip = "Approximates local ambient light colour. A bright red pillar by a white wall will make the wall a bit red. Makes Ambient Occlusion use two samples of colour data as well as depth.\n\nFast Ambient Occlusion must be enabled too.";
    ui_type = "radio";
> = true;


uniform bool dof_enabled <
    ui_category = "Enabled Effects";
    ui_label = "Depth of field (DOF) (requires depth buffer)";
    ui_tooltip = "Softens distant objects subtly, as if slightly out of focus. ";
    ui_type = "radio";
> = true;

uniform bool depth_detect <
    ui_category = "Enabled Effects";
    ui_label = "Detect menus & videos (requires depth buffer)";
    ui_tooltip = "Skip all processing if depth value is 0 or 1 (per pixel). Full-screen videos and 2D menus probably do not need anti-aliasing nor sharpenning, and may lose worse with them.\n\nOnly enable if depth buffer always available in gameplay!";
    ui_type = "radio";
> = false;


//////////////////////////////////////

uniform float sharp_strength < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Effects Intensity";
	ui_min = 0; ui_max = 1; ui_step = .05;
	ui_tooltip = "For values > 0.5 I suggest depth of field too. ";
	ui_label = "Sharpen strength";
> = .5;

uniform float ao_strength < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Effects Intensity";
	ui_min = 0.0; ui_max = 1.0; ui_step = .05;
	ui_tooltip = "Ambient Occlusion. Higher mean deeper shade in concave areas.\n\nFor quality adjustment, set preprocessor definition FAST_AO_POINTS. Higher is better quality but slower. Minimum is 2; don't go above 12 - algorithm isn't designed to take advantage of more points. ";
	ui_label = "AO strength";
> = 0.7;

uniform float bounce_strength < __UNIFORM_SLIDER_FLOAT1
    ui_category = "Effects Intensity";
	ui_min = 0.0; ui_max = 1.0; ui_step = .05;
    ui_label = "Bounce strength";
    ui_tooltip = "Multiplier for local bounced light. A bright red pillar by a white wall will make the wall a bit red, but how red? ";
> = .7;

uniform float ao_shine_strength < __UNIFORM_SLIDER_FLOAT1
    ui_category = "Effects Intensity";
	ui_min = 0.0; ui_max = 1; ui_step = .05;
    ui_label = "AO shine";
    ui_tooltip = "Normally AO just adds shade; with this it also brightens convex shapes. Maybe not realistic, but it prevents the image overall becoming too dark, makes it more vivid, and makes some corners clearer. Higher than 0.5 looks a bit unrealistic. ";
> = .3;

uniform float dof_strength < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Effects Intensity";
	ui_min = 0; ui_max = 1; ui_step = .05;
	ui_tooltip = "Depth of field. Applies subtle smoothing to distant objects. If zero it just cancels out sharpening on far objects. It's a small effect (1 pixel radius).";
	ui_label = "DOF blur";
> = 0.3;


uniform int debug_mode <
    ui_category = "Output mode";
	ui_type = "radio";
    ui_label = "Output mode";
    ui_items = "Normal\0"
	           "Debug: show FXAA edges\0"
			   "Debug: show ambient occlusion shade\0"
	           "Debug: show depth buffer\0"
			   "Debug: show depth and edges\0";
	ui_tooltip = "Handy when tuning ambient occlusion settings.";
> = 0;



uniform float ao_fog_fix < __UNIFORM_SLIDER_FLOAT1
    ui_category = "Advanced Tuning and Configuration";
	ui_min = 0.0; ui_max = 2; ui_step = .05;
    ui_label = "AO max distance";
    ui_tooltip = "The ambient occlusion effect fades until it is zero at this distance. Helps avoid avoid artefacts if the game uses fog or haze. If you see deep shadows in the clouds then reduce this. If the game has long, clear views then increase it.";
> = .5;

uniform float ao_radius < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Tuning and Configuration";
	ui_min = 0.0; ui_max = 2; ui_step = 0.01;
	ui_tooltip = "Ambient Occlusion area size, as percent of screen. Bigger means larger areas of shade, but too big and you lose detail in the shade around small objects. Bigger can be slower too. ";
	ui_label = "AO radius";
> = 1;

uniform float ao_shape_modifier < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Tuning and Configuration";
	ui_min = 1; ui_max = 2000; ui_step = 1;
	ui_tooltip = "Ambient occlusion - weight against shading flat areas. Increase if you get deep shade in almost flat areas. Decrease if you get no-shade in concave areas areas that are shallow, but deep enough that they should be occluded. ";
	ui_label = "AO shape modifier";
> = 500;

uniform float ao_max_depth_diff < __UNIFORM_SLIDER_FLOAT1
	ui_category = "Advanced Tuning and Configuration";
	ui_min = 0; ui_max = 2; ui_step = 0.001;
	ui_tooltip = "Ambient occlusion biggest depth difference to allow, as percent of depth. Prevents nearby objects casting shade on distant objects. Decrease if you get dark halos around objects. Increase if holes that should be shaded are not.";
	ui_label = "AO max depth diff";
> = 0.5;


uniform bool abtest <
    ui_category = "Advanced Tuning and Configuration";
    ui_label = "A/B test";
    ui_tooltip = "Ignore this. Used by developer when testing and comparing algorithm changes.";
    ui_type = "radio";
> = false;


//////////////////////////////////////////////////////////////////////

//Smallest possible number in a float
#define FLT_EPSILON 1.1920928955078125e-07F

uniform int framecount < source = "framecount"; >;

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



float3 Fast_FXAA_sharpen_DOF_and_AO_PS(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{	
	
	//centre (original pixel)
	float3 c = tex2D(samplerColor, texcoord).rgb;	
	float3 original_c = c;
	
	//centre pixel depth
	float depth=0;
	
	if(ao_enabled || dof_enabled || debug_mode == 3 || depth_detect) {
		depth = pointDepth(texcoord);									
	}
	
	// multiplier to convert rgb to perceived brightness	
	static const float3 luma = float3(0.2126, 0.7152, 0.0722);
	
	const bool run_fxaa = fxaa_enabled || debug_mode==1 || debug_mode==4;
	
	float ratio=0;
	float3 smoothed =0;
	
  //skip all processing if in menu or video
  if(!depth_detect || ( depth!=0 && depth != 1) ) { 
	
	if(run_fxaa || sharp_enabled || dof_enabled) {
	
		//Average of the four nearest pixels to each diagonal.
		float3 ne = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(.5,.5)).rgb;
		float3 sw = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(-.5,-.5)).rgb;
		float3 se = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(.5,-.5)).rgb;
		float3 nw = tex2D(samplerColor, texcoord + BUFFER_PIXEL_SIZE*float2(-.5,.5)).rgb;
		
		// Average of surrounding pixels, both smoothing edges (FXAA) 
		smoothed = ((ne+nw)+(se+sw)-c)/3;	
		
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
		if(run_fxaa) {	
			//Get two more pixels further away on the possible line.
			const float dist = 3.5;
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
			// Add step_detect_threshold of 0.05. To avoid blurring where not needed and to avoid divide by zero. We're in linear colour space, but monitors and human vision isn't. Darker pixels need smaller threshold than light ones, so we adjust the threshold.
				
			float3 total_diff = (d1+d2) + 0.05 *sqrt(smoothed);					
			float3 max_diff = max(d1,d2);
				
			//score between 0 and 1
			float score = dot(luma,(max_diff/total_diff));			
								
			//ratio of sharp to smoothed
			//If score > 0.5 then smooth. Anything less goes to zero,
			ratio = max( 2*score-1, 0);				
		}
		
		if(sharp_enabled) {		
			float3 sharp1 = 2*c-n2;
			float3 sharp2 = 2*c-s2;
										
			//clamp to diff1 and diff2. If the sign of those is not the same we get 0. this is how we sharpen textures but not edges.
			float3 min1 = (1+.2*sharp_strength)*min(sharp1, sharp2);
			float3 max1 = (1-.2*sharp_strength)*max(sharp1, sharp2);
						
			float3 sharp_diff = 2*c-n2-s2;
			
			//Make it sharpen twice as fast for first .2 of colour - helps bring out subtle details.
			sharp_diff=clamp(sharp_diff, sharp_diff - 0.1, sharp_diff + 0.1) ;
			
			sharp_diff *= sharp_strength;
						
			//If pixel will get brighter, reduce strength. Looks better. Don't brighten at all in bright areas, but allow dark areas to get a bit lighter. 
			sharp_diff = min(sharp_diff, sharp_diff * max(.5-2*length(c),0));					
					
			// If DOF enabled, we adjust turn down sharpen based on depth.
			if(dof_enabled) {
				sharp_diff = lerp(sharp_diff,0,depth);
			}
						
			c = clamp(c+sharp_diff, max(c/2,min(max1,c)), max(min1,c));			
		}
		
		// Debug mode: make the smoothed option more highlighted in green.		
		if(debug_mode==1) { c.r=c.g; c.b=c.g; smoothed=lerp(c,float3(0,1,0),ratio);  } 
		if(debug_mode==4) { c=depth; smoothed=lerp(c,float3(0,1,0),ratio);  } 
		
		//Now apply FXAA after sharpening		
		c = lerp(c, smoothed, ratio);	
				
		//Now apply DOF blur, based on depth. Limit the change % to minimize artefacts on near/far edges.
		if(dof_enabled) { 			
			c=lerp(c, clamp(smoothed,c*.66,c*1.5), dof_strength*depth);			
		}	
		
	}
	
	//Fast screen-space ambient occlusion. It does a good job of shading concave corners facing the camera, even with few samples.
	//depth check is to minimize performance impact areas beyond our max distance, on games that don't give us depth, if AO left on by mistake.
	if(FAST_AO_POINTS >= 2 && ao_enabled && depth>0 && depth<ao_fog_fix && debug_mode != 4) {
		
		// Checkerboard pattern of 1s and 0s ▀▄▀▄▀▄. Single layer of dither works nicely to allow us to use 2 radii without doubling the samples per pixel. More complex dither patterns are noticable and annoying.
		uint square =  (uint(vpos.x+vpos.y)) % 2;
				
		//our sample points. 
		const uint points=min(FAST_AO_POINTS,20);

		float s[FAST_AO_POINTS]; // size must be compile time constant
		
		//This is the angle between the same point on adjacent pixels, or half the angle between adjacently points on this pixel.		
		const float angle = radians(180)/points;
		
		float max_depth = depth+0.01*ao_max_depth_diff;
		float min_depth_sq = sqrt(depth)-0.01*ao_max_depth_diff;
		
		uint i; //loop counter
		
		// Get circle of depth samples.	
		float2 the_vector;
		
		
		[unroll]
		for(i = 0; i<points; i++) {
			// distance of points is either ao_radius or ao_radius*.4 (distance depending on position in checkerboard.)
			// We want (i*2+square)*angle, but this is a trick to help the optimizer generate constants instead of trig functions.
			// Also, note, for points < 5 we reduce larger radius a bit - with few points we need more precision near centre.			
			float2 outer_circle = (min(.002*points,.01)) * ao_radius/normalize(BUFFER_SCREEN_SIZE)*float2( sin((i*2+.5)*angle), cos((i*2+.5)*angle) );
			float2 inner_circle =                   .004 * ao_radius/normalize(BUFFER_SCREEN_SIZE)*float2( sin((i*2-.5)*angle), cos((i*2-.5)*angle) );
			the_vector = square ? inner_circle : outer_circle;
			
			//Debug: show points shape.
			//if(abtest) if(length((the_vector+texcoord-0.5)/BUFFER_PIXEL_SIZE) < 1 ) c=2;
									
			//Make area smaller for distant objects
			the_vector *= (1-depth);
									
			//Get the depth at each point - must use POINT sampling, not LINEAR to avoid ghosting artefacts near object edges.
			s[i] = pointDepth( texcoord+the_vector);
		}
		
		[unroll]
		for(i = 0; i<points; i++) {
			//If s[i] is much farther than depth then bring it closer so that one distance point does not have too much effect.
			s[i] = min( s[i], max_depth );			
		}
		
		const float shape = FLT_EPSILON*ao_shape_modifier; 
		
		//Now deal with points to close or to far to affect shade.
		[unroll]
		for(i = 0; i<points; i++) {
			//If s[i] is much closer than depth then it's a different object and we don't let it cast shadow - instead predict value based on opposite point(s) (so they cancel out).
			if( sqrt(s[i]) < min_depth_sq ) {
				float opposite = s[(i+points/2)%points];		;
				if(points%2) opposite = (opposite + s[(1+i+points/2)%points] ) /2;
				
				//If opposite pixel is also too close then set value to depth so we don't cast shade nor shine.
				if( sqrt(opposite) < min_depth_sq ) s[i] = depth;
				else s[i] = ( depth*2-opposite );				
			}
		}
		
		//Now estimate the local variation - sum of differences between adjacent points.
		float diff = abs(s[0]-s[points-1]);
		[unroll]
		for(i = 0; i<points-1; i++) {			
			diff = diff + abs(s[i]-s[i+1]);
		}
		
		float variance = diff/(2*points) ;
				
		// Minimum difference in depth - this is to prevent shading areas that are only slighly concave.
		
		variance += shape;
		
		float ao = 0;		
		[unroll]
		for(i = 0; i<points; i++) {
			uint j = (i+1)%points;
			// naive algorithm is to just add up all the sample points that cast shade. Instead we interpolate between adjacent points in the circle. Imagine the arc between two ajacent points - we're estimating the fraction of it that is in front of the centre point.
			float near=min(s[i],s[j]); 
			float far=max(s[i],s[j]); 
			
			//This is the magic that makes shaded areas smoothed instead of band of equal shade. If both points are in front, but one is only slightly in front (relative to variance) then 
			near -= variance;
			far  += variance;
			
			//Linear interpolation - 
			float crossing = (depth-near)/(far-near);
			
			//If depth is between near and far, crossing is between 0 and 1. If not, clamp it. Then adjust it to be between -1 and +1.
			crossing = 2*clamp(crossing,0,1)-1;
			
			ao += crossing;
		}
							
		// now we know how much the point is occluded. 
		ao = ao/points;
		
		//Because of our checkerboard pattern it can be too dark in the inner_circle and create a noticable step. This softens the inner circle (which will be darker anyway because outer_circle is probably dark too.)
		if(square || points==2) ao*=(2.0/3.0);
		
		//Weaken the AO effect depth is a long way away. This is to avoid artefacts when there is fog/haze/darkness in the distance.	
		float fog_fix_multiplier = min(1, (1-depth/ao_fog_fix)*2 );	
		ao = ao*fog_fix_multiplier;
		
		//If bounce lighting isn't enabled we actually pretend it is using c*smoothed to get better colour in bright areas (otherwise shade can be too deep or too grey.)
		float3 bounce=smoothed*c*ao_strength;
		
		//Coloured bounce lighting from nearby
		if(bounce_lighting) {					
			float closest = 1;			
			the_vector=0;
			
			// Bounce is subtle effect, we don't want to double time taken by reading as many points again.
			// Choose two vectors for the bounce, based on closest point. Where two walls meet in a corner this works well.
			[unroll]
			for(i = 0; i<points; i++) {
				const float2 outer_circle = (min(.002*points,.01)) * ao_radius/normalize(BUFFER_SCREEN_SIZE)*float2( sin((i*2+.5)*angle), cos((i*2+.5)*angle) );
				const float2 inner_circle =                   .004 * ao_radius/normalize(BUFFER_SCREEN_SIZE)*float2( sin((i*2-.5)*angle), cos((i*2-.5)*angle) );					
				if( s[i] < closest ) {						
					closest = s[i];					
					the_vector = (square) ? inner_circle : outer_circle;					
				}
			}
			
			//Make area smaller for distant objects
			the_vector *= (1-depth);
			
			//This has a surprising performance boost, It's because an offset of 0 is faster as current pixel is already cached.
			//This is faster than putting this check around the whole section (due to parallel execution, some pixels in the block always go down this path therefore all must.)
			if(ao<=0) the_vector=0;
			
			float3 bounce1 = tex2D(samplerColor, texcoord+the_vector).rgb;				
			float3 bounce2 = tex2D(samplerColor, texcoord-the_vector).rgb;	
			
			//Imagine corner where white and red walls meet. If centre is white, one of the two points probably is too. We take the minimum so we make sure we pick up any strong colour, but it has to be darker than centre point.
			bounce = min(bounce1 , bounce2);
			
			//Compensate if bounce much darker than c. Sometimes we are unlucky and our sample is in a small black detail in an otherwise bright area - this limits the damage.
			bounce = max(bounce, c*.5*normalize(bounce));
						
			//Estimate amount of white light hitting area based on max of our 3 points
			float light = length(max(c,max(bounce1,bounce2)))+.005;
									
			// Estimate base unlit colour of c
			float3 unlit_c = c/light;
									
			//We take our bounce light and multiply it by base unlit colour of c to get amount reflected from c.
			
			bounce = bounce*unlit_c*bounce_strength*2;
		}
		
		bounce = bounce*clamp(ao,0,.5);
		
		//If ao is negative it's an exposed area to be brightened (or set to 0 if shine is off).
		if (ao<0) ao*=ao_shine_strength;
		else ao *= ao_strength*1.4; // multiply by 1.4 to compensate for the bounce value we're adding
				
		//debug Show ambient occlusion mode
		if(debug_mode==2) c=.5;
				
		//apply AO and clamp the pixel to avoid going completely black or white.
		c = clamp( c*(1-ao) + bounce	, 0.2*c, .5*c +0.5  );
	}	
	
	//Show depth buffer mode
	if(debug_mode == 3) c = depth ; 	
  }		

  return c;
}


technique Fast_FXAA_sharpen_DOF_and_AO <
	ui_tooltip = "Designed for speed and quality, it combines multiple effects in one shader. Probably even faster than your game's built-in post-processing options (turn them off!).\n"
				 "1. FXAA. Fixes jagged edges. \n"
				 "2. Intelligent Sharpening. \n"
				 "3. Subtle Depth of Field. Softens distant objects.\n"
				 "4. Ambient occlusion. Shades areas that receive less ambient light. It can optionally brighten exposed shapes too, making the image more vivid (AO shine setting).\n"
				 "5. Bounce lighting. A fast local indirect lighting technique. Surfaces get some colour reflected from a nearby surface. \n" ;
	>
{	
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = Fast_FXAA_sharpen_DOF_and_AO_PS;
				
		// Enable gamma correction applied to the output.
		SRGBWriteEnable = true;
	}	
}

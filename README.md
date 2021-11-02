Glamarye Fast Effects for ReShade (version 4.2.1)
======================================

(Previously know as Fast_FXAA_sharpen_DOF_and_AO)

**New in 4.2.1** In response to feedback about the effect not being strong enough I have increased the maximum Fake GI strength and contrast.

**New in 4.2:** Improved quality of Fake Global Illumination, and clearer settings for it. Tweaked defaults.

Author: Robert Jessop 

License: MIT


About
-----
	
Designed for speed and quality, this shader for ReShade is for people who can't just run everything at max settings and want good enough post-processing without costing too much framerate. The FXAA quite a bit faster than as standard FXAA, and ambient occlusion more than twice as fast as other algorithms. Global Illumination is many times faster than other GI shaders, but it's not really the same - it's a fake 2D rough approximation (though it works surprising well!)
	
Glamarye Fast Effects combines several fast versions of common postprocessing enhancements in one shader for speed. Each can be enabled or disabled separately.
	
1. Fast FXAA (fullscreen approximate anti-aliasing). Fixes jagged edges. Almost twice as fast as normal FXAA, and it preserves fine details and GUI elements a bit better. However, long edges very close to horizontal or vertical aren't fixed so smoothly.
2. Intelligent Sharpening. Improves clarity of texture details.
3. Fast ambient occlusion. Shades concave areas that would receive less scattered ambient light. This is faster than typical implementations (e.g. SSAO, HBAO+). The algorithm gives surprisingly good quality with few sample points. It's designed for speed, not perfection - for highest possible quality you might want to try the game's built-in AO options, or a different ReShade shader instead. There is also the option, AO shine, for it to highlight convex areas, which can make images more vivid, adds depth, and prevents the image overall becoming too dark. 
4. Subtle Depth of Field. Softens distant objects. A sharpened background can distract from the foreground action; softening the background can make the image feel more real too. 
5. Detect Menus and Videos. Depending on how the game uses the depth buffer it may be possible to detect when not in-game and disable the effects.
6. Detect Sky. Depending on how the game uses the depth buffer it may be possible to detect background images behind the 3D world and disable effects for them.
7. Fake Global Illumination. Attempts to look like fancy GI shaders but using a very simple 2D approximation instead. Not the most realistic solution but very fast. It makes the lighting look less flat; you can even see bright colours reflecting off other surfaces in the area. 
8. Bounce lighting. A very fast short-range indirect lighting implementation that gives surfaces some coloured light reflected from nearby. It makes colours and shade much more realistic than Ambient Occlusion alone.
	
3, 4 & 5 require depth buffer access.

Tested in Toussaint (and other places and games.)

![Screenshot](glamayre%204.2%20max.png "Beauclair, The Witcher 3")

This was taken in version 4.2 with strengths all set to 1 to make effects more clear. Default settings are more subtle than this.

Comparison (version 4.2)
----------

[Comparison of v4.2 default, max, none, and Witcher 3's builtin FXAA, Sharpen and AO](https://imgsli.com/Nzk3OTk/)
	
Setup
-----
	
1. Install ReShade and configure it for your game (See https://reshade.me)
2. Copy Shaders/Glamarye_Fast_Effects.fx to ReShade's Shaders folder within the game's folder (e.g. C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\reshade-shaders\Shaders)
3. Run the game
4. **Turn off the game's own FXAA, sharpen, depth of field & AO/SSAO/HBAO options** (if it has them).
	- Some games do not have individual options, but have a single "post-processing" setting. Setting that to the lowest value will probably disable them all.
5. Call up ReShade's interface in game and enable Glamarye_Fast_Effects ("Home" key by default)
6. Check if depth buffer is working and set up correctly. If it's not available then Depth of field, Ambient Occlusion, Detect Menus and Detect Sky won't work - disable them. 	
	- Use the built-in "Debug: show depth buffer" to check it's there. Close objects should be black and distant ones white.
	- Use "Debug: show depth and FXAA edges" to check it's aligned.
	- If it isn't right see [Marty McFly's Depth Buffer guide](https://github.com/martymcmodding/ReShade-Guide/wiki/The-Depth-Buffer).		
7. (Optional) Adjust based on personal preference and what works best & looks good in the game. 
	- Note: turn off "performance mode" in Reshade (bottom of panel) to configure, Turn it on when you're happy with the configuration.  

Troubleshooting
-----------

* For help installing and using ReShade see: (https://www.youtube.com/playlist?list=PLVJvgoR2kklkkDQxYjBsbR2y-ieWmgSZt) and for more troubleshooting (https://www.youtube.com/watch?v=hYUiWfvyafQ)
* Game crashes: disable anything else that also displays in game, such as Razer's FPS counter, or Steam's overlay. Some games have issues when more than one program is hooking DirectX.
* If you get "error X4505: maximum temp register index exceeded" on DirectX 9.0 games then in ReShade set FAST_AO_POINTS lower (4 should work).
* Fast Ambient Occlusion
	- If you see shadows in fog, mist, explosions etc then try tweaking **Reduce AO in bright areas** and **AO max distance** under Advanced Tuning and configuration.
	- If shadows in the wrong places then depth buffer needs configuring (see below)
	- If you see other artefacts (e.g. shadows look bad) then options are:
		- turn down the strength
		- increase the quality by setting FAST_AO_POINTS to 8 or 12.
		- Try tweaking the AO options in Advanced Tuning and configuration.
* Depth buffer issues:
	- Check ReShade's supported games list to see any notes about depth buffer first. 
	- Check in-game (playing, not in a menu or video cutscene):
	- If it's missing or looks different it may need configuration
		- Use right most tab in Reshade and try to manually find the depth buffer in the list of possible buffers.
		- Use ReShade's DisplayDepth shader to help find and set the right "global preprocessor definitions" to fix the depth buffer.
	- More guidance on depth buffer setup from Marty McFly: (https://github.com/martymcmodding/ReShade-Guide/wiki/The-Depth-Buffer)
* No effects do anything. Reset settings to defaults. If using "Detect menus & videos" remember it requires correct depth buffer - depth buffer is just black no effects are applied.
* Things are too soft/blurry. 
	- Turn off DOF of turn down DOF blur. Depth of field blurs distant objects but not everyone wants that and if the depth buffer isn't set up well it might blur too much.
	- Make sure sharpen is on. FXAA may slightly blur fine texture details, sharpen can fix this.
* GShade: I have heard it works with GShade, but you might need to add "ReShade.fxh" and "ReShadeUI.fxh" from ReShade to your shaders directory too if you don't have them already.
* Everything is set up properly, but I want better quality.
	- use other reshade shaders instead. This is optimized for speed, some others have better quality.
	- Make sure you're not using two versions of the same effect at the same time. Modern games have built-in antialiasing and ambient occlusion (likely slower than Glamayre.) They might be called something like FXAA/SMAA/TAA and SSAO/HBAO or just hidden in a single postprocessing quality option. Disable the game's version or disable Glamayre's version.
		
Enabled/disable effects
-----------------------
	
**Fast FXAA** - Fullscreen approximate anti-aliasing. Fixes jagged edges.

**Intelligent Sharpen** - Sharpens details but not straight edges (avoiding artefacts). It works with FXAA and depth of field instead of fighting them. It darkens pixels more than it brightens them; this looks more realistic. 

**Fast Ambient Occlusion (AO) (requires depth buffer)** - Ambient occlusion shades places that are surrounded by points closer to the camera. It's an approximation of the reduced ambient light reaching occluded areas and concave shapes (e.g. under grass and in corners.)

**Depth of Field (DOF) (requires depth buffer)** - Softens distant objects subtly, as if slightly out of focus. 

**Detect menus & videos (requires depth buffer)** - Skip all processing if depth value is 0 (per pixel). Sometimes menus use depth 1 - in that case use Detect Sky option instead. Full-screen videos and 2D menus do not need anti-aliasing nor sharpenning, and may lose worse with them. Only enable if depth buffer always available in gameplay!

**Detect sky** - Skip all processing if depth value is 1 (per pixel). Background sky images might not need anti-aliasing nor sharpenning, and may look worse with them. Only enable if depth buffer always available in gameplay!
    
The following two effects do not have checkboxes, but you will see two versions of Glamayre in ReShade's effects list (with and without these). There used to be checkboxes, but there was some performance cost even if disabled (due to extra shader passes) - having two versions of the shader is faster if you don't want Fake Global Illumination.

**Fake Global Illumination** and **Bounce lighting** - Approximates light bouncing and reflecting around the scene. Every pixel gets some light added from the surrounding area of the image. This is a simple 2D approximation and therefore not as realistic as path tracing or ray tracing solutions, but it's fast! No depth required! Fake GI is larger scale and doesn't require depth buffer. Bounce lighting modifies ambient occlusion to more accurately colour areas it shades.

Effects Intensity
-----------------

**Sharpen strength** - For values > 0.5 I suggest depth of field too. Values > 1 only recommended if you can't see individual pixels (i.e. high resolutions on small or far away screens.)

**AO strength** - Ambient Occlusion. Higher mean deeper shade in concave areas. Tip: if increasing also increase FAST_AO_POINTS preprocessor definition for higher quality.

**AO shine** - Normally AO just adds shade; with this it also brightens convex shapes. Maybe not realistic, but it prevents the image overall becoming too dark, makes it more vivid, and makes some corners clearer. Higher than 0.5 looks a bit unrealistic.

**DOF blur** - Depth of field. Applies subtle smoothing to distant objects. If zero it just cancels out sharpening on far objects. It's a small effect (1 pixel radius).

**AO Quality** - Due to compatibility with older drivers and D3D9 games this option has been removed - however you can still increase quality by changing the preprocessor definition FAST_AO_POINTS (defauly is 6, try 12 for best quality.)

Fake Global Illumination
------------------------

These only work if you are using the _with Fake GI_ version of the shader.

**Fake GI strength** - Fake Global Illumination intensity. Every pixel gets some light added from the surrounding area of the image. Greater than 1 may look unrealistic.

**Fake GI saturation** - Fake Global Illumination can exaggerate colours in the image too much. Decrease this to reduce the colour saturation of the added light. Increase for more vibrant colours.

**Fake GI contrast** - Increases contrast of image relative to average light in each area. Fake Global Illumination can reduce overall contrast; this setting compensates for that and even improve contrast compared to the original. Greater than 1 may look unrealistic.

**AO Bounce multiplier** - When Fake GI and AO are both enabled, it uses local depth and colour information to approximate short-range bounced light. A bright red pillar next to a white wall will make the wall a bit red, but how red? Use this to make the effect stronger or weaker. Also affects overall brightness of AO shading. Recommendation: keep at 1.

Output modes
-----------

**Normal** - Normal output

**Debug: show FXAA edges** - Highlights edges that are being smoothed by FXAA. The brighter green the more smoothing is applied. Don't worry if moderate smoothing appears where you don't think it should - sharpening will compensate.

**Debug: show AO shade & GI colour** - Shows amount of shading AO, bounce and Fake GI is adding, against a grey background. Use this if tweaking AO settings to help get them just right see the effect of each setting clearly. However, don't worry if it doesn't look perfect - it exaggerates the effect and many issues won't be noticable in the final image. The best final check is in normal mode.

**Debug: show depth buffer** - This image shows the distance to each pixel. However not all games provide it and there are a few different formats they can use. Use to check if it works and is in the correct format. Close objects should be black and distant ones white. If it looks different it may need configuration - Use ReShade's DisplayDepth shader to help find and set the right "global preprocessor definitions" to fix the depth buffer. If you get no depth image, set Depth of Field, Ambient Occlusion and Detect Menus to off, as they won't work.		

**Debug: show depth and edges** - Shows depth buffer and highlights edges - it helps you check if depth buffer is correctly aligned with the image. Some games (e.g. Journey) do weird things that mean it's offset and tweaking ReShade's depth buffer settings might be required. It's as if you can see the Matrix.

**Debug: show GI area colour** - Global Illumination: Shows the colour of the light from the area affecting to each pixel.

**Debug: show GI ambient light** Global Illumination: Shows the brightness of the bigger each area - ratio between this and color helps decide overall brightness.

**Debug: show bounce light** - Shows what the bounce lightling effect is adding and where.


Advanced Tuning and Configuration
------------------------

You probably don't want to adjust these, unless your game has visible artefacts with the defaults.

**Reduce AO in bright areas** - Do not shade very light areas. Helps prevent unwanted shadows in bright transparent effects like smoke and fire, but also reduces them in solid white objects. Increase if you see shadows in white smoke, decrease for more shade on light objects. Doesn't help with dark smoke.

**AO max distance** - The ambient occlusion effect fades until it is zero at this distance. Helps avoid avoid artefacts if the game uses fog or haze. If you see deep shadows in the clouds then reduce this. If the game has long, clear views then increase it.

**AO radius** - Ambient Occlusion area size, as percent of screen. Bigger means larger areas of shade, but too big and you lose detail in the shade around small objects. Bigger can be slower too. 	

**Bounce multiplier** When bounce is enabled, ambient occlusion also takes into the colour of light bouncing off nearby pixels. A bright red pillar by a white wall will make the wall a bit red, but how red? Use this to make the effect stronger or weaker. 
		
**AO shape modifier** - Ambient occlusion - weight against shading flat areas. Increase if you get deep shade in almost flat areas. Decrease if you get no-shade in concave areas areas that are shallow, but deep enough that they should be occluded. 
	
**AO max depth diff** - Ambient occlusion biggest depth difference to allow, as percent of depth. Prevents nearby objects casting shade on distant objects. Decrease if you get dark halos around objects. Increase if holes that should be shaded are not.

**FXAA bias** - Don't anti-alias edges with very small differences than this - this is to make sure subtle details can be sharpened and do not disappear. Decrease for smoother edges but at the cost of detail, increase to only sharpen high-contrast edges. This FXAA algorithm is designed for speed and doesn't look as far along the edges as others - for best quality you might want turn it off and use a different shader, such as SMAA.

**FAST_AO_POINTS** (preprocessor definition - bottom of GUI). Number of depth sample points in Performance mode. This is your speed vs quality knob; higher is better but slower. Minimum is 2, Maximum 16. 

Tips
----

- Turn up the strength settings, to taste. The defaults are conservative.
- Check if game provides depth buffer! If not turn of depth of field, ambient occlusion and detect menus for better performance (they won't affect the image if left on by mistake).
- If depth is always available during gameplay then enabling Detect menus and videos is recommended to make non-gamplay parts clearer. 
- If the game uses lots of dithering (i.e. ░▒▓ patterns), sharpen may exagerate it, so use less sharpenning. (e.g. Witcher 2's lighting & shadows.)		
- If you don't like an effect then reduce it or turn it off. Disabling effects improves performance, except sharpening, which is basically free if FXAA or depth of field is on.	
- If the game uses lots of semi-transparent effects like smoke or fog, and you get incorrect shadows/silluettes then you may need to tweak AO max distance. Alternatively, you could use the game's own slower SSAO option if it has one. This is a limitation of ReShade and similar tools - ambient occlusion should be done before transparent objects, but ReShade can only work with the output of the game and apply it after.
- You can mix and match with in-game options or other ReShade shaders, though you lose some the performance benefits of a combined shader. Make sure you don't have two effects of the same type enabled.
- Don't set FAST_AO_POINTS higher than 12 - the algorithm is designed for few points and won't use the extra points wisely.
- Experiment!
	* What strength settings looks best may depend on the game, your monitor, and its settings (your TV's "game mode" may have some built-in sharpening for example).
	* Depth of field, AO Shine, and Fake Glboal Illumination are really a matter of personal taste. 
	* Don't be afraid to try lower FAST_AO_POINTS (minimum: 2) and turn off bounce lighting if you want really fast AO. Even very low quality AO can make the image look better (but keep strength <= 0.5).
	* Be careful with the advanced ambient occlusion settings; what looks good in one scene may be too much in another. Try to test changes in different areas of the game with different fog and light levels. 
		
Benchmark
---------

TODO: redo this for current version.

- Game: Witcher 3 
- Scene: [Beauclair looking at the water feature opposite the bank](/Benchmark%20Location.png) 
- Settings: 1080p, Graphics settings low
- Hardware: Razer Blade Stealth 13 Late 2019 Laptop with NVIDIA GeForce GTX 1650 with Max-Q design
- Shader version: 1.0 (didn't include fake global illumination effect)

**Baseline**

	FPS	Settings
	86	No post-processing

**Fast_FXAA_sharpen_DOF_and_AO v1.0 results (previous name for Glamarye Fast Effects)**

	FPS	Settings
	82	v1.0 defaults (Fast FXAA + sharpen + Fast AO + bounce + DOF)
	84	Fast FXAA only
	84	Fast FXAA + sharpen
	83	Fast AO only
	82	Fast AO only, FAST_AO_POINTS 12
	83	Fast AO + bounce
	81	Fast AO + bounce, FAST_AO_POINTS 12
	80	v1.0 all max, FAST_AO_POINTS 12
	
**Note**: Full benchmark with v3.0 not done yet. Fake Global Illumination wasn't in 1.0 and the default FAST_AO_POINTS was slightly lower (6). V2 is 1-2 FPS slower in its default settings, but if configured like 1.0 is faster.

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
2. Bounce lighting. This is good where two surfaces of different colour meet. However, most of the time this has little effect so it's not worth sampling many nearby points. We use same wide area brightness from the Fake GI algorithm to estimate the ambient light and therefore the unlit colour of the pixel, and therefore how much light it will reflect. We blur the image to get the average light nearby. We multiply the unlit pixel colour with the nearby light to get the light bounced. The value is multiplied by our AO value too, which is a measure of shape and makes sure only concave areas get bounced light added.

Fake Global Illumination is a quite simple 2D approximation of global illumination. Being 2D it's not very realistic but is fast. First we blur the main image to get the overall colour of light in each area. We also blur the maximum of red, green and blue to estimate the amount of ambient light in the area - this is used to help guess if current pixel's true surface colour -  is likely a light surface in shadow, or a dark surface in the light? This surface colour is multiplied by the overall light and added to the pixel. The pixel is darkenned to keep the overall image about the same brightness. We also blur the image again to get a larger ambient light area. The ratio of of two blurs is used as a multiplier for the pixel brightness - this gives some variation and increases the contrast between light and dark areas. Overall the image appears less flat - even if the illumination isn't always realistic, the subtle variations in shade help make the image seem more real.

**Ideas for future improvement**

- Stop improving this a start playing the games again!

**History**

(*) Feature (+) Improvement	(x) Bugfix (-) Information (!) Compatibility

4.2.1 (+) In response to feedback about the effect not being strong enough I have increased the maximum Fake GI strength and contrast.

4.2 (+) Improved quality of fake global illumination, and clearer settings for it. Tweaked defaults.

4.1.1 (x) Fixed typo that caused failure on older versions of ReShade (though current version 4.9.1 was okay)

4.1 (x) Fixed bug affecting AO quality for some FAST_AO_POINTS. Improved variance calculation for AO. Fixed compiler warnings.

4.0 (+) Allow stronger sharpening. Optimized Ambient Occlusion to use fewer instructions and registers, which should fix compilation issues on some D3D9 Games. Faster and better quality Fake Global illumination; also more tweakable. Make bounce lighting faster and smoother by using using some blurred values we calculate anyway for Fake GI.

3.2 (x) Make quality setting Preprocessor only as someone reported compatility issues with Prince of Persia  - looks like too many registers so need to simplify. Change AO to use float4x4 to sav intructions and registers.

3.1 (+) Option to Reduce AO in bright areas. Helps prevent unwanted shadows in bright transparent effects like smoke and fire.

3.0 (+) More tweaks to Fake GI - improving performance and smoothness. Improved FXAA quality (fixed rare divide by zero and fixed subtle issue where Fake GI combined badly with FXAA). Improved sharpen quality (better clamp limits). Simplified main settings. Added dropdown to select from two AO quality levels. Bounce tweaked and moved bounce strength to advanced settings (it is now equal to ao_strength by default - having them different is usually worse.)

2.1 (+) Smoother blur for Fake Global Illumination light, which fixes artefacts (thank you Alex Tuderan). Tweaked defaults. Minor tweaks elsewhere. Smoother where GI meets sky detect.

2.0 (*) Fake Global Illumination! Even better than the real thing (if speed is your main concern!)

1.2.3 (x) Regression fix: AO shade colour when not using bounce. Actually tweaked this whole section so it works like bounce lighting but using the current pixel instead of reading nearby ones, and simplified the code in places too. 

1.2.2 (+) bounce_lighting performance improvement!

1.2.1 (x) Bugfix: didn't compile in OpenGL games.

1.2 (+) Better AO. Smoother shading transition at the inner circle of depth sample points - less artefacts at high strength. Tweaked defaults - The shading improvements enabled me go back to default FAST_AO_POINTS=6 for better performance. Allow slightly deeper shade at max.

1.1 (+) Improved sharpening. Tweaked bounce lightling strength. Tweaked defaults. Simplified settings. Quality is now only set in pre-processor - to avoid problems.

1.0 (-) Initial public release

Thank you:

Alex Tuduran for the previous blur algorithm, suggestions and inspiration for the brightness part of Fake GI algorithm.

macron, AlucardDH, NikkMann, Mirt81, distino, vetrogor, illuzio, geisalt for feedback and bug reports.

ReShade devs for ReShade.

Glamarye?
----------

In the Andrzej Sapkowski's Witcher novels, [Glamayre](https://witcher.fandom.com/wiki/Glamour) is magical make-up. Like Sapkowski's sourceresses, The Witcher 3 is very beautiful already, but still likes a bit of Glamayre.


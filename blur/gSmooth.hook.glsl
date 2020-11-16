/* Gaussian Smoothing filter (3x3 or 5x5 kernel), hw: uses hw linear sampling
by butterw, License: GPL v3
 
Select the HOOKs you want to apply (ex: MAIN, OUTPUT), NONE disables:
- hw.gSmooth3: 3x3 Gaussian kernel using hw linear sampling (4 texture fetches) 
- gSmooth3:    3x3 Gaussian kernel, full (9 texture fetches)
- hw.gSmooth5: 2-pass 5x5 Gaussian kernel using hw linear sampling (2*3 texture fetches)
For stronger blurs use blurGaussR.hook (hw.Gaussian9x9 downscaled by 2) and blurGauss.hook (hw.Gaussian9x9) for subsequent passes.
*/

//!HOOK NONE_MAIN
//!BIND HOOKED
//!DESC hw.gSmooth3

vec4 hook(){ //hw.gSmooth3 (3x3 gaussian kernel) using hw linear sampling, tex:4 
	vec4 blur = HOOKED_texOff(vec2(-0.5, -0.5));
	blur+= HOOKED_texOff(vec2(-0.5, 0.5));  
	blur+= HOOKED_texOff(vec2(0.5, -0.5));
	blur+= HOOKED_texOff(vec2(0.5, 0.5));
	return blur*0.25;
}
/*--------------------------------------------------------------- */

//!HOOK MAIN
//!BIND HOOKED
//!DESC gSmooth3

/* Gaussian 3x3 Kernel:
sigma=0.85, in multi-pass sigma=sigma*sqrt(2)
[ 1 , 2 , 1 ]
[ 2 , 4 , 2 ]
[ 1 , 2 , 1 ]
*/

vec4 hook(){ //gSmooth3 (3x3 gaussian kernel), tex:9
	if (HOOKED_pos.x<0.5) return HOOKED_texOff(0);
	vec4 blur = HOOKED_texOff(-1);
	blur+= 2*HOOKED_texOff(ivec2(0, -1));  
	blur+= HOOKED_texOff(ivec2(1, -1));
	blur+= 2*HOOKED_texOff(ivec2(-1, 0));
	blur+= 4*HOOKED_texOff(0);
	blur+= 2*HOOKED_texOff(ivec2(1, 0));
	blur+= HOOKED_texOff(ivec2(-1, 1));	
	blur+= 2*HOOKED_texOff(ivec2(0, 1));
	blur+= HOOKED_texOff(1);
	return blur/16.;
}

/*--------------------------------------------------------------- */

//!HOOK NONE_MAIN
//!BIND HOOKED
//!DESC hw.gSmooth5

vec4 hook() { //H-pass, 5x5 gaussian kernel, 2pass with hw linear sampling
  vec4 color = HOOKED_tex(HOOKED_pos) *0.29411764705882354;
  color+= HOOKED_tex(HOOKED_pos +vec2( 4/3., 0)*HOOKED_pt) *0.35294117647058826;
  color+= HOOKED_tex(HOOKED_pos +vec2(-4/3., 0)*HOOKED_pt) *0.35294117647058826;
  return color; 
}

//!HOOK NONE_MAIN
//!BIND HOOKED
//!DESC hw.gSmooth5_Y

vec4 hook() { //V-pass, 5x5 gaussian kernel, 2pass with hw linear sampling
  vec4 color = HOOKED_tex(HOOKED_pos) *0.29411764705882354;
  color+= HOOKED_tex(HOOKED_pos +vec2(0,  4/3.)*HOOKED_pt) *0.35294117647058826;
  color+= HOOKED_tex(HOOKED_pos +vec2(0, -4/3.)*HOOKED_pt) *0.35294117647058826;
  return color; 
}

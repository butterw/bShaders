//!HOOK OUTPUT //hook: LUMA, MAIN, OUTPUT
//!BIND HOOKED
//!COMPUTE 32 32 //Workgroup bloc size(X, Y) is defined as X*Y threads, with 1 thread per input pixel.
//!DESC Compute_WorkGroups

/* mpv .hook Compute Shader example by butterw
COMPUTE bw bh [tw th]

Compute Shaders have a slightly different syntax vs fragment shaders. They don't return a pixel color value, output is done through out_image. 

Threads have integer IDs:
uvec3:*/
#define NumWkg gl_NumWorkGroups
#define WkgSize gl_WorkGroupSize
#define WkgID   gl_WorkGroupID
#define LoID    gl_LocalInvocationID // gl_LocalInvocationID.xy * gl_WorkGroupID.xy == gl_GlobalInvocationID
#define GlobID  gl_GlobalInvocationID

#define LoIndex gl_LocalInvocationIndex //uint


#define Orange vec4(1, .5, 0, 1)
#define Blue   vec4(0 ,.5, 1, 1)

void hook() { //executed per thread, in WorkGroup blocks
	vec4 color = HOOKED_tex(HOOKED_pos); //Read input texel
  
  if (WkgID.x==frame && WkgID.x==WkgID.y) color = Blue; // effect at mpv first-launch  
	if (WkgID.x==2 && WkgID.y==0) color = Orange;

	ivec2 coords = ivec2(GlobID); //Global (x, y) ID for pixel threads ex: (100, 240) 
	imageStore(out_image, coords, color);
}

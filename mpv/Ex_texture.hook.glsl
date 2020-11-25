//!HOOK MAIN
//!BIND HOOKED
//!BIND DISCO
//!DESC texture example


/* Simple mpv embedded texture example v0.1
https://forum.videohelp.com/threads/397797-Pixel-shaders-for-video-playback-(-hlsl-glsl)#post2602036

Displays a 3x2 color palette stored in the embedded texture DISCO (FORMAT rgba8)
tested on mpv0.32 Win10 dx11 
*/ 
vec4 hook(){ 
	// return vec4(texture(DISCO, HOOKED_pos).a); //alpha channel
    return texture(DISCO, HOOKED_pos);
}

//!TEXTURE DISCO
//!SIZE 3 2
//!FORMAT rgba8
//!FILTER NEAREST
00ff11ffff00001100000000ffffffff00ff11fffff00ffaa

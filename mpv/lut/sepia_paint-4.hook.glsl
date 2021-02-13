//!HOOK MAIN
//!BIND HOOKED
//!BIND CLUT
//!DESC Sepia_Paint-4

/* small RGB 3D-LUT (cube-4: 64 values) based on the Sepia filter of Paint.net 
This is a tone effect, the effect is the same if applied to a color image or the Y-only noChroma image.  
*/ 

vec4 hook(){
	vec4 color = HOOKED_texOff(0);
	return texture(CLUT, 3.0/4*color.rgb +1/8.0);
}

//created with butterw/lut2hook.py from sepia_paint-4.png
//!TEXTURE CLUT
//!SIZE 4 4 4
//!FORMAT rgba8
//!FILTER LINEAR
000000aa27190Faa453224aa604C3Baa443123aa5F4B3Aaa786452aa917E6Daa776351aa907D6CaaA69686aaBDB0A3aaA59585aaBCAFA2aaD1C8BEaaE6E1DBaa110904aa342317aa503C2Caa695544aa4F3B2Caa695544aa826E5Caa998776aa816D5Baa988675aaAFA091aaC5B9ADaaAE9F90aaC4B8ACaaDAD2CAaaEEEBE7aa1F130Baa3E2C1Eaa5A4636aa735F4Daa594535aa725E4Caa8B7867aaA29181aa8A7766aaA19080aaB8AA9CaaCDC3B8aaB7A99BaaCCC2B7aaE1DBD4aaF6F5F3aa2C1D12aa493627aa634F3Eaa7D6957aa624E3Daa7C6856aa938170aaAB9B8Caa92806FaaAA9A8BaaC0B3A6aaD6CDC4aaBFB2A5aaD5CCC3aaE9E5E0aaFFFFFFaa
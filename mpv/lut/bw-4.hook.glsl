//!HOOK MAIN
//!BIND HOOKED
//!BIND CLUT
//!DESC bw-4 rollei_ortho_25 

/* this is a contrasted Black & White Shader. Alternatives would be: 
for less contrast:
- NoChroma (cancels source chroma)
- bw (Agfa 200X)

Higher contrasts for Blacks or Whites are possible, but not suited for all sources.
- Kodachrome; bw
- etc.
see: https://gmic.eu/color_presets/bw_sample_7.html#browse
*/ 


vec4 hook(){
	vec4 color = HOOKED_texOff(0);
	return texture(CLUT, 0.75*color.rgb +0.125);
}

//created with butterw/lut2hook.py from BW_rollei_ortho_25 smooth https://filterhunt.com/showLut/AkbY2lGABCA
//!TEXTURE CLUT
//!SIZE 4 4 4
//!FORMAT rgba8
//!FILTER LINEAR
000000aa000000aa010101aa020202aa272727aa282828aa2B2B2Baa2D2D2Daa696969aa6A6A6Aaa6C6C6Caa6F6F6FaaCCCCCCaaCCCCCCaaCDCDCDaaCFCFCFaa292929aa2C2C2Caa2F2F2Faa323232aa515151aa545454aa575757aa5B5B5Baa8E8E8Eaa909090aa939393aa969696aaD9D9D9aaD9D9D9aaDADADAaaDCDCDCaa6E6E6Eaa737373aa787878aa7D7D7Daa9D9D9DaaA0A0A0aaA4A4A4aaA9A9A9aaCACACAaaCBCBCBaaCDCDCDaaD0D0D0aaEEEEEEaaEEEEEEaaF0F0F0aaF1F2F2aaC7C7C7aaCBCBCBaaCECECEaaD1D1D1aaDDDDDDaaDFDFDFaaE1E1E1aaE3E3E3aaF2F2F2aaF3F3F3aaF6F6F6aaF9F9F9aaFFFFFFaaFFFFFFaaFFFFFFaaFFFFFFaa

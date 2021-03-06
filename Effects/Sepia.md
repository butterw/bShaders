## Sepia and Tone Effects 

Sepia can designate a variety of different effects. The Sepia effects considered here have the following properties: 
- Tinted monochrome image with Blacks and Whites unchanged. 
- Brightness/saturation stay mostly the same. Details are preserved. 
- the Sepia tint can be brown, yellow, pink...
- Tone Effects are like Sepia but use a different color tint (ex: Purple, Blue)  

### Lightweight Shader approaches
- (Color) >> Grayscale >> RGB x normalized_tint. This approach might be the most straightforward for customization (contrast, tint). It can also be used with a color Input rather than grayscale: midtone/hightlight greys are tinted pink. 
- RGB >> ColorMatrix >> Sepia 
- mpv: RGB >> lut shader >> Sepia

### Results
Testing is done using colorbarsHD input

- Grayscale(NoChroma) / mpv Lut-4(Sepia_Paint): <br/>
<img src="https://raw.githubusercontent.com/butterw/bShaders/master/assets/img/ColorBarsHD720_noChroma.png" width="360">     <img src="https://raw.githubusercontent.com/butterw/bShaders/master/assets/img/ColorBarsHD720_Sepia_Paint-4.png" width="360">

- Colormatrix / Grayscale+ rgb normalized tint: <br/>
<img src="https://raw.githubusercontent.com/butterw/bShaders/master/assets/img/ColorBarsHD720_Colormatrix.png" width="360">     <img src="https://raw.githubusercontent.com/butterw/bShaders/master/assets/img/ColorBarsHD720_rgb-nTint.png" width="360">




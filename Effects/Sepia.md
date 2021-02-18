## Sepia and Tone Effects 

Sepia can designate a variety of different effects. The following type of effects will be considered here: 
- Tinted monochrome image with Blacks and Whites unchanged. 
- Brightness/saturation stay mostly the same. Details are preserved. 
- the Sepia tint can be brown, yellow, pink...
- Tone Effects are like Sepia but use a different color tint (ex: Purple, Blue)  

### Lightweight Shader approaches
- (Color) >> Grayscale >> RGB*normalized_tint
- RGB >> ColorMatrix >> Sepia 
- mpv: RGB >> lut shader >> Sepia

### Results
Testing is done using colorbarsHD input

- Grayscale(NoChroma):<br/>
<img src="https://raw.githubusercontent.com/butterw/bShaders/master/assets/img/ColorBarsHD720_noChroma.png" width="360">

- mpv Lut-4(Sepia_Paint):<br/>
<img src="https://raw.githubusercontent.com/butterw/bShaders/master/assets/img/ColorBarsHD720_Sepia_Paint-4.png" width="360">




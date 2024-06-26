# Paint Effect shader
A shader applied to any object to make it look as it has been painted. The shader only uses a "paint texture", a grayscale texture used for the brush strokes effect, and a gradient texture, used to change the paint color based on lighting.
The project also features custom post processing effects, making the screen looks like a painting canvas, although the paint effect can be used only on object separately, without any post processing effect.

## Breakdown

The shader used is a fragment shader using custom lighting computation; getting the lighting data before actually applying it is a good way to tweak them for the desired painted effect.
In order, here are the steps the shader follows to render an object.

**TODO:** Base.

**TODO:** Lambert lighting.

**TODO:** Tweak Lambert result with paint texture.

**TODO:** Cast shadow.

**TODO:** Specular.

**TODO:** Fresnel.

**TOOD:** Use final mask to apply color gradient.

## Post processing

TODO: Distortion.

TODO: Sobel outline.

TODO: Paint canvas.

![paint shader 02](https://github.com/sixrobin/PaintEffectShader/assets/55784799/edb29693-8bfd-4b07-a12c-fe0c5c15d895)
![paint shader 01](https://github.com/sixrobin/PaintEffectShader/assets/55784799/c10fa464-5f42-4a30-a582-f08b8a5a8e72)
![paint shader 03](https://github.com/sixrobin/PaintEffectShader/assets/55784799/ba71c13d-57e5-42a1-a652-cadc2bae8b8d)

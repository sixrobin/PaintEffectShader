# Paint Effect shader

![painteffect_on-off](https://github.com/sixrobin/PaintEffectShader/assets/55784799/47fefaca-11f3-495f-9667-634a9e058950)

A shader applied to any object to make it look as it has been painted. The shader only uses a "paint texture", a grayscale texture used for the brush strokes effect, and a gradient texture, used to change the paint color based on lighting.
The project also features custom post processing effects, making the screen looks like a painting canvas, although the paint effect can be used only on object separately, without any post processing effect.

One of the benefits of this implementation is that the shader can use triplanar projection for the paint effect, meaning UV unwrapping is not needed for the meshes (which can be useful if using meshes found online, or to gain some time when using custom meshes).

**Note: the meshes used in the project are free resources I found online! They're not meant to be perfect or reusable, but are only here to show actual implementations of the shader.**

## Breakdown

The shader used is a fragment shader using custom lighting computation; getting the lighting data before actually applying it is a good way to tweak them for the desired painted effect.
In order, here are the steps the shader follows to render an object.

**TODO:** Base.

**TODO:** Lambert lighting.

**TODO:** Tweak Lambert result with paint texture.

**TODO:** Cast shadow.

**TODO:** Specular.

**TODO:** Fresnel.

**TOOD:** Mask to color gradient.

**TODO:** Add light color.

**TODO:** Add ambient color.

## Post processing

TODO: Distortion.

TODO: Sobel outline.

TODO: Paint canvas.

![painteffect_03](https://github.com/sixrobin/PaintEffectShader/assets/55784799/eda80eae-acc7-44ba-914c-0f1ce218919f)
![painteffect_02](https://github.com/sixrobin/PaintEffectShader/assets/55784799/4868817d-693a-40d5-8125-eae2c2fdaa05)
![painteffect_01](https://github.com/sixrobin/PaintEffectShader/assets/55784799/e6e8cc9f-2ce8-4012-a4f9-a052376df4de)
![painteffect_04](https://github.com/sixrobin/PaintEffectShader/assets/55784799/e9e77877-1683-4add-8dc2-eca58cab87c6)


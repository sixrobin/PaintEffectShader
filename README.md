# Paint Effect shader

![painteffect_on-off](https://github.com/sixrobin/PaintEffectShader/assets/55784799/47fefaca-11f3-495f-9667-634a9e058950)

A shader applied to any object to make it look as it has been painted. The shader only uses a "paint texture", a grayscale texture used for the brush strokes effect, and a gradient texture, used to change the paint color based on lighting.
The project also features custom post processing effects, making the screen looks like a painting canvas, although the paint effect can be used only on object separately, without any post processing effect.

One of the benefits of this implementation is that the shader can use triplanar projection for the paint effect, meaning UV unwrapping is not needed for the meshes (which can be useful if using meshes found online, or to gain some time when using custom meshes).

**Note: the meshes used in the project are free resources I found online! They're not meant to be perfect or reusable, but are only here to show actual implementations of the shader.**

## Breakdown

The shader used is a fragment shader using custom lighting computation; getting the lighting data before actually applying it is a good way to tweak them for the desired painted effect.
In order, here are the steps the shader follows to render an object.

**Standard diffuse material:** as a reference point, here's how the demo object looks like before anything done:

![apple_base](https://github.com/sixrobin/PaintEffectShader/assets/55784799/fd2d6127-7d64-4e1c-840e-3f82a4f13260)

**Lambert lighting:** the most important part of the effect is the lighting calculation, that will be crucial when applying color afterward. A simple Lambert is used, with some control to remap the values, and decrease the shadow intensity (which does not make much sense for a PBR perspective, but is useful here since we want a nice looking painted effect).

![apple_brushstrokes](https://github.com/sixrobin/PaintEffectShader/assets/55784799/e93e50db-326f-4e6a-adb0-ea0966e6a645)

**Specular:** a specular highlight can be added if needed, depending on the object.

![apple_specular](https://github.com/sixrobin/PaintEffectShader/assets/55784799/0a6e0f9a-d6c5-4ac1-a476-46e0a8079952)

**Fresnel:** a Fresnel effect can be added if needed, depending on the object. On an apple, it may seem quite strange, but at least the effect is very readable.

![apple_fresnel](https://github.com/sixrobin/PaintEffectShader/assets/55784799/5f08bec1-ad28-48be-9c03-712145b795b1)

Brought together, all of the effects detailed above give this result:

![apple_effectsmerge](https://github.com/sixrobin/PaintEffectShader/assets/55784799/c267669b-c5fd-45bb-a3f8-d962f34bc7bf)

**Gradient map:** using the lighting data, a color gradient is applied across the object. Note that the gradient is applied to all of the mesh, meaning that if some parts of it should use a different gradient, than they should be split into separate meshes. Here, the apple's tail should not use the same color as the apple itself (this is fine for the demo purpose, and also to show a restriction of the shader).

![apple_color](https://github.com/sixrobin/PaintEffectShader/assets/55784799/1173f33d-45c0-43a9-b3de-91184d6cb1d8)

**Ambient color:** ambient color of the scene is applied to the darker parts of the object, tinting the shadows.

![apple_ambient](https://github.com/sixrobin/PaintEffectShader/assets/55784799/790c586d-6c1d-4052-a2be-9342e487564f)

**Light color:** the light color is applied to the brighter parts of the objects, tinting the parts that are exposed to light, and leaving the shadows unchanged.

![apple_light](https://github.com/sixrobin/PaintEffectShader/assets/55784799/a21d4893-b71b-4f0d-a192-d1222913ba38)

The effect is now done, although the cast shadow still looks bad. To fix this, the ground needs to also use a painted material.

![apple_ground](https://github.com/sixrobin/PaintEffectShader/assets/55784799/7aacad1a-f1a8-4f47-ba10-2cc8f9224b1a)

## Post processing

Some custom post processing effects are implemented, to enhance the overall painted effect.

**Base image:** consider this image as the base rendered image.

![pp_01](https://github.com/sixrobin/PaintEffectShader/assets/55784799/c6d2534f-09e3-4962-9e18-70b370facdc7)

**Distortion:** using a noise texture, the screen can be distorted to mimic the flaws of brush strokes. Ideally, a Kuwahara filter could be implemented, but I didn't take the time to look at it (may be something to do in the future).

![pp_02](https://github.com/sixrobin/PaintEffectShader/assets/55784799/02ada3d9-e655-4c2a-8fba-2b8302936d6d)

**Sobel outline:** an outline filter can be added, to add some sort of drawn lines. May not look good with any scene, but still a nice addition to experiment with if needed.

![pp_03](https://github.com/sixrobin/PaintEffectShader/assets/55784799/6abc3618-2ba9-4c31-ac81-f6bcd8511cb5)

**Canvas texture:** the most important effect, applying a painting canvas texture with a custom mask on the screen borders. The mask has been hand drawn and is not driven by material parameters, it's a simple grayscale texture.

![pp_04](https://github.com/sixrobin/PaintEffectShader/assets/55784799/0bcd67ba-ef1f-42bb-8c7d-2a8739d93779)

## Demo screenshots

![painteffect_03](https://github.com/sixrobin/PaintEffectShader/assets/55784799/eda80eae-acc7-44ba-914c-0f1ce218919f)
![painteffect_02](https://github.com/sixrobin/PaintEffectShader/assets/55784799/4868817d-693a-40d5-8125-eae2c2fdaa05)
![painteffect_01](https://github.com/sixrobin/PaintEffectShader/assets/55784799/e6e8cc9f-2ce8-4012-a4f9-a052376df4de)
![painteffect_04](https://github.com/sixrobin/PaintEffectShader/assets/55784799/e9e77877-1683-4add-8dc2-eca58cab87c6)


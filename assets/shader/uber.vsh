#ifdef GL_ES
precision highp float;
#else
#define highp 
#define mediump 
#define lowp 
#endif

attribute vec4 a_pos;
attribute vec2 a_uv0;
attribute vec3 a_normal;

#ifdef SUPPORTED_GL_OES_30
attribute mat4 a_model;
#else
uniform mat4 u_model;
#define a_model u_model
#endif

#ifdef NORMAL
attribute vec3 a_tangent;
attribute vec3 a_binormal;
#endif

uniform mat4 u_projectionView;
uniform mat4 u_view;

varying vec2 v_texCoord0;
#ifdef LIGHTMAP
varying vec2 v_texCoordLightmap;
#endif

#ifdef STENCIL
uniform vec4 u_stencilScaleOffset;
varying vec2 v_texCoordStencil;
#endif

varying highp vec3 v_normal;

#ifdef NORMAL
varying highp vec3 v_tangent;
varying highp vec3 v_binormal;
#endif

void main(void)
{
	v_texCoord0 = a_uv0;
	v_normal = normalize(vec3(u_view * (a_model * vec4(a_normal, 0.0))));
#ifdef NORMAL
	v_tangent = normalize(vec3(u_view * (a_model * vec4(a_tangent, 0.0))));
	v_binormal = normalize(vec3(u_view * (a_model * vec4(a_binormal, 0.0))));
#endif
	
#ifdef LIGHTMAP
	v_texCoordLightmap = v_normal.xy * vec2(0.5, -0.5) + vec2(0.5, 0.5);
#endif

#ifdef STENCIL
	v_texCoordStencil = a_uv0 * u_stencilScaleOffset.xy + u_stencilScaleOffset.zw;
#endif

	gl_Position = u_projectionView * a_model * a_pos;
}

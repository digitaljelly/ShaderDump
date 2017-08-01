// A sprite for 2D shadow effects 
// To support stencils, comment out the Stencil block and use the SpriteMask shader on objects that make this shader's material visible

Shader "Sprites/Shadow"
{
	Properties
	{
		_MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_Distance("Blur Distance", Float) = 0.015
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True" // If you find the blur effect is appearing on other objects you don't expect, set this to False
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog{ Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha 
		
		Pass
		{
			/*Stencil{
				Ref 2
				Comp equal
				Pass replace
			}*/

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile DUMMY PIXELSNAP_ON
			#include "UnityCG.cginc"

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color : COLOR;
				half2 texcoord  : TEXCOORD0;
			};

			fixed4 _Color;
			float _Distance;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap(OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed4 computedColor = tex2D(_MainTex, IN.texcoord) * IN.color;
				
				// Very basic gaussian blur
				float distance = _Distance;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x + distance , IN.texcoord.y + distance)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x + distance , IN.texcoord.y)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x , IN.texcoord.y + distance)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x - distance , IN.texcoord.y - distance)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x + distance , IN.texcoord.y - distance)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x - distance , IN.texcoord.y + distance)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x - distance , IN.texcoord.y)) * IN.color;
				computedColor += tex2D(_MainTex, half2(IN.texcoord.x , IN.texcoord.y - distance)) * IN.color;
				computedColor = computedColor / 9;
				
				// Set the RGB values to be the tint values ONLY, shadows are monochrome last time I look at mine
				computedColor.rgb = IN.color.rgb;
				return computedColor;
			}
			ENDCG
		}
	}
}

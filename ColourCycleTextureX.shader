Shader "Unlit/ColourCycleTextureX"
{
	Properties
	{
		_MainTex("Color (RGB) Alpha (A)", 2D) = "white" {}
		_WaveSpeed ("WaveSpeed", Range(-1000, 1000)) = 20
		_Frequency ("Frequency", Range(0, 100)) = 10
		_Amplitude ("Amplitude", Range(0, 3)) = 0.02
		_RedScale("Red Scale", Range(0, 3)) = 1
		_GreenScale("Green Scale", Range(0, 3)) = 1
		_BlueScale("Blue Scale", Range(0, 3)) = 1
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Frequency;
			fixed _WaveSpeed;
			fixed _Amplitude;
			fixed _RedScale;
			fixed _GreenScale;
			fixed _BlueScale;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 uvs = i.uv;
				fixed4 col = tex2D(_MainTex, uvs);
				fixed d = sin(uvs.x * _Frequency + _Time * _WaveSpeed) * _Amplitude;
				col.r += d * _RedScale;
				col.g += d * _GreenScale;
				col.b += d * _BlueScale;
				return col;
			}
			ENDCG
		}
	}
}

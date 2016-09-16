Shader "Unlit/WaveTransTexture"
{
	Properties
	{
		_MainTex("Color (RGB) Alpha (A)", 2D) = "white" {}
		_WaveSpeedX ("X Axis WaveSpeed", Range(0, 100)) = 10
		_FrequencyX ("X Axis Frequency", Range(0, 100)) = 10
		_AmplitudeX ("X Axis Amplitude", Range(0, 100)) = 0.02
		_WaveSpeedY ("Y Axis WaveSpeed", Range(0, 100)) = 10
		_FrequencyY ("Y Axis Frequency", Range(0, 100)) = 10
		_AmplitudeY ("Y Axis Amplitude", Range(0, 100)) = 0.02
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
			fixed _FrequencyX;
			fixed _AmplitudeX;
			fixed _WaveSpeedX;
			fixed _FrequencyY;
			fixed _AmplitudeY;
			fixed _WaveSpeedY;

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
				uvs.x += sin(uvs.y * _FrequencyX + _Time * _WaveSpeedX) * _AmplitudeX;
				uvs.x = (uvs.x * 0.9) + 0.05;
				uvs.y += cos(uvs.x * _FrequencyY + _Time * _WaveSpeedY) * _AmplitudeY;
				uvs.y = (uvs.y * 0.9) + 0.05;
				fixed4 col = tex2D(_MainTex, uvs);
				return col;
			}
			ENDCG
		}
	}
}

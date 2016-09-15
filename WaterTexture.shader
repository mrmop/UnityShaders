Shader "Unlit/WaterTexture"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScrollX ("X Scroll Speed", Range(-10, 10)) = 0
		_WaveSpeed("WaveSpeed", Range(0, 100)) = 10
		_FrequencyX("X Axis Frequency", Range(0, 100)) = 34
		_AmplitudeX("X Axis Amplitude", Range(0, 100)) = 0.005
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
			fixed _ScrollX;
			fixed _FrequencyX;
			fixed _AmplitudeX;
			fixed _WaveSpeed;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed time = _Time * _WaveSpeed;
				fixed2 uvs = i.uv;
				fixed offset = (_ScrollX * _Time);
				uvs.x += offset;
				uvs.x = fmod(uvs.x, 1);
				uvs.x += sin(uvs.y * _FrequencyX + time) * _AmplitudeX;
				fixed2 uvs2 = i.uv;
				uvs2.x -= offset;
				uvs2.x = fmod(uvs2.x, 1);
				if (uvs2.x < 0)
					uvs2.x += 1;
				uvs2.y = 1 - i.uv.y;
				uvs2.x += sin(uvs2.y * _FrequencyX + time) * _AmplitudeX;
				fixed4 col = tex2D(_MainTex, uvs);
				fixed4 col2 = tex2D(_MainTex, uvs2);
				col = (col + col2) / 2;
				return col;
			}

			ENDCG
		}
	}
}

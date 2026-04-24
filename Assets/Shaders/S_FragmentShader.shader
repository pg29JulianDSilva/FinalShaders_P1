Shader "Unlit/S_FragmentShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _DissolveAmount ("Dissolve Amount", Range(0,1)) = 0.0
        _EdgeEmission ("Edge Emission", Range(0.5, 5)) = 2.0
        _EdgeWidth ("Edge Width", Range(0, 0.2)) = 0.05

        [Header(Color layers)]
        _EdgeColor1 ("Edge Color 1", Color) = (1, 0.4, 0, 1)
        _EdgeColor2 ("Edge Color 2", Color) = (4.5, 3.2, 8.1, 1)
        _EdgeColor3 ("Edge Color 3", Color) = (3.7, 0.4, 0, 1)

        [Header(Time Management)]
        _Speed1 ("Speed 1", Range(0.0, 100.0)) = 1.0
        _Speed2 ("Speed 2", Range(0.0, 100.0)) = 1.0
        _Speed3 ("Speed 3", Range(0.0, 100.0)) = 1.0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull off //this removes the culling, leting us see thought

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
                float2 uvNoise : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            float _DissolveAmount;

            float _EdgeWidth;
            float _EdgeEmission;
            float4 _EdgeColor1;
            float _Speed1;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvNoise = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float noiseVal = tex2D(_NoiseTex, i.uvNoise).r * _Time.x;

                //overlapped the fragments, which it will decide which vertex will have which type of fragments
                float dissolveThreshold = ((noiseVal - _DissolveAmount) * (1.0 + _EdgeWidth)) + _EdgeWidth;
                //for the edge
                float edgeFactor = 1.0 - smoothstep(0.0, _EdgeWidth, dissolveThreshold * 2);
                float4 edgeColor = _EdgeColor1 * cos(_DissolveAmount * _Time.y * _Speed1);
                clip(dissolveThreshold);
                float4 finalColor = lerp(col, edgeColor, edgeFactor);

                return finalColor;
            }
            ENDCG
        }

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
                float2 uvNoise : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            float _DissolveAmount;

            float _EdgeWidth;
            float _EdgeEmission;
            float4 _EdgeColor2;
            float _Speed2;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvNoise = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float noiseVal = tex2D(_NoiseTex, i.uvNoise).r;

                //overlapped the fragments, which it will decide which vertex will have which type of fragments
                float dissolveThreshold = (((noiseVal - _DissolveAmount) * (1.0 + _EdgeWidth)) + _EdgeWidth) * -1;
                //for the edge
                float edgeFactor = 1.0 - smoothstep(0.10, _EdgeWidth, dissolveThreshold);
                float4 edgeColor = _EdgeColor2 * cos(_DissolveAmount * _Time.y * _Speed2 * 2);
                clip(dissolveThreshold / 2);
                float4 finalColor = lerp(col, edgeColor, edgeFactor);

                return finalColor;
            }
            ENDCG
        }

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
                float2 uvNoise : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            float _DissolveAmount;

            float _EdgeWidth;
            float _EdgeEmission;
            float4 _EdgeColor3;
            float _Speed3;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvNoise = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float noiseVal = tex2D(_NoiseTex, i.uvNoise).r;

                //overlapped the fragments, which it will decide which vertex will have which type of fragments
                float dissolveThreshold = ((noiseVal - _DissolveAmount) * (1.0 + _EdgeWidth)) + _EdgeWidth;
                //for the edge
                float edgeFactor = 1.0 - smoothstep(0.20, _EdgeWidth, dissolveThreshold);
                float4 edgeColor = _EdgeColor3 * cos(_DissolveAmount * _Time.y * _Speed3);
                float4 finalColor = lerp(col, edgeColor, edgeFactor);

                return finalColor;
            }
            ENDCG
        }
    }
}

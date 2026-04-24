Shader "Unlit/S_VertexShader"
{
    Properties
    {

        //So, the commented stuff was the modification for the shader

        [Header(Base Samples)]
        _MainTex ("Texture", 2D) = "white" {}

        //Added to controll the magnitude of the shader
        [Header(Magnitude of the shader)]
        _Period ("Period", Range(0, 1)) = 0.09
        _Scale ("Scale", Range(0, 10)) = 1.0
        _Range ("Range", Range(0, 10)) = 6.5
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //Added the new parameters
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Period;
            float _Scale;
            float _Range;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);

                //Added a value to find the center of the object
                float4 objectOrigin = mul(v.vertex, float4(0,0,0,0));
              
                //This one only works when the object is far away
                if(distance(objectOrigin, o.vertex) >= _Range)
                {
                    //The for changes teh magnitude of teh shader
                    for(int x = 0; x < _Scale; x++)
                    {
                        //Here the vertex in relation of the distance of the camera and the object, perfect for First person games. 
                        o.vertex.y = o.vertex.y * distance(objectOrigin, o.vertex) * _Period;
                    }
                }

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}

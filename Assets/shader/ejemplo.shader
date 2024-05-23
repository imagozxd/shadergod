Shader "Custom/MyShaderSurfaceShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _BumpMap("Bumpmap", 2D) = "bump" {}
        _EmissiveTex("Emissive (RGB)", 2D) = "white" {}
        [HDR] _EmissiveColor("Emissive Color", Color) = (1,1,1,1)
        _AO("AO (RGB)", 2D) = "white" {}
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _BumpMap;
            sampler2D _EmissiveTex;
            sampler2D _AO;
            struct Input
            {
                float2 uv_MainTex;
                float2 uv_BumpMap;
                
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            fixed4 _EmissiveColor;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;

                // Normal map
                o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;

                fixed4 ao= tex2D(_AO, IN.uv_MainTex);
                if (length(ao.rgb > 0))
                    o.Albedo *= ao.rgb;
            }
            ENDCG
        }
            FallBack "Diffuse"
}

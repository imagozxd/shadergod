Shader "Custom/AdvancedSurfaceShader"
{
    Properties
    {
        _MainTex("Base Color (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _MetallicMap("Metallic Map", 2D) = "black" {}
        _HeightMap("Height Map", 2D) = "black" {}
        _OcclusionMap("Ambient Occlusion Map", 2D) = "white" {}
        _EmissionMap("Emission Map", 2D) = "black" {}
        _EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionStrength("Emission Strength", Range(0, 10)) = 1.0
        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
        _Parallax("Parallax", Range(0.0, 0.1)) = 0.02
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 300

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows

            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _MetallicMap;
            sampler2D _HeightMap;
            sampler2D _OcclusionMap;
            sampler2D _EmissionMap;

            fixed4 _EmissionColor;
            float _EmissionStrength;
            float _Glossiness;
            float _Parallax;

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_NormalMap;
                float2 uv_MetallicMap;
                float2 uv_HeightMap;
                float2 uv_OcclusionMap;
                float2 uv_EmissionMap;
                float3 viewDir;
            };

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Parallax Mapping
                float height = tex2D(_HeightMap, IN.uv_HeightMap).r;
                float2 parallaxOffset = (IN.viewDir.xy / IN.viewDir.z) * (_Parallax * (height - 0.5));
                float2 uv = IN.uv_MainTex + parallaxOffset;

                // Base Albedo
                fixed4 c = tex2D(_MainTex, uv);
                o.Albedo = c.rgb;
                o.Smoothness = _Glossiness;

                // Normal Map
                o.Normal = UnpackNormal(tex2D(_NormalMap, uv));

                // Metallic Map
                fixed4 metallic = tex2D(_MetallicMap, uv);
                o.Metallic = metallic.r;

                // Ambient Occlusion Map
                fixed ao = tex2D(_OcclusionMap, uv).r;
                o.Occlusion = ao;

                // Emission Map
                fixed4 emission = tex2D(_EmissionMap, uv);
                o.Emission = emission.rgb * _EmissionColor.rgb * _EmissionStrength;
            }
            ENDCG
        }
            FallBack "Diffuse"
}

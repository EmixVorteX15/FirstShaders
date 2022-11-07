Shader "Custom/Interferencia"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        
        //Textura secundaria con el ruido que modificará la textura principal
        _NoiseTex("Noise", 2D) = "white" {}
        
        //Cantidad de interferencia entre la textura original y la resultante
        _Noise("NoiseIntensity", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        //Definicion de _NoiseTex como textura 2D
        sampler2D _NoiseTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        //Declaracion del ruido como un tipo half
        half _Noise;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Muestreamos la textura del ruido de la que extraeremos 2 componentes
            fixed4 c2 = tex2D(_NoiseTex, IN.uv_NoiseTex);

            //Vector de half con 2 componentes (red y green) modificadas por _Noise y el valor absoluto del seno de _Time para tener un resultado entre 0 y 1
            half2 uv = c2.rg * _Noise * abs(sin(_Time)) * 0.1 ;

            //Aplicamos a c la textura con la modificación del vector uv
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex + uv) * _Color;

            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

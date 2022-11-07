Shader "Custom/Disipacion"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0

            //Añadimos las cuatro propiedades
            _Color2("Color2", Color) = (1,1,1,1)
            _DisolTex("DisolTex (RGB)", 2D) = "white"{}
            _Umbral("Umbral", Range(0,1)) = 0.5
            _Rango("Rango", Range(0,1)) = 0.2

    }
        SubShader
            {
                Tags { "RenderType" = "Opaque" }
                LOD 200

                CGPROGRAM
                // Physically based Standard lighting model, and enable shadows on all light types
                #pragma surface surf Standard fullforwardshadows addshadow

                // Use shader model 3.0 target, to get nicer looking lighting
                #pragma target 3.0

                sampler2D _MainTex;
            //Incluimos las propiedades en el código HLSL
            sampler2D _DisolTex;

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_DisolTex;			//Añadimos la variable de las coordenadas de textura de disolución a Input
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;

            fixed4 _Color2;
            half _Umbral;
            half _Rango;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                fixed4 c2 = tex2D(_DisolTex, IN.uv_DisolTex);

                //Leemos el valor de la componente r de la textura de disolución
                float v = tex2D(_DisolTex, IN.uv_DisolTex).r;

                //Si el valor de la textura de disolución es menor que el umbral se elimina
                if (v < _Umbral)
                    clip(v - _Umbral);
                //Si el valor de textura es mayor que el umbral y menor que el umbral más el rango
                else if (v < (_Umbral + _Rango))
                {
                    _Color2.r = (1 - (_Umbral + _Rango - v) / _Rango);      //Modificamos el valor de la componente r del color para que dé la sesación de degradado. De que se quema
                    o.Albedo = _Color2.rgb;
                }
                //Si el valor de textura es mayor que el umbral aplicamos el valor de albedo por defecto 
                else
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

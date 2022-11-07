Shader "Custom/Inflacion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        
        //Variable que modifica la altura a la que se encuentra la franja     
        _Altura("Altura", Range(-0.5,0.5)) = 0.0        //La altura en el centro de la figura será 0.0  
        
        //Variable que modifica la anchura de la franja
        _Anchura("Anchura", Range(0,1)) = 0.0
        
        //Variable que indica el inflado máximo de la franja
        _Inflado("Inflado", Range(0,1)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows  vertex:vert addshadow
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Altura;
        float _Anchura;
        float _Inflado;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        
            void vert(inout appdata_full v) {

            if (v.vertex.y < (_Altura + _Anchura /2) && v.vertex.y > (_Altura - _Anchura / 2 ))                         //Asegura que modifica solo los vértices dentro de la franja establecida
            { 
                if (_Altura < 0.0f) {
                    v.vertex.xz = v.vertex.xz * _Inflado * smoothstep(_Altura + _Anchura / 2, _Altura, v.vertex.y);    //Utilizamos la función smoothstep que dotan a la figura de más fluidez
                }                  
                if (_Altura > 0.0f) {
                    v.vertex.xz = v.vertex.xz * _Inflado * smoothstep(_Altura - _Anchura / 2, _Altura, v.vertex.y);    //Utilizamos la función smoothstep que dotan a la figura de más fluidez
                }      
                else 
                    v.vertex.xz = v.vertex.xz * _Inflado * smoothstep(0,1,v.vertex.y);    //Utilizamos la función smoothstep que dotan a la figura de más fluidez

            }                
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
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

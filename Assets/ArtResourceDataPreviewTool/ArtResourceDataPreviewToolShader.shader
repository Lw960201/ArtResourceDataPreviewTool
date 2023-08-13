/*
功能：预览贴图和顶点色通道Mask
开发者：秘密基地工作室(SecretBaseStudio)-6君
*/
Shader "SecretBaseStudio/ArtResourceDataPreviewShader"
{
    Properties
    {
        _MainTex ("贴图", 2D) = "white" {}
         //贴图通道
        [Toggle(_TEX_SHOW_R)]_TexShowR("预览贴图的R通道", float) = 0
        [Toggle(_TEX_SHOW_G)]_TexShowG("预览贴图的G通道", float) = 0
        [Toggle(_TEX_SHOW_B)]_TexShowB("预览贴图的B通道", float) = 0
        [Toggle(_TEX_SHOW_A)]_TexShowA("预览贴图的A通道", float) = 0
        //顶点色通道
        [Toggle(_VERTEX_COLOR_SHOW_R)]_VertexColorShow_R("预览顶点色的R通道", float) = 0
        [Toggle(_VERTEX_COLOR_SHOW_G)]_VertexColorShow_G("预览顶点色的G通道", float) = 0
        [Toggle(_VERTEX_COLOR_SHOW_B)]_VertexColorShow_B("预览顶点色的B通道", float) = 0
        [Toggle(_VERTEX_COLOR_SHOW_A)]_VertexColorShow_A("预览顶点色的A通道", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" "RenderPipeline"="UniversalPipeline"}
        LOD 100

        Pass
        {
            Tags { "LightMode"="UniversalForward" }
            
            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            //贴图通道
            #pragma shader_feature _TEX_SHOW_R
            #pragma shader_feature _TEX_SHOW_G
            #pragma shader_feature _TEX_SHOW_B
            #pragma shader_feature _TEX_SHOW_A
            //顶点色通道
            #pragma shader_feature _VERTEX_COLOR_SHOW_R
            #pragma shader_feature _VERTEX_COLOR_SHOW_G
            #pragma shader_feature _VERTEX_COLOR_SHOW_B
            #pragma shader_feature _VERTEX_COLOR_SHOW_A

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                half4 vertexColor : COLOR;
                half2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
                half4 vertexColor : TEXCOORD1;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.vertexColor = v.vertexColor;
                o.uv = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                half4 vertexColor = i.vertexColor;
                //预览开关======================================================
                //查看贴图不同通道存的Mask
                #ifdef  _TEX_SHOW_R//颜色贴图通道
                    return half4(col.rrr,1);
                #elif _TEX_SHOW_G
                    return half4(col.ggg,1);
                #elif _TEX_SHOW_B
                    return half4(col.bbb,1);
                #elif _TEX_SHOW_A
                    return half4(col.aaa,1);
                #elif _VERTEX_COLOR_SHOW_R//顶点色通道
                    return half4(vertexColor.rrr,1);
                #elif _VERTEX_COLOR_SHOW_G
                    return half4(vertexColor.ggg,1);
                #elif _VERTEX_COLOR_SHOW_B
                    return half4(vertexColor.bbb,1);
                #elif _VERTEX_COLOR_SHOW_A
                    return half4(vertexColor.aaa,1);
                #endif
                
                return col;
            }
            ENDHLSL
        }
    }
}

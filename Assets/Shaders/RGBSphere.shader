Shader "Mine/RGBSphere"
{
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 wPos : TEXCOORD0; //world position
                float4 pos : SV_POSITION;
            };

            float3 _CrossSectionPoint;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            #define STEPS 128
            #define STEP_SIZE 0.01
            #define PI 3.141592

            //we only draw a part of sphere
            bool SphereHit(float3 position, float3 center, float radius) 
            {
                return distance(position, center) < radius;
            }

			float ScaleMaxValue()
			{
				float3 worldScale = float3(
					length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)), // scale x axis
					length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)), // scale y axis
					length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))  // scale z axis
					);

				float maxScale = max(worldScale.x, worldScale.y);
				return max(maxScale, worldScale.z);
			}

            float angleBetween(float3 vector_one, float3 vector_two) 
            {
                return acos(dot(vector_one, vector_two) / (length(vector_one) * length(vector_two)));
            }

            float GetGreen(float3 position, float3 center)
            {
                float3 direction = position - center;
                direction.y = 0;
                float3 compareVector = float3(0, direction.y, 1);

                float angle = angleBetween(direction, compareVector) / PI;
                if (direction.x < 0) angle = -angle;

                return lerp(0, 1, (angle + 1) / 2);
            }

            float GetBlue(float3 position, float3 center)
            {
                float3 direction = position - center;
                float3 compareVector = float3(direction.x, 0, direction.z);

                float angle = angleBetween(direction, compareVector) / PI;
                if (direction.y < 0) angle = -angle;

                return lerp(0, 1, angle + 0.5);
            }

            float4 RaymarchHit(float3 position, float3 direction)
            {
				float4 objectOrigin = mul(unity_ObjectToWorld, float4(0.0, 0.0, 0.0, 1.0));
				int steps = ScaleMaxValue() * STEPS;
				float radius = ScaleMaxValue() * 0.5f;

                for (int i = 0; i < steps; i++)
                {
                    if (SphereHit(position, objectOrigin.xyz, radius)) 
                    {
                        bool sphere = distance(position, _CrossSectionPoint) > distance(objectOrigin.xyz, _CrossSectionPoint);
                        bool crossSection = abs(distance(position, _CrossSectionPoint) - distance(objectOrigin.xyz, _CrossSectionPoint)) < 2 * STEP_SIZE;

                        if (sphere)
                        {
                            float red = 1;
                            float green = GetGreen(position, objectOrigin.xyz);
                            float blue = GetBlue(position, objectOrigin.xyz);
                            return float4(red, green, blue, 1);
                        }
                        else if (crossSection)
                        {
                            float red = lerp(0, 1, distance(position, objectOrigin.xyz) / radius);
                            float green = GetGreen(position, objectOrigin.xyz);
                            float blue = GetBlue(position, objectOrigin.xyz);
                            return float4(red, green, blue, 1);
                        }
                    }
                    position += direction * STEP_SIZE;
                }

                return float4(0,0,0,0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float3 worldPosition = i.wPos;
				float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
				float4 depthValue = RaymarchHit(worldPosition, viewDirection);
				
				if (length(depthValue) != 0) return depthValue;
				else return fixed4(0, 0, 0, 0);
            }
            ENDCG
        }
    }
}
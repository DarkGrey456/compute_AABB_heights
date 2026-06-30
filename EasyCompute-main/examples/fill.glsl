#[compute]
#version 450

layout(set = 0, binding = 0, rgba8) uniform image2D sourceImage;
layout(set = 0, binding = 2, rgba8) uniform image2D colorImage;
layout(local_size_x = 4, local_size_y = 4, local_size_z = 1) in;

shared float sdata[16];




void main() {

	ivec2 UV = gl_GlobalInvocationID.xy + gl_LocalInvocationID.xy; 
	
	ivec2 UV_out = ivec2( UV.x / 4, UV.y / 4);
	int local_index = gl_LocalInvocationID.x + gl_LocalInvocationID.y * 4; 
	sdata[local_index] =  imageLoad(sourceImage, UV, ivec2(0, 0), ivec2(511, 511) )).r;
	
	memoryBarrierShared();
	barrier();
	
	float min =10000.0;
	float max = -10000.0;
	for(int i = 0; i<16; i++){
		
		if( sdata[i] > max ){
			max = sdata[i];
		} 
		if( sdata[i] < min ){
			min = sdata[i];
		}
		
	}
	
	//ivec2 storePos = ivec2(gl_LocalInvocationID.x, gl_WorkGroupID.x);
	
	imageStore(colorImage, UV_out, fillColor);
}

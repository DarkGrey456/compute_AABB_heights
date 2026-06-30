extends Node

var compute: EasyCompute = EasyCompute.new()

func _ready() -> void:
	
	texture_fill2()
	
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
	
@onready var sprite_2d: Sprite2D = $Sprite2D



## Fill a texture with a the specified color
func texture_fill():
	compute.load_shader("fill", "res://examples/fill2.glsl")
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN	
	noise.frequency = 0.02
	#var image = noise.get_image(512,512,false,false,true)#   create(64, 64, false, Image.FORMAT_RGBA8)

	var tex :CompressedTexture2D= load("res://examples/height2.exr")
	#if image.is_compressed():
		#image.decompress()	
	var image = tex.get_image()
	image.convert(Image.FORMAT_R16)
	var texture = ImageTexture.create_from_image(image)
	var source_size = 4096
	compute.register_texture("height_image", 0, source_size, source_size, image.get_data(), RenderingDevice.DATA_FORMAT_R16_UNORM)

	#var output_image = Image.create(32, 32, false, Image.FORMAT_RGBA16)
	
	compute.register_texture("data_output_image", 1, 512, 512,[], RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT)
	
	#var fill_color = PackedFloat32Array()#([1.0, 0.0, 0.0, 1.0]) # RGBA
	#fill_color.resize(16)
	#compute.register_storage_buffer("fill_color", 1, 0, fill_color.to_byte_array())

	compute.execute("fill", 512,512)
	compute.sync()

	var image_data = compute.fetch_texture("data_output_image")
	var float_data = image_data.to_vector4_array()
	
	var index = 16 + 16*32
	#print(float_data[index])
	for i in float_data.size():
		
		print(float_data[i].x)
		print(float_data[i].y)
			#print(output_image.get_pixel(i,j).g)
	var output_image = Image.create_from_data(512, 512, false, Image.FORMAT_RGBAF, image_data)
	var texture2 = ImageTexture.create_from_image(output_image)

	texture2.update(output_image)
	sprite_2d.texture = texture2
	
	sprite_2d_2.texture = texture
	
## Fill a texture with a the specified color
func texture_fill2():
	compute.load_shader("fill", "res://examples/fill2.glsl")
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN	
	noise.frequency = 0.02
	#var image = noise.get_image(512,512,false,false,true)#   create(64, 64, false, Image.FORMAT_RGBA8)

	var tex :CompressedTexture2D= load("res://examples/height2.exr")
	#if image.is_compressed():
		#image.decompress()	
	var image = tex.get_image()
	image.convert(Image.FORMAT_R16)
	var texture = ImageTexture.create_from_image(image)
	var source_size = 4096
	compute.register_texture("height_image", 0, source_size, source_size, image.get_data(), RenderingDevice.DATA_FORMAT_R16_UNORM)

	#var output_image = Image.create(32, 32, false, Image.FORMAT_RGBA16)
	
	compute.register_texture("data_output_image", 1, 512, 512,[], RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT)
	
	#var fill_color = PackedFloat32Array()#([1.0, 0.0, 0.0, 1.0]) # RGBA
	#fill_color.resize(16)
	#compute.register_storage_buffer("fill_color", 1, 0, fill_color.to_byte_array())

	compute.execute("fill", 512,512)
	compute.sync()

	var image_data = compute.fetch_texture("data_output_image")
	#print(image_data.to_vector4_array())
	compute.load_shader("fill_min_max", "res://examples/fill_min_max2.glsl")
	compute.register_texture("height_image", 0, 512, 512, image_data, RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT)
	compute.register_texture("data_output_image", 0, 64, 64, [], RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT)
	compute.execute("fill_min_max", 64,64)
	compute.sync()
	var final_image_data = compute.fetch_texture("data_output_image")
	var float_data = final_image_data.to_vector4_array()
	
	var index1 = 32 + 32*64
	var index2 = 33 + 32*64
	var index3 = 32 + 33*64
	var index4 = 33 + 33*64
	
	var max:float = 0.0
	var min:float = 10000.0
	if float_data[index1].x < min:
		min =float_data[index1].x 
	if float_data[index2].x < min:
		min =float_data[index2].x		
	if float_data[index3].x < min:
		min =float_data[index3].x 
	if float_data[index4].x < min:
		min =float_data[index4].x		
	#print(float_data[index])
	if float_data[index1].y > max:
		max =float_data[index1].y 
	if float_data[index2].y > max:
		max =float_data[index2].y		
	if float_data[index3].y > max:
		max =float_data[index3].y 
	if float_data[index4].y > max:
		max =float_data[index4].y
		
	print(min)
	print(max)	
	
	var output_image = Image.create_from_data(64, 64, false, Image.FORMAT_RGBAF, final_image_data)
	var texture2 = ImageTexture.create_from_image(output_image)
 	
	#texture2.update(output_image)
	sprite_2d.texture = texture2
	
	sprite_2d_2.texture = texture
	
func usage_showcase():
	# Load shader from file with the specified path and store it with the specified name
	compute.load_shader("example", "res://examples/fill.glsl")

	# Register a storage buffer
	var arr = PackedFloat32Array([1.0, 2.0, 3.0, 4.0])
	compute.register_storage_buffer(
		"example_storage",	# Name: used to identify the buffer later
		0, 					# Binding: this is the binding point in the shader
		0, 					# Size: since we're passing the data, we don't need to specify the size
		arr.to_byte_array()
	)

	# Register a uniform buffer with size 32 (4 32-bit floats) and no data
	compute.register_uniform_buffer("example_uniform", 1, 32)

	# Register a texture
	var image = Image.create(512, 512, false, Image.FORMAT_RGBA8)
	compute.register_texture("example_texture", 2, 512, 512, image.get_data(), RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM)

	# Check if the compute shader is available
	if not compute.is_available():
		return

	# Execute the compute shader (1 work group in each direction) and wait for it to finish
	compute.execute("example", 1, 1, 1)
	compute.sync()

	# Retrieve the texture data
	var _texture_data = compute.fetch_texture("example_texture")
	# do something with the texture data

	# Update the storage buffer
	arr[0] = 5.0
	compute.update_buffer("example_storage", arr.to_byte_array())

	# Unregister the uniform buffer
	compute.unregister_buffer("example_uniform")

	# Register the uniform buffer again, but with half the size
	compute.register_uniform_buffer("example_uniform", 1, 16, [])
	
	# Set the uniform buffer data (size 16 means 2 32-bit floats)
	var uniform_data = PackedFloat32Array([1.0, 2.0])
	compute.update_buffer("example_uniform", uniform_data.to_byte_array())

	# Execute the compute shader again (1 work group in each direction) and wait for it to finish
	compute.execute("example", 1, 1, 1)
	compute.sync()
	
	var image2 = Image.create_from_data(512, 512, false, Image.FORMAT_RGBA8, _texture_data)
	var texture = ImageTexture.create_from_image(image2)
	#texture.update(image2)
	sprite_2d.texture = texture

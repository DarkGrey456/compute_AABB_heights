<img width="1159" height="652" alt="Screenshot 2026-07-02 120616" src="https://github.com/user-attachments/assets/89238d13-1099-4660-b36f-a44f35b09ff8" />

This project is a component project for the heightmap projects, usable with either chunked lod or similar (DACLOD) and can be used to compute
AABB's for the terrain tiles and obviously occlusion shapes too.

The project just demonstrates launching a compute shader kernel on the terrain heightmap and finding the min and max heights using a downscaling reduce shader.

Thats the output viewed in 3D.
To load the scene you just open Node3D.tscn. That is the only working version.

There is no display of sprites - the file example.gd has a function fill2 that loads corrupt versions of the byte code.


MIT Licsence ...


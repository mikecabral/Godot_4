## Introduction

Basic Blood Painting Technique in 3D for Godot 4.3...

I don't see any tutorials on how to do this online for 3D.. so it took me a little while to figure out.

### How to Use

1. Set an **Autoload** under **Globals** for **surface.tscn** and **enable** it.

2. Make sure you place surface.tscn in your level.tscn as a child of the ROOT node.

3. Set **MASKS** for what you want to get painted in **surface.tscn** and **blood_particle.tscn**

4. Adjust other variables in the inspector as necessary.. such as decal size, collision sizes, ect
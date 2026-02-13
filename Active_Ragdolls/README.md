## Introduction

## Active Ragdolls in 3D for Godot 4.5

I don't see any tutorials on how to do this online for 3D.. so it took me a little while to figure out.

### How to Use

1. Remember to get a working ragdoll that just drops in place properly going FIRST...

2. The collision layers are important...
CharacterBody3D is on Layer3 (Enemy) and Mask is Layer1

The Physics Skeleton's bones are on Layer3 and Mask is Layer 1 and Layer 3
(Layer1 for our collisionshape so we don't fall through the floor)
(Layer 3 for the bones to collide with eachother, otherwise you get a deflating effect)

3. **Animated Skeleton3D** and **Interpolated Skeleton3D** should have **"Animate Physical Bones OFF"**

The Skeleton3D for the **Physics (RAGDOLL)** should be the only one with **"Animate Physical Bones ON."**


4. **USE THE PhysicalBoneSimulator3D!!**

![Alt text](https://github.com/mikecabral/Godot_4/blob/main/Active_Ragdolls/thumbnail.gif)

5. When **full_ragdoll_mode** is enabled the **interpolated mesh** gets **hidden** and **shows** the **physics mesh.** (that's the only way i figured out how to do it).
Bones twisting was insane because of constraints to make the realistic ragdoll.

![Alt text](https://github.com/mikecabral/Godot_4/blob/main/Active_Ragdolls/thumbnail2.gif)

.nds

.open "header.bin", 0x0

.org 0x1FC
.dw 1 ;Set ROM Patch Version to 1 for sm64dse Compatibility

.close

.open "arm9_header.bin", 0x2004000

.org 0x2004854
nop ;Skip ARM9 Binary Decompression

.org 0x2004AF4  ;R4 Flashcart Fix from sm64dse Source Code
.dw 0
.dw 0

.close

.open "arm9_decompressed.bin", 0x2008000

.org 0x2008C30
mov r0, r0, lsl 0Dh ;Camera Move Speed Multiplier Credits

.org 0x2008C48
mov r0, r0, lsl 0Dh ;Camera Rotation Speed Multiplier Credits

.org 0x2009630
moveq r7, 288 ;Speed of Long Hold Cannon Camera View
movne r7, 256 ;Speed of Short Hold Cannon Camera View

.org 0x200E9BC
mov r9, r0, lsl 1h ;Multiply Ending Cutscene Start Timings by 2

.org 0x200E9C8
mov r10, r0, lsl 1h ;Multiply Ending Cutscene End Timings by 2

.org 0x2010BC8
b correctactorgravity ;Fix Simple Actor Gravity

.org 0x2010C18
b correctactorgravitytrig ;Fix Actor Gravity

.org 0x2010CB0
b correctactorspeed ;Fix Speed of Actors

.org 0x201C7FC
mov r0, 20h ;Halve Flicker Rate of Text Arrow

.org 0x202C490
mov r7, 1 ;Framerate is 60fps

.org 0x203C07C
b correctpathfollowspeed ;Correct Actor Path Following Speed

.org 0x2090B9C ;Freespace in ARM9
correctactorspeed:
bl 0x20525D4 ;Call AddVec3
ldr r1, [r5, 0A4h] ;Get X Speed of Actor
ldr r0, [r5, 05Ch] ;Get X Position of Actor
mov r1, r1, asr 1h ;Halve X Speed of Actor
sub r0, r0, r1 ;Remove Half of Actor X Speed from Position
str r0, [r5, 05Ch] ;Store Updated X Position of Actor
ldr r1, [r5, 0A8h] ;Get Y Speed of Actor
ldr r0, [r5, 060h] ;Get Y Position of Actor
mov r1, r1, asr 1h ;Halve Y Speed of Actor
sub r0, r0, r1 ;Remove Half of Actor Y Speed from Position
str r0, [r5, 060h] ;Store Updated Y Position of Actor
ldr r1, [r5, 0ACh] ;Get Z Speed of Actor
ldr r0, [r5, 064h] ;Get Z Position of Actor
mov r1, r1, asr 1h ;Halve Z Speed of Actor
sub r0, r0, r1 ;Remove Half of Actor Z Speed from Position
str r0, [r5, 064h] ;Store Updated Z Position of Actor
b 0x2010CB4 ;Return to Original Code
correctactorgravitytrig:
ldr r4, [r0, 09Ch] ;Get Actor Gravity
mov r4, r4, asr 1h ;Halve Actor Gravity
b 0x2010C1C ;Return to Original Code
correctactorgravity:
ldr r1, [r0, 09Ch] ;Get Actor Gravity
mov r1, r1, asr 1h ;Halve Actor Gravity
b 0x2010BCC ;Return to Original Code
correctpathfollowspeed:
str r3, [r0, 8h] ;Update Actor Z Path Follow Speed
ldr r3, [r13, 14h] ;Get Caller Address
mov r4, 0x2100000 ;Lower Bound of Valid Path Follow Routine Caller Address
cmp r3, r4 ;Check if Caller Address is Less Than Lower Bound
blt skiphalvepath ;Skip Halving Path Follow Speed if Caller Address is Less Than Lower Bound
ldr r3, [r0, 8h] ;Get Actor X Path Follow Speed
mov r3, r3, asr 1h ;Halve Actor Z Path Follow Speed
str r3, [r0, 8h] ;Update Actor Z Path Follow Speed
ldr r3, [r0] ;Get Actor X Path Follow Speed
mov r3, r3, asr 1h ;Halve Actor X Path Follow Speed
str r3, [r0] ;Update Actor X Path Follow Speed
ldr r3, [r0, 4h] ;Get Actor Y Path Follow Speed
mov r3, r3, asr 1h ;Halve Actor Y Path Follow Speed
str r3, [r0, 4h] ;Update Actor Y Path Follow Speed
skiphalvepath:
b 0x203C080 ;Return to Original Code
carpetspeedfix:
ldr r2, [r1] ;Get Carpet X Speed
mov r2, r2, asr 1h ;Halve Carpet X Speed
str r2, [r1] ;Update Carpet X Speed
ldr r2, [r1, 4h] ;Get Carpet Y Speed
mov r2, r2, asr 1h ;Halve Carpet Y Speed
str r2, [r1, 4h] ;Update Carpet Y Speed
ldr r2, [r1, 8h] ;Get Carpet Z Speed
mov r2, r2, asr 1h ;Halve Carpet Z Speed
str r2, [r1, 8h] ;Update Carpet Z Speed
mov r2, r0 ;Destination Address for Next Position Vector
b 0x20E7A98 ;Return to Original Code
fixwaterresistx:
mov r12, r12, asr 1h ;Halve X Water Resistance
add r5, r14, r12 ;Get Updated X Position After Water Resistance
b 0x20B85CC ;Return to Original Code
fixwaterresistz:
mov r1, r1, asr 1h ;Halve Z Water Resistance
add r0, r3, r1 ;Get Updated Z Position After Water Resistance
b 0x20B85F8 ;Return to Original Code
fixbluecoinswitchtimer:
ldrh r2, [r1, 2Ah] ;Get Blue Coin Switch Timer
mov r2, r2, lsl 1h ;Double Blue Coin Switch Timer
strh r2, [r1, 2Ah] ;Update Blue Coin Switch Timer
b 0x20E94D0 ;Return to Original Code
fixjrbboxzspeed:
mov r5, r5, asr 1h ;Halve Z Speed of Jolly Roger Bay Skull Box
add r2, r2, r5 ;Update Position of Jolly Roger Bay Skull Box
b 0x210A434 ;Return to Original Code
fixwindresistx:
mov r3, r3, asr 1h ;Halve X Wind Resistance
add r2, r4, r3 ;Get Updated X Position After Wind Resistance
b 0x20B803C ;Return to Original Code
fixwindresistz:
mov r1, r1, asr 1h ;Halve Z Wind Resistance
add r0, r4, r1 ;Get Updated Z Position After Wind Resistance
b 0x20B8060 ;Return to Original Code
flamechompsizefix:
ldr r0, [r4, 0Ch] ;Get Frame Number of Flame Chomp Animation for Scale Lookup
mov r0, r0, asr 1h ;Halve the Frame Number of Flame Chomp Animation for Scale Lookup
b 0x2118B90 ;Return to Original Code
fixxfirespeed:
ldr r2, [r4, 98h] ;Get Speed of Fire
mov r2, r2, asr 1h ;Halve Speed of Fire for Updating Y and Z Axis Position
b 0x20F10C8 ;Return to Original Code
fixyzfirespeed:
ldr r1, [r4, 98h] ;Get Speed of Fire
mov r1, r1, asr 1h ;Halve Speed of Fire for Updating Y and Z Axis Position
b 0x20F1104 ;Return to Original Code
dddwhirlpoolfix:
ldr r0, [r13, 20h] ;Get Z Pull for Dire Dire Docks Whirlpool
mov r0, r0, asr 1h ;Halve Z Pull of Dire Dire Docks Whirlpool
str r0, [r13, 20h] ;Update X Pull of Dire Dire Docks Whirlpool
ldr r0, [r13, 1Ch] ;Get Y Pull for Dire Dire Docks Whirlpool
mov r0, r0, asr 1h ;Halve Y Pull of Dire Dire Docks Whirlpool
str r0, [r13, 1Ch] ;Update Y Pull of Dire Dire Docks Whirlpool
ldr r0, [r13, 18h] ;Get X Pull for Dire Dire Docks Whirlpool
mov r0, r0, asr 1h ;Halve X Pull of Dire Dire Docks Whirlpool
b 0x2108F90 ;Return to Original Code
fixttcrandomtreadmill:
strcc r0, [r4, 390h] ;Update Negative Treadmill Speed if Higher Than -4096
ldr r0, [r4, 390h] ;Get Treadmill Speed
mov r0, r0, asr 1h ;Halve Treadmill Speed
str r0, [r4, 390h] ;Update Treadmill Speed
b 0x21118A0 ;Return to Original Code
fixbowseranims:
mov r1, r1, asr 1h ;Halve Bowser Animation Speed
str r1, [r4, 130h] ;Update Bowser Animation Speed
b 0x210D110 ;Return to Original Code
fixbowserspinspeed:
ldrsh r2, [r0, 9Ch] ;Get Bowser Spin Speed
mov r2, r2, asr 1h ;Halve Bowser Spin Speed for Animation Update
b 0x20D289C ;Return to Original Code
fixpenguinracepath:
ldr r0, [r4, 98h] ;Get Race Penguin Speed for Path Following
mov r0, r0, asr 1h ;Halve Race Penguin Path Follow Speed
b 0x21084AC ;Return to Original Code
fixgrandstarflypath:
ldrsh r1, [r3] ;Grab Current Fly Speed of Player
mov r1, r1, asr 1h ;Halve Fly Speed of Player After Grand Star Grab
b 0x20BB38C ;Return to Original Code
fixbitfsoscillateplatform:
mov r2, r2, asr 1h ;Halve Y Speed of Bowser in the Fire Sea Oscillating Platform
sub r1, r3, r2 ;Get Y Position of Bowser in the Fire Sea Oscillating Platform
b 0x2108808 ;Return to Original Code

.close

.open "overlay/overlay_0008.bin", 0x20A59E0

.org 0x20AA620
cmp r1, 90 ;Coins Start Flickering When 90 Frames Remain

.org 0x20AA6FC
add r1, r1, 1536 ;Rotation Speed of Coins

.org 0x20AAC90
mov r1, 420 ;Coins Last 420 Frames

.org 0x20AC584
movne r1, 360 ;Shells from Blocks Last for 360 Frames

.org 0x20AEE98
add r0, r0, 128 ;Rotation Speed of Bowser in the Sky Elevators

.org 0x20B2CCC
mov r1, 800 ;Exclamation Point Switches are Hit for 800 Frames

.org 0x20B2CDC
mov r1, 20 ;Star Switches are Hit for TT*20 Frames

.org 0x20B2F6C
mov r1, 128 ;Door Open Duration

.org 0x20B2FC4
addne r0, r0, 128 ;Left Opening Doors Rotation Speed

.org 0x20B2FD4
subeq r0, r0, 128 ;Right Opening Doors Rotation Speed

.org 0x20B4ABC
mov r0, 180 ;Time Between Heart Heals

.org 0x20B61D0
mov r3, 1200 ;Max Time for Metal Wario

.org 0x20B6274
mov r3, 1200 ;Max Time for Luigi Invisibility

.org 0x20B62DC
mov r2, 1200 ;Max Time for Mega Mode

.org 0x20B7260
mov r4, r3, lsr 1h ;Halve Character Animation Speeds

.org 0x20B7F40
nop ;Disable Wind Resistance Calculation Change

.org 0x20B8038
b fixwindresistx ;Fix X Axis Wind Resistance

.org 0x20B805C
b fixwindresistz ;Fix Z Axis Wind Resistance

.org 0x20B85C8
b fixwaterresistx ;Fix X Axis Water Resistance

.org 0x20B85F4
b fixwaterresistz ;Fix Z Axis Water Resistance

.org 0x20B9798
mov r0, 128 ;Time Between Damage in Poison

.org 0x20BB388
b fixgrandstarflypath ;Fix Flying Speed of After Grabbing Grand Star

.org 0x20BBE8C
sub r1, r1, 67584 ;Wing Cap Fly Off Speed in Ending Cutscene

.org 0x20C129C
sub r1, r1, 64 ;X Shrink Speed Going into Big Boo Haunt

.org 0x20C12AC
sub r1, r1, 64 ;Y Shrink Speed Going into Big Boo Haunt

.org 0x20C12BC
sub r1, r1, 64 ;Z Shrink Speed Going into Big Boo Haunt

.org 0x20C3CE8
mov r6, 61440 ;Tree Climb Down Max Speed

.org 0x20C3BF4
mov r2, 1024 ;Tree Climb Up Acceleration

.org 0x20C3CF0
mov r2, 1024 ;Tree Climb Down Acceleration

.org 0x20C3FDC
.dw 13104 ;Tree Climb Up Max Speed

.org 0x20C5964
mov r5, 400 ;Turn Speed in Water
mov r9, 288 ;Turn Acceleration in Water

.org 0x20C6340
mov r1, 480 ;Duration of Water Shell Hold

.org 0x20C6F2C
mov r4, 480 ;Duration of One Health Point Underwater

.org 0x20C6F10
mov r1, 30 ;Duration of Healing One Health at Surface

.org 0x20C6F34
movne r4, 160 ;Duration of One Health Point in Cold Water

.org 0x20CB4E4
.dw 3600 ;Duration of Sleep Animation Part 1

.org 0x20CB6A8
mov r1, 1792 ;Wait Animation Duration

.org 0x20CD630
cmp r0, 160 ;First Damage Point Lost when 160 Frames is Left of Damage Causing Burn Animation

.org 0x20CD638
cmp r0, 100 ;Second Damage Point Lost when 100 Frames is Left of Damage Causing Burn Animation

.org 0x20CD640
cmp r0, 40 ;Last Damage Point Lost when 40 Frames is Left of Damage Causing Burn Animation

.org 0x20CD694
add r1, r1, 1 ;Burn Animation End Wait Timer Speed

.org 0x20CD990
mov r1, 162 ;Duration of Damage Causing Burn Animation

.org 0x20D02E4
mov r3, 1200 ;Max Time for Yoshi Fire Ability

.org 0x20D19F4
movne r1, 72 ;Duration of Invincibility

.org 0x20D2730
cmp r2, 240 ;Bowser Hold Duration when Paused

.org 0x20D2898
b fixbowserspinspeed ;Fix Spin Speed of Bowser

.org 0x20D6C8C
mov r3, 1200 ;Max Time for Balloon Mario

.org 0x20D7C84
movlt r2, 32 ;Acceleration Speed of Fast Angle Change Manual Control Flight

.org 0x20D7C8C
movge r2, 16 ;Acceleration Speed of Slow Angle Change Manual Control Flight

.org 0x20D7C94
mov r1, r1, asr 11h ;Halve Max Speed of Angle Change in Manual Flight

.org 0x20D7CAC
mov r2, 32 ;Deceleration Speed of Automatic Angle Change

.org 0x20D86C8
.dw 3600 ;Max Fly Time is 3600 Frames

.org 0x20D93C8
add r0, r0, 3072 ;Spin Speed of Luigi Backflip

.org 0x20E07C4
add r1, r1, 1536 ;Rotation Speed of Stars

.org 0x20E30C4
add r1, r1, 512 ;Star Marker Rotation Speed

.org 0x20E783C
mov r1, 600 ;Double Max Time Off Carpet

.org 0x20E7A94
b carpetspeedfix ;Fix Carpet Movement Speed

.org 0x20E94CC
b fixbluecoinswitchtimer ;Fix Blue Coin Switch Max Time

.org 0x20F10C4
b fixxfirespeed ;Fix Fire Movement Speed on X Axis

.org 0x20F1100
b fixyzfirespeed ;Fix Fire Movement Speed on Y and Z Axis

.org 0x20F4C30
mov r1, 360 ;Seconds last 360 Frames in VS Mode

.org 0x20F582C
mov r14, 360 ;First Second Lasts 360 Frames in VS Mode

.close

.open "overlay/overlay_0023.bin", 0x21082C0

.org 0x2108384
add r1, r1, 512 ;Rotation Speed Upwards of Bowser in the Dark World Floor Trap

.org 0x2108404
sub r0, r0, 128 ;Deceleration Rate Downwards of Bowser in the Dark World Floor Trap

.org 0x2108474
mov r2, 512 ;Starting Downwards Speed of Bowser in the Dark World Floor Trap

.close

.open "overlay/overlay_0027.bin", 0x21082C0

.org 0x2108704
sub r1, r1, 10240 ;Lower Speed of Water After Hitting Pillars

.close

.open "overlay/overlay_0029.bin", 0x21082C0

.org 0x21083F4
subgt r0, r0, 4 ;Move Down Speed of Pendulum in TTC Room

.org 0x2108404
addle r0, r0, 4 ;Move Up Speed of Pendulum in TTC Room

.org 0x21087CC
.dh -256 ;Large Hand Clock Rotation Speed
.dh -16 ;Small Hand Clock Rotation Speed

.close

.open "overlay/overlay_0033.bin", 0x21082C0

.org 0x21090CC
mov r1, 40 ;Duration of Pause for Wall Blocks

.close

.open "overlay/overlay_0035.bin", 0x21082C0

.org 0x2108840
mov r0, 2048 ;Animation Speed of Jolly Roger Bay Eel Wave Tail

.org 0x210898C
mov r1, 2048 ;Animation Speed of Jolly Roger Bay Eel Taunt

.org 0x2108AD4
mov r0, 2048 ;Animation Speed of Jolly Roger Bay Eel Exit Hiding

.org 0x21098DC
add r2, r2, 109 ;Oscillation Speed of Jolly Roger Bay Ship

.org 0x2109DB0
add r1, r1, 2 ;Acceleration of Jolly Roger Bay Pillar Fall

.org 0x210A430
b fixjrbboxzspeed ;Fix Speed of Jolly Roger Bay Skull Box Oscillation

.close

.open "overlay/overlay_0041.bin", 0x21082C0

.org 0x21084A8
b fixpenguinracepath ;Fix Penguin Race Path Following Speed

.org 0x210889C
mov r0, 2048 ;Penguin End-Race Talk Animation Speed

.org 0x2108A4C
mov r3, 2048 ;Penguin Waddle Animation Speed

.org 0x2108B0C
mov r1, 2048 ;Penguin Race Animation Speed

.org 0x2108C20
mov r3, 2048 ;Penguin Stand Up Animation Speed

.org 0x2108EB4
mov r3, 2048 ;Penguin Race Start Animation Speed

.org 0x2108FC4
mov r3, 2048 ;Penguin Pre-Race Land Animation Speed

.org 0x2109008
mov r3, 2048 ;Penguin Idle Pre-Race Wait Animation Speed

.org 0x2109098
mov r3, 2048 ;Penguin Turn Around Animation Speed

.org 0x2109348
mov r3, 2048 ;Penguin Idle Animation Speed

.close

.open "overlay/overlay_0043.bin", 0x21082C0

.org 0x2108BFC
mov r0, 102400 ;Speed of Big Boo Haunt Flying Books

.org 0x2108C24
mov r0, 102400 ;Top Speed of Big Boo Haunt Flying Books

.close

.open "overlay/overlay_0045.bin", 0x21082C0

.org 0x2108780
cmp r0, 90 ;Hazy Maze Cave Arrow Mover Flicker Start Time

.org 0x210915C
mov r2, 600 ;Max Time off Hazy Maze Cave Arrow Mover

.org 0x21097F8
cmp r0, 69632 ;Top Speed of Hazy Maze Cave Rocks

.org 0x2109800
mov r0, 69632 ;Set Max Speed of Hazy Maze Cave Rocks

.close

.open "overlay/overlay_0047.bin", 0x21082C0

.org 0x210841C
mov r2, 7 ;Rotation Deceleration Speed of Lethal Lava Land Center Platform

.org 0x2108438
mov r1, 300 ;Duration of Lethal Lava Land Center Platform Pause while Standing

.org 0x2108474
mvn r1, 127 ;Max Rotation Speed of Lethal Lava Land Center Platform

.org 0x2108478
mov r2, 7 ;Rotation Acceleration Speed of Lethal Lava Land Center Platform

.org 0x2108494
mov r1, 300 ;Duration of Lethal Lava Land Center Platform Rotation while Standing

.org 0x2108644
mvn r0, 127 ;Starting Rotation Speed of Lethal Lava Land Center Platform

.org 0x2108C28
sub r1, r1, 128 ;Going Up Speed of Lethal Lava Land Drawbridge

.org 0x2108C40
mov r0, 31 ;Duration of Lethal Lava Land Drawbridge Going Up in Frames

.org 0x2108C5C
add r0, r0, 128 ;Going Down Speed of Lethal Lava Land Drawbridge

.org 0x2108C78
mov r0, 31 ;Duration of Lethal Lava Land Drawbridge Going Down in Frames

.close

.open "overlay/overlay_0048.bin", 0x21082C0

.org 0x2108548
sub r2, r2, 32 ;Falling Acceleration of Lethal Lava Land Squasher

.org 0x21086C4
mov r2, 64 ;Rising Speed of Lethal Lava Land Squasher

.close

.open "overlay/overlay_0052.bin", 0x21082C0

.org 0x210865C
mov r0, 40960 ;Spindel Forward Movement Speed

.org 0x210866C
mov r0, 512 ;Spindel Forward Rotation Speed

.org 0x2108680
mov r0, 40960 ;Spindel Backward Movement Speed

.org 0x2108690
mov r2, 512 ;Spindel Backward Rotation Speed

.org 0x2108AD8
mov r2, 512 ;Grindel Rotation Speed

.org 0x2109464
mov r0, 20480 ;Descend Speed of Shifting Sand Land Elevator

.close

.open "overlay/overlay_0054.bin", 0x21082C0

.org 0x2108F8C
b dddwhirlpoolfix ;Fix Dire Dire Docks Whirlpool Pull

.close

.open "overlay/overlay_0056.bin", 0x21082C0

.org 0x2108514
mov r0, 40 ;Double Spacing between Snowman Land Ice Block Spawns

.org 0x2108628
mov r2, 200 ;Despawn Time of Snowman Land Ice Blocks

.close

.open "overlay/overlay_0060.bin", 0x21082C0

.org 0x2108D60
sub r1, r1, 40960 ;Descend Speed of Wet Dry World Elevator

.org 0x2109500
add r0, r0, 20480 ;Rise Speed of Wet Dry World Water

.org 0x2109524
sub r0, r0, 20480 ;Descent Speed of Wet Dry World Water

.close

.open "overlay/overlay_0066.bin", 0x21082C0

.org 0x2108574
mov r9, 2048 ;Wiggler Restart Walk Animation Speed

.org 0x2108788
mov r4, 2048 ;Wiggler Player Gets Hit Rebound Animation Speed

.org 0x2108B44
mov r4, 2048 ;Wiggler Gets Angrier Animation Speed

.org 0x2108CF4
mov r4, 2048 ;Wiggler Hit Animation Speed

.org 0x21092BC
mov r9, 2048 ;Wiggler Walk Animation Speed

.org 0x2109CF4
mov r2, r2, asr 11h ;Halve Rotation Speed of Wiggler in Tiny Huge Island

.org 0x210A688
mov r3, 2048 ;Wiggler Initial Walk Animation Speed

.close

.open "overlay/overlay_0072.bin", 0x21082C0

.org 0x2108AF0
mov r0, 60 ;Delay Multiplier for Tick Tock Clock Green Spinners

.org 0x2109014
.dh 40 ;Slow Speed Tick Tock Clock Clock Hand Small Move
.dh 10 ;Fast Speed Tick Tock Clock Clock Hand Small Move
.dh 10 ;Random Speed Tick Tock Clock Clock Hand Small Move

.org 0x210901C
.dh 40 ;Slow Speed Tick Tock Clock Clock Hand Large Move
.dh 10 ;Fast Speed Tick Tock Clock Clock Hand Large Move
.dh 10 ;Random Speed Tick Tock Clock Clock Hand Large Move

.org 0x2109CA0
.dh 100 ;Spin Speed of Slow Clock Speed Tick Tock Clock Green Spinners
.dh 300 ;Spin Speed of Fast Clock Speed Tick Tock Clock Green Spinners
.dh 100 ;Spin Speed of Random Clock Speed Tick Tock Clock Green Spinners

.close

.open "overlay/overlay_0074.bin", 0x21082C0

.org 0x210842c
subge r0, r0, 2 ;Deceleration Rate of Rainbow Ride Swing Lift


.org 0x2108444
add r0, r0, 2 ;Acceleration Rate of Rainbow Ride Swing Lift

.org 0x21094A8
cmp r1, 180 ;Carpet Starts Flickering Twice as Late

.org 0x210AC38
.dw 156 ;Forward Spin Rate of Rainbow Ride Spinners
.dw -312 ;Backward Spin Rate of Rainbow Ride Spinners

.close

.open "overlay/overlay_0087.bin", 0x21082C0

.org 0x21083E4
mov r0, 120 ;Turn Time of Bowser in the Dark World Square Platforms

.org 0x21084B8
mov r0, 120 ;Turn Time of First Turn of Bowser in the Dark World Square Platforms

.close

.open "overlay/overlay_0091.bin", 0x21082C0

.org 0x2108410
cmp r0, 40 ;Rise Duration of Bowser in the Fire Sea Elevator

.org 0x2108424
add r2, r2, 20480 ;Rise Speed of Elevator in Bowser in the Fire Sea

.org 0x2108480
cmp r1, 40 ;Fall Duration of Bowser in the Fire Sea Elevator

.org 0x2108490
sub r1, r1, 20480 ;Fall Speed of Elevator in Bowser in the Fire Sea

.org 0x2108804
b fixbitfsoscillateplatform ;Fix Y Speed of Oscillating Platform in Bowser in the Fire Sea

.close

.open "overlay/overlay_0049.bin", 0x21082C0

.org 0x2108430
add r1, r1, 256 ;Oscillation Speed of Rising Platforms in Goomboss Stage

.close

.open "overlay/overlay_0057.bin", 0x2108A20

.org 0x210BE50
moveq r2, 512 ;Rotation Speed of Bowser in the Fire Sea Bowser

.org 0x210BE64
movgt r2, 512 ;Rotation Speed of Bowser in the Sky Bowser on First Hit

.org 0x210BE70
moveq r2, 384 ;Bowser in the Dark World Bowser Alternate Rotation Speed
movne r2, 256 ;Bowser in the Dark World Bowser Rotation Speed

.org 0x210D10C
b fixbowseranims ;Fix Bowser Animations

.close

.open "overlay/overlay_0059.bin", 0x210CFA0

.org 0x210D314
mov r3, 2048 ;Chuckya Throw Animation Speed

.org 0x210D398
mov r3, 2048 ;Chuckya Swing Animation Speed

.org 0x210D44C
mov r3, 2048 ;Chuckya Throw Start Animation Speed

.org 0x210D5EC
mov r3, 2048 ;Chuckya Hold Animation Speed

.org 0x210D864
mov r3, 2048 ;Chuckya Move Animation Speed

.org 0x210DC80
mov r3, 2048 ;Chuckya Move Start Animation Speed

.org 0x210DD58
mov r3, 2048 ;Chuckya Throw End Animation Speed

.org 0x2110A38
mov r3, 2048 ;Speed of Koopa the Quick Jumping Animation

.org 0x2110DA0
mov r3, 2048 ;Speed of Koopa the Quick End Talking Animation

.org 0x2110F38
mov r3, 2048 ;Speed of Koopa the Quick Give Star Animation

.org 0x21111F8
mov r3, 2048 ;Speed of Koopa the Quick End Race Idle Animation

.org 0x2111570
moveq r0, r0, asr 4h ;Halve Speed of Koopa the Quick Running Animation

.org 0x211157C
mov r1, 2048 ;Speed of Koopa the Quick Run Start Animation

.org 0x21115CC
mov r3, 2048 ;Speed of Koopa the Quick Basic Run

.org 0x2111674
mov r3, 2048 ;Speed of Koopa the Quick Short Jump Animation

.org 0x211179C
mov r3, 2048 ;Speed of Koopa the Quick Jump Land Animation

.org 0x2111864
mov r3, 2048 ;Speed of Koopa the Quick Talking Animation

.org 0x21119B0
mov r3, 2048 ;Speed of Koopa the Quick Idle Animation

.org 0x2111DFC
mov r3, 2048 ;Speed of Koopa the Quick Starting Idle Animation

.org 0x2112268
mov r3, 2048 ;Speed of Flag Animation

.org 0x21129F8
mov r1, 2048 ;Speed of Raptor Lose Star Animation

.org 0x2112D90
mov r0, 2048 ;Speed of Raptor Attack Animation

.org 0x21130E8
mov r0, 2048 ;Speed of Raptor Speed Up Animation

.org 0x2113170
mov r0, 2048 ;Speed of Raptor Fly Straight Animation

.org 0x211333C
mov r0, 2048 ;Speed of Raptor Turn Animation

.org 0x21136DC
mov r0, 2048 ;Speed of Raptor Fly Up Animation

.close

.open "overlay/overlay_0028.bin", 0x210CFA0

.org 0x21138A0
mov r2, 64 ;Rotation Speed of Big Boo Haunt Basement Platform

.org 0x2113C30
mov r2, r2, asr 0Dh ;Halve Rotation Speed of Big Boo Haunt Floor Trap

.org 0x2114C64
mov r1, 2048 ;Piano Eating Animation Speed

.close

.open "overlay/overlay_0061.bin", 0x210CFA0

.org 0x210EE60
add r2, r2, 1280 ;Oscillation Speed of Carry Platform to Lethal Lava Land Log

.org 0x210F330
sub r0, r0, 128 ;Rotation Speed of Horizontal Firebars

.org 0x2110674
mov r1, 160 ;Spawn Time of Dire Dire Docks Rings from WATER_HAKIDASI

.org 0x2110F54
mov r2, 400 ;Despawn Time of Dire Dire Docks Rings

.org 0x2111910
mov r3, 2048 ;Open Speed of Chests

.org 0x2111B9C
cmp r0, 300 ;Open Duration of Clams

.org 0x2111C10
mov r3, 2048 ;Open Speed of Clams

.org 0x2111C44
cmp r0, 300 ;Close Start of Clams

.org 0x2111C68
mov r3, 2048 ;Close Speed of Clams

.close

.open "overlay/overlay_0013.bin", 0x210CFA0

.org 0x210DF7C
mov r2, 2048 ;Snufit Animation Speed

.org 0x210F860
mov r1, r1, asr 11h ;Halve Dorrie Turn Speed

.org 0x2110C00
mov r2, 600 ;Spin Speed of Tick Tock Clock Blocks

.org 0x211189C
b fixttcrandomtreadmill ;Fix TTC Treadmill at Random Speed

.org 0x21120D0
cmp r0, 2048000 ;Tick Tock Clock Platform Push Out Direction Start Compare Speed

.org 0x21120DC
rsb r3, r0, 2048000 ;Tick Tock Clock Platform Push Out Start Speed 1
rsb r2, r2, 2048000 ;Tick Tock Clock Platform Push Out Start Speed 2

.org 0x2112148
cmp r0, 2048000 ;Platform Push Out Direction Get Compare Speed

.org 0x2112130
mov r1, 60 ;Tick Tock Clock Wall Platform Push-In Pause Duration

.org 0x2112610
mov r2, 25 ;TTC Random Cog Acceleration

.org 0x2113170
.dh 6 ;Slow Clock Speed Pendulum Speed
.dh 11 ;Fast Clock Speed Pendulum Speed
.dh 6 ;Random Clock Speed Minimum Pendulum Speed

.org 0x2113178
.dw 2048 ;Treadmill Speed Tick Tock Clock Slow Clock
.dw 4096 ;Treadmill Speed Tick Tock Clock Fast Clock

.org 0x2113188
.dh 106 ;Slow Clock Speed Wall Platform Push-Out Pause Duration
.dh 60 ;Fast Clock Speed Wall Platform Push-Out Pause Duration
.dh 106 ;Random Clock Speed Default Wall Platform Push-Out Pause Duration

.org 0x2114064
.db 240 ;Slow Clock Tick Tock Clock Block Rotation Delay
.db 80 ;Fast Clock Tick Tock Clock Block Rotation Delay

.org 0x211432C
.dh 2 ;Random Clock Speed Wall Platform Push-Out Pause Duration 1
.dh 24 ;Random Clock Speed Wall Platform Push-Out Pause Duration 2
.dh 106 ;Random Clock Speed Wall Platform Push-Out Pause Duration 3
.dh 200 ;Random Clock Speed Wall Platform Push-Out Pause Duration 4

.org 0x21143F4
.dh 100 ;Slow Clock Speed Cog Rotation Speed
.dh 200 ;Fast Clock Speed Cog Rotation Speed

.close

.open "overlay/overlay_0063.bin", 0x210CFA0

.org 0x210D648
mov r0, 2048 ;Eyerok Eye Hittable Animation

.org 0x210D740
mov r0, 2048 ;Eyerok Compress Hand Animation

.org 0x210D91C
mov r0, 2048 ;Eyerok Stand Up Hand Animation Speed

.org 0x210F360
cmp r1, 40 ;Eyerok Hand Stays Up for 40 Frames

.org 0x210F75C
mov r0, 2048 ;Eyerok Step on Animation Speed

.close

.open "overlay/overlay_0067.bin", 0x21160C0

.org 0x2117450
mov r1, 2048 ;Shy Guy Animation Speed

.org 0x211863C
cmp r0, 60 ;Flame Chomp Spit Time

.org 0x2118794
mov r3, 2048 ;Speed of Flame Chomp Animation

.org 0x21187A8
mov r2, 142 ;Flame Chomp Spit Animation Duration

.org 0x21188A4
mov r1, 230 ;Flame Chomp Spit Pause Duration

.org 0x2118B8C
b flamechompsizefix ;Fix Size of Flame Chomp

.org 0x211AC88
mov r3, 2048 ;Monty Mole Jump Animation Speed

.org 0x211ADFC
mov r3, 2048 ;Monty Mole Throw Rock Animation Speed

.org 0x211B008
mov r3, 2048 ;Monty Mole Dig Head Animation Speed

.close

.open "overlay/overlay_0015.bin", 0x21160C0

.org 0x2116AD4
mov r0, 2048 ;Ice Bully Knockback Animation Speed

.org 0x2116AF0
mov r1, 60 ;Ice Bully Knockback Animation Duration

.org 0x2117494
mov r0, 10240 ;Ice Bully Destoying Platforms Rebound Gravity

.org 0x21174E8
mov r0, 4096 ;Ice Bully Destoying Platforms Rebound Animation Speed

.org 0x2117720
mov r0, 4096 ;Ice Bully Destoying Platforms Animation Speed

.org 0x2117BC8
mov r1, 8192 ;Ice Bully Balancing on Platform Animation Speed

.org 0x2117CF8
mov r1, 8192 ;Ice Bully about to Fall off Stage Animation Speed

.org 0x2117C0C
mov r2, 180 ;Ice Bully about to Fall off Stage Animation Duration

.org 0x2117CFC
mov r0, 6144 ;Gravity of Ice Bully

.org 0x2117E74
mov r1, 2048 ;Ice Bully Landed Hit Animation Speed

.org 0x2118268
mov r0, 4096 ;Ice Bully Restart Walk Animation Speed

.org 0x2118330
mov r0, 4096 ;Ice Bully Walk Animation Speed

.close

.open "overlay/overlay_0067.bin", 0x21160C0

.org 0x2117AB8
mov r1, 500 ;Max Speed of Amp
mov r2, 10 ;Acceleration of Amp

.close

.open "overlay/overlay_0032.bin", 0x21160C0

.org 0x2116DE8
mov r2, 5632 ;Animation Speed of Scuttlebug Attack Rebound

.org 0x2116F6C
mov r0, 5632 ;Animation Speed of Scuttlebug Jump

.org 0x21170C0
mov r0, 2048 ;Animation Speed of Scuttlebug Walk

.org 0x2117804
movne r0, 200 ;Minimum Speed for Big Mister I Spin
moveq r0, 400 ;Minimum Speed for Mister I Spin

.org 0x2118354
movne r0, 166 ;Pause Time Between Mister I Shots for Big Mister I

.org 0x21184B4
mov r1, 166 ;Pause Time Between Mister I Shots

.org 0x2118650
movpl r0, 100 ;Starting Spin Speed of Forward Spin Mister I

.org 0x2118658
mvnmi r0, 99 ;Starting Spin Speed of Backward Spin Mister I

.close

.open "overlay/overlay_0071.bin", 0x21160C0

.org 0x2119EBE
.dh 104 ;Last Health Point Goomboss Speed
.dh 64 ;Second Health Point Goomboss Speed
.dh 40 ;First Health Point Goomboss Speed

.close

.open "overlay/overlay_0002.bin", 0x21160C0

.org 0x211B788
mov r3, 2048 ;Lakitu Drop Animation Speed

.close

.open "overlay/overlay_0075.bin", 0x211A800

.org 0x211C5E8
mov r3, 256 ;Halve King Bob-omb Turn Speed

.org 0x211D224
mov r1, r1, lsl 0Bh ;Halve King Bob-omb Animation Speed

.close

.open "overlay/overlay_0036.bin", 0x211A800

.org 0x211BC10
mov r1, 40 ;Duration Multiplier of Whomp Lie Down

.org 0x211BC20
add r0, r1, 200 ;Base Duration of Whomp Lie Down

.org 0x211BD60
mov r0, 328 ;Vertical Orientation Correction Speed of Whomp Boss

.org 0x211C4B8
addne r0, r0, 152 ;Vertical Fall Speed of Whomp Boss

.org 0x211C4C8
addeq r0, r0, 128 ;Vertical Fall Speed of Little Whomp

.org 0x211C818
mov r1, 2048 ;Whomp Wait Animation Speed

.org 0x211C834
mov r2, 256 ;Turn Speed of Whomp Boss

.close

.open "overlay/overlay_0102.bin", 0x211A800

.org 0x211DF04
mov r0, 0 ;All Paintings Act Normally

.org 0x211E37C
subgt r0, r0, 8 ;Acceleration of Log Rotation Forwards

.org 0x211E38C
addle r0, r0, 8 ;Acceleration of Log Rotation Backwards

.org 0x211E39C
mov r0, 256 ;Max Speed of Log Rotation

.org 0x211E3B0
cmp r2, 256 ;Speed Clamp of Log Rotation

.close

.open "overlay/overlay_0080.bin", 0x21200E0

.org 0x2122988
mov r1, r1, lsl 2h ;Halve Animation Speed of Goombas and Piranha Plants

.org 0x2123A10
mov r3, 2048 ;Animation Speed of Bob-omb Buddies

.org 0x2124F08
mov r3, 2048 ;Piranha Plant Shrinking Animation Speed

.org 0x21254F4
mov r3, 2048 ;Piranha Plant Growing Animation Speed

.close

.open "overlay/overlay_0007.bin", 0x21200E0

.org 0x2120AF4
mov r0, 2048 ;Toad Animation Speed

.close

.open "overlay/overlay_0019.bin", 0x2127FC0

.org 0x2129450
cmp r1, 512 ;Speed Check for Key Speed Reduction/Set

.org 0x212945C
subgt r0, r0, 128 ;Key Speed Reduction Rate

.org 0x212946C
moveq r1, 512 ;Key Speed Set to 512 on Spawn

.close

.open "overlay/overlay_0086.bin", 0x2127FC0

.org 0x2128CB8
mov r0, r0, lsr 7h ;Get Pause Time for Skeeter
and r0, r0, 63 ;Max Additional Pause Time for Skeeter
add r1, r0, 300 ;Minimum Time for Skeeter Pause

.org 0x2129940
mov r1, 78 ;Timer Between Manta Rings Spawn

.org 0x212A598
mov r1, 2048 ;Animation Speed of Cheep Cheeps

.close

.open "overlay/overlay_0042.bin", 0x2127FC0

.org 0x21290F4
mov r1, 20480 ;Bowser in the Fire Sea Starting Platform Speed

.org 0x2129630
mov r1, 31 ;Duration of Platform Pause Duration

.org 0x2129FDC
sub r0, r0, 8192 ;Gravity of Thwomp

.org 0x212A0F0
add r0, r0, 20480 ;Upwards Movement Speed of Thwomp

.org 0x212AFBC
mov r3, 200 ;Duration Between Fwoosh Wind Blows

.org 0x212B5C4
.dh 138 ;Platform Type 1 Cycle Length
.dh 160 ;Platform Type 2 Cycle Length
.dh 156 ;Platform Type 3 Cycle Length
.dh 160 ;Platform Type 4 Cycle Length
.dh 120 ;Platform Type 5 Cycle Length
.dh 300 ;Platform Type 6 Cycle Length
.dh 100 ;Platform Type 7 Cycle Length

.close

.open "overlay/overlay_0044.bin", 0x212C7A0

.org 0x212CEA4
mov r2, 102400 ;Max Speed of Bob-omb Battlefield Seesaw

.org 0x212D278
mov r1, 20480 ;Max Speed of Elevator Moving Down
mov r2, 4096 ;Acceleration Speed of Elevator Moving Down

.org 0x212D368
mov r1, 20480 ;Max Speed of Elevator Moving Up
mov r2, 4096 ;Acceleration Speed of Elevator Moving Up

.org 0x212DA14
mov r1, 120 ;Flame Thrower Stays Up for 120 Frames

.org 0x212DA5C
moveq r1, 120 ;Flame Thrower Pauses for 120 Frames

.close

.open "overlay/overlay_0092.bin", 0x212C7A0

.org 0x212E0FC
cmp r0, 720 ;Minimum Delay Between Shifting Sand Land Tornado Spawns

.close


.open "overlay/overlay_0096.bin", 0x2137A20

.org 0x213C39C
mov r3, 2048 ;Animation Speed of Doors

.org 0x213C648
mov r2, 16384 ;Sliding Speed of Star Doors

.org 0x213DD54
cmp r0, 180 ;HMC Upper Platform Flicker Time Start

.org 0x213A74C
mov r1, 2048 ;Animation Speed of Chain Chomp

.close

.open "overlay/overlay_0098.bin", 0x213F700

.org 0x21418A0
mov r1, 160 ;Yoshi Mouth Bob-omb Max Time

.org 0x214199C
mov r1, 300 ;Pre-Activated Bob-omb Max Time

.org 0x2142698
mov r1, 300 ;Activate Bob-omb Max Time

.org 0x21429DC
mov r1, 300 ;Grab Bob-omb Max Time

.org 0x2142D1C
mov r0, r0, asr 4h ;Halve Bob-omb Animation Speed

.org 0x2143D2C
add r1, r1, 2048 ;Rotation Speed of Koopa Shell

.close
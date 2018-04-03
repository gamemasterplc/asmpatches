.n64

.open "Mario Party 3 (U) [!].z64", 0x7FFEF680 //OVL 0 ROM Offset-0x801059A0

.org 0x7FFFC540
nop //Bypass Mismatch Save Type Error

.org 0x7FFFE8D0
addiu a0, r0, 0 //Boot to OVL 0

.org 0x801059A0
addiu sp, sp, -32 //Use Stack Space
sw ra, 24(sp) //Backup Return Address
jal 0x80012220 //Init Cameras
addiu a0, r0, 1 //Init 1 Camera (Delay Slot)
jal 0x8001FE20 //Init Animations
addiu a0, r0, 1 //Required Parameter for Previous Function (Delay Slot)
jal 0x800142A0
addiu a0, r0, 0x19
addiu a0, r0, 0x33
jal 0x80047160 //Call InitObjSys
addu a1, r0, r0
li a0, cheatmenuprc //Process Address
addiu a1, r0, 0x1001
addiu a2, r0, 0x1000
jal 0x80047EA0 //Call InitProcess
addu a3, r0, r0
jal 0x80036080 //Game Thinks Controllers are Plugged In
nop //Delay Slot
lw ra, 24(sp) //Restore Return Address
jr ra //Return to Caller
addiu sp, sp, 32 //Restore Removed Stack Space

cheatmenuprc:
li s0, cheatmenuptrtable //Start of Cheat Lookup Table
li s2, 24 //Start Y Position of Cheat Names
li s1, 0x800D5558 //Player 1 Buttons Pressed Address
lh s1, 0(s1) //Read Player 1 Buttons Pressed
andi v0, s1, 0x1000 //Is Player 1 Pressing Start
beq v0, r0, controlcheatlist //If Not Advance to Controlling the Cheat List
nop
jal 0x80035864 //Call MallocPermHeap
addiu a0, r0, 12288 //Allocate 12288 Bytes of Memory
addu s1, v0, r0 //Keep Allocated Memory Address
li v1, 0x0FFFFFFC //Bitmask for J Instruction
and v0, v0, v1 //Filter Out Unused Bits for J Instruction
sra v0, v0, 2 //Divide Jump Destination by 4 for J Instruction
lui v1, 0x800 //Jump Instruction Base
or v0, v0, v1 //Generate Jump to Allocated Memory
lui v1, 0x8001 //Upper Half of OVL Load Function End
sw v0, 0xB35C(v1) //Write Jump to OVL Load Function End
lui v1, 0x8005 //End of Process Loop Upper Half Address
sw v0, 0xF234(v1) //Jump to Allocated Memory from Process Loop Finishing
li a0, 0x8004F220 //Invalidate Cache
jal 0x80078C50 //Invalidate Icache Around Process Loop Jump
li a1, 32 //Invalidate 32 Bytes Around Process Loop Jump
li a0, 0x8000B340 //Invalidate Cache
jal 0x80078C50 //Invalidate Icache Around OVL Load Jump
li a1, 32 //Invalidate 32 Bytes Around OVL Load Jump
cheatinstallloop:
lw s2, 0(s0) //Get Cheat Menu Pointer Table Entry
lb v0, 8(s2) //Is the Current Cheat Enabled
beq v0, r0, @@nextcheat //Don't Copy the Cheat if Disabled
nop //Delay Slot of Previous Instruction
lw a0, 0(s2) //Beginning of Cheat Assembly
lw a1, 4(s2) //End of Cheat Assembly
subu s3, a1, a0 //Get Length of Cheat Assembly
addu a2, s3, r0 //Copy Length of Cheat Assembly for 32-bit memcpy
jal memcpy32 //Call 32-bit memcpy
addu a1, s1, r0 //Destination for Cheat Assembly
addu a0, s1, r0 //Invalidate Destination for Cheat Assembly
jal 0x80078C50 //Call osInvalICache
addu a1, s3, r0 //Copy Length of Cheat Assembly for Cache Invalidation
addu s1, s1, s3 //Move to Next Space for Cheat Assembly
@@nextcheat:
addiu s0, s0, 4 //Move to Next Cheat Menu Pointer Table Entry
lw v0, 0(s0) //Get Next Cheat Menu Pointer Table Entry
bne v0, r0, cheatinstallloop //Is This the Last Entry
nop //Delay Slot
li v0, 0x03E00008 //V0 Holds JR RA Instruction
sw v0, 0(s1) //Update Instruction After Last Installed Cheat
sw r0, 4(s1) //Set Delay Slot of the JR RA Installed
li a0, 122 //Start Intro Cutscene OVL
li a1, 2 //Call Entrypoint 2
jal 0x80048128 //Call ChangeOVL
li a2, 146 //Unknown Parameter to ChangeOVL (Delay Slot)
jal 0x80048008 //Call EndProcess
addu a0, r0, r0 //Delay Slot
forever:
jal 0x8004F074 //Call ProcessVSleep
nop //Delay Slot
j forever //Keep Sleeping This Process if Not Ending
nop //Delay Slot
controlcheatlist:
li s5, cheatsel //Current Cheat Selection Address
lb s5, 0(s5) //Read Current Cheat Selection
addiu s3, r0, -2 //Default Cheat Counter
addu s4, s0, r0 //First Cheat Table Pointer Entry for Counting
countcheats:
lw v0, 0(s4) //Read Current Cheat Menu Pointer Table Entry
addiu s4, s4, 4 //Get to Next Cheat Menu Pointer Table Entry
addiu s3, s3, 1 //Increment Number of Cheat Menu Pointer Table Entries
bne v0, r0, countcheats //Increment Cheat Counter
nop
li v0, 0x800D0590 //Get Analog Directions Pressed Address
lh s6, 0(v0) //Read Analog Directions Pressed
andi v0, s6, 0x400 //Is Analog-Down Pressed
beq v0, r0, @@checkanalogup //If Not Check for Analog-Up
nop //(Delay Slot)
bne s5, s3, @@checkanalogup //Are We At the Last Cheat Menu Selection
addiu s5, s5, 1 //No Matter What Increment Current Selection While Analog-Down Is Pressed
nop
addu s5, r0, r0 //If at Last Selection Go Back to First Selection
@@checkanalogup:
andi v0, s6, 0x800 //Is Analog-Up Pressed
beq v0, r0, @@checkA //If Not Check for A Presses
nop //
bne s5, r0, @@checkA
addiu s5, s5, -1
nop
addu s5, s3, r0
@@checkA:
andi v0, s1, 0x8000 //Is A Pressed
beq v0, r0, updatecheatmenusel
nop
sll v0, s5, 2
li s1, cheatmenuptrtable
addu s1, s1, v0
lw s1, 0(s1)
lb s3, 0x8(s1)
xori s3, s3, 0x1
sb s3, 0x8(s1)
updatecheatmenusel:
li v0, cheatsel //Load Address for Cheat Selected
sb s5, 0(v0) //Update Cheat Selection
drawcheatlist:
lw s1, 0(s0) //Get Current Entry in Cheat Pointer Table
lb v0, 8(s1) //Get Cheat Enabled Status
addiu v1, r0, 15 //Disabled Cheats are White
beq v0, r0, settextcolour
nop
addiu v1, r0, 12 //Enabled Cheats are Green
settextcolour:
lui at, 0x800D //Upper Half of Debug Text Colour Address
sw v1, 0xB8A4(at) //Update Debug Text Colour
li a0, 16 //X Position of Cheat Text
addiu a2, s1, 9 //Text Offset from Cheat Table Entry Start
jal 0x8004DD7C //Call DrawDebugText
addu a1, s2, r0 //Y Position of Cheat Textt
addiu s2, s2, 8 //Next Line Text X Position
addiu s0, s0, 4 //Go To Next Cheat Menu Pointer Table Entry
lw v0, 0(s0) //Get Next Cheat Menu Entry
bne v0, r0, drawcheatlist //Is This the Last Cheat Menu Entry
nop
li v1, 12 //Set Text Colour to Green
li at, 0x800CB8A4 //Debug Text Colour Address
sw v1, 0(at) //Set Debug Text Colour
li a0, 8 //X Position of GREEN = ON
li a2, green //Text Pointer of GREEN = ON
jal 0x8004DD7C //Call DrawDebugText
li a1, 8 //Y Position of GREEN = ON Text
addiu v1, r0, 15 //Set Cursor Colour to White
lui at, 0x800D //Upper Half of Debug Text Colour Address
sw v1, 0xB8A4(at) //Update Debug Text Colour
li a0, 8 //X Position of Current Selected Cheat
li a2, cursorchar //Pointer to Cursor Character
li a1, cheatsel //Get Current Cheat Selection Address
lb a1, 0(a1) //Load Current Cheat Selection
sll a1, a1, 3 //Multiply Current Cheat Selection by 8 for Drawing
jal 0x8004DD7C //Call DrawDebugText
addiu a1, a1, 24 //First Cheat Selection Y Position
li a0, 120 //X Position of CHEAT MENU Text
li a2, cheatmenuheader //CHEAT MENU Text
jal 0x8004DD7C //Call DrawDebugText
li a1, 8 //Y Position of CHEAT MENU Text
li a0, 224 //X Position of WHITE = OFF Text
li a2, white //WHITE = OFF Text Pointer 
jal 0x8004DD7C //Call DrawDebugText
li a1, 8 //Y Position of WHITE = OFF Text
jal 0x8004F074 //Call SleepVProcess
nop //Delay Slot of Previous Opcode
j cheatmenuprc //Return to Beginning of Cheat Menu Process
nop //Delay Slot of Previous Opcode

memcpy32:
lw a3, 0(a0) //Copy From Source Pointer
sw a3, 0(a1) //Copy to Destination Pointer
addiu a2, a2, -4 //Length Counter
addiu a0, a0, 4 //Increment Source Counter
bne a2, r0, memcpy32 //Continue if Length hasn't Fully Copied
addiu a1, a1, 4 //Increment Destination Pointer
nop
jr ra //Return to Caller
nop

cursorchar:
db ">", 0x00 //Cursor Character
.align 4

cheatmenuheader:
db "CHEAT MENU", 0x00 //CHEAT MENU Text
.align 4

green:
db "GREEN = ON", 0x00 //GREEN = ON Text
.align 4

white:
db "WHITE = OFF", 0x00 //WHITE = OFF Text
.align 4

cheatsel:
db 0 //Default Cheat Selection
.align 4

cheatmenuptrtable:
dw slowpartnerroulette
dw nochillyiceslip
dw dbssoutheastblowfish
dw noresultsproceed //Disable Results Proceed Cheat Table
dw eotlreplace
dw nogameguy
dw hlsreplace
dw mpiqfasttext
dw merrychompreplace
dw spotlightmoreswim
dw nodbsmissile
dw nowaluigitraps
dw reversemode
dw riverraiderreplace
dw tworealstarsspiny
dw stackedreplace
dw swingswipereplace
dw tauntanywhere //Taunt During Your Turn Cheat Table
dw beatgoesonreplace
dw tidaltossreplace
dw unlockeverything
dw waluigibombexplode1hit
dw alwaysslowwaluigi
dw neverfastwaluigi
dw 0 //End of Cheat Menu Pointer Table

tauntanywhere:
dw tauntanywherefunc //Start of Taunt in Your Turn Function
dw nochillyiceslipfunc //End of Taunt in Your Turn Function + 4 Bytes
db 1 //Cheat Defaults to Enabled
db "TAUNT IN YOUR TURN", 0x00 //TAUNT IN YOUR TURN Text
.align 4

nochillyiceslip:
dw nochillyiceslipfunc //Start of Disabling Chilly Waters Ice Slip Function
dw noresultsproceedfunc //End of Disabling Chilly Waters Ice Slip Function + 4 Bytes
db 0 //Cheat Defaults to Disabled
db "CHILLY WATERS NO ICE SLIP", 0x00 //CHILLY WATERS NO ICE SLIP Text
.align 4

noresultsproceed:
dw noresultsproceedfunc
dw reversemodefunc
db 1 //Cheat Defaults to Enabled
db "DISABLE RESULTS PROCEED", 0x00 //DISABLE RESULTS PROCEED Text
.align 4

reversemode:
dw reversemodefunc
dw mpiqfasttextfunc
db 0
db "REVERSE MODE", 0x00 //REVERSE MODE Text
.align 4

mpiqfasttext:
dw mpiqfasttextfunc
dw spotlightmoreswimfunc
db 0
db "INSTANT MPIQ TEXT", 0x00 //INSTANT MPIQ TEXT Text
.align 4

spotlightmoreswim:
dw spotlightmoreswimfunc
dw nodbsmissilefunc
db 0
db "MORE SWIM TIME SPOTLIGHT SWIM", 0x00 //MORE SWIM TIME SPOTLIGHT SWIM Text
.align 4

nodbsmissile:
dw nodbsmissilefunc
dw dbssoutheastblowfishfunc
db 0
db "NO DEEP BLOOBER SEA MISSILE", 0x00 //NO DEEP BLOOBER SEA MISSILE Text
.align 4

dbssoutheastblowfish:
dw dbssoutheastblowfishfunc
dw tworealstarsspinyfunc
db 0
db "DBS BLOWFISH ALWAYS POINTS SOUTHEAST", 0x00 //DBS BLOWFISH ALWAYS POINTS SOUTHEAST Text
.align 4

tworealstarsspiny:
dw tworealstarsspinyfunc
dw cursorchar
db 0
db "SPINY DESERT TWO REAL STARS", 0x00 //SPINY DESERT TWO REAL STARS Text
.align 4

unlockeverything:
dw unlockeverythingfunc
dw waluigibombexplode1hitfunc
db 1
db "UNLOCK EVERYTHING (TEMPORARY)", 0x00 //UNLOCK EVERYTHING (TEMPORARY) Text
.align 4

waluigibombexplode1hit:
dw waluigibombexplode1hitfunc
dw nogameguyfunc
db 0
db "WALUIGI ISLAND BOMB EXPLODES IN 1 HIT", 0x00 //WALUIGI ISLAND BOMB EXPLODES IN 1 HIT Text
.align 4

nogameguy:
dw nogameguyfunc
dw slowpartnerroulettefunc
db 0
db "GAME GUY SPACES DO NOTHING", 0x00
.align 4

slowpartnerroulette:
dw slowpartnerroulettefunc
dw hlsreplacefunc
db 0
db "ALWAYS SLOW PARTNER ROULETTE", 0x00
.align 4

hlsreplace:
dw hlsreplacefunc
dw eotlreplacefunc
db 0
db "HAND LINE AND SINKER TO BOULDER BALL", 0x00
.align 4

eotlreplace:
dw eotlreplacefunc
dw stackedreplacefunc
db 0
db "END OF THE LINE TO VINE WITH ME", 0x00
.align 4

stackedreplace:
dw stackedreplacefunc
dw beatgoesonreplacefunc
db 0
db "STACKED DECK TO ALL FIRED UP", 0x00
.align 4

beatgoesonreplace:
dw beatgoesonreplacefunc
dw swingswipereplacefunc
db 0
db "THE BEAT GOES ON TO TOADSTOOL TITAN", 0x00
.align 4

swingswipereplace:
dw swingswipereplacefunc
dw merrychompreplacefunc
db 0
db "SWING N SWIPE TO SWINGING WITH SHARKS", 0x00
.align 4

merrychompreplace:
dw merrychompreplacefunc
dw riverraiderreplacefunc
db 0
db "MERRY GO CHOMP TO EYE SORE", 0x00
.align 4

riverraiderreplace:
dw riverraiderreplacefunc
dw tidaltossreplacefunc
db 0
db "RIVER RAIDERS TO THWOMP PULL", 0x00
.align 4

tidaltossreplace:
dw tidaltossreplacefunc
dw nowaluigitrapsfunc
db 0
db "TIDAL TOSS TO COCONUT CONK", 0x00
.align 4

nowaluigitraps:
dw nowaluigitrapsfunc
dw neverfastwaluigifunc
db 0
db "NO WALUIGI ISLAND TRAPS", 0x00
.align 4

neverfastwaluigi:
dw neverfastwaluigifunc
dw alwaysslowwaluigifunc
db 0
db "WALUIGI ISLAND ROULETTE NEVER FAST", 0x00
.align 4

alwaysslowwaluigi:
dw alwaysslowwaluigifunc
dw lastsym
db 0
db "WALUIGI ISLAND ROULETTE ALWAYS SLOW", 0x00
.align 4

tauntanywherefunc:
lui a0, 0x800A //Upper Half of Can Taunt On Your Turn Address
sh r0, 0x12D6(a0) //Write 0 to Can Taunt On Your Turn Address
@@endcheat:

nochillyiceslipfunc:
lui a0, 0x8012 //Upper Half of Check Address for Chilly Waters Detection
lh a0, 0x8AD6(a0) //Read Chilly Waters Detection Address
li a1, 0x60C2 //Chilly Waters Detection Compare Value
bne a1, a0, @@endcheat //On Chilly Waters?
nop //Delay Slot
lui a0, 0x8012 //Upper Half of Chilly Waters Ice Slip Check Address
li a1, 0x1000 //Force Branch Upper Half
sh a1, 0x8AC4(a0) //Force Check for Chilly Waters Ice Slip to Never Happen
@@endcheat:

noresultsproceedfunc:
lui a0, 0x8011 //Upper Half of Battle Royale Results Screen Check Address
lh a0, 0x95AA(a0) //Read Battle Royale Results Screen Check Address
li a1, 0x2484 //Check Value of Battle Royale Results Screen Check Address
bne a1, a0, @@endcheat //On Battle Royale Results?
nop //Delay Slot
lui a0, 0x8011 //Upper Half of Proceed Check Battle Royale Results Screen Address
sw r0, 0x9348(a0) //Proceed Check Always Fails
@@endcheat:

reversemodefunc:
li a0, 0x800FD196 //Battle Royale Mode Check Address
lh a0, 0(a0) //Read Battle Royale Mode Check Address
addiu a1, r0, 0x80 //Compare Value Battle Royale Mode Check
bne a0, a1, @@endcheat //Skip Cheat if Battle Royale Mode Check Doesn't Match Compare Value
nop
li a0, 0x800FD194 //Battle Royale Reverse Mode Check
li a1, 0x3442 //OR Reverse Mode Bit in
sh a1, 0(a0) //Update Reverse Mode Bit
li a1, 0xA2420017 //Update Reverse Mode Status
sw a1, 4(a0) //Write to Reverse Mode Status
@@endcheat:

mpiqfasttextfunc:
li a0, 0x8010BC62 //MPIQ Text Speed Constant Address
lh a0, 0x0(a0) //Read MPIQ Text Speed Constant Address
li a1, 5 //MPIQ Text Speed Constant Compare Value
bne a0, a1, @@endcheat //Check if the MPIQ Text Speed Constant Matches 5
nop
li a0, 0x8010BC62 //MPIQ Text Speed Constant Address
sh r0, 0(a0) //Set MPIQ Text Speed to Instant
@@endcheat:

spotlightmoreswimfunc:
li a0, 0x801089C6 //Spotlight Swim Minigame Detection Address
lh a0, 0(a0) //Read Spotlight Swim Minigame Detection Address
li a1, 0x228B //Spotlight Swim Minigame Detection Check Value
bne a0, a1, @@endcheat
nop
li a0, 0x80108992 //Spotlight Swim Max Swim Time Address
li a1, 127 //Can Swim for Up to 127 Frames in Spotlight Swim
sh a1, 0(a0) //Update Spotlight Swim Max Swim TIme
@@endcheat:

nodbsmissilefunc:
li a0, 0x80119EFE //Deep Bloober Sea Detection Address
lh a0, 0(a0) //Read Deep Bloober Sea Detection Address
addiu a1, r0, 0xFF76 //Deep Bloober Sea Detection Address Compare Value
bne a0, a1, @@endcheat //Skip Deep Bloober Sea Missile Disable if not on DBS
nop
li a0, 0x80118398 //Start of DBS Missile Changes
li a1, 0xA480 //Haven't Pressed Any DBS Buttons
sh a1, 0(a0) //Do Not Update Pressed DBS Buttons
li a1, 0x1000 //Missile Check Always Thinks Button Is Not Missile
sh a1, 0x278(a0) //DBS Missile Check Always Fails
@@endcheat:

dbssoutheastblowfishfunc:
li a0, 0x80119EFE //Deep Bloober Sea Detection Address
lh a0, 0(a0) //Read Deep Bloober Sea Detection Address
addiu a1, r0, 0xFF76 //Deep Bloober Sea Detection Address Compare Value
bne a0, a1, @@endcheat //Skip DBS Blowfish Direction Force if not on DBS
nop
li a0, 0x80119ED0 //DBS Blowfish Direction Set Address
li a1, 0x241E0005 //DBS Blowfish Direction is Always Southeast
sw a1, 0(a0) //Update DBS Blowfish Direction
@@endcheat:

tworealstarsspinyfunc:
li a0, 0x8010A312 //Spiny Desert Detection Address
lh a0, 0(a0) //Read Spiny Desert Detection Address
li a1, 1 //Spiny Desert Detection Address Compare Value
bne a0, a1, @@endcheat //Skip Double Real Star Spiny Desert if Not on Spiny Desert
nop
li a0, 0x8010A314 //Spiny Desert is Star Real Check Address
sw r0, 0x0(a0) //Spiny Desert Star Always Real
@@endcheat:

unlockeverythingfunc:
li a0, 0x80035C00 //Minigame Check Address
li a1, 0x240400FF //All Minigames Values
sw a1, 0(a0) //Update Minigame Check Address
li a0, 0x8010AEEA //Minigame Freeplay Check Address
lh a0, 0(a0) //Read Minigame Freeplay Check Address
li a1, 0x2BBE //Minigame Freeplay Check Compare Value
bne a1, a0, @@gamesetupovlunlock //Skip Setting Special Minigame Unlocks if Not in Minigame Freeplay
nop
li a0, 0x80105F90
li a1, 0x24020001 //Value for Special Minigame Unlock Checks
sw a1, 0(a0) //Unlock Game Guy's Room
sw a1, 0x4E80(a0) //Unlock Stardust Battle
sw a1, 0x4F68(A0) //Unlock Mario Puzzle Party Pro
@@gamesetupovlunlock:
li a0, 0x801133FA //Check for Game Setup Scene Address
lh a0, 0(a0) //Read Check for Game Setup Scene Address
li a1, 0x4D04 //Game Setup Scene Check Compare Value
bne a1, a0, @@unlockextrasounds //Skip Opening Boards and Super Hard if Not in Game Setup
nop
li a0, 0x80113398 //Base Address of Game Setup Scene Writes
sw r0, 0(a0) //Always Have Super Hard in Duel/Battle Royale Setup
li a1, 0x1000 //Force Check Backtrack and Waluigi Island to Pass
sh a1, 0xC3C(a0) //Write Updated Backtrack and Waluigi Island Check
li a1, 0x24020001 //Always Have Super Hard in Story Setup 
sw a1, 0x4750(a0) //Write Always Have Super Hard in Story Setup
@@unlockextrasounds:
li a0, 0x8010F2A6 //Address of Princess Peach's Castle Check
lh a0, 0(a0) //Read Address for Checking if Princess Peach's Castle
li a1, 0x4006 //Compare Value for Princess Peach's Castle
bne a0, a1, @@endcheat //Skip Unlocking Songs Outside Princess Peach's Castle
nop
li a0, 0x8010F2C0 //Start of Unlock Checks for Songs
li a1, 0x24020001 //Force Songs to be Read as Unlocked
sw a1, 0(a0) //Unlock Game Guy Theme
sw a1, 0x1C(a0) //Unlock Waluigi Island Theme
sw a1, 0x38(a0) //Unlock Other the Winner Is Me Theme
sw a1, 0x54(a0) //Unlock Stardust Battle Theme
@@endcheat:

waluigibombexplode1hitfunc:
li a0, 0x80119932 //Waluigi Island Detection Address
lh a0, 0(a0) //Read Waluigi Island Detection Address
li a1, 0x6624 //Compare Value for Waluigi Island Detection Address
bne a1, a0, @@endcheat //Skip Cheat if Not on Waluigi Island
nop
li a0, 0x80119980 //Waluigi Island Bomb Explode Check
sw r0, 0(a0) //Never Skip Waluigi Island Bomb Explode
@@endcheat:

nogameguyfunc:
li a0, 0x80102966 //Duel Mode Space Switch Statement Detection Address
addiu a1, r0, 0xE8A4 //Lower Half of a Duel Mode Space Switch Statement Address
lh a0, 0(a0)
bne a0, a1, @@nobattleroyalegameguy
nop
li a0, 0x80102968 //Game Guy Space Duel Mode Switch Case Address
li a1, 0x800FF28C //Null Switch Case for Game Guy Space in Duel Mode
sw a1, 0(a0) //Set Game Guy Switch Case for Duel Mode
@@nobattleroyalegameguy:
li a0, 0x801026D6 //Battle Royale Game Guy Space Switch Case Address
addiu a1, r0, 0xE9C0 //Battle Royale Game Guy Switch Space Case Default Value
lh a0, 0(a0) //Read Battle Royale Game Guy Space Switch Case Address
bne a0, a1, @@endcheat //Skip Battle Royale Game Guy Case Update Outside Battle Royale
nop
li a0, 0x801026D6 //Battle Royale Game Guy Space Switch Case Address
addiu a1, r0, 0xEEBC //Null Space Switch Case 
sh a1, 0(a0) //Replace Game Guy Switch Case With Null Space
@@endcheat:

slowpartnerroulettefunc:
li a0, 0x800CD0B3 //Partner Roulette Speed Address
li a1, 2 //Partner Roulette Speed is Slow
sb a1, 0(a0) //Update Partner Roulette Speed
@@endcheat:

hlsreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 1 //Is it Hand Line and Sinker
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 4 //Change Next Minigame to Boulder Ball
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

eotlreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 51 //Is it End of the Line
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 49 //Change Next Minigame to Vine With Me
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

stackedreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 42 //Is it Stacked Deck
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 41 //Change Next Minigame to All Fired Up
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

beatgoesonreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 32 //Is it The Beat Goes On
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 22 //Change Next Minigame to Toadstool Titan
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

swingswipereplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 64 //Is it Swing 'n' Swipe
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 63 //Change Next Minigame to Swinging with Sharks
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

merrychompreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 45 //Is it Merry Go Chomp
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 48 //Change Next Minigame to Eye Sore
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

riverraiderreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 9 //Is it River Raiders
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 8 //Change Next Minigame to Eye Sore
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

tidaltossreplacefunc:
li a0, 0x800CD068 //Next Minigame Address
lb a0, 0(a0) //Read Next Minigame Address
li a1, 10 //Is it Tidal Toss
bne a0, a1, @@endcheat //Skip Replacement if Not
nop
li a0, 0x800CD068 //Next Minigame Address
li a1, 2 //Change Next Minigame to Coconut Conk
sb a1, 0(a0) //Update Next Minigame
@@endcheat:

nowaluigitrapsfunc:
li a0, 0x80119932 //Waluigi Island Detection Address
lh a0, 0(a0) //Read Waluigi Island Detection Address
li a1, 0x6624 //Compare Value for Waluigi Island Detection Address
bne a1, a0, @@endcheat //Skip Cheat if Not on Waluigi Island
nop
li a0, 0x8010A900 //Waluigi Island Trap Check Address
li a1, 0x1000 //Waluigi Island Trap Check Always Fails
sh a1, 0(a0) //Update Waluigi Island Trap Check
@@endcheat:

neverfastwaluigifunc:
li a0, 0x80119932 //Waluigi Island Detection Address
lh a0, 0(a0) //Read Waluigi Island Detection Address
li a1, 0x6624 //Compare Value for Waluigi Island Detection Address
bne a1, a0, @@endcheat //Skip Cheat if Not on Waluigi Island
nop
li a0, 0x8011E100 //Waluigi Island Fast Change Rate Address
li a1, 4 //Waluigi Island Fast Change Changes in 4 Frames
sb a1, 0(a0) //Update Waluigi Island Fast Change Rate
@@endcheat:

alwaysslowwaluigifunc:
li a0, 0x80119932 //Waluigi Island Detection Address
lh a0, 0(a0) //Read Waluigi Island Detection Address
li a1, 0x6624 //Compare Value for Waluigi Island Detection Address
bne a1, a0, @@endcheat //Skip Cheat if Not on Waluigi Island
nop
li a0, 0x80109070 //Waluigi Island Current Roulette Speed Read Address
li a1, 0x24150008 //Speed of Current Waluigi Island Roulette 
sw a1, 0(a0) //Update Waluigi Island Current Roulette Speed Read

@@endcheat:
lastsym: //Required End Symbol

.close

; Copyright Piranha 1986, CMTB Animation, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g.
; Print_HighScore_Loop.

> $4000 @org=$4000
> $4000 @start
> $4000 @expand=#IF({asm})(#DEF(#FLUNKY(addr)(link=Flunky)$link))
> $4000 @expand=#IF({asm}==0)(#DEF1(#FLUNKY(addr)#HTML(<a href="/flunky/#IF({{mode[base]}}==16)(,dec/)asm/#IF({{mode[base]}}==16)(#EVAL({addr},16,4),#EVAL({addr})).html">Flunky</a>)))
> $4000 @expand=#DEF1(#SKOOLKID(addr,anchor=0)(name)#HTML(<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/#IF({{mode[base]}}==16)(hex/)asm/#IF({{mode[base]}}==16)(#EVAL({addr},16,4),#EVAL({addr})).html#IF({anchor})(#CHR(35)#IF({{mode[base]}}==16)(#EVAL({anchor},16,4),#EVAL({anchor})))">){name}#HTML(</a>))
b $4000 Loading Screen
@ $4000 label=Loading
D $4000 #UDGTABLE { =h The Trap Door Loading Screen. } { #SCR$02(loading) }
. UDGTABLE#
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

i $5B00

t $5F65 Tape Header Remnant
@ $5F65 label=TapeHeaderRemnant
D $5F65 Leftover tape header name "TRAPDOOR".
  $5F65,$0A "TRAPDOOR".

i $5F6F

b $636D Data: Display Buffer Scratch
@ $636D label=Data_DisplayBufferScratch
D $636D Small block of non-zero data immediately before the primary display
. buffer.
  $636D,$33

b $63A0 Primary Display Buffer
@ $63A0 label=PrimaryDisplayBuffer
D $63A0 #N$0780-byte off-screen display buffer. Swapped with #R$6B20 via
. #R$72EA.
  $63A0,$0780

b $6B20 Secondary Display Buffer
@ $6B20 label=SecondaryDisplayBuffer
D $6B20 Off-screen display buffer (to #R$729F). In this snapshot the
. menu-music source at #R$6F04 occupies the upper part of this region
. until #R$AAB3 relocates it to #R$FC6C and the buffer is cleared.
  $6B20,$03E4

b $6F04 Menu Music Source
@ $6F04 label=MenuMusicSource
D $6F04 Source copy of the menu-music and key-wait code. #R$AAB3 copies
. #N$0393 bytes from here to #R$FC6C and then calls it. See #R$FC6C for
. the annotated disassembly of these bytes after relocation. The final
. nine bytes are the leftover filename at #R$728E.
  $6F04,$038A Menu-music source bytes before the leftover filename (relocated to
. #R$FC6C).

t $728E Leftover: @Music.en
@ $728E label=Leftover_MusicEn
D $728E Nine bytes <code>@Music.en</code> left at the end of the #R$6F04.
. #R$AAB3 copies these bytes to #R$FFF6 along with the rest of the
. block; they are never used as a message.
  $728E,$09 "#STR(#PC,$04,$09)".

u $7297 Secondary Display Buffer (Tail)
@ $7297 label=SecondaryDisplayBuffer_Tail
D $7297 Final bytes of the secondary display buffer after the menu-music source.
  $7297,$09

c $72A0 Game Start Alias
@ $72A0 label=Alias_GameStart
D $72A0 Jump to #R$AAB3.
  $72A0,$03 Jump to #R$AAB3 to restart the game.

g $72A3 Copy Length: Entity State Data
@ $72A3 label=CopyLength_EntityStateData
D $72A3 Byte count used when copying entity state data during initialisation /
. room changes.
W $72A3,$02

g $72A5 Copy Length: Game State
@ $72A5 label=CopyLength_GameState
D $72A5 Byte count used when copying game-state data during initialisation /
. room changes.
W $72A5,$02

g $72A7 Pointer: Entity State Backup End
@ $72A7 label=Pointer_EntityStateBackupEnd
D $72A7 End pointer for the entity-state backup region used by copy routines.
W $72A7,$02

g $72A9 Flag: Learner Berk Mode
@ $72A9 label=Flag_LearnerBerkMode
D $72A9 Set by the main menu (#R$F43D): #N$00 = Super Berk, #N$01 = Learner
. Berk. #R$DE19 uses this to choose the rating message at #R$DDB4.
B $72A9,$01

g $72AA Pointer: Last Collided Entity
@ $72AA label=Pointer_LastCollidedEntity
D $72AA Address of the complex state data for the entity involved in the
. last collision / interaction check. Written by the collision helpers at
. #R$F2B2, #R$F31F, #R$F381 and #R$F3E3; read as #REGix / #REGiy / #REGbc
. throughout Berk's movement and pick-up / put-down logic.
W $72AA,$02

g $72AC Pointer: Current Entity
@ $72AC label=Pointer_CurrentEntity
D $72AC Address of the complex state data for the entity currently being
. processed (usually Berk). Often the entity Berk is holding when bit #N$04
. of Berk's flags byte 3 (#REGix+#N$03) is set.
W $72AC,$02

g $72AE Current Task Index
@ $72AE label=CurrentTaskIndex
D $72AE Index of the current Bad Tempered Thing task (meal request).
B $72AE,$01

g $72AF Current Task Phase
@ $72AF label=CurrentTaskPhase
D $72AF Phase / sub-step within the current task.
B $72AF,$01

g $72B0 Dialogue Line Index
@ $72B0 label=DialogueLineIndex
D $72B0 Index of the current dialogue / message line.
B $72B0,$01

g $72B1 Pointer: Berk Script Position
@ $72B1 label=Pointer_BerkScriptPosition
D $72B1 Pointer into Berk's current script data stream.
W $72B1,$02

g $72B3 Game Event Flags
@ $72B3 label=GameEventFlags
D $72B3 Cross-cutting event bits for trap door and task state.
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$00 | Room / script event raised (set by helpers such as #R$EF49) }
. { #N$01 | Trap door is open / trap door event armed }
. { #N$02 | Falling-entity latch (cleared/set by #R$B1A9) }
. { #N$03 | Object has been offered to the trap (Bad Tempered Thing path) }
. { #N$04 | Task-two / upstairs event latch }
. { #N$05 | Reserved / unused in the observed call sites }
. { #N$06 | Special put-down / room-transition event }
. { #N$07 | Task entity script is active }
. TABLE#
B $72B3,$01

g $72B4 Task Status Flags
@ $72B4 label=TaskStatusFlags
D $72B4 Per-task status bits (Drutt / collectible progress and dialogue gates).
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$00 | Task progress / dialogue gate }
. { #N$01 | Timed Berk event pending }
. { #N$04 | Drutt collected a type-#N$18 object }
. { #N$05 | Drutt collected a type-#N$1C object }
. { #N$06 | Berk action / eat latch }
. { #N$07 | Berk script / dialogue busy }
. TABLE#
B $72B4,$01

g $72B5 Task Two Flags
@ $72B5 label=TaskTwoFlags
D $72B5 Flags for the "Thing Upstairs" (task two) state machine.
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$01 | Task-two script should advance }
. { #N$02 | Spawn / random-walk latch for the upstairs helper }
. { #N$03 | Helper entity needs its layout restoring }
. { #N$04 | Task-two helper busy }
. { #N$05 | Task-two helper secondary latch }
. { #N$06 | Task-two room-transition latch }
. { #N$07 | Task-two entity script active }
. TABLE#
B $72B5,$01

g $72B6 Task Three Flags
@ $72B6 label=TaskThreeFlags
D $72B6 Flags for the task-three (boiled slimies / feeding) state machine.
. Bit names below are taken from the Bad Tempered Thing dialogue gates and
. the stove / put-down writers that set or clear them.
. #TABLE(default,centre,centre,centre)
. { =h Bit | =h Name | =h Set / clear }
. { #N$00 | MobileHeater | no SET/RES site found }
. { #N$01 | Slimies | set by #R$F110; tested by #R$D901 }
. { #N$02 | SlimyLoose | set by #R$B401 / #R$C6FC; cleared by #R$C63B }
. { #N$04 | BoilEmUp | set by #R$C5D2; cleared by #R$C63B; tested by #R$D927 }
. { #N$05 | BoilEmUpLatch | set by #R$C5D2; cleared by #R$C63B / #R$C397 }
. { #N$06 | StoveReady | set by #R$C63B when #R$72BE reaches #N$04 }
. { #N$07 | StoveUpdated | set by #R$C63B; tested by #R$C5D2 }
. TABLE#
N $72B6 Bit #N$00 (MobileHeater) gates #R$DC08 ("Mobile Heater") / #R$DC18
. ("The Stove's No Help", #R$D921); no SET/RES site found.
N $72B6 Bit #N$01 (Slimies) gates #R$DBC4 ("Slimies"); set by #R$F110 on
. put-down of type #N$09; tested by #R$D901.
N $72B6 Bit #N$02 (SlimyLoose) gates #R$DBCD ("Slimy Loose !"); set by
. #R$B401 / #R$C6FC; cleared by #R$C63B; if set, #R$D907 skips the line.
N $72B6 Bit #N$04 (BoilEmUp) gates #R$DC2C ("Boil'Em Up !") / #R$DC3B
. ("Flame ?"); set by #R$C5D2 with #N$05; cleared by #R$C63B; tested by
. #R$D927.
N $72B6 Bit #N$05 (BoilEmUpLatch) is the companion set with BoilEmUp by
. #R$C5D2; cleared by #R$C63B / #R$C397; no BIT reader found.
N $72B6 Bit #N$06 (StoveReady) gates #R$DBDE ("Too Soon ?") / #R$DBEB ("Hot
. Stuff", #R$D915) and #R$DBF5 ("Got All Slimies ?", #R$D91B); set by #R$C63B
. when #R$72BE reaches #N$04.
N $72B6 Bit #N$07 (StoveUpdated) is set by #R$C63B; tested by #R$C5D2 before
. it sets BoilEmUp / BoilEmUpLatch and swaps the cauldron layout.
B $72B6,$01

u $72B7
B $72B7,$01

g $72B8 Task One / Collision Flags
@ $72B8 label=TaskOneCollisionFlags
D $72B8 Flag byte for task-one progress messages (#R$E24E) and the type-#N$08 /
. type-#N$0B collision latch at #R$D446.
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$06 | Third consecutive #R$D446 collision (cleared by #R$EDB8) }
. { #N$07 | Collision seen this check (#R$D446) }
. TABLE#
B $72B8,$01

g $72B9 Entity Interaction Flag
@ $72B9 label=EntityInteractionFlag
D $72B9 Cross-cutting interaction bits for crushers, ghosts and hazards.
. Meanings below are from observed writers/readers only.
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$01 | Set by #R$B34B; tested by #R$D93E }
. { #N$02 | Set/cleared by #R$CBCE; tested by #R$D95C to gate dialogue }
. { #N$03 | Set by #R$CEBD; tested and cleared by #R$CE4B }
. { #N$04 | Set by #R$CF1E; tested by #R$D944 to gate dialogue }
. { #N$06 | Set by #R$CF1E when #R$72C2 reaches #N$03; no BIT reader found }
. { #N$07 | Set by #R$CF1E on every crusher update; no BIT reader found }
. TABLE#
N $72B9 Bit #N$01 is set by #R$B34B; tested by #R$D93E to gate Bad Tempered
. Thing dialogue.
B $72B9,$01

g $72BA Trap Door Flags
@ $72BA label=TrapDoorFlags
D $72BA Animation and interaction bits for the trap door itself.
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$01 | Weight-chain layout swap pending }
. { #N$02 | Drutt is mid trap door animation }
. { #N$03 | Trap door is open for Berk's put-down check }
. TABLE#
B $72BA,$01

g $72BB Drutt Animation Counter
@ $72BB label=DruttAnimationCounter
D $72BB Frame counter driving Drutt's animation.
B $72BB,$01

g $72BC Collectible Counter
@ $72BC label=CollectibleCounter
D $72BC Count of collectible eyeballs gathered so far.
B $72BC,$01

g $72BD Collision Scratch Byte
@ $72BD label=CollisionScratchByte
D $72BD Byte used by collision / collectible helpers (#R$D446,
. #R$D7D3) to remember a room index or entity field across a call.
B $72BD,$01

g $72BE Stove Tick
@ $72BE label=StoveTick
D $72BE How many times #R$C63B Update Stove has run this boil cycle. On the
. fourth call that routine sets StoveReady (bit #N$06 of #R$72B6).
B $72BE,$01

g $72BF Room Transition Flag
@ $72BF label=RoomTransitionFlag
D $72BF Non-zero while a room transition is in progress.
B $72BF,$01

g $72C0 Entity Spawn Timer
@ $72C0 label=EntitySpawnTimer
D $72C0 Countdown / tick used when spawning transient entities.
B $72C0,$01

g $72C1 Animation Frame Counter
@ $72C1 label=AnimationFrameCounter
D $72C1 Shared animation frame counter for scripted entities.
B $72C1,$01

g $72C2 Shared Tick
@ $72C2 label=SharedTick
D $72C2 One-byte counter shared by #R$CF1E (increments on each crusher update)
. and script routine #R$CBCE (decrements toward zero). Not a pure frame
. counter: #R$CF1E advances it once per crusher call, and when the value
. reaches #N$03 that routine also sets bits #N$06 and #N$07 of #R$72B9.
B $72C2,$01

g $72C3 Task Three Timer
@ $72C3 label=TaskThreeTimer
D $72C3 Countdown timer for task-three creature behaviour.
B $72C3,$01

g $72C4 Stove / Heater State
@ $72C4 label=StoveHeaterState
D $72C4 State of the stove / heater prop.
B $72C4,$01

g $72C5 Message Trigger
@ $72C5 label=MessageTrigger
D $72C5 Latch that triggers the next on-screen message.
B $72C5,$01

g $72C6 Frame Counter
@ $72C6 label=FrameCounter
D $72C6 Global frame counter advanced by the main loop.
B $72C6,$01

g $72C7 Bad Tempered Thing State
@ $72C7 label=BadTemperedThingState
D $72C7 State flags for the Bad Tempered Thing.
B $72C7,$01

g $72C8 Berk Action Lock
@ $72C8 label=BerkActionLock
D $72C8 Lock that prevents Berk starting a new action until cleared.
B $72C8,$01

g $72C9 Task Selection Table
@ $72C9 label=TaskSelectionTable
D $72C9 Bit #N$07 marks a task slot as used. Task #N$05 is chosen separately at
. #R$AC10.
B $72C9,$01 Task 01 (value not read; bit #N$07 set once used).
B $72CA,$01 Task 02.
B $72CB,$01 Task 03.
B $72CC,$01 Task 04.
B $72CD,$01 Wrap marker (bit #N$06 set).

g $72CE Timed Event Latch
@ $72CE label=TimedEventLatch
D $72CE Non-zero while a timed Drutt / trap door script is armed. Set to #N$01
. by #R$F1DF, written from an entity type at #R$ADED,
. cleared by #R$ADA1, and tested by #R$AC48 / #R$B973 before those paths run.
B $72CE,$01

g $72CF Pointer: Active Script Cursor
@ $72CF label=Pointer_ActiveScriptCursor
D $72CF Live script-data cursor while a task / entity script runs. Task updaters
. copy their dedicated script position (#R$72D1 / #R$72D3 / #R$72D5 / #R$72D7 /
. #R$72D9 / #R$72B1) here, call the shared runner, then write the (possibly
. advanced) cursor back.
W $72CF,$02

g $72D1 Pointer: Task Three Script Position
@ $72D1 label=Pointer_TaskThreeScriptPosition
D $72D1 Pointer into task-three script data.
W $72D1,$02

g $72D3 Pointer: Drutt Script Position
@ $72D3 label=Pointer_DruttScriptPosition
D $72D3 Pointer into Drutt script data.
W $72D3,$02

g $72D5 Pointer: Task Two Script Position
@ $72D5 label=Pointer_TaskTwoScriptPosition
D $72D5 Pointer into task-two script data.
W $72D5,$02

g $72D7 Pointer: Task Four Script Position
@ $72D7 label=Pointer_TaskFourScriptPosition
D $72D7 Pointer into task-four script data.
W $72D7,$02

g $72D9 Pointer: Thing Upstairs Script Position
@ $72D9 label=Pointer_ThingUpstairsScriptPosition
D $72D9 Script cursor for complex entity slot #N$20 when its type is
. #N$22. Written by #R$BDBA / #R$BC2B; read by #R$BC1F.
W $72D9,$02

g $72DB Pointer: Berk Held Entity
@ $72DB label=Pointer_BerkHeldEntity
D $72DB Pointer to the entity Berk is currently holding.
W $72DB,$02

g $72DD Score
@ $72DD label=Score
D $72DD Current score.
W $72DD,$02

g $72DF Collectible Slot State
@ $72DF label=CollectibleSlotState
D $72DF Three 3-byte records used by #R$D45B Update Collectibles. Each record is
. a script-position word plus a per-slot counter; #R$D45B walks the table,
. copies a record through #R$72CF / #R$72BC, calls #R$D48E, then writes the
. updated values back.
B $72DF,$09,$03

g $72E8 Saved Room Index
@ $72E8 label=SavedRoomIndex
D $72E8 Room index remembered by #R$ED36 while Berk opens a door behind him.
. Also used by #R$AFC5 as the exclusive end address when measuring the
. #R$72AE…#R$72DF(#N$72E7) game-state backup length into #R$72A5.
B $72E8,$01

g $72E9 Held Entity Y-Extent
@ $72E9 label=HeldEntityYExtent
D $72E9 Y-extent to restore onto a held entity. Written by #R$B6D8 as the
. collision partner's y−#N$01 during Berk's put-down / pick-up probe; read and
. cleared by #R$F13E when applying the held entity's new y / y-extent.
B $72E9,$01

g $72EA Display Buffer Select Flag
@ $72EA label=DisplayBufferSelectFlag
D $72EA Selects which display buffer is active when swapping primary /
. secondary.
B $72EA,$01

g $72EB Message Colour
@ $72EB label=MessageColour
D $72EB Attribute used when printing messages.
B $72EB,$01

g $72EC Door Interaction Delay
@ $72EC label=DoorInteractionDelay
D $72EC Short countdown used by #R$ECDB. Set to #N$01–#N$02 at #R$ED9B after a
. room change; while non-zero #R$ED19 decrements it and skips the rest of that
. interaction pass.
B $72EC,$01

g $72ED Camera Y Coordinate
@ $72ED label=CameraYCoordinate
D $72ED Camera Y coordinate.
B $72ED,$01

g $72EE Camera X Coordinate
@ $72EE label=CameraXCoordinate
D $72EE Camera X coordinate.
B $72EE,$01

u $72EF
B $72EF,$01

g $72F0 Task Timer
@ $72F0 label=TaskTimer
D $72F0 Task timer. Incremented at #R$AC65. #R$AC69 compares it with #N$A0
. for the timeout path. #R$ACA2 also reads it for the status attribute strip.
. Reset to #N$00 at #R$AD48. Not the pseudo-random seed at #R$EAE2.
B $72F0,$01

g $72F1 Task Progress Repeat Count
@ $72F1 label=TaskProgressRepeatCount
D $72F1 Cleared at #R$E2A4 and loaded at #R$E2C6 from the byte at the address
. the message stream names. #R$AE6A returns if it is zero. Otherwise each
. pass of the loop at #R$AEAF sets the bonus at #R$72DB, reprints it and
. calls #R$AECC.
B $72F1,$01

g $72F2 Game Tick Counter
@ $72F2 label=GameTickCounter
D $72F2 Game tick counter.
B $72F2,$01

g $72F3 High Score
@ $72F3 label=HighScore
D $72F3 High score.
W $72F3,$02

g $72F5 Pointer: Current Display Buffer
@ $72F5 label=Pointer_CurrentDisplayBuffer
D $72F5 Pointer to the current display-buffer base used while drawing layouts.
W $72F5,$02

g $72F7 Stored Drawing Coordinates
@ $72F7 label=StoredDrawingCoordinates
D $72F7 Base x/y character coordinates used while processing graphic layout data
. (#REGh = x, #REGl = y).
W $72F7,$02

g $72F9 Pointer: Current Character Set
@ $72F9 label=Pointer_CurrentCharacterSet
D $72F9 Pointer to the character set currently used for text output.
W $72F9,$02

g $72FB Pointer: Camera Room Origin
@ $72FB label=Pointer_CameraRoomOrigin
D $72FB Pointer to the camera room origin used while drawing.
W $72FB,$02

g $72FD Pointer: Script Loop Restart
@ $72FD label=Pointer_ScriptLoopRestart
D $72FD Script-data address saved by #R$EC53 so #R$EC61 (End Script Loop) can
. reload #REGhl and repeat the body while #R$7301 remains non-zero.
W $72FD,$02

g $72FF Pointer: Graphic Layout Loop Start
@ $72FF label=Pointer_GraphicLayoutLoopStart
D $72FF Saved position in graphic layout data at the start of a loop (opcodes
. #N$EE / #N$EF).
W $72FF,$02

g $7301 Script Loop Counter
@ $7301 label=ScriptLoopCounter
D $7301 Remaining iterations for a script-level loop. Loaded from the operand of
. #R$EC53; decremented by #R$EC61 until it hits zero.
B $7301,$01

g $7302 Graphic Layout Loop Counter
@ $7302 label=GraphicLayoutLoopCounter
D $7302 Remaining iterations for the current graphic layout loop (opcodes
. #N$EE / #N$EF).
B $7302,$01

g $7303 Berk X Coordinate Copy
@ $7303 label=BerkXCoordinateCopy
D $7303 Copy of Berk's X coordinate used by camera-follow logic.
B $7303,$01

g $7304 Berk X-Extent Copy
@ $7304 label=BerkXExtentCopy
D $7304 Copy of the camera-follow entity's x-extent (#REGix+#N$08), written by
. #R$B41A alongside #R$7303. Not a Y coordinate.
B $7304,$01

g $7305 Berk Room Index Copy
@ $7305 label=BerkRoomIndexCopy
D $7305 Copy of Berk's room index used by camera-follow logic.
B $7305,$01

g $7306 Current Graphic Set Index
@ $7306 label=CurrentGraphicSetIndex
D $7306 Index of the graphic set currently selected by graphic layout opcode
. #N$F4. Written into the display buffer with each tile; #R$E9EF looks up the
. set base in #R$730B.
B $7306,$01

g $7307 Current Text Attribute
@ $7307 label=CurrentTextAttribute
D $7307 Attribute applied when printing menu / HUD text.
B $7307,$01

g $7308 Current Attribute
@ $7308 label=CurrentAttribute
D $7308 Attribute byte currently selected by graphic layout opcode #N$F2.
. Written into the display buffer with each tile; #N$00 means "use the
. attribute from the graphic data".
B $7308,$01

g $7309 Pending Sound Index
@ $7309 label=PendingSoundIndex
D $7309 Sound index queued by #R$F8F9 for #R$F9AF (#N$00 = idle). Bit #N$07
. marks a force-queue from #R$F8F9.
B $7309,$01

g $730A Camera Follow Delay
@ $730A label=CameraFollowDelay
D $730A Camera-follow delay countdown.
B $730A,$01

w $730B Table: Addresses of Graphic Sets
@ $730B label=Table_GraphicSetAddresses
D $730B Base addresses for graphic sets #N$00–#N$06. #R$E9EF indexes this table
. with (set × #N$02) when blitting a display-buffer tile. Layout opcode
. #N$F4 writes the set index to #R$7306. Index #N$00 is a never-selected
. placeholder so the live sets stay on #N$01–#N$06 matching the #N$F4
. operands. #N$F4 never selects set #N$00.
. #TABLE(default,centre,centre,centre,centre)
. { =h Set | =h Base | =h Tiles | =h Notes }
. { #N$00 | #N($0000,$04,$04) | — | Placeholder }
. { #N$01 | #R$7C51 | #N$B3 | Room scenery / props }
. { #N$02 | #R$81E9 | #N$8F | Shared scenery tiles }
. { #N$03 | #R$7419 | #N$A8 | Berk, Drutt, doors, most entities }
. { #N$04 | #R$7959 | #N$5F | Additional scenery }
. { #N$05 | #R$8661 | #N$65 | Trap door / scenery variants }
. { #N$06 | #R$8989 | #N$3C | Extra tiles }
. TABLE#
W $730B,$02 Graphics set #N$00: placeholder (never selected by #N$F4; base
. #N($0000,$04,$04)).
W $730D,$02 Graphics set #N$01: room scenery / props; see #R$7C51.
W $730F,$02 Graphics set #N$02: shared scenery tiles; see #R$81E9.
W $7311,$02 Graphics set #N$03: Berk, Drutt, doors, most entities; see #R$7419.
W $7313,$02 Graphics set #N$04: additional scenery; see #R$7959.
W $7315,$02 Graphics set #N$05: trap door / scenery variants, see #R$8661.
W $7317,$02 Graphics set #N$06: extra tiles; see #R$8989.

b $7319 Bitmap Mirror Image Lookup Table
@ $7319 label=BitmapMirrorLookup
D $7319 Lookup table used by #R$EA23 to reverse the bits in a bitmap byte when
. horizontally mirroring a graphic tile (attribute bit #N$07 set in the
. display-buffer entry).
  $7319,$0100,$08

b $7419 Graphics: Set #N$03
@ $7419 label=Graphics_Set03
D $7419 Primary entity graphic set (Berk, Drutt, doors, collectibles and most
. interactive props). Selected by layout opcode #N$F4 with index #N$03; base
. address held at #R$7311.
  $7419,$08 #UDGTABLE(default,centre,centre)
.   { #N((#PC-$7419)/$08) | #UDG(#PC) } UDGTABLE#
L $7419,$08,$A8

b $7959 Graphics: Set #N$04
@ $7959 label=Graphics_Set04
D $7959 Additional scenery graphic set. Base address at #R$7313.
  $7959,$08 #UDGTABLE(default,centre,centre,centre)
.   { #N((#PC-$7959)/$08) | #UDG(#PC) }
. UDGTABLE#
L $7959,$08,$5F

b $7C51 Graphics: Set #N$01
@ $7C51 label=Graphics_Set01
D $7C51 Room-scenery graphic set. Selected by layout opcode #N$F4 with index
. #N$01; base address at #R$730D.
  $7C51,$08 #UDGTABLE(default,centre,centre)
.   { #N((#PC-$7C51)/$08) | #UDG(#PC) }
. UDGTABLE#
L $7C51,$08,$B3

b $81E9 Graphics: Set #N$02
@ $81E9 label=Graphics_Set02
D $81E9 Shared scenery / prop graphic set. Selected by layout opcode #N$F4
. with index #N$02; base address at #R$730F.
  $81E9,$08 #UDGTABLE(default,centre,centre)
.   { #N((#PC-$81E9)/$08) | #UDG(#PC) }
. UDGTABLE#
L $81E9,$08,$8F

b $8661 Graphics: Set #N$05
@ $8661 label=Graphics_Set05
D $8661 Trap door / scenery-variant graphic set. Selected by layout opcode
. #N$F4 with index #N$05; base address at #R$7315.
  $8661,$08 #UDGTABLE(default,centre,centre)
.   { #N((#PC-$8661)/$08) | #UDG(#PC) }
. UDGTABLE#
L $8661,$08,$65

b $8989 Graphics: Set #N$06
@ $8989 label=Graphics_Set06
D $8989 Extra graphic tiles.
  $8989,$08 #UDGTABLE(default,centre,centre)
.   { =h #N((#PC-$8989)/$08) | #UDG(#PC) }
. UDGTABLE#
L $8989,$08,$3C

b $8B69 State Data: Simple Entities
@ $8B69 label=StateData_SimpleEntities
D $8B69 Table of simple entity state records (#N($000E,$04,$04) bytes
. each; #N$40 entries). Field names follow readers: flags byte 1 at
. #R$F2EA (#REGix+#N$01), flags byte 2 at #R$B1BE (#REGix+#N$02),
. flags byte 3 at #R$B440 (#REGix+#N$03), plus room/position readers
. at #R$E6E4 / #R$E71D / #R$F2FA / #R$F301 / #R$F30F, direction / state at
. #R$B344 / #R$B617, and extra state at #R$B3A9 / #R$CB1E / #R$CB44. The
. table ends on a type byte of #N$FF (tested at #R$F2D2), not on the final
. word of each record.
N $8B69 Blue staircase (type #N($32), room #N($00), layout #R$A839).
N $8B77 Blue staircase (type #N($32), room #N($00), layout #R$A839).
N $8B85 Blue staircase (type #N($32), room #N($00), layout #R$A839).
N $8B93 Blue staircase (type #N($32), room #N($00), layout #R$A839).
N $8BA1 Blue staircase (type #N($32), room #N($00), layout #R$A839).
N $8BAF Blue staircase (type #N($32), room #N($00), layout #R$A839).
N $8BBD Blue staircase (type #N($50), room #N($00), layout #R$A839).
N $8BCB Swamp wrap scenery (type #N($32), room #N($00), layout #R$A929)
. at x #N$EA-#N$FF.
N $8BD9 Scenery decor (type #N($36), room #N($00), layout #R$A64F).
N $8BE7 Scenery decor (type #N($36), room #N($00), layout #R$A64F).
N $8BF5 Shared tile (type #N($66), room #N($00), layout #R$A272).
N $8C03 Scenery block (type #N($32), room #N($01), layout #R$A2A8).
N $8C11 Scenery block (type #N($32), room #N($01), layout #R$A2F1).
N $8C1F Scenery block (type #N($32), room #N($01), layout #R$A28B).
N $8C2D Platform / ledge (type #N($64), room #N($01), layout #R$A272).
N $8C3B Platform / ledge (type #N($64), room #N($01), layout #R$A272).
N $8C49 Scenery block (type #N($32), room #N($01), layout #R$A5E9).
N $8C57 Platform / ledge (type #N($64), room #N($01), layout #R$A5B6).
N $8C65 Scenery block (type #N($32), room #N($01), layout #R$A5B6).
N $8C73 Scenery block (type #N($32), room #N($01), layout #R$A5E9).
N $8C81 Scenery block (type #N($32), room #N($01), layout #R$A2F1).
N $8C8F Platform / ledge (type #N($64), room #N($01), layout #R$A272).
N $8C9D Scenery block (type #N($32), room #N($01), layout #R$A6BB).
N $8CAB Platform / ledge (type #N($64), room #N($01), layout #R$A5B6).
N $8CB9 Scenery block (type #N($32), room #N($01), layout #R$A5B6).
N $8CC7 Scenery decor (type #N($36), room #N($01), layout #R$A64F).
N $8CD5 Scenery decor (type #N($36), room #N($01), layout #R$A64F).
N $8CE3 Scenery decor (type #N($36), room #N($01), layout #R$A64F).
N $8CF1 Scenery block (type #N($32), room #N($01), layout #R$A8CC).
N $8CFF Scenery block (type #N($32), room #N($01), layout #R$A237).
N $8D0D Scenery block (type #N($32), room #N($01), layout #R$A65B).
N $8D1B Scenery decor (type #N($36), room #N($01), layout #R$A6AC).
N $8D29 Scenery block (type #N($32), room #N($01), layout #R$A2F6).
N $8D37 Scenery block (type #N($32), room #N($01), layout #R$A2F1).
N $8D45 Scenery block (type #N($32), room #N($01), layout #R$A8F6).
N $8D53 Platform / ledge (type #N($64), room #N($01), layout #R$A272).
N $8D61 Scenery block (type #N($32), room #N($01), layout #R$A28B).
N $8D6F Stove lit (type #N($15), room #N($02), layout #R$9FDC).
N $8D7D Dumb waiter (type #N($3D), room #N($00), layout #R$A7DA). The
. extra-state word at #R$8D89 is the trap door entity pointer (see #R$ADA6).
N $8D8B Lever scenery (type #N($38), room #N($01), layout #R$A827).
N $8D99 Scenery block (type #N($32), room #N($01), layout #R$A90B).
N $8DA7 Scenery block (type #N($32), room #N($01), layout #R$A273).
N $8DB5 Mossy arch (type #N($68), room #N($01), layout #R$A77A).
N $8DC3 Green arch bottom (type #N($64), room #N($01), layout #R$A4BD).
N $8DD1 Scenery block (type #N($32), room #N($01), layout #R$A2F1).
N $8DDF Platform / ledge (type #N($64), room #N($01), layout #R$A272).
N $8DED Green arch bottom (type #N($32), room #N($01), layout #R$A4BD).
N $8DFB Platform / ledge (type #N($64), room #N($01), layout #R$A272).
N $8E09 Scenery block (type #N($32), room #N($01), layout #R$A8CC).
N $8E17 Room-five platform stub (type #N($33), room #N($05), layout #R$A272).
N $8E25 Room-five platform stub (type #N($33), room #N($05), layout #R$A272).
N $8E33 Scenery block (type #N($32), room #N($01), layout #R$A272).
N $8E41 Shared-tile stub (type #N($33), room #N($01), layout #R$A272).
N $8E4F Green arch top (type #N($32), room #N($01), layout #R$A46C).
N $8E5D Green arch bottom (type #N($32), room #N($01), layout #R$A4BD).
N $8E6B Scenery block (type #N($32), room #N($01), layout #R$A5E9).
N $8E79 Platform / ledge (type #N($64), room #N($01), layout #R$A5B6).
N $8E87 Open/close stamp slot (type #N($B2), room #N($02), layout #R$A453).
N $8E95 Open/close stamp slot (type #N($B2), room #N($03), layout #R$A272).
N $8EA3 Open/close stamp slot (type #N($B2), room #N($03), layout #R$A272).
N $8EB1 Open/close stamp slot (type #N($B2), room #N($04), layout #R$A426).
N $8EBF Open/close stamp slot (type #N($B2), room #N($04), layout #R$A272).
N $8ECD Trap door hatch (type #N($3A), room #N($02), layout #R$A3F3).
N $8EDB Scenery block (type #N($32), room #N($04), layout #R$A3D8).
  $8B69,$01 Type: #N(#PEEK(#PC)).
  $8B6A,$01 Flags byte 1: #N(#PEEK(#PC)).
  $8B6B,$01 Flags byte 2: #N(#PEEK(#PC)).
  $8B6C,$01 Flags byte 3: #N(#PEEK(#PC)).
  $8B6D,$01 Room: #N(#PEEK(#PC)).
  $8B6E,$01 Y coordinate: #N(#PEEK(#PC)).
  $8B6F,$01 Y extent: #N(#PEEK(#PC)).
  $8B70,$01 X coordinate: #N(#PEEK(#PC)).
  $8B71,$01 X extent: #N(#PEEK(#PC)).
  $8B72,$01 Direction / state: #N(#PEEK(#PC)).
W $8B73,$02 Layout: #R(#PEEK(#PC)+#PEEK(#PC+$01)*$0100).
W $8B75,$02 Extra state.
L $8B69,$0E,$40,$02

b $8EE9 State Data: Complex Entities
@ $8EE9 label=StateData_ComplexEntities
D $8EE9 Table of complex entity state records (#N($000E,$04,$04) bytes each).
. Backed up to #R$FA0E by #R$AFA9.
. Field layout: #N$00 type; #N$01–#N$03 flags; #N$04 room
. #N$05/#N$06 y and y-extent; #N$07/#N$08 x and x-extent
. #N$09 direction/state; #N$0A/#N$0B graphic layout pointer
. #N$0C/#N$0D extra state.
. Flags byte 3 at offset #N$03 (#REGix+#N$03) for Berk and most movers:
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$00 | Script-locked (ignore input; also set while facing / moving up) }
. { #N$01 | Facing left (reset = facing right) }
. { #N$02 | Mid-interaction / push latch }
. { #N$03 | Bit #N$03 of flags byte 3 }
. { #N$04 | Bit #N$04 of flags byte 3 (see #R$F0F2 / #R$F13E) }
. { #N$05 | Bit #N$05 of flags byte 3 }
. { #N$06 | Can-fall / gravity latch }
. { #N$07 | Rising / special vertical-state latch }
. TABLE#
. Direction / state at offset #N$09: #N$01 face left, #N$02 face right,
. #N$04 face down, #N$08 face up (see script routines #R$EF5B–#R$EF70).
@ $8EE9 label=StateData_Boney
  $8EE9,$0A Boney (type #N($01), room #N($01), layout #R$9C9E). First #N$0A
. state bytes.
g $8EF3 Pointer: Boney Graphic Layout
@ $8EF3 label=Pointer_BoneyGraphicLayout
D $8EF3 Current graphic layout pointer for Boney (entity field #REGix+#N$0A).
. The snapshot holds #R$9C9E (Boney's skull). #R$D82F / #R$DA04 restore
. #R$9C9E after Bad Tempered Thing dialogue.
W $8EF3,$02
B $8EF5,$02 Remaining Boney entity state bytes after the layout pointer.
@ $8EF7 label=StateData_Drutt
  $8EF7,$0E Drutt (type #N($87), room #N($05), layout #R$9E37 (the bullet)).
. Drutt's script and animation data is at #R$D234.
@ $8F05 label=StateData_Complex_02
  $8F05,$0E Inactive slot (type #N($00), room #N$04).
@ $8F13 label=StateData_Complex_03
  $8F13,$0E Slimies (type #N($89), room #N($05), layout #R$A1F8).
@ $8F21 label=StateData_Complex_04
  $8F21,$0E Slimies (type #N($89), room #N($05), layout #R$A1F8).
@ $8F2F label=StateData_Complex_05
  $8F2F,$0E Slimies (type #N($89), room #N($05), layout #R$A1F8).
@ $8F3D label=StateData_Complex_06
  $8F3D,$0E Slimies (type #N($89), room #N($05), layout #R$A1F8).
@ $8F4B label=StateData_Complex_07
  $8F4B,$0E Collectible eyeball (type #N($8D), room #N($00), layout #R$A033).
@ $8F59 label=StateData_Complex_08
  $8F59,$0E Collectible eyeball (type #N($8D), room #N($00), layout #R$A033).
@ $8F67 label=StateData_Complex_09
  $8F67,$0E Collectible eyeball (type #N($8D), room #N($00), layout #R$A033).
@ $8F75 label=StateData_Complex_10
  $8F75,$0E Plant pot (type #N($0F), room #N($04), layout #R$A082).
@ $8F83 label=StateData_Complex_11
  $8F83,$0E Plant pot (type #N($0F), room #N($03), layout #R$A082).
@ $8F91 label=StateData_Complex_12
  $8F91,$0E Plant pot (type #N($0F), room #N($04), layout #R$A082).
@ $8F9F label=StateData_Complex_13
  $8F9F,$0E Inactive slot (type #N($00), room #N$00).
@ $8FAD label=StateData_Complex_14
  $8FAD,$0E Inactive slot (type #N($00), room #N$00).
@ $8FBB label=StateData_Complex_15
  $8FBB,$0E Inactive slot (type #N($00), room #N$00).
@ $8FC9 label=StateData_Complex_16
  $8FC9,$0E Crusher / hazard (type #N($0C), room #N($05), layout #R$D234).
@ $8FD7 label=StateData_Complex_17
  $8FD7,$0E White orb helper (type #N($86), room #N($03), layout #R$9DB3).
@ $8FE5 label=StateData_Complex_18
  $8FE5,$0E Task-three entity (type #N($A1), room #N($03), layout #R$C102).
@ $8FF3 label=StateData_Complex_19
  $8FF3,$0E Task-three entity (type #N($A3), room #N($03), layout
. #R$CCBA).
@ $9001 label=StateData_Complex_20
  $9001,$0E Inactive slot (type #N($00), room #N($03), ghost layout
. #R$BDC3).
@ $900F label=StateData_Complex_21
  $900F,$0E Empty bottle (type #N($11), room #N($01), layout #R$A051).
@ $901D label=StateData_Complex_22
  $901D,$0E Seed box (type #N($90), room #N($05), layout #R$A13F).
@ $902B label=StateData_Complex_23
  $902B,$0E Worm can (type #N($08), room #N($01), layout #R$9DA2).
@ $9039 label=StateData_Complex_24
  $9039,$0E Yellow cup (type #N($05), room #N($00), layout #R$9D69).
@ $9047 label=StateData_Complex_25
  $9047,$0E Basket (type #N($03), room #N($00), layout #R$9D0F).
@ $9055 label=StateData_Complex_26
  $9055,$0E Pan (type #N($04), room #N($01), layout #R$9E07).
@ $9063 label=StateData_Complex_27
  $9063,$0E Cauldron (type #N($14), room #N($03), layout #R$9F9D).
@ $9071 label=StateData_Complex_28
  $9071,$0E Vat (type #N($16), room #N($04), layout #R$A18B).
@ $907F label=StateData_Complex_29
  $907F,$0E Inactive slot (type #N($00), room #N($00), layout #R$9EE2).
@ $908D label=StateData_Complex_30
  $908D,$0E Weight chain (type #N($37), room #N($03), layout #R$9E61).
@ $909B label=StateData_Berk
  $909B,$0E Berk (type #N($1F), room #N($04), layout #R$9647). Camera-follow
. entity that holds Berk's live layout pointer.
@ $90A9 label=StateData_Complex_32
  $90A9,$0E Inactive slot (type #N($00), room #N($03), mobile flamer
. layout #R$C70E).

b $90B7 State Data: Scenery Entities
@ $90B7 label=StateData_SceneryEntities
  $90B7,$01
  $90B8,$B5
D $90B7 Additional entity state records for room scenery and fixtures
. (#N($000E,$04,$04) bytes each, terminated by #N$FF at #R$9207). These
. are not included in the #R$AFA9 backup. Each record's layout pointer
. references graphic layout data in #R$9208–#R$A827.
@ $916D label=StateData_TrapDoorScenery
  $916D,$0A Trap door scenery entity.
@ $9177 label=Pointer_TrapDoorLayout
W $9177,$02 Current open/closed graphic layout pointer for the trap door.
  $9179,$02
@ $917B label=StateData_ScenerySecondary
  $917B,$01
  $917C,$29
@ $91A5 label=StateData_AnimatingScenery
  $91A5,$01
  $91A6,$09
@ $91AF label=Pointer_AnimatingSceneryLayout
W $91AF,$02 Graphic layout pointer for the scenery entity at #R$91A5; written by
. #R$AFDC / #R$B01E while animating the trap door.
  $91B1,$56
  $9207,$01 Terminator.

b $9208 Graphic Layout: Berk
@ $9208 label=GraphicLayout_Berk
D $9208 Berk's graphic layouts for walking right, plus the facing-out waving
. frames at #R$9245, #R$9251, #R$925D and #R$9269 (readers #R$BB13 through
. #R$BB49) and the lower-body parts from #R$9288 through #R$9457. The put-down
. script at #R$B9A9 loads #R$9208 and #R$9214. Walk-right faces also use
. #R$9226 from #R$BA77.
N $9208 Berk walking right.
N $9208 #UDGTABLE { #LAYOUT$08,$92(layout-9208) } UDGTABLE#
B $9208,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $920B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $920E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9211,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9214 #UDGTABLE { #LAYOUT$14,$92(layout-9214) } UDGTABLE#
B $9214,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9217,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $921A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $921D,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9220 Berk walking right (animated).
N $9220 #UDGTABLE { #LAYOUT$20,$92(layout-9220) } UDGTABLE#
B $9220,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9223,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9226 #UDGTABLE { #LAYOUT$26,$92(layout-9226) } UDGTABLE#
B $9226,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9229,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $922C,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $922F #UDGTABLE { #LAYOUT$2F,$92,$00,$01(layout-922f) } UDGTABLE#
B $922F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9232,$11,$11 Increment the index and jump to one of #R$92F8, #R$931A,
. #R$933F, #R$9367, #R$9395, #R$93BA, #R$93E2.
B $9243,$02
N $9245 Berk facing out of screen.
N $9245 #UDGTABLE { #LAYOUT$45,$92(layout-9245) } UDGTABLE#
B $9245,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9248,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $924B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $924E,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9251 #UDGTABLE { #LAYOUT$51,$92(layout-9251) } UDGTABLE#
B $9251,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9254,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9257,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $925A,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $925D #UDGTABLE { #LAYOUT$5D,$92(layout-925d) } UDGTABLE#
B $925D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9260,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9263,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9266,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9269 #UDGTABLE { #LAYOUT$69,$92(layout-9269) } UDGTABLE#
B $9269,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $926C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $926F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9272,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9275 #UDGTABLE { #LAYOUT$75,$92,$00,$01(layout-9275) } UDGTABLE#
B $9275,$11,$11 Increment the index and jump to one of #R$92B1, #R$92B1,
. #R$92B1, #R$92B1, #R$92D3, #R$92D3, #R$92D3.
B $9286,$02
N $9288 #UDGTABLE { #LAYOUT$88,$92(layout-9288) } UDGTABLE#
B $9288,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $928A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $928D,$08 Set the next graphic index from a random list.
B $9295,$03 Draw a random tile from the list at #R$928D with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9298,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $929B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $929E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92B0,$01 Load the stored coordinates and return.
N $92B1 #UDGTABLE { #LAYOUT$B1,$92,$00,$01(layout-92b1) } UDGTABLE#
B $92B1,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $92B4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92B7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92BA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92C0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92C3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92C6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92CC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92CF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92D2,$01 Load the stored coordinates and return.
N $92D3 #UDGTABLE { #LAYOUT$D3,$92,$00,$01(layout-92d3) } UDGTABLE#
B $92D3,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $92D6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92D9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92DC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92E8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92F7,$01 Load the stored coordinates and return.
N $92F8 #UDGTABLE { #LAYOUT$F8,$92,$00,$01(layout-92f8) } UDGTABLE#
B $92F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $92FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9301,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9304,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9307,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $930A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $930D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9310,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9313,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9316,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9319,$01 Load the stored coordinates and return.
N $931A #UDGTABLE { #LAYOUT$1A,$93,$00,$01(layout-931a) } UDGTABLE#
B $931A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $931D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9320,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9323,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9326,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9329,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $932C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $932F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9332,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9335,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9338,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $933B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $933E,$01 Load the stored coordinates and return.
N $933F #UDGTABLE { #LAYOUT$3F,$93,$00,$01(layout-933f) } UDGTABLE#
B $933F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9342,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9345,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9348,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $934B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $934E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9351,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9354,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9357,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $935A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $935D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9360,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9363,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9366,$01 Load the stored coordinates and return.
N $9367 #UDGTABLE { #LAYOUT$67,$93,$00,$01(layout-9367) } UDGTABLE#
B $9367,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $936A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $936D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9370,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9373,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9376,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9379,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $937C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $937F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9382,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9385,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9388,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $938B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $938E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9391,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9394,$01 Load the stored coordinates and return.
N $9395 #UDGTABLE { #LAYOUT$95,$93,$00,$01(layout-9395) } UDGTABLE#
B $9395,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9398,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $939B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $939E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93B0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93B3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93B6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93B9,$01 Load the stored coordinates and return.
N $93BA #UDGTABLE { #LAYOUT$BA,$93,$00,$01(layout-93ba) } UDGTABLE#
B $93BA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93C0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93C3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93C6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93CC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93CF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93D2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93D5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93D8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93DB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93DE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93E1,$01 Load the stored coordinates and return.
N $93E2 #UDGTABLE { #LAYOUT$E2,$93,$00,$01(layout-93e2) } UDGTABLE#
B $93E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93E8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93F7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93FA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $93FD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9400,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9403,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9406,$01 Load the stored coordinates and return.
B $9407,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $940A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $940D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9410,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9413,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9416,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9419,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $941C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $941F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9422,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9425,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9428,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $942B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $942E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9431,$01 Load the stored coordinates and return.
N $9432 #UDGTABLE { #LAYOUT$32,$94,$00,$01(layout-9432) } UDGTABLE#
B $9432,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9434,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $9437,$08 Set the next graphic index from a random list.
B $943F,$03 Draw a random tile from the list at #R$9437 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9442,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9445,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9448,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $944B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $944E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9451,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9454,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9457,$01 Load the stored coordinates and return.

b $9458 Graphic Layout: Berk Walking Left
@ $9458 label=GraphicLayout_BerkWalkingLeft
D $9458 Berk's left-facing graphic layouts. The put-down script at #R$B9C9
. loads #R$9458 and #R$9461. Walk-left faces also use #R$9470 from #R$BA83.
N $9458 Stepping left, left foot out.
N $9458 #UDGTABLE { #LAYOUT$58,$94(layout-9458) } UDGTABLE#
B $9458,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $945B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $945E,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9461 #UDGTABLE { #LAYOUT$61,$94(layout-9461) } UDGTABLE#
B $9461,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9464,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9467,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $946A Berk walking left (animated).
N $946A #UDGTABLE { #LAYOUT$6A,$94(layout-946a) } UDGTABLE#
B $946A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $946D,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9470 #UDGTABLE { #LAYOUT$70,$94(layout-9470) } UDGTABLE#
B $9470,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9473,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9476,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9479 #UDGTABLE { #LAYOUT$79,$94,$00,$01(layout-9479) } UDGTABLE#
B $9479,$11,$11 Increment the index and jump to one of #R$94E9, #R$950E,
. #R$9536, #R$9561, #R$9592, #R$95BA, #R$95E5.
B $948A,$02
N $948C #UDGTABLE { #LAYOUT$8C,$94,$00,$01(layout-948c) } UDGTABLE#
B $948C,$11,$11 Increment the index and jump to one of #R$949F, #R$949F,
. #R$949F, #R$949F, #R$94C1, #R$94C1, #R$94C1.
B $949D,$02
N $949F #UDGTABLE { #LAYOUT$9F,$94,$00,$01(layout-949f) } UDGTABLE#
B $949F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $94A2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94A5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94A8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94AB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94AE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94B1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94B4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94B7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94BA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94C0,$01 Load the stored coordinates and return.
N $94C1 #UDGTABLE { #LAYOUT$C1,$94,$00,$01(layout-94c1) } UDGTABLE#
B $94C1,$03 Conditionally jump to #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), or
. skip that address.
B $94C4,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $94C7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94CA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94CD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94D0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94D3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94D6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94D9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94DC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94E8,$01 Load the stored coordinates and return.
N $94E9 #UDGTABLE { #LAYOUT$E9,$94,$00,$01(layout-94e9) } UDGTABLE#
B $94E9,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $94EC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $94FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9501,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9504,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9507,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $950A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $950D,$01 Load the stored coordinates and return.
N $950E #UDGTABLE { #LAYOUT$0E,$95,$00,$01(layout-950e) } UDGTABLE#
B $950E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9511,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9514,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9517,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $951A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $951D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9520,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9523,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9526,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9529,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $952C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $952F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9532,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9535,$01 Load the stored coordinates and return.
N $9536 #UDGTABLE { #LAYOUT$36,$95,$00,$01(layout-9536) } UDGTABLE#
B $9536,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9539,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $953C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $953F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9542,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9545,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9548,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $954B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $954E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9551,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9554,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9557,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $955A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $955D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9560,$01 Load the stored coordinates and return.
N $9561 #UDGTABLE { #LAYOUT$61,$95,$00,$01(layout-9561) } UDGTABLE#
B $9561,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9564,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9567,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $956A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $956D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9570,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9573,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9576,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9579,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $957C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $957F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9582,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9585,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9588,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $958B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $958E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9591,$01 Load the stored coordinates and return.
N $9592 #UDGTABLE { #LAYOUT$92,$95,$00,$01(layout-9592) } UDGTABLE#
B $9592,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9595,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9598,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $959B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $959E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95B0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95B3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95B6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95B9,$01 Load the stored coordinates and return.
N $95BA #UDGTABLE { #LAYOUT$BA,$95,$00,$01(layout-95ba) } UDGTABLE#
B $95BA,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $95BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95C0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95C3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95C6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95CC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95CF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95D2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95D5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95D8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95DB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95DE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95E1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95E4,$01 Load the stored coordinates and return.
N $95E5 #UDGTABLE { #LAYOUT$E5,$95,$00,$01(layout-95e5) } UDGTABLE#
B $95E5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $95E8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95F7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95FA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $95FD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9600,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9603,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9606,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9609,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $960C,$01 Load the stored coordinates and return.
B $960D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9610,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9613,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9616,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9619,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $961C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $961F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9622,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9625,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9628,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $962B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $962E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9631,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9634,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9637,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $963A,$01 Load the stored coordinates and return.

b $963B Graphic Layout: Berk Facing Out
@ $963B label=GraphicLayout_BerkFacingOut
D $963B Berk facing out of the screen. The put-down script at #R$BA23 loads
. #R$963B. Idle and held poses continue at #R$9647. Facing into the screen
. continues at #R$985A.
N $963B Arms outstretched, animated.
N $963B #UDGTABLE { #LAYOUT$3B,$96(layout-963b) } UDGTABLE#
B $963B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $963E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9641,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9644,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9647 Berk facing out of screen (idle).
N $9647 #UDGTABLE { #LAYOUT$47,$96(layout-9647) } UDGTABLE#
@ $9647 label=GraphicLayout_BerkFacingOut_Idle
B $9647,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $964A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $964D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
N $9650 #UDGTABLE { #LAYOUT$50,$96,$00,$01(layout-9650) } UDGTABLE#
B $9650,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
N $9653 #UDGTABLE { #LAYOUT$53,$96,$00,$01(layout-9653) } UDGTABLE#
B $9653,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $9656 #UDGTABLE { #LAYOUT$56,$96,$00,$01(layout-9656) } UDGTABLE#
B $9656,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9659,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $965C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $965F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9662,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9665,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9668,$01 Load the stored coordinates and return.
N $9669 #UDGTABLE { #LAYOUT$69,$96,$00,$01(layout-9669) } UDGTABLE#
B $9669,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $966C #UDGTABLE { #LAYOUT$6C,$96,$00,$01(layout-966c) } UDGTABLE#
B $966C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $966F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9672,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9675,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9678,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $967B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $967E,$01 Load the stored coordinates and return.
N $967F #UDGTABLE { #LAYOUT$7F,$96(layout-967f) } UDGTABLE#
B $967F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $9682,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9684,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9687,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $968A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $968D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9690,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9693 #UDGTABLE { #LAYOUT$93,$96(layout-9693) } UDGTABLE#
B $9693,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $9696,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9698,$13,$13 Jump to a time-weighted random layout address (#R$96C6,
. #R$96AB, #R$96B4, #R$96BD).
N $96AB #UDGTABLE { #LAYOUT$AB,$96,$00,$01(layout-96ab) } UDGTABLE#
B $96AB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96AE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96B1,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $96B4 #UDGTABLE { #LAYOUT$B4,$96,$00,$01(layout-96b4) } UDGTABLE#
B $96B4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96B7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96BA,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $96BD #UDGTABLE { #LAYOUT$BD,$96,$00,$01(layout-96bd) } UDGTABLE#
B $96BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96C0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96C3,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $96C6 #UDGTABLE { #LAYOUT$C6,$96,$00,$01(layout-96c6) } UDGTABLE#
B $96C6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
N $96CC #UDGTABLE { #LAYOUT$CC,$96,$00,$01(layout-96cc) } UDGTABLE#
B $96CC,$0F,$0F Jump to a time-weighted random layout address (#R$96DB,
. #R$96ED, #R$96E4).
N $96DB #UDGTABLE { #LAYOUT$DB,$96,$00,$01(layout-96db) } UDGTABLE#
B $96DB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96DE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96E1,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $96E4 #UDGTABLE { #LAYOUT$E4,$96,$00,$01(layout-96e4) } UDGTABLE#
B $96E4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96E7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96EA,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $96ED #UDGTABLE { #LAYOUT$ED,$96,$00,$01(layout-96ed) } UDGTABLE#
B $96ED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96F0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
N $96F3 #UDGTABLE { #LAYOUT$F3,$96,$00,$01(layout-96f3) } UDGTABLE#
B $96F3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96F6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96F9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96FC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $96FF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9702,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9705,$01 Load the stored coordinates and return.
N $9706 Berk holding an object.
N $9706 #UDGTABLE { #LAYOUT$06,$97(layout-9706) } UDGTABLE#
B $9706,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9709,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $970C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $970F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9712,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9715 #UDGTABLE { #LAYOUT$15,$97(layout-9715) } UDGTABLE#
B $9715,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9718,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $971B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $971E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9721,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9724 #UDGTABLE { #LAYOUT$24,$97(layout-9724) } UDGTABLE#
B $9724,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9727,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $972A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $972D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9730,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9733 #UDGTABLE { #LAYOUT$33,$97(layout-9733) } UDGTABLE#
B $9733,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9736,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9739,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $973C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $973F,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9742 #UDGTABLE { #LAYOUT$42,$97(layout-9742) } UDGTABLE#
B $9742,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9745,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9748,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $974B,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $974E #UDGTABLE { #LAYOUT$4E,$97(layout-974e) } UDGTABLE#
B $974E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9751,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9754,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9757,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $975A #UDGTABLE { #LAYOUT$5A,$97(layout-975a) } UDGTABLE#
B $975A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $975D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9760,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9763,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9766 #UDGTABLE { #LAYOUT$66,$97(layout-9766) } UDGTABLE#
B $9766,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9769,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $976C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $976F,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9772 #UDGTABLE { #LAYOUT$72,$97(layout-9772) } UDGTABLE#
B $9772,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9775,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9778,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $977B,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $977E #UDGTABLE { #LAYOUT$7E,$97,$00,$01(layout-977e) } UDGTABLE#
B $977E,$09,$09 Jump using the carried-entity width to one of #R$9787, #R$97B5,
. #R$97E3, #R$981A.
N $9787 #UDGTABLE { #LAYOUT$87,$97,$00,$01(layout-9787) } UDGTABLE#
B $9787,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $978A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $978D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9790,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9793,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9796,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9799,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $979C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $979F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97A2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97A5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97A8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97AB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97AE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97B1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97B4,$01 Load the stored coordinates and return.
N $97B5 #UDGTABLE { #LAYOUT$B5,$97,$00,$01(layout-97b5) } UDGTABLE#
B $97B5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $97B8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97BB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97BE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97C1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97C4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97C7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97CA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97CD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97D0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97D3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97D6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97D9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97DC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97E2,$01 Load the stored coordinates and return.
N $97E3 #UDGTABLE { #LAYOUT$E3,$97,$00,$01(layout-97e3) } UDGTABLE#
B $97E3,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $97E6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97E9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97EC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $97FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9801,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9804,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9807,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $980A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $980D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9810,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9813,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9816,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9819,$01 Load the stored coordinates and return.
N $981A #UDGTABLE { #LAYOUT$1A,$98,$00,$01(layout-981a) } UDGTABLE#
B $981A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $981D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9820,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9823,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9826,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9829,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $982C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $982F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9832,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9835,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9838,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $983B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $983E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9841,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9844,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9847,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $984A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $984D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9850,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9853,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9856,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9859,$01 Load the stored coordinates and return.

b $985A Graphic Layout: Berk Facing In
@ $985A label=GraphicLayout_BerkFacingIn
D $985A Berk facing into the screen (back view). Put-down scripts load #R$985A
. from #R$B9EF, #R$BA0B, #R$BA47 and #R$BA61.
N $985A Arms out to the sides.
N $985A #UDGTABLE { #LAYOUT$5A,$98(layout-985a) } UDGTABLE#
B $985A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $985D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9860,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9863,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9866,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9869 #UDGTABLE { #LAYOUT$69,$98(layout-9869) } UDGTABLE#
B $9869,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $986C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $986F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9872,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9875,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9878 #UDGTABLE { #LAYOUT$78,$98(layout-9878) } UDGTABLE#
B $9878,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $987B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $987E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9881,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9884,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9887 #UDGTABLE { #LAYOUT$87,$98(layout-9887) } UDGTABLE#
B $9887,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $988A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $988D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9890,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9893,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9896 #UDGTABLE { #LAYOUT$96,$98(layout-9896) } UDGTABLE#
B $9896,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9899,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $989C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $989F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98A2,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98A5 #UDGTABLE { #LAYOUT$A5,$98(layout-98a5) } UDGTABLE#
B $98A5,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98A8,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98AB,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98AE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98B1,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98B4 #UDGTABLE { #LAYOUT$B4,$98(layout-98b4) } UDGTABLE#
B $98B4,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98B7,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98BA,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98BD #UDGTABLE { #LAYOUT$BD,$98(layout-98bd) } UDGTABLE#
B $98BD,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98C0,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98C3,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98C6 #UDGTABLE { #LAYOUT$C6,$98(layout-98c6) } UDGTABLE#
B $98C6,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98C9,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98CC,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98CF #UDGTABLE { #LAYOUT$CF,$98(layout-98cf) } UDGTABLE#
B $98CF,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98D2,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98D5,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98D8 #UDGTABLE { #LAYOUT$D8,$98(layout-98d8) } UDGTABLE#
B $98D8,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98DB,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $98DE,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $98E1 #UDGTABLE { #LAYOUT$E1,$98(layout-98e1) } UDGTABLE#
B $98E1,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $98E3,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $98E6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98E9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98EC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $98FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9901,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9904,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9907,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $990A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $990D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9910,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9913,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9916,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9919,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $991C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $991F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9922,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9925,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9928,$01 Load the stored coordinates and return.

b $9929 Graphic Layout: Berk Body Parts
@ $9929 label=GraphicLayout_BerkBodyParts
D $9929 Shared Berk limb and torso fragments. Reached only through nested FB
. calls from layouts such as #R$9647 and #R$985A.
N $9929 Right arm.
N $9929 #UDGTABLE { #LAYOUT$29,$99,$00,$01(layout-9929) } UDGTABLE#
B $9929,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $992C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $992F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9932,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9935,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9938,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $993B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $993E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9941,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9944,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9947,$01 Load the stored coordinates and return.
N $9948 #UDGTABLE { #LAYOUT$48,$99,$00,$01(layout-9948) } UDGTABLE#
B $9948,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $994B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $994E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9951,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9954,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9957,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $995A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $995D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9960,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9963,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9966,$01 Load the stored coordinates and return.
N $9967 #UDGTABLE { #LAYOUT$67,$99,$00,$01(layout-9967) } UDGTABLE#
B $9967,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $996A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $996D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9970,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9973,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9976,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9979,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $997C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $997F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9982,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9985,$01 Load the stored coordinates and return.
N $9986 #UDGTABLE { #LAYOUT$86,$99,$00,$01(layout-9986) } UDGTABLE#
B $9986,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9989,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $998C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $998F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9992,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9995,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9998,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $999B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $999E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99A4,$01 Load the stored coordinates and return.
N $99A5 #UDGTABLE { #LAYOUT$A5,$99,$00,$01(layout-99a5) } UDGTABLE#
B $99A5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $99A8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99AB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99AE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99B1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99B4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99B7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99BA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99C0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99C3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99C6,$01 Load the stored coordinates and return.
N $99C7 #UDGTABLE { #LAYOUT$C7,$99,$00,$01(layout-99c7) } UDGTABLE#
B $99C7,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $99CA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99CD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99D0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99D3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99D6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99D9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99DC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99E8,$01 Load the stored coordinates and return.
N $99E9 #UDGTABLE { #LAYOUT$E9,$99,$00,$01(layout-99e9) } UDGTABLE#
B $99E9,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $99EC #UDGTABLE { #LAYOUT$EC,$99,$00,$01(layout-99ec) } UDGTABLE#
B $99EC,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $99EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $99F5,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $99F8 #UDGTABLE { #LAYOUT$F8,$99,$00,$01(layout-99f8) } UDGTABLE#
B $99F8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $99FB #UDGTABLE { #LAYOUT$FB,$99,$00,$01(layout-99fb) } UDGTABLE#
B $99FB,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $99FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A01,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A04,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9A07 #UDGTABLE { #LAYOUT$07,$9A,$00,$01(layout-9a07) } UDGTABLE#
B $9A07,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $9A0A #UDGTABLE { #LAYOUT$0A,$9A,$00,$01(layout-9a0a) } UDGTABLE#
B $9A0A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A0D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A10,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A13,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A16,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A19,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A1C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A1F,$01 Load the stored coordinates and return.
N $9A20 #UDGTABLE { #LAYOUT$20,$9A,$00,$01(layout-9a20) } UDGTABLE#
B $9A20,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $9A23 #UDGTABLE { #LAYOUT$23,$9A,$00,$01(layout-9a23) } UDGTABLE#
B $9A23,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A35,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A38,$01 Load the stored coordinates and return.
N $9A39 #UDGTABLE { #LAYOUT$39,$9A,$00,$01(layout-9a39) } UDGTABLE#
B $9A39,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A3C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A3F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A42,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A45,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A48,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A4B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A4E,$01 Load the stored coordinates and return.
N $9A4F #UDGTABLE { #LAYOUT$4F,$9A,$00,$01(layout-9a4f) } UDGTABLE#
B $9A4F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A52,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A55,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A58,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A5B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A5E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A61,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A64,$01 Load the stored coordinates and return.
N $9A65 #UDGTABLE { #LAYOUT$65,$9A,$00,$01(layout-9a65) } UDGTABLE#
B $9A65,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A68,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A6B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A6E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A71,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A74,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A77,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A7A,$01 Load the stored coordinates and return.
N $9A7B #UDGTABLE { #LAYOUT$7B,$9A,$00,$01(layout-9a7b) } UDGTABLE#
B $9A7B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A7E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A81,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A84,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A87,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A8A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A8D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A90,$01 Load the stored coordinates and return.
N $9A91 #UDGTABLE { #LAYOUT$91,$9A,$00,$01(layout-9a91) } UDGTABLE#
B $9A91,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9A94,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A97,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A9A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9A9D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AA0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AA3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AA6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AA9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AAC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AAF,$01 Load the stored coordinates and return.
N $9AB0 #UDGTABLE { #LAYOUT$B0,$9A,$00,$01(layout-9ab0) } UDGTABLE#
B $9AB0,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9AB3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AB6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AB9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9ABC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9ABF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AC2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AC5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AC8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9ACB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9ACE,$01 Load the stored coordinates and return.
N $9ACF #UDGTABLE { #LAYOUT$CF,$9A,$00,$01(layout-9acf) } UDGTABLE#
B $9ACF,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9AD2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AD5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AD8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9ADB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9ADE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AE1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AE4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AE7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AEA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AF0,$01 Load the stored coordinates and return.
N $9AF1 #UDGTABLE { #LAYOUT$F1,$9A,$00,$01(layout-9af1) } UDGTABLE#
B $9AF1,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9AF4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AF7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AFA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9AFD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B00,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B03,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B06,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B09,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B0C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B0F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B12,$01 Load the stored coordinates and return.
N $9B13 #UDGTABLE { #LAYOUT$13,$9B(layout-9b13) } UDGTABLE#
B $9B13,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9B15,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $9B18,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9B1B,$06 Set the next graphic index from a random list.
B $9B21,$03 Draw a random tile from the list at #R$9B1B with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B24,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B27,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B2A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B2D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B30,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B33,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B36,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B39,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B3C,$01 Load the stored coordinates and return.
N $9B3D #UDGTABLE { #LAYOUT$3D,$9B(layout-9b3d) } UDGTABLE#
B $9B3D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9B3F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $9B42,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9B45,$06 Set the next graphic index from a random list.
B $9B4B,$03 Draw a random tile from the list at #R$9B45 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B4E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B51,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B54,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B57,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B5A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B5D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B60,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B63,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B66,$01 Load the stored coordinates and return.

b $9B67 Graphic Layout: Berk In Action
@ $9B67 label=GraphicLayout_BerkInAction
D $9B67 Berk action poses. Put-down scripts load #R$9B67 from #R$BA25 through
. #R$BA29.
N $9B67 Facing out of screen, bending down.
N $9B67 #UDGTABLE { #LAYOUT$67,$9B(layout-9b67) } UDGTABLE#
B $9B67,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9B69,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9B6C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B6F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B72,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B75,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B78,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B7B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B7E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B81,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B84,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B87,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B8A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B8D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B90,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B93,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B96,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B99,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B9C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9B9F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BA2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BA5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BA8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BAB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BAE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BB1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BB4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BB7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BBA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BBD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BC0,$01 Load the stored coordinates and return.
N $9BC1 Back-view put-down.
N $9BC1 #UDGTABLE { #LAYOUT$C1,$9B(layout-9bc1) } UDGTABLE#
B $9BC1,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $9BC4,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9BC6,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9BC9,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9BCC,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9BCF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BD2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BD5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BD8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BDB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BDE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BE1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BE4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BE7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BEA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BF0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BF3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BF6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BF9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BFC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9BFF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C02,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C05,$01 Load the stored coordinates and return.
N $9C06 Facing out of screen, arms raised.
N $9C06 #UDGTABLE { #LAYOUT$06,$9C(layout-9c06) } UDGTABLE#
B $9C06,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9C08,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9C0B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C0E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C11,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C14,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C17,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C1A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C1D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C20,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C23,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C35,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C38,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C3B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C3E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C41,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C44,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C47,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C4A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C4D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C50,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C53,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C56,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C59,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C5C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C5F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C62,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C65,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C68,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C6B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C6E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C71,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C74,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C77,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C7A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C7D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C80,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C83,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C86,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9C89,$01 Load the stored coordinates and return.

b $9C8A Graphic Layout / Script Data: Boney Actions
@ $9C8A label=GraphicLayoutScript_BoneyActions
D $9C8A Script and graphic layout data used while Boney turns and
. interacts. Boney's current layout pointer is held at #R$8EE9 + #N$0A.
N $9C8A #UDGTABLE { #SCRIPTANIM$9C8A(script-9c8a) } UDGTABLE#
N $9C8A #UDGTABLE { #LAYOUT$8A,$9C(layout-9c8a) } UDGTABLE#
B $9C8A,$07 Increment the index and jump to one of #R$9C91, #R$9C9E.
N $9C91 #UDGTABLE { #LAYOUT$91,$9C(layout-9c91) } UDGTABLE#
@ $9C91 label=GraphicLayout_BoneyActions_Skull
B $9C91,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9C93,$0B,$0B Jump to a time-weighted random layout address (#R$9CAB,
. #R$9CDD).

b $9C9E Graphic Layout Data: Boney
@ $9C9E label=GraphicLayout_Boney
D $9C9E Boney's skull graphic layout. Boney's layout field at #R$8EF3 points
. here in the snapshot and is restored by #R$D82F / #R$DA04 after Bad Tempered
. Thing dialogue.
N $9C9E #UDGTABLE { #LAYOUT$9E,$9C(layout-9c9e) } UDGTABLE#
B $9C9E,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9CA0,$0B,$0B Jump to a time-weighted random layout address (#R$9CC4,
. #R$9CF6).
N $9CAB #UDGTABLE { #LAYOUT$AB,$9C(layout-9cab) } UDGTABLE#
@ $9CAB label=GraphicLayout_Boney_FrameA
B $9CAB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CAE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CB1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CB4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CB7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CBA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CBD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CC0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CC3,$01 Load the stored coordinates and return.
N $9CC4 #UDGTABLE { #LAYOUT$C4,$9C(layout-9cc4) } UDGTABLE#
@ $9CC4 label=GraphicLayout_Boney_FrameB
B $9CC4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CC7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CCA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CCD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CD0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CD3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CD6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CD9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CDC,$01 Load the stored coordinates and return.
N $9CDD #UDGTABLE { #LAYOUT$DD,$9C(layout-9cdd) } UDGTABLE#
@ $9CDD label=GraphicLayout_Boney_FrameC
B $9CDD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CE0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CE3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CE6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CE9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CEC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CEF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CF2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CF5,$01 Load the stored coordinates and return.
N $9CF6 #UDGTABLE { #LAYOUT$F6,$9C(layout-9cf6) } UDGTABLE#
@ $9CF6 label=GraphicLayout_Boney_FrameD
B $9CF6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CF9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CFC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9CFF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D02,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D05,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D08,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D0B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D0E,$01 Load the stored coordinates and return.

b $9D0F Graphic Layout: Basket
@ $9D0F label=GraphicLayout_Basket
D $9D0F Basket layout. Written by entity init at #R$9047 and pointed by
. #R$ECD1.
N $9D0F #UDGTABLE { #LAYOUT$0F,$9D(layout-9d0f) } UDGTABLE#
B $9D0F,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9D11,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D14,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D17,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D1A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D1D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D20,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D23,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D2C,$01 Load the stored coordinates and return.

b $9D2D Graphic Layout: Basket Rim
@ $9D2D label=GraphicLayout_BasketRim
D $9D2D Basket rim. Selected by script routine #N$1E when the current entity
. type is #N$03.
N $9D2D #UDGTABLE { #LAYOUT$2D,$9D(layout-9d2d) } UDGTABLE#
B $9D2D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9D2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D35,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D38,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D3B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D3E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D41,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D44,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D47,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D4A,$01 Load the stored coordinates and return.

b $9D4B Graphic Layout: Basket Upside Down
@ $9D4B label=GraphicLayout_BasketUpsideDown
D $9D4B Basket upside-down. Selected by script routine #N$1F when the current
. entity type is #N$03.
N $9D4B #UDGTABLE { #LAYOUT$4B,$9D(layout-9d4b) } UDGTABLE#
B $9D4B,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9D4D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D50,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D53,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D56,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D59,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D5C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D5F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D62,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D65,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D68,$01 Load the stored coordinates and return.

b $9D69 Graphic Layout: Yellow Cup
@ $9D69 label=GraphicLayout_YellowCup
D $9D69 Yellow cup. Written by entity init at #R$9039 and pointed by #R$ECCC.
N $9D69 #UDGTABLE { #LAYOUT$69,$9D(layout-9d69) } UDGTABLE#
B $9D69,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9D6B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D6E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D71,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D74,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D77,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D7A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D7D,$01 Load the stored coordinates and return.

b $9D7E Graphic Layout: Yellow Cup Rim
@ $9D7E label=GraphicLayout_YellowCupRim
D $9D7E Yellow cup rim. Selected by script routine #N$1E for entity types
. #N$05 / #N$08.
N $9D7E #UDGTABLE { #LAYOUT$7E,$9D(layout-9d7e) } UDGTABLE#
B $9D7E,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9D80,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D83,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D86,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D89,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D8C,$01 Load the stored coordinates and return.

b $9D8D Graphic Layout: Yellow Cup Upside Down
@ $9D8D label=GraphicLayout_YellowCupUpsideDown
D $9D8D Yellow cup upside-down. Selected by script routine #N$1F for entity
. type #N$05.
N $9D8D #UDGTABLE { #LAYOUT$8D,$9D(layout-9d8d) } UDGTABLE#
B $9D8D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9D8F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D92,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D95,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D98,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D9B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9D9E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9DA1,$01 Load the stored coordinates and return.

b $9DA2 Graphic Layout Data: Worm Can
@ $9DA2 label=GraphicLayout_WormCan
D $9DA2 Worm-can layout (used when collecting worms). Written by entity
. init at #R$902B and pointed by #R$ECC7 / #R$ED05.
N $9DA2 #UDGTABLE { #LAYOUT$A2,$9D(layout-9da2) } UDGTABLE#
B $9DA2,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9DA4,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9DA6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DA5)).
B $9DA8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DA5)).
B $9DAA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DA5)).
B $9DAC,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DA5)).
B $9DAE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DA5)).
B $9DB0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DA5)).
B $9DB2,$01 Load the stored coordinates and return.

b $9DB3 Graphic Layout Data: White Orb
@ $9DB3 label=GraphicLayout_WhiteOrb
D $9DB3 Small white orb. Written by the type-#N$86 spawned helper at #R$8FD7.
N $9DB3 #UDGTABLE { #LAYOUT$B3,$9D(layout-9db3) } UDGTABLE#
B $9DB3,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9DB5,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9DB7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DB6)).
B $9DB9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DB6)).
B $9DBB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DB6)).
B $9DBD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DB6)).
B $9DBF,$01 Load the stored coordinates and return.

b $9DC0 Graphic Layout Data: White Burst
@ $9DC0 label=GraphicLayout_WhiteBurst
D $9DC0 White burst / splash layout. No entity init writer found; kept as a
. plain layout description from the rendered tiles.
N $9DC0 #UDGTABLE { #LAYOUT$C0,$9D(layout-9dc0) } UDGTABLE#
B $9DC0,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9DC2,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9DC5,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9DC7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DC9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DCB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DCD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DCF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DD1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DD3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DD5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9DC6)).
B $9DD7,$01 Load the stored coordinates and return.

b $9DD8 Graphic Layout: Hot Pan
@ $9DD8 label=GraphicLayout_PanHot
D $9DD8 Hot pan (red). No entity init writer found.
N $9DD8 #UDGTABLE { #LAYOUT$D8,$9D(layout-9dd8) } UDGTABLE#
B $9DD8,$0B,$0B Increment the index and jump to one of #R$9E07, #R$9E1F,
. #R$9E07, #R$9E1F.

b $9DE3 Graphic Layout: Pan Cooking
@ $9DE3 label=GraphicLayout_PanCooking
D $9DE3 Pan while cooking (steam). No entity init writer found.
N $9DE3 #UDGTABLE { #LAYOUT$E3,$9D(layout-9de3) } UDGTABLE#
B $9DE3,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9DE5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9DE8,$04 Set the next graphic index from a random list.
B $9DEC,$03 Draw a random tile from the list at #R$9DE8 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9DEF,$04 Set the next graphic index from a random list.
B $9DF3,$03 Draw a random tile from the list at #R$9DEF with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9DF6,$04 Set the next graphic index from a random list.
B $9DFA,$03 Draw a random tile from the list at #R$9DF6 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9DFD,$04 Set the next graphic index from a random list.
B $9E01,$03 Draw a random tile from the list at #R$9DFD with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E04,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).

b $9E07 Graphic Layout: Pan
@ $9E07 label=GraphicLayout_Pan
D $9E07 Pan layout (same family as the cooking pan at #R$9DE3). Written by
. #R$9055.
N $9E07 #UDGTABLE { #LAYOUT$07,$9E(layout-9e07) } UDGTABLE#
B $9E07,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9E09,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $9E0C #UDGTABLE { #LAYOUT$0C,$9E(layout-9e0c) } UDGTABLE#
@ $9E0C label=GraphicLayout_Pan_Body
B $9E0C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E0F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E12,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E15,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E18,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E1B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E1E,$01 Load the stored coordinates and return.
N $9E1F #UDGTABLE { #LAYOUT$1F,$9E(layout-9e1f) } UDGTABLE#
@ $9E1F label=GraphicLayout_Pan_Cyan
B $9E1F,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9E21,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9E24,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E27,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E2A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E2D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E30,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E33,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E36,$01 Load the stored coordinates and return.

b $9E37 Graphic Layout: Bullet
@ $9E37 label=GraphicLayout_Bullet
D $9E37 Bullet. Used as Drutt's live layout at #R$8EF7 (script data #R$D234).
N $9E37 #UDGTABLE { #LAYOUT$37,$9E(layout-9e37) } UDGTABLE#
B $9E37,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9E39,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E3C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E3F,$01 Load the stored coordinates and return.
N $9E40 Weight chain wrapper used when Drutt catches the weight. Nests
. #R$9E61 (the same chain) with catch-path attributes. Pointed from the
. Drutt catch path at #R$B088.
. #UDGTABLE { #LAYOUT$40,$9E(layout-9e40) } UDGTABLE#
@ $9E40 label=GraphicLayout_WeightChainWrapper
B $9E40,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9E43,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9E45,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $9E48 #UDGTABLE { #LAYOUT$48,$9E(layout-9e48) } UDGTABLE#
B $9E48,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9E4B,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
N $9E4D Weight-chain body (attribute #COLOUR(#PEEK($9E44))
. (#N(#PEEK($9E44)))); origin lowered for the FA +#N$11 move.
. #UDGTABLE { #LAYOUT$4D,$9E,$02,$03,$08,$08,$18,$10(layout-9e4d) } UDGTABLE#
@ $9E4D label=GraphicLayout_WeightChainWrapper_Body
B $9E4D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9E50,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E52,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E54,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E56,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E58,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E5A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E5C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E5E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E4C)).
B $9E60,$01 Load the stored coordinates and return.

b $9E61 Graphic Layout: Weight Chain
@ $9E61 label=GraphicLayout_WeightChain
D $9E61 Weight chain for the type-#N$37 entity at #R$908D. #R$9E40 nests
. this same chain for Drutt's catch path. Writers: entity init, also #R$B041.
N $9E61 #UDGTABLE { #LAYOUT$61,$9E(layout-9e61) } UDGTABLE#
B $9E61,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9E63,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9E66,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9E68,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E6A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E6C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E6E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E70,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E72,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E74,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E76,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E78,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E7A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E7C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E7E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E67)).
B $9E80,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9E82,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E85,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E88,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E8B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E8E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E91,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9E94,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9E96,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9E98,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9E9A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9E9C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9E9E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EA0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EA2,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EA4,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EA6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EA8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EAA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EAC,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EAE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EB0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EB2,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EB4,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EB6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EB8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EBA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EBC,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EBE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EC0,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9EC3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EC5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EC7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EC9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ECB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ECD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ECF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ED1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ED3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ED5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ED7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9ED9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EDB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EDD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EDF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9E95)).
B $9EE1,$01 Load the stored coordinates and return.

b $9EE2 Graphic Layout Data: Safe
@ $9EE2 label=GraphicLayout_Safe
D $9EE2 Cyan safe / strongbox. Referenced from the inactive complex slot at
. #R$907F.
N $9EE2 #UDGTABLE { #LAYOUT$E2,$9E(layout-9ee2) } UDGTABLE#
B $9EE2,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9EE4,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9EE7,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9EEA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EF0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EF3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EF6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EF9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EFC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9EFF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F02,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F05,$01 Load the stored coordinates and return.
N $9F06 #UDGTABLE { #LAYOUT$06,$9F(layout-9f06) } UDGTABLE#
@ $9F06 label=GraphicLayout_OpenSafe
B $9F06,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9F08,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $9F0B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9F0E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F11,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F14,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F17,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F1A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F1D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F20,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F23,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F32,$01 Load the stored coordinates and return.
N $9F33 #UDGTABLE { #LAYOUT$33,$9F(layout-9f33) } UDGTABLE#
B $9F33,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F36,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F39,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F3C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F3F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F42,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F45,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F48,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F4B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F4E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F51,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F54,$01 Load the stored coordinates and return.
N $9F55 #UDGTABLE { #LAYOUT$55,$9F(layout-9f55) } UDGTABLE#
B $9F55,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9F57,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $9F59,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9F5C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F5E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F60,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F62,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F64,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F66,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F68,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F6A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F6C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F6E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F70,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F72,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($9F58)).
B $9F74,$01 Load the stored coordinates and return.

b $9F75 Graphic Layout: Cauldron Cooking
@ $9F75 label=GraphicLayout_CauldronCooking
D $9F75 Cauldron cooking with steam. Pointed by #R$C5E1.
N $9F75 #UDGTABLE { #LAYOUT$75,$9F(layout-9f75) } UDGTABLE#
B $9F75,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9F77,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $9F7A,$04 Set the next graphic index from a random list.
B $9F7E,$03 Draw a random tile from the list at #R$9F7A with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F81,$04 Set the next graphic index from a random list.
B $9F85,$03 Draw a random tile from the list at #R$9F81 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F88,$04 Set the next graphic index from a random list.
B $9F8C,$03 Draw a random tile from the list at #R$9F88 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F8F,$04 Set the next graphic index from a random list.
B $9F93,$03 Draw a random tile from the list at #R$9F8F with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9F96,$04 Set the next graphic index from a random list.
B $9F9A,$03 Draw a random tile from the list at #R$9F96 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).

b $9F9D Graphic Layout Data: Cauldron
@ $9F9D label=GraphicLayout_Cauldron
D $9F9D Cauldron. Written by the type-#N$14 entity at #R$9063.
N $9F9D #UDGTABLE { #LAYOUT$9D,$9F(layout-9f9d) } UDGTABLE#
B $9F9D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9F9F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FA2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FA5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FA8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FAB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FAE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FB1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FB4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FB7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FBA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FBD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FC0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FC3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FC6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FC9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FCC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FCF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FD2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FD5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FD8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FDB,$01 Load the stored coordinates and return.

b $9FDC Graphic Layout: Stove Lit
@ $9FDC label=GraphicLayout_StoveLit
D $9FDC Stove lit with flames. Written by the type-#N$15 entity at #R$8D6F.
N $9FDC #UDGTABLE { #LAYOUT$DC,$9F(layout-9fdc) } UDGTABLE#
B $9FDC,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $9FDE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FE1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FE4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FE7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FEA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FF0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FF3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FF6,$06 Set the next graphic index from a random list.
B $9FFC,$03 Draw a random tile from the list at #R$9FF6 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $9FFF,$06 Set the next graphic index from a random list.
B $A005,$03 Draw a random tile from the list at #R$9FFF with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A008,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A00B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A00E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A011,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A014,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A017,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A01A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A01D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A020,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A023,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A026,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A029,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A02C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A02F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A032,$01 Load the stored coordinates and return.

b $A033 Graphic Layout: Collectible Eyeball
@ $A033 label=GraphicLayout_CollectibleEyeball
D $A033 Collectible eyeball. Written by the type-#N$8D entities at #R$8F4B,
. #R$8F59 and #R$8F67.
N $A033 #UDGTABLE { #LAYOUT$33,$A0(layout-a033) } UDGTABLE#
B $A033,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A035,$06 Set the next graphic index from a random list.
B $A03B,$03 Draw a random tile from the list at #R$A035 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A03E,$01 Load the stored coordinates and return.
B $A03F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A042,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A045,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A048,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A04B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A04E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.

b $A051 Graphic Layout: Empty Bottle
@ $A051 label=GraphicLayout_EmptyBottle
D $A051 Empty bottle. Written by the type-#N$11 entity at #R$900F.
N $A051 #UDGTABLE { #LAYOUT$51,$A0(layout-a051) } UDGTABLE#
B $A051,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A053,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A056,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A059,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A05C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A05F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A062,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A065,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A068,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A06B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A06E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A071,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A074,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A077,$01 Load the stored coordinates and return.
N $A078 #UDGTABLE { #LAYOUT$78,$A0(layout-a078) } UDGTABLE#
B $A078,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A07B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A07E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A081,$01 Load the stored coordinates and return.

b $A082 Graphic Layout Data: Plant Pot
@ $A082 label=GraphicLayout_PlantPot
D $A082 Red plant pot. Written by the type-#N$0F pot entities at #R$8F75,
. #R$8F83 and #R$8F91.
N $A082 #UDGTABLE { #LAYOUT$82,$A0(layout-a082) } UDGTABLE#
B $A082,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A084,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A087,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A08A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A08D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A090,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A093,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A096,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A099,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A09C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A09F,$01 Load the stored coordinates and return.
N $A0A0 Eyeball plant growth level #N$01.
N $A0A0 #UDGTABLE { #LAYOUT$A0,$A0(layout-a0a0) } UDGTABLE#
@ $A0A0 label=GraphicLayout_EyeballPlantLevel1
B $A0A0,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0A3,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $A0A6,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $A0A9 Eyeball plant growth level #N$02.
N $A0A9 #UDGTABLE { #LAYOUT$A9,$A0(layout-a0a9) } UDGTABLE#
@ $A0A9 label=GraphicLayout_EyeballPlantLevel2
B $A0A9,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0AC,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $A0AF Eyeball plant growth level #N$03.
N $A0AF #UDGTABLE { #LAYOUT$AF,$A0(layout-a0af) } UDGTABLE#
@ $A0AF label=GraphicLayout_EyeballPlantLevel3
B $A0AF,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0B2,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $A0B5 Eyeball plant growth level #N$04.
N $A0B5 #UDGTABLE { #LAYOUT$B5,$A0(layout-a0b5) } UDGTABLE#
@ $A0B5 label=GraphicLayout_EyeballPlantLevel4
B $A0B5,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0B8,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $A0BB,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0BE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0C1,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A0C4,$06 Set the next graphic index from a random list.
B $A0CA,$03 Draw a random tile from the list at #R$A0C4 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A0CD,$01 Load the stored coordinates and return.
B $A0CE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
N $A0D1 Collectible eyeball frame #N$01.
N $A0D1 #UDGTABLE { #LAYOUT$D1,$A0(layout-a0d1) } UDGTABLE#
@ $A0D1 label=GraphicLayout_CollectibleEyeballFrame1
B $A0D1,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0D4,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A0D7,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $A0DA,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0DD,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0E0,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $A0E3,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0E6,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0E9,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0EC,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0EF,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $A0F2,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0F5,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $A0F8 Eyeball plant growth level #N$05.
N $A0F8 #UDGTABLE { #LAYOUT$F8,$A0(layout-a0f8) } UDGTABLE#
@ $A0F8 label=GraphicLayout_EyeballPlantLevel5
B $A0F8,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0FB,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A0FE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A101,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A104,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A107,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
N $A10A Eyeball plant tip.
N $A10A #UDGTABLE { #LAYOUT$0A,$A1(layout-a10a) } UDGTABLE#
@ $A10A label=GraphicLayout_EyeballPlantTip
B $A10A,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A10C,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $A10F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A112,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A10B)).
B $A114,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A10B)).
B $A116,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A10B)).
B $A118,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A10B)).
B $A11A,$01 Load the stored coordinates and return.
N $A11B Collectible eyeball frame #N$02.
N $A11B #UDGTABLE { #LAYOUT$1B,$A1(layout-a11b) } UDGTABLE#
@ $A11B label=GraphicLayout_CollectibleEyeballFrame2
B $A11B,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A11D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A120,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A123,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A126,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A129,$06 Set the next graphic index from a random list.
B $A12F,$03 Draw a random tile from the list at #R$A129 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A132,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A135,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A138,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A13B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A13E,$01 Load the stored coordinates and return.

b $A13F Graphic Layout Data: Seed Box
@ $A13F label=GraphicLayout_SeedBox
D $A13F Cyan "SEED" box. Written by the type-#N$90 entity at #R$901D and pointed
. by #R$ECD6.
N $A13F #UDGTABLE { #LAYOUT$3F,$A1(layout-a13f) } UDGTABLE#
B $A13F,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A141,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A144,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A147,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A14A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A14D,$01 Load the stored coordinates and return.
N $A14E #UDGTABLE { #LAYOUT$4E,$A1(layout-a14e) } UDGTABLE#
B $A14E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A151,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A154,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A157,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A15A,$01 Load the stored coordinates and return.
N $A15B #UDGTABLE { #LAYOUT$5B,$A1(layout-a15b) } UDGTABLE#
B $A15B,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A15D,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A15C)).
B $A15F,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A15C)).
B $A161,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A15C)).
B $A163,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A15C)).
B $A165,$01 Load the stored coordinates and return.

b $A166 Graphic Layout Data: Vat Pouring
@ $A166 label=GraphicLayout_Vat_Pouring
D $A166 Striped vat pouring from its spout. Pointed by #R$CBE3.
N $A166 #UDGTABLE { #LAYOUT$66,$A1(layout-a166) } UDGTABLE#
B $A166,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A169,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A16C,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A16E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A16D)).
B $A170,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A16D)).
B $A172,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A16D)).
B $A174,$07 Increment the index and jump to one of #R$A17B, #R$A182.
N $A17B Eyeball juice splash frame #N$01.
N $A17B #UDGTABLE { #LAYOUT$7B,$A1,$44,$03(layout-a17b) } UDGTABLE#
@ $A17B label=GraphicLayout_EyeballJuiceSplash1
B $A17B,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A16D)).
B $A17D,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A16D)).
B $A17F,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A16D)).
B $A181,$01 Load the stored coordinates and return.
N $A182 Eyeball juice splash frame #N$02.
N $A182 #UDGTABLE { #LAYOUT$82,$A1,$44,$03(layout-a182) } UDGTABLE#
@ $A182 label=GraphicLayout_EyeballJuiceSplash2
B $A182,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A184,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A183)).
B $A186,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A183)).
B $A188,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A183)).
B $A18A,$01 Load the stored coordinates and return.

b $A18B Graphic Layout Data: Vat
@ $A18B label=GraphicLayout_Vat
D $A18B Striped vat with spout. Written by the type-#N$16 entity at #R$9071 and
. pointed by #R$CC6E.
N $A18B #UDGTABLE { #LAYOUT$8B,$A1(layout-a18b) } UDGTABLE#
B $A18B,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A18D,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A18F,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A191,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A193,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A195,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A197,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A199,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A19B,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A19D,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A19F,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1A1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1A3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1A5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1A7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1A9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1AB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1AD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1AF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1B1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1B3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1B5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1B7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1B9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1BB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1BD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1BF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1C1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1C3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1C5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1C7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1C9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1CB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1CD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1CF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1D1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1D3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1D5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A18E)).
B $A1D7,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A1D9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1D8)).
B $A1DB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1D8)).
B $A1DD,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A1DF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1E1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1E3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1E5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1E7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1E9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1EB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1ED,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1EF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1F1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1F3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1F5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A1DE)).
B $A1F7,$01 Load the stored coordinates and return.

b $A1F8 Graphic Layout: Slimies
@ $A1F8 label=GraphicLayout_Slimies
D $A1F8 Slimies. Written by the type-#N$89 entities at #R$8F13, #R$8F21,
. #R$8F2F and #R$8F3D.
N $A1F8 Slimies frame #N$01.
N $A1F8 #UDGTABLE { #LAYOUT$F8,$A1(layout-a1f8) } UDGTABLE#
B $A1F8,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A1FA,$0B,$0B Jump to a time-weighted random layout address (#R$A205,
. #R$A21E).
N $A205 Slimies frame #N$02.
N $A205 #UDGTABLE { #LAYOUT$05,$A2(layout-a205) } UDGTABLE#
@ $A205 label=GraphicLayout_SlimiesFrame2
B $A205,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A208,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A20B,$06 Set the next graphic index from a random list.
B $A211,$03 Draw a random tile from the list at #R$A20B with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A214,$06 Set the next graphic index from a random list.
B $A21A,$03 Draw a random tile from the list at #R$A214 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A21D,$01 Load the stored coordinates and return.
N $A21E Slimies frame #N$03.
N $A21E #UDGTABLE { #LAYOUT$1E,$A2(layout-a21e) } UDGTABLE#
@ $A21E label=GraphicLayout_SlimiesFrame3
B $A21E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A221,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A224,$06 Set the next graphic index from a random list.
B $A22A,$03 Draw a random tile from the list at #R$A224 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A22D,$06 Set the next graphic index from a random list.
B $A233,$03 Draw a random tile from the list at #R$A22D with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A236,$01 Load the stored coordinates and return.

b $A237 Graphic Layout Data: Room 1 Scenery
@ $A237 label=GraphicLayout_Room1SceneryBlock
D $A237 Room scenery layout referenced from simple entity state at #R$8CFF.
N $A237 #UDGTABLE { #LAYOUT$37,$A2(layout-a237) } UDGTABLE#
B $A237,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A239,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A23C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A23F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A242,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A245,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A248,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A24B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A24E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A251,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A254,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A257,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A25A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A25D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A260,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A263,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A266,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A269,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A26C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A26F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).

b $A272 Graphic Layout Data: Shared Scenery Tile
@ $A272 label=GraphicLayout_SharedScenery
D $A272 Shared scenery / platform layout used by multiple simple entities;
. a single #N$FF return, so it draws nothing (e.g. #R$8BF5, #R$8C2D).
B $A272,$01 Load the stored coordinates and return.
N $A273 #UDGTABLE { #LAYOUT$73,$A2(layout-a273) } UDGTABLE#
@ $A273 label=GraphicLayout_SharedScenery_Alt
B $A273,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A275,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A277,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A279,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A27B,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A27D,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A27F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A282,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A284,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A286,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A288,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A276)).
B $A28A,$01 Load the stored coordinates and return.

b $A28B Graphic Layout Data: Room Scenery
@ $A28B label=GraphicLayout_RoomSceneryBlock
D $A28B Room scenery layout referenced from simple entity state.
N $A28B #UDGTABLE { #LAYOUT$8B,$A2(layout-a28b) } UDGTABLE#
B $A28B,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A28D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A290,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A292,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A294,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A296,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A299,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A29B,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A29D,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A29F,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A2A1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A2A3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A2A5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A291)).
B $A2A7,$01 Load the stored coordinates and return.

b $A2A8 Graphic Layout Data: Room Scenery
@ $A2A8 label=GraphicLayout_RoomSceneryBlockB
D $A2A8 Room scenery layout referenced from simple entity state at #R$8C03.
N $A2A8 #UDGTABLE { #LAYOUT$A8,$A2(layout-a2a8) } UDGTABLE#
B $A2A8,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A2AA,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A2AD,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A2B0,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A2B3,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A2B6,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A2B9,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A2BB,$02 Start a loop of count #N(#PEEK(#PC+$01)).
B $A2BD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2BA)).
B $A2BF,$01 End the current loop.
B $A2C0,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A2C3,$02 Start a loop of count #N(#PEEK(#PC+$01)).
B $A2C5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2BA)).
B $A2C7,$01 End the current loop.
B $A2C8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A2CB,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
N $A2CD A row of twelve ground tiles drawn left to right along the bottom
. of the railings picture in the #R$A2A8 layout. Each entry is a tile from
. graphic set #N$02 plus a one-column step. There is no per-tile attribute
. because #R$A2CB has already set one.
B $A2CD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2CF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2D1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2D3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2D5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2D7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2D9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2DB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2DD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2DF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2E1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2E3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2CC)).
B $A2E5,$01 Load the stored coordinates and return.
N $A2E6 Sky.
N $A2E6 #UDGTABLE { #LAYOUT$E6,$A2,$00,$02(layout-a2e6) } UDGTABLE#
@ $A2E6 label=GraphicLayout_Sky
B $A2E6,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A2E8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $A2EB,$02 Start a loop of count #N(#PEEK(#PC+$01)).
B $A2ED,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A2E7)).
B $A2EF,$01 End the current loop.
B $A2F0,$01 Load the stored coordinates and return.

b $A2F1 Graphic Layout Data: Floor Strip
@ $A2F1 label=GraphicLayout_FloorStrip
D $A2F1 Floor-strip layout used across rooms. Some entity records enter at
. #R$A2F6.
N $A2F1 #UDGTABLE { #LAYOUT$F1,$A2(layout-a2f1) } UDGTABLE#
B $A2F1,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A2F3,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
N $A2F6 #UDGTABLE { #LAYOUT$F6,$A2(layout-a2f6) } UDGTABLE#
@ $A2F6 label=GraphicLayout_FloorStrip_Alt
B $A2F6,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A2F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A2FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A2FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A301,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A304,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A307,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A30A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A30D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A310,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A313,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A316,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A319,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A31C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A31F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A322,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A325,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A328,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A32B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A32E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A331,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A334,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A337,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A33A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A33D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A340,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A343,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A346,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A349,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A34C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A34F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A352,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A355,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A358,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A35B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A35E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A361,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A364,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A367,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A36A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A36D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A370,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A373,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A376,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A379,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A37C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A37F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A382,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A385,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A388,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A38B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A38E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A391,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A394,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A397,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A39A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A39D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3A0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3A3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3A6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3A9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3AC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3AF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3B2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3B5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3B8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3BB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3BE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3C1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3C4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3C7,$01 Load the stored coordinates and return.
N $A3C8 #UDGTABLE { #LAYOUT$C8,$A3,$00,$02(layout-a3c8) } UDGTABLE#
B $A3C8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A3CB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3D1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3D4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3D7,$01 Load the stored coordinates and return.

b $A3D8 Graphic Layout Data: Trap Door Edge
@ $A3D8 label=GraphicLayout_TrapDoorEdge
D $A3D8 Layout for the trap door edge entity at #R$8EDB.
N $A3D8 #UDGTABLE { #LAYOUT$D8,$A3(layout-a3d8) } UDGTABLE#
B $A3D8,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A3DA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3DD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3E0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3E3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3E6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3E9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3EC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3F2,$01 Load the stored coordinates and return.

b $A3F3 Graphic Layout: Closed Trap Door
@ $A3F3 label=GraphicLayout_TrapDoorClosed
D $A3F3 Closed trap door. Layout for the trap door entity at #R$8ECD.
N $A3F3 #UDGTABLE { #LAYOUT$F3,$A3(layout-a3f3) } UDGTABLE#
B $A3F3,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A3F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A3FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A401,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A404,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A407,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A40A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A40D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A410,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A413,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A416,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A419,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A41C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A41F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A422,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A425,$01 Load the stored coordinates and return.

b $A426 Graphic Layout: Open Trap Door
@ $A426 label=GraphicLayout_TrapDoorOpen
D $A426 Open trap door. Referenced from simple entity state at #R$8EB1.
N $A426 #UDGTABLE { #LAYOUT$26,$A4(layout-a426) } UDGTABLE#
B $A426,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A428,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A42B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A42E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A431,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A434,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A437,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A43A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A43D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A440,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A443,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A446,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A449,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A44C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A44F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A452,$01 Load the stored coordinates and return.

b $A453 Graphic Layout: Trap Door Floor
@ $A453 label=GraphicLayout_TrapDoorFloor
D $A453 Floor around the top of the trap door. Referenced from simple entity
. state at #R$8E87.
N $A453 #UDGTABLE { #LAYOUT$53,$A4(layout-a453) } UDGTABLE#
B $A453,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A455,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A458,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A45A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A459)).
B $A45C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A459)).
B $A45E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A459)).
B $A460,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A459)).
B $A462,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A459)).
B $A464,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A459)).
B $A466,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A468,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A46B,$01 Load the stored coordinates and return.

b $A46C Graphic Layout: Green Arch Top
@ $A46C label=GraphicLayout_GreenArchTop
D $A46C Top of a green arch. Used by several room entities.
N $A46C #UDGTABLE { #LAYOUT$6C,$A4(layout-a46c) } UDGTABLE#
B $A46C,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A46E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A471,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A474,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A477,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A47A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A47D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A480,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A483,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A486,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A489,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A48C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A48F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A492,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A495,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A498,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A49B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A49E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4B0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4B3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4B6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4B9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4BC,$01 Load the stored coordinates and return.

b $A4BD Graphic Layout: Green Arch Bottom
@ $A4BD label=GraphicLayout_GreenArchBottom
D $A4BD Bottom of a green arch. Used by several room entities.
N $A4BD #UDGTABLE { #LAYOUT$BD,$A4(layout-a4bd) } UDGTABLE#
B $A4BD,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A4BF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4C2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4C5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4C8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4CB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4D1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4D4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4D7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4DA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4DD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4E0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4E3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4E6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4E9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4EC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A4FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A501,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A504,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A507,$01 Load the stored coordinates and return.

b $A508 Graphic Layout: White Arch
@ $A508 label=GraphicLayout_WhiteArch
D $A508 White arch (room #N$05 record at #R$917B).
N $A508 #UDGTABLE { #LAYOUT$08,$A5(layout-a508) } UDGTABLE#
B $A508,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A50A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A50D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A510,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A513,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A516,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A519,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A51C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A51F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A522,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A525,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A528,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A52B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A52E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A531,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A534,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A537,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A53A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A53D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A540,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A543,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A546,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A549,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A54C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A54F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A552,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A555,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A558,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A55B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A55E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A561,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A564,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A567,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A56A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A56D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A570,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A573,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A576,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A579,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A57C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A57F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A582,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A585,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A588,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A58B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A58E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A591,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A594,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A597,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A59A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A59D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5A0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5A3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5A6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5A9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5AC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5AF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5B2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5B5,$01 Load the stored coordinates and return.

b $A5B6 Graphic Layout Data: Door Frame
@ $A5B6 label=GraphicLayout_DoorFrame
D $A5B6 Door-frame / aperture layout used by several room entities.
N $A5B6 #UDGTABLE { #LAYOUT$B6,$A5(layout-a5b6) } UDGTABLE#
B $A5B6,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A5B8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5BB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5BE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5C1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5C4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5C7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5CA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5CD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5D0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5D3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5D6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5D9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5DC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5E8,$01 Load the stored coordinates and return.

b $A5E9 Graphic Layout Data: Door Frame Variant
@ $A5E9 label=GraphicLayout_DoorFrameVariant
D $A5E9 Door-frame variant layout.
N $A5E9 #UDGTABLE { #LAYOUT$E9,$A5(layout-a5e9) } UDGTABLE#
B $A5E9,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A5EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5F7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5FA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A5FD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A600,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A603,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A606,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A609,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A60C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A60F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A612,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A615,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A618,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A61B,$01 Load the stored coordinates and return.

b $A61C Graphic Layout Data: Vertical Column
@ $A61C label=GraphicLayout_VerticalColumn
D $A61C Vertical column layout used in room #N$05.
N $A61C #UDGTABLE { #LAYOUT$1C,$A6(layout-a61c) } UDGTABLE#
B $A61C,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A61E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A621,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
N $A624 #UDGTABLE { #LAYOUT$24,$A6,$00,$02(layout-a624) } UDGTABLE#
B $A624,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A626,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A628,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A62A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A62C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A62E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A630,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A632,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A634,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A636,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A638,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A63A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A63C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A63E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A640,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A642,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A644,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A646,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A648,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A64A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A64C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A625)).
B $A64E,$01 Load the stored coordinates and return.

b $A64F Graphic Layout Data: Small Decor
@ $A64F label=GraphicLayout_SmallDecor
D $A64F Small decorative layout (e.g. wall hooks).
N $A64F #UDGTABLE { #LAYOUT$4F,$A6(layout-a64f) } UDGTABLE#
B $A64F,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A651,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A654,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A657,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A65A,$01 Load the stored coordinates and return.

b $A65B Graphic Layout Data
@ $A65B label=GraphicLayout_DecorSmall
D $A65B Layout referenced from simple entity state at #R$8D0D.
N $A65B #UDGTABLE { #LAYOUT$5B,$A6(layout-a65b) } UDGTABLE#
B $A65B,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A65D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A660,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A663,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A666,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A669,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A66C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A66F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A672,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A675,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A678,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A67B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A67E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A681,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A684,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A687,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A68A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A68D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A690,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A693,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A696,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A699,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A69C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A69F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6A2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6A5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6A8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6AB,$01 Load the stored coordinates and return.

b $A6AC Graphic Layout Data
@ $A6AC label=GraphicLayout_DecorWide
D $A6AC Layout referenced from simple entity state at #R$8D1B.
N $A6AC #UDGTABLE { #LAYOUT$AC,$A6(layout-a6ac) } UDGTABLE#
B $A6AC,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A6AE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6B1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6B4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6B7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6BA,$01 Load the stored coordinates and return.

b $A6BB Graphic Layout Data: Long Platform
@ $A6BB label=GraphicLayout_LongPlatform
D $A6BB Long platform / shelf layout.
N $A6BB #UDGTABLE { #LAYOUT$BB,$A6(layout-a6bb) } UDGTABLE#
B $A6BB,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A6BD,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A6BF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6C1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6C3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6C5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6C7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6C9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6CB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6CD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6CF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6D1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6D3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6D5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6D7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6D9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6DB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6DD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6DF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6E1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6E3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6E5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6E7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6E9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6EB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A6BE)).
B $A6ED,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A6EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A6FE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A701,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A704,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A707,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A70A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A70D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A710,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A713,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A716,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A719,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A71C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A71F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A722,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A725,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A728,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A72B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A72E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A731,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A734,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A737,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A73A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A73D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A740,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A743,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A746,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A749,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A74C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A74F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A752,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A755,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A758,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A75B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A75E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A761,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A764,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A767,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A76A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A76D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A770,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A773,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A776,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A779,$01 Load the stored coordinates and return.

b $A77A Graphic Layout Data: Mossy Arch
@ $A77A label=GraphicLayout_MossyArch
D $A77A Green mossy archway. Written by the type-#N$68 entity at #R$8DB5.
N $A77A #UDGTABLE { #LAYOUT$7A,$A7(layout-a77a) } UDGTABLE#
B $A77A,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A77C,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A77E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A780,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A782,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A784,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A786,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A788,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A78A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A78C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A78E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A790,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A792,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A794,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A796,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A798,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A79A,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A79C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A79E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7A0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7A2,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7A4,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7A6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7A8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7AA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7AC,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7AE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7B0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7B2,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7B4,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7B6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7B8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7BA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7BC,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A7BF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7C1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7C3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7C5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7C7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7C9,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7CB,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7CD,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7CF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7D1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7D3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7D5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7D7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A77D)).
B $A7D9,$01 Load the stored coordinates and return.

b $A7DA Graphic Layout: Dumb Waiter
@ $A7DA label=GraphicLayout_DumbWaiter
D $A7DA Dumb waiter. Written by the type-#N$3D entity at #R$8D7D.
N $A7DA #UDGTABLE { #LAYOUT$DA,$A7(layout-a7da) } UDGTABLE#
B $A7DA,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A7DC,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A7DE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7E0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7E2,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7E4,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7E6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7E8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7EA,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A7ED,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7EF,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7F1,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7F3,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7F5,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7F7,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7DD)).
B $A7F9,$01 Load the stored coordinates and return.

b $A7FA Graphic Layout: Lever Open Facing Right
@ $A7FA label=GraphicLayout_LeverOpenRight
D $A7FA Lever open, facing right. Written into #R$9177 when the trap door
. opens (#R$EDF8).
N $A7FA #UDGTABLE { #LAYOUT$FA,$A7(layout-a7fa) } UDGTABLE#
B $A7FA,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A7FC,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A7FE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7FD)).
B $A800,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7FD)).
B $A802,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7FD)).
B $A804,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7FD)).
B $A806,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A7FD)).
B $A808,$01 Load the stored coordinates and return.

b $A809 Graphic Layout: Lever Closed Facing Right
@ $A809 label=GraphicLayout_LeverClosedRight
D $A809 Lever closed, facing right. Written into #R$9177 when the trap door
. closes (#R$EDDB). Also the default pointer held at #R$9177 after #R$AB31
. initialises a new game.
N $A809 #UDGTABLE { #LAYOUT$09,$A8(layout-a809) } UDGTABLE#
B $A809,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A80B,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A80D,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A80C)).
B $A80F,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A80C)).
B $A811,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A80C)).
B $A813,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A80C)).
B $A815,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A80C)).
B $A817,$01 Load the stored coordinates and return.

b $A818 Graphic Layout: Lever Open Facing Left
@ $A818 label=GraphicLayout_LeverOpenLeft
D $A818 Lever open, facing left. Written by #R$F1E3 (#REGiy+#N$0A / #N$0B)
. and pointed by #R$B00E.
N $A818 #UDGTABLE { #LAYOUT$18,$A8(layout-a818) } UDGTABLE#
B $A818,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A81A,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A81C,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A81B)).
B $A81E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A81B)).
B $A820,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A81B)).
B $A822,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A81B)).
B $A824,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A81B)).
B $A826,$01 Load the stored coordinates and return.

b $A827 Graphic Layout: Lever Closed Facing Left
@ $A827 label=GraphicLayout_LeverClosedLeft
D $A827 Lever closed, facing left. Used by #R$AFDC / #R$B01E while the lever
. animates.
. Also referenced from #R$ADE2.
N $A827 #UDGTABLE { #LAYOUT$27,$A8(layout-a827) } UDGTABLE#
B $A827,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A829,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A82C,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A82E,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A82D)).
B $A830,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A82D)).
B $A832,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A82D)).
B $A834,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A82D)).
B $A836,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A82D)).
B $A838,$01 Load the stored coordinates and return.

b $A839 Graphic Layout: Blue Staircase
@ $A839 label=GraphicLayout_BlueStaircase
D $A839 Blue staircase. Referenced from scenery entities at #R$8B69 through
. #R$8BBD.
N $A839 #UDGTABLE { #LAYOUT$39,$A8(layout-a839) } UDGTABLE#
B $A839,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A83B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A83E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A841,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A844,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A847,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A84A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A84D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A850,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A853,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A856,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A859,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A85C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A85F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A862,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A865,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A868,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A86B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A86E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A871,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A874,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A877,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A87A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A87D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A880,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A883,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A886,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A889,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A88C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A88F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A892,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A895,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A898,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A89B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A89E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8B0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8B3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8B6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8B9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8BC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8BF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8C2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8C5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8C8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8CB,$01 Load the stored coordinates and return.

b $A8CC Graphic Layout Data: Room 1 Scenery
@ $A8CC label=GraphicLayout_Room1Scenery
D $A8CC Room scenery layout referenced from simple entity state at #R$8CF1
. and #R$8E09.
N $A8CC #UDGTABLE { #LAYOUT$CC,$A8(layout-a8cc) } UDGTABLE#
B $A8CC,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A8CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8D1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8D4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8D7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8DA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8DD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8E0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8E3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8E6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8E9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8EC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A8F5,$01 Load the stored coordinates and return.

b $A8F6 Graphic Layout Data: Room 1 Scenery
@ $A8F6 label=GraphicLayout_Room1SceneryB
D $A8F6 Room scenery layout referenced from simple entity state at #R$8D45.
N $A8F6 #UDGTABLE { #LAYOUT$F6,$A8(layout-a8f6) } UDGTABLE#
B $A8F6,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A8F8,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A8FA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A8FC,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A8FE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A900,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A902,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A904,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A906,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A908,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A8F9)).
B $A90A,$01 Load the stored coordinates and return.
N $A90B Alternate room-#N$01 scenery-block layout (entity at #R$8D99).
. #UDGTABLE { #LAYOUT$0B,$A9(layout-a90b) } UDGTABLE#
@ $A90B label=GraphicLayout_SceneryBlock_Alt
B $A90B,$02 Start a loop of count #N(#PEEK(#PC+$01)).
B $A90D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A910,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A913,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A916,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A919,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A91C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A91F,$01 End the current loop.
B $A920,$01 Load the stored coordinates and return.
B $A921,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A923,$02 Start a loop of count #N(#PEEK(#PC+$01)).
B $A925,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A922)).
B $A927,$01 End the current loop.
B $A928,$01 Load the stored coordinates and return.

b $A929 Graphic Layout Data: Swamp Dripping Water
@ $A929 label=GraphicLayout_SwampDrippingWater
D $A929 Wrap-around swamp scenery for room #N$00 (entity at #R$8BCB, x
. #N$EA-#N$FF). Drawn when the camera sits at #N$E0-#N$FF via #R$E6DB.
N $A929 #UDGTABLE { #LAYOUT$29,$A9(layout-a929) } UDGTABLE#
B $A929,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $A92B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A92E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A931,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A934,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A937,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A93A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $A93D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A940,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A943,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A946,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A949,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A94C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A94F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A952,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A955,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A958,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A95B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A95E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A961,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A964,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A967,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A96A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A96D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A970,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A973,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A976,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A979,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A97C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A97F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A982,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A985,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A988,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A98B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A98E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A991,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A994,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A997,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A99A,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A99D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A9A0,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A9A3,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A9A6,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A9A9,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A9AC,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A9AF,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A9B2,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A9B5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A9B8,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A9BB,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $A9BE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $A9C1,$01 Load the stored coordinates and return.
N $A9C2 #UDGTABLE { #LAYOUT$C2,$A9,$00,$05(layout-a9c2) } UDGTABLE#
B $A9C2,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $A9C4,$02 Start a loop of count #N(#PEEK(#PC+$01)).
B $A9C6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($A9C3)).
B $A9C8,$01 End the current loop.
B $A9C9,$01 Load the stored coordinates and return.
N $A9CA #UDGTABLE { #LAYOUT$CA,$A9,$00,$05(layout-a9ca) } UDGTABLE#
B $A9CA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9CD,$01 Load the stored coordinates and return.
N $A9CE #UDGTABLE { #LAYOUT$CE,$A9,$00,$05(layout-a9ce) } UDGTABLE#
B $A9CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9D1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9D4,$01 Load the stored coordinates and return.
N $A9D5 #UDGTABLE { #LAYOUT$D5,$A9,$00,$05(layout-a9d5) } UDGTABLE#
B $A9D5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9D8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9DB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9DE,$01 Load the stored coordinates and return.
N $A9DF #UDGTABLE { #LAYOUT$DF,$A9,$00,$05(layout-a9df) } UDGTABLE#
B $A9DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9E8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9EE,$01 Load the stored coordinates and return.
N $A9EF #UDGTABLE { #LAYOUT$EF,$A9,$00,$05(layout-a9ef) } UDGTABLE#
B $A9EF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9F2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9F5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9F8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9FB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $A9FE,$01 Load the stored coordinates and return.
N $A9FF #UDGTABLE { #LAYOUT$FF,$A9,$00,$05(layout-a9ff) } UDGTABLE#
B $A9FF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA02,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA05,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA08,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA0B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA0E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA11,$01 Load the stored coordinates and return.
N $AA12 #UDGTABLE { #LAYOUT$12,$AA,$00,$05(layout-aa12) } UDGTABLE#
B $AA12,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA15,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA18,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA1B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA1E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA21,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA24,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA27,$01 Load the stored coordinates and return.

b $AA28 Graphic Layout: Green Scenery Strip
@ $AA28 label=GraphicLayout_GreenSceneryStrip
D $AA28 Green scenery strip. Referenced from the type-#N$32 scenery entities
. after #R$91B1 (rooms #N$01 through #N$05). Drawn with graphic set #N$05.
N $AA28 #UDGTABLE { #LAYOUT$28,$AA(layout-aa28) } UDGTABLE#
B $AA28,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $AA2A,$02 Jump into the following layout data at a random
. 3-byte entry (maximum index #N(#PEEK(#PC+$01))). Drawing then
. carries on through every later tile to the #N$FF.
B $AA2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA35,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA38,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA3B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA3E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA41,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA44,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA47,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA4A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA4D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA50,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA53,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA56,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA59,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA5C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA5F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA62,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA65,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA68,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA6B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA6E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA71,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA74,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA77,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA7A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA7D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA80,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA83,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA86,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA89,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA8C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA8F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA92,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA95,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA98,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA9B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AA9E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AAA1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AAA4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AAA7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $AAAA,$01 Load the stored coordinates and return.

c $AAAB Game Restart
@ $AAAB label=GameRestart
D $AAAB Re-enter the main loop after a completed game cycle: refresh the high
. score, re-initialise entity data, then join #R$AAB3 at #R$AAC2.
  $AAAB,$03 Call #R$F6A6 to update the high-score display.
  $AAAE,$03 Call #R$AB31 to initialise entity data.
  $AAB1,$02 Jump to #R$AAC2 to re-enter the main loop.

c $AAB3 Game Start
@ $AAB3 label=GameStart
D $AAB3 Relocate the menu-music code, show the main menu, set up a new game,
. then enter the main loop.
  $AAB3,$01 Disable interrupts.
  $AAB4,$03 Point #REGhl at #R$6F04.
  $AAB7,$03 #REGde=#R$FC6C.
  $AABA,$03 Load #REGbc with #N$0393 (menu-music source copy length).
  $AABD,$02 Copy the menu-music source to #R$FC6C.
  $AABF,$03 Call #R$FC6C to seed the menu music and wait for a key.
N $AAC2 Seed RNG from #SKOOLKID$5C78(FRAMES), run the main menu, initialise a
. new game, then tick the world.
@ $AAC2 label=GameStart_MainLoopEntry
  $AAC2,$06 Fetch #SKOOLKID$5C78(FRAMES), then seed the random scratch byte
. (#R$EAE2).
  $AAC8,$03 Call #R$F3EF to display and handle the main menu.
  $AACB,$03 Call #R$AF3C to initialise a new game.
N $AACE Per-frame update: controls, camera, Berk, task entities, Drutt, physics,
. messaging, blit.
@ $AACE label=GameStart_FrameLoop
  $AACE,$03 Call #R$F603 to read the player controls into #R$F5F8.
  $AAD1,$03 Call #R$F1F3 to update the camera follow.
N $AAD4 Update Berk's task/idle state and drive him from the control bitmap.
  $AAD4,$03 Call #R$AB95 to update Berk's state.
  $AAD7,$03 Call #R$B41A to update Berk's controller.
N $AADA Tick the current Thing Upstairs task entities (tasks two–four) plus the
. Thing Upstairs entity.
  $AADA,$03 Call #R$BECD to update task-two entities.
  $AADD,$03 Call #R$C378 to update task-three entities.
  $AAE0,$03 Call #R$CAA7 to update task-four entities.
  $AAE3,$03 Call #R$BC12 to update the Thing Upstairs entity.
  $AAE6,$03 Call #R$CF37 to update miscellaneous entities.
N $AAE9 Advance timed events, Drutt, falling/rising physics and Bad Tempered
. Thing dialogue.
  $AAE9,$03 Call #R$ADA1 to update timed events.
  $AAEC,$03 Call #R$B034 to update Drutt.
  $AAEF,$03 Call #R$B258 to process special entity flags.
  $AAF2,$03 Call #R$B1A9 to process falling entities.
  $AAF5,$03 Call #R$B21E to process rising entities.
  $AAF8,$03 Call #R$D7D3 to update Bad Tempered Thing dialogue.
  $AAFB,$03 Call #R$AF7F to check task completion.
N $AAFE Clear, populate and blit the display buffers, then play any queued
. sound.
  $AAFE,$03 Call #R$EA44 to clear the display buffer.
  $AB01,$03 Call #R$E6DB to populate the display buffer for visible entities.
  $AB04,$03 Call #R$E991 to blit the display buffer to the screen.
  $AB07,$03 Call #R$F9AF to play any queued sound.
N $AB0A Flip the double-buffer select and continue unless the camera-follow
. entity has been cleared (death).
  $AB0A,$03 Point #REGhl at display buffer A (#R$63A0).
  $AB0D,$03 Point #REGde at display buffer B (#R$6B20).
  $AB10,$03 Fetch the display-buffer select flag (#R$72EA).
  $AB13,$02,b$01 Toggle bit #N$00 of #REGa.
  $AB15,$03 Store it back at #R$72EA.
  $AB18,$02 If it is now zero, keep #REGhl = buffer A at #R$AB1B.
  $AB1A,$01 Otherwise swap so #REGhl = buffer B.
N $AB1B Remember the active display buffer, then loop another frame while the
. camera-follow entity is still alive.
@ $AB1B label=GameStart_StoreBufferPointer
  $AB1B,$03 Store the active display-buffer pointer at #R$72F5.
  $AB1E,$07 Fetch the camera-follow entity type (#R$909B). Is the camera-follow
. entity still active? If so, jump to #R$AACE for another frame.
N $AB25 Death / end-of-life: print the death line, blit, show ratings, restart.
  $AB25,$03 Call #R$DFB5 to print the death message.
  $AB28,$03 Call #R$E991 to blit the display buffer to the screen.
  $AB2B,$03 Call #R$DE19 to print status / rating messages.
  $AB2E,$03 Jump to #R$AAAB to restart the game.

c $AB31 Initialise Entity Data
@ $AB31 label=Initialise_Entity_Data
D $AB31 Initialise Entity Data walking the entity tables at #R$8B69 / #R$8EE9.
  $AB31,$03 Point #REGhl at the entity-state backup buffer (#R$FA0E).
  $AB34,$03 Point #REGde at Boney's complex entity state (#R$8EE9).
  $AB37,$04 Load #REGbc with the entity-state copy length (#R$72A3).
  $AB3B,$02 Copy the block at #REGhl to #REGde.
N $AB3D Reset the dumb waiter's y-band and prepare to stamp closed-trap types.
  $AB3D,$04 Point #REGix at the dumb-waiter entity (#R$8D7D).
  $AB41,$04 Write #N$1D to the current entity's y-coordinate.
  $AB45,$04 Write #N$23 to the current entity's y-extent.
  $AB49,$03 Point #REGhl at the closed-trap type list (#R$EDC9).
  $AB4C,$04 Point #REGix at the simple-entity slot at #R$8E87.
  $AB50,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $AB53,$02 Load #REGb with #N$06 as a loop counter.
N $AB55 Walk the simple-entity slots and apply each closed-trap type from
. #R$EDC9, then restore the closed-trap lever.
@ $AB55 label=Initialise_Entity_Data_ApplyType
  $AB55,$01 Fetch the next byte from #R$EDC9.
  $AB56,$03 Set the current entity's entity type.
  $AB59,$01 Advance #R$EDC9 by one byte.
  $AB5A,$02 Advance #REGix to the next entity record.
  $AB5C,$02 Decrease the loop counter in #REGb and jump to #R$AB55 if more
. iterations remain.
N $AB5E Point the lever at closed facing right, then restore task/game state
. from the backup.
  $AB5E,$03 Point #REGhl at the lever closed, facing right (#R$A809).
  $AB61,$03 Write the lever layout pointer to #R$9177.
  $AB64,$03 Load #REGhl with the entity-state backup end pointer (#R$72A7).
  $AB67,$03 Point #REGde at the current task index (#R$72AE).
  $AB6A,$04 Load #REGbc with the game-state copy length (#R$72A5).
  $AB6E,$02 Copy the block at #REGhl to #REGde.
  $AB70,$01 Return.

b $AB71 Data: Berk Idle Script Selectors
@ $AB71 label=Data_BerkIdleScriptSelectors
D $AB71 Short selector table passed to #R$ACE4 when Berk is idle and a task is
. active (#R$ABB5).
  $AB71,$05

c $AB76 Initialise Entity Defaults
@ $AB76 label=Initialise_Entity_Defaults
D $AB76 Initialise Entity Defaults walking the entity tables at #R$8B69 /
. #R$8EE9.
  $AB76,$04 Point #REGix at the plant-pot complex entity (#R$8F75).
  $AB7A,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $AB7D,$03 Point #REGhl at Graphic Layout Data: Entity Type #N$0F (#R$A082).
  $AB80,$02 Load #REGb with #N$03 as a loop counter.
N $AB82 Stamp default type/flags/layout onto each plant-pot entity slot and walk
. to the next.
@ $AB82 label=Initialise_Entity_Defaults_WriteType
  $AB82,$04 Write #N$12 to the current entity's entity type.
  $AB86,$04 Write #N$1B to the current entity's flags byte 1.
  $AB8A,$03 Set the low byte of the current entity's graphic layout address from
. #REGl.
  $AB8D,$03 Set the high byte of the current entity's graphic layout address
. from #REGh.
  $AB90,$02 Advance #REGix to the next entity record.
  $AB92,$02 Decrease the loop counter in #REGb and jump to #R$AB82 if more
. iterations remain.
  $AB94,$01 Return.

c $AB95 Update Berk State
@ $AB95 label=Update_Berk_State
D $AB95 Update Berk State for the player character using complex state at
. #R$8EE9.
N $AB95 Checks the current task phase/index, Berk action lock and timed events
. before driving Berk scripts.
  $AB95,$06 Load #REGa with the current task phase (#R$72AF). Is the current
. task phase inactive (zero)? If not, skip to the timed-event checks at #R$ABC0.
  $AB9B,$03 Load #REGa with the game event flags (#R$72B3).
  $AB9E,$04 Is bit #N$01 of the game event flags set? If so, jump to #R$ABC0.
  $ABA2,$03 Load #REGa with Berk's action lock (#R$72C8).
  $ABA5,$03 Is Berk's action lock zero? If not, jump to #R$ABAB.
  $ABA8,$01 Set #REGa to #N$01 ready to store as the task phase.
  $ABA9,$02 Jump to #R$ABBD to store the task phase.
N $ABAB Branch on the current task index: finish phase #N($05), tick when idle,
. or start an idle Berk script.
@ $ABAB label=Update_Berk_State_ByTaskIndex
  $ABAB,$03 Load #REGa with the current task index (#R$72AE).
  $ABAE,$04 Is the current task index equal to #N$05? If so, jump to #R$ABBD.
  $ABB2,$03 Is the current task index zero? If so, jump to #R$ABC0.
  $ABB5,$03 Point #REGhl at Berk's idle script selectors (#R$AB71).
  $ABB8,$02 Load #REGa with #N$04 as the candidate-row count.
  $ABBA,$03 Call #R$ACE4 to start Berk's script.
N $ABBD Store the chosen task phase into #R$72AF.
@ $ABBD label=Update_Berk_State_SetTaskPhase
  $ABBD,$03 Set the current task phase (#R$72AF).
N $ABC0 Count down the game tick; when it hits zero, continue into the idle/task
. branch.
@ $ABC0 label=Update_Berk_State_TickCounter
  $ABC0,$03 Point #REGhl at the game tick counter (#R$72F2).
  $ABC3,$01 Fetch the game tick counter into #REGa.
  $ABC4,$03 Is the game tick counter zero? If so, jump to #R$ABC9.
  $ABC7,$01 Decrease the game tick counter.
  $ABC8,$01 Return.
N $ABC9 With no active task, either run Berk's action path or pick a random
. idle-script selector.
@ $ABC9 label=Update_Berk_State_Branch
  $ABC9,$03 Load #REGa with the current task index (#R$72AE).
  $ABCC,$03 Is the current task index zero? If not, jump to #R$AC48.
  $ABCF,$03 Load #REGa with the task status flags (#R$72B4).
  $ABD2,$04 Is bit #N$00 of the task status flags set? If so, jump to #R$AC29.
  $ABD6,$03 Point #REGhl at #R$72C9.
  $ABD9,$03 Load #REGa with Berk's action lock (#R$72C8).
  $ABDC,$03 Is Berk's action lock zero? If not, jump to #R$ABE5.
  $ABDF,$04 Advance Berk's action lock by one.
  $ABE3,$02 Jump to #R$AC15 with task #N$01 in #REGa.
N $ABE5 Pick a random task-selection slot and prepare to try up to #N$04
. candidates.
@ $ABE5 label=Update_Berk_State_RandomActionPick
  $ABE5,$02 Load #REGa with #N$04.
  $ABE7,$04 Call #R$EAE5 to pick a pseudo-random offset and keep it in #REGc.
  $ABEB,$02 Clear #REGb so #REGbc is the random offset alone.
  $ABED,$01 Advance #REGhl by the random offset in #REGbc.
  $ABEE,$02 Load #REGa with #N$04 as the try counter.
N $ABF0 Skip used task slots; free slots fall through, used ones try the next
. candidate.
@ $ABF0 label=Update_Berk_State_TrySelectorRow
  $ABF0,$04 Is this task slot already used (bit #N$07)? If not, jump to #R$AC14.
  $ABF4,$01 Advance the pointer in #REGhl by one byte.
  $ABF5,$04 Is the wrap marker (bit #N$06) clear? If so, jump to #R$ABFC.
  $ABF9,$03 Point #REGhl at #R$72C9.
N $ABFC Exhaust selector tries, then either run Berk's action or force task
. index #N$05 after resetting defaults.
@ $ABFC label=Update_Berk_State_DecTryCounter
  $ABFC,$01 Decrease the try counter in #REGa.
  $ABFD,$02 Jump to #R$ABF0 while tries remain.
  $ABFF,$03 Load #REGa with the dialogue line index (#R$72B0).
  $AC02,$05 Is the dialogue line index less than #N$04? If so, jump to #R$AC29.
  $AC07,$03 Load #REGa with the Learner Berk mode flag (#R$72A9).
  $AC0A,$03 Is the Learner Berk mode flag zero? If not, jump to #R$AC29.
  $AC0D,$03 Call #R$AB76 to initialise entity defaults.
  $AC10,$02 Load #REGa with #N$05.
  $AC12,$02 Jump to #R$AC17 to store task index #N$05.
N $AC14 Take the free selector byte as the new task index.
@ $AC14 label=Update_Berk_State_TakeSelectorByte
  $AC14,$01 Fetch the selected byte through #REGhl into #REGa.
N $AC15 Mark the selected task slot as used with bit #N$07.
@ $AC15 label=Update_Berk_State_MarkTaskSlotUsed
  $AC15,$02 Mark the selected task slot as used (bit #N$07).
N $AC17 Announce the new task, reset the text cursor, seed the held-entity
. countdown and refresh the room display.
@ $AC17 label=Update_Berk_State_SetTaskIndexAndAnnounce
  $AC17,$03 Set the current task index (#R$72AE).
  $AC1A,$03 Call #R$DE51 to print a message by index.
  $AC1D,$03 Call #R$AD47 to reset the text position.
  $AC20,$02 Load #REGa with #N$A0.
  $AC22,$03 Set the held-entity pointer (#R$72DB).
  $AC25,$03 Call #R$AF01 to initialise the room display.
  $AC28,$01 Return.
N $AC29 Run Berk's action handler; if task status bit #N$05 is set, refresh the
. room display and act again before restart.
@ $AC29 label=Update_Berk_State_ActionAndMaybeRestart
  $AC29,$03 Call #R$AECC to handle Berk's action.
  $AC2C,$03 Call #R$AD98 to clear messaging attributes.
  $AC2F,$03 Load #REGa with the task status flags (#R$72B4).
  $AC32,$04 Is bit #N$05 of the task status flags set? If not, jump to #R$AC41.
  $AC36,$02 Load #REGa with #N$C8.
  $AC38,$03 Set the held-entity pointer (#R$72DB).
  $AC3B,$03 Call #R$AF01 to initialise the room display.
  $AC3E,$03 Call #R$AECC to handle Berk's action.
N $AC41 Print status/rating messages and restart the game at #R$AAAB.
@ $AC41 label=Update_Berk_State_PrintStatusAndRestart
  $AC41,$03 Call #R$DE19 to print status messages.
  $AC44,$01 Restore #REGbc from the stack.
  $AC45,$03 Jump to #R$AAAB to restart the game.
N $AC48 While a timed event is quiet, tick the frame counter and fall through
. when it expires.
@ $AC48 label=Update_Berk_State_ActiveTaskFrameTick
  $AC48,$03 Load #REGa with the timed event latch (#R$72CE).
  $AC4B,$02 Is the timed event latch zero? If not, return.
  $AC4D,$03 Load #REGa with the frame counter (#R$72C6).
  $AC50,$04 Step the frame counter back by one.
  $AC54,$01 Return unless the frame counter is now zero.
  $AC55,$03 Load #REGa with the Learner Berk mode flag (#R$72A9).
  $AC58,$03 Is the Learner Berk mode flag zero? If so, jump to #R$AC5D.
  $AC5B,$02 Load #REGa with #N$05.
N $AC5D Reload the frame counter, advance the task timer, and either paint the
. attr strip or play the task-fanfare path.
@ $AC5D label=Update_Berk_State_ReloadFrameCounter
  $AC5D,$02 Add #N$0F to #REGa.
  $AC5F,$03 Set the frame counter (#R$72C6).
  $AC62,$03 Load #REGa with the task timer (#R$72F0).
  $AC65,$04 Advance the task timer by one.
  $AC69,$04 Is the task timer less than #N$A0? If so, jump to #R$ACA2.
N $AC6D #HTML(#AUDIO0(task-fanfare.wav)(#INCLUDE(TaskFanfare)))
  $AC6D,$02 Load #REGa with sound index #N$0B.
  $AC6F,$03 Call #R$F8F9 to queue a sound.
  $AC72,$03 Call #R$F9AF to play the queued sound.
  $AC75,$03 Load #REGa with the current task index (#R$72AE).
  $AC78,$05 Is the current task index equal to #N$05? If so, jump to #R$AC41.
  $AC7D,$03 Load #REGa with the Learner Berk mode flag (#R$72A9).
  $AC80,$04 Is the Learner Berk mode flag zero? If so, jump to #R$AC41.
  $AC84,$01 Clear #REGa.
  $AC85,$03 Set the current task index (#R$72AE).
  $AC88,$03 Load #REGa with the current task phase (#R$72AF).
  $AC8B,$04 Is the current task phase equal to #N$01? If not, jump to #R$AC93.
  $AC8F,$04 Step the current task phase back by one.
N $AC93 Print too-late feedback, handle Berk's action, and reload the game tick
. counter.
@ $AC93 label=Update_Berk_State_TooLateFeedback
  $AC93,$03 Call #R$DDA3 to print too-late task feedback.
  $AC96,$03 Call #R$AD47 to reset the text position.
  $AC99,$03 Call #R$AECC to handle Berk's action.
  $AC9C,$02 Load #REGa with #N$46 as the game tick reload value.
  $AC9E,$03 Set the game tick counter (#R$72F2).
  $ACA1,$01 Return.
N $ACA2 Choose an attribute value from the task timer (bright white, or divide
. to map into the ink range).
@ $ACA2 label=Update_Berk_State_AttrStripFromSeed
  $ACA2,$03 Load #REGa with the task timer (#R$72F0).
  $ACA5,$04 Is the task timer less than #N$9C? If so, jump to #R$ACAD.
  $ACA9,$02 Load #REGa with #N$C7.
  $ACAB,$02 Jump to #R$ACB7 to paint the attribute strip.
N $ACAD Set up divisor #N$17 to map the task timer into an attribute ink.
@ $ACAD label=Update_Berk_State_DivModSetup
  $ACAD,$03 Load #REGbc with #N($0017,$04,$04).
N $ACB0 Divide the task timer by #N$17 and bias the quotient into the attribute
. ink range.
@ $ACB0 label=Update_Berk_State_DivModLoop
  $ACB0,$01 Increment the quotient counter in #REGb.
  $ACB1,$01 Subtract #REGc from #REGa.
  $ACB2,$02 Jump to #R$ACB0 while #REGa remains at least #REGc.
  $ACB4,$01 Copy the quotient from #REGb into #REGa.
  $ACB5,$02 Add #N$40 to #REGa.
N $ACB7 Point at the status attribute strip
. (#N$5AA4 (attribute buffer)) ready to paint.
@ $ACB7 label=Update_Berk_State_Hit
  $ACB7,$03 Point #REGhl at attribute-file address #N$5AA4 (attribute buffer).
  $ACBA,$02 Load #REGb with #N$14 as a loop counter.
N $ACBC Fill the status attribute strip, then prepare to scan the matching
. screen row.
@ $ACBC label=Update_Berk_State_Exit
  $ACBC,$01 Store #REGa at the address in #REGhl.
  $ACBD,$01 Advance #REGhl by one byte.
  $ACBE,$02 Decrease the loop counter in #REGb and jump to #R$ACBC while bytes
. remain.
  $ACC0,$03 Point #REGhl at screen address #N$51A4 (screen buffer).
  $ACC3,$02 Load #REGb with #N$13 as a loop counter.
N $ACC5 Scan the status screen row for a non-#N$FF cell to rotate.
@ $ACC5 label=Update_Berk_State_PartA
  $ACC5,$01 Fetch the next byte through #REGhl into #REGa.
  $ACC6,$04 Is the fetched byte equal to #N$FF? If not, jump to #R$ACCD.
  $ACCA,$01 Advance #REGhl by one byte.
  $ACCB,$02 Decrease the loop counter in #REGb and jump to #R$ACC5 while bytes
. remain.
N $ACCD Prepare to rotate six pixel rows of the found status glyph.
@ $ACCD label=Update_Berk_State_PartB
  $ACCD,$02 Load #REGb with #N$06 as a loop counter.
N $ACCF Rotate the status glyph down the screen rows, then count down the
. held-entity pointer if set.
@ $ACCF label=Update_Berk_State_PartC
  $ACCF,$01 Signal success.
  $ACD0,$02 Rotate right the byte at #REGhl.
  $ACD2,$01 Advance the high byte of the pointer in #REGhl.
  $ACD3,$02 Decrease the loop counter in #REGb and jump to #R$ACCF while rows
. remain.
  $ACD5,$03 Load #REGhl with the held-entity pointer (#R$72DB).
  $ACD8,$01 Copy the high byte of the pointer into #REGa.
  $ACD9,$01 Merge the low byte of the pointer into #REGa.
  $ACDA,$01 Return if the held-entity pointer is zero.
  $ACDB,$01 Step the held-entity pointer back by one.
  $ACDC,$03 Store #REGhl in the held-entity pointer (#R$72DB).
  $ACDF,$03 Jump to #R$AF1E to reprint the bonus.

g $ACE2 Pointer: Berk Script Table Base
@ $ACE2 label=Pointer_BerkScriptTableBase
D $ACE2 Saved base address of the Berk script table while #R$ACE4 walks a random
. entry. Written on entry to #R$ACE4 and reloaded when a candidate row is
. rejected.
W $ACE2,$02

c $ACE4 Start Berk Script
@ $ACE4 label=Start_Berk_Script
D $ACE4 Pick a Berk script row from the table at #REGhl and enter #R$EC30.
R $ACE4 HL Base of the Berk script table to sample
R $ACE4 A Number of candidate rows to skip / try
  $ACE4,$03 Save the script-table base at #R$ACE2.
  $ACE7,$03 Remember the original row count at #R$ACE4(#N$AD03).
N $ACEA Pick a random Berk script-table row from the candidate base.
@ $ACEA label=Start_Berk_Script_PickRandom
  $ACEA,$01 Stash #REGaf on the stack.
  $ACEB,$04 Call #R$EAE5 to pick a pseudo-random offset and keep it in #REGc.
  $ACEF,$02 Clear #REGb so #REGbc is the random offset alone.
  $ACF1,$01 Advance #REGhl to the randomly chosen table row.
  $ACF2,$01 Restore #REGaf from the stack.
N $ACF3 Claim a free script row, or step on / reload the table when the
. candidate is busy.
@ $ACF3 label=Start_Berk_Script_TestRowInUse
  $ACF3,$04 Is this script row already marked in-use (bit #N$07)? If not, take
. it at #R$AD13.
  $ACF7,$01 Step to the flags byte of the next candidate.
  $ACF8,$04 Is this candidate free (bit #N$06 clear)? If so, restart from the
. saved base at #R$ACFF.
  $ACFC,$03 Reload the script-table base from #R$ACE2.
N $ACFF Count down remaining script-row tries; when exhausted, clear in-use bits
. and retry.
@ $ACFF label=Start_Berk_Script_CountTries
  $ACFF,$03 Count down the remaining tries, then loop to #R$ACF3 while tries
. remain.
  $AD02,$02 Only one clear-pass remains, then continue into the in-use-bit reset
. at #R$AD08.
  $AD04,$03 Reload the script-table base from #R$ACE2.
  $AD07,$01 Stash #REGhl on the stack.
N $AD08 Clear every script-row in-use flag, then retry a fresh random pick.
@ $AD08 label=Start_Berk_Script_Branch
  $AD08,$02 Clear the script-row in-use flag (bit #N$07 of the Berk script table
. entry).
  $AD0A,$01 Advance the current pointer by one byte.
  $AD0B,$02 Decrease the loop counter in #REGb and jump to #R$AD08 if more
. iterations remain.
  $AD0D,$01 Restore #REGhl from the stack.
  $AD0E,$03 Reload the original row-count from the self-modifying byte at
. #R$ACE4(#N$AD03).
  $AD11,$02 Jump to #R$ACEA to try another Berk script row.
N $AD13 Claim this script row by setting its in-use flag and return the selected
. byte.
@ $AD13 label=Start_Berk_Script_ClaimRow
  $AD13,$01 Fetch the next byte from the current pointer.
  $AD14,$02 Set the script-row in-use flag (bit #N$07 of the Berk script table
. entry).
  $AD16,$01 Return.

b $AD17 Data: Menu Glyph Bitmaps
@ $AD17 label=Data_MenuGlyphBitmaps
D $AD17 Soft-character bitmaps for status/menu text. #R$AD47 / #R$AF56 point
. #R$72F9 here; #R$EB67 reads each glyph as #N($0008,$04,$04) pixel rows via
. #R$EB7A / #R$EB82.
. #UDGTABLE { #UDGARRAY$06,scale=$04($AD17-$AD3F-$08-$08)(menu-glyph-bitmaps) }
. UDGTABLE#
  $AD17,$08
L $AD17,$08,$06

c $AD47 Reset Text Position
@ $AD47 label=Reset_Text_Position
D $AD47 Reset the status/menu text cursor to the glyph bitmap at #R$AD17.
  $AD47,$01 Clear #REGa ready to reset the task timer.
  $AD48,$03 Set the task timer (#R$72F0).
  $AD4B,$03 Point #REGhl at the menu glyph bitmaps (#R$AD17).
  $AD4E,$03 Write the pointer in #REGhl to the temporary screen pointer
. (#R$72F9).
  $AD51,$03 Call #R$AD6F to print Menu Strings.
  $AD54,$01 Mask #REGa with #REGb.
  $AD55,$01 Copy #REGd into #REGe (build a pointer/offset).
  $AD56,$01 Write the loop counter through the pointer in #REGhl.
  $AD57,$03 Load #REGbc with #N$0302 as a room/position constant.
  $AD5A,$01 Copy #REGl into #REGe (build a pointer/offset).
  $AD5B,$02 Load #REGa with #N$02.
  $AD5D,$03 Set the temporary room/state byte (#R$7307).
  $AD60,$03 Point #REGhl at attribute-file address #N$5AA4 (attribute buffer).
  $AD63,$02 Load #REGb with #N$14 as a loop counter.
  $AD65,$03 Clear #REGde (zero offset).
N $AD68 Print the status/menu glyph run across the attribute strip at
. #N$5AA4 (attribute buffer).
@ $AD68 label=Reset_Text_Position_PrintLoop
  $AD68,$03 Call #R$EB67 to print Character.
  $AD6B,$01 Advance #N$5AA4 (attribute buffer) by one byte.
  $AD6C,$02 Decrease the loop counter in #REGb and jump to #R$AD68 if more
. iterations remain.
  $AD6E,$01 Return.

c $AD6F Print Menu Strings
@ $AD6F label=Print_Menu_Strings
D $AD6F Print a menu printer stream from #REGbc. Fragment headers are three
. bytes (address low/high, attribute); #CHR$26 (#N$26) starts a new fragment;
. #CHR$5D (#N$5D) ends the stream. Uses the character set at #R$72F9.
N $AD6F Entry: pop the CALL return address into #REGbc as the printer-stream
. pointer.
  $AD6F,$01 Pop the stream pointer into #REGbc.
N $AD70 Read the next menu-string fragment header: screen address and attribute
. into #R$7307.
@ $AD70 label=Print_Menu_Strings_FetchByte
  $AD70,$01 Fetch a byte through the pointer in #REGbc.
  $AD71,$01 Keep the screen-address low byte in #REGl.
  $AD72,$01 Advance the stream pointer in #REGbc by one.
  $AD73,$01 Fetch a byte through the pointer in #REGbc.
  $AD74,$01 Keep the screen-address high byte in #REGh.
  $AD75,$01 Advance the counter/pointer in #REGbc by one.
  $AD76,$01 Fetch a byte through the pointer in #REGbc.
  $AD77,$03 Set the temporary room/state byte (#R$7307).
  $AD7A,$01 Advance the counter/pointer in #REGbc by one.
  $AD7B,$02 Clear #REGd (high byte of a pointer/offset).
N $AD7D Fetch the next glyph: #N$26 starts a new fragment, #N$5D ends the
. stream, else print it.
@ $AD7D label=Print_Menu_Strings_FetchGlyph
  $AD7D,$01 Fetch a byte through the pointer in #REGbc.
  $AD7E,$01 Advance the counter/pointer in #REGbc by one.
  $AD7F,$04 Is #REGa equal to #N$26? If so, jump to #R$AD70.
  $AD83,$04 Is #REGa equal to #N$5D? If not, jump to #R$AD89.
  $AD87,$01 Stash #REGbc on the stack.
  $AD88,$01 Return.
N $AD89 Print one menu glyph and loop for the next, then clear the display
. buffers on the fall-through path.
@ $AD89 label=Print_Menu_Strings_PrintGlyph
  $AD89,$01 Keep the glyph code in #REGe for #R$EB67.
  $AD8A,$03 Call #R$EB67 to print Character.
  $AD8D,$01 Advance the current pointer by one byte.
  $AD8E,$02 Jump to #R$AD7D to print the next menu glyph.
  $AD90,$03 Call #R$EA3C to clear both display buffers.
  $AD93,$02 Load #REGa with #N$12.
  $AD95,$03 Call #R$EA52 to clear Attribute File.

c $AD98 Clear Messaging Attributes
@ $AD98 label=Clear_Messaging_Attributes
D $AD98 Blank the attribute cells behind the status / menu message area so the
. next printed line starts on a clean strip.
  $AD98,$03 Clear #REGbc (zero length/offset).
N $AD9B Busy-wait the messaging-attribute clear countdown down to zero.
@ $AD9B label=Clear_Messaging_Attributes_Countdown
  $AD9B,$01 Step the length/counter in #REGbc back by one.
  $AD9C,$01 Copy the loop counter from #REGb into #REGa.
  $AD9D,$01 OR #REGc into #REGa to test whether #REGbc has reached zero.
  $AD9E,$02 If the result was non-zero, jump to #R$AD9B.
  $ADA0,$01 Return.

c $ADA1 Update Timed Events
@ $ADA1 label=Update_Timed_Events
D $ADA1 Once per frame: run timed room events, fanfares and the script-temporary
. countdown while a task is active.
  $ADA1,$03 Load #REGa with the timed event latch (#R$72CE).
  $ADA4,$02 Is timed event latch zero? If so, return.
  $ADA6,$04 Point #REGix at the dumb-waiter entity (#R$8D7D).
  $ADAA,$04 Is timed event latch equal to #N$1C? If not, jump to #R$ADEC.
  $ADAE,$01 Clear the timed event latch.
  $ADAF,$03 Set the timed event latch.
  $ADB2,$04 Load #REGix from the trap door entity pointer (#R$8D89).
  $ADB6,$03 Fetch the current entity's type for the type test.
  $ADB9,$04 Is the current entity's entity type less than #N$14? If so, jump to
. #R$ADDE.
  $ADBD,$06 Is bit #N$06 of the current entity's flags byte 1 set? If not,
. jump to #R$ADDE.
  $ADC3,$04 Reset bit #N$06 of the current entity's flags byte 1.
  $ADC7,$03 Advance this entity into the next room.
  $ADCA,$06 Move this entity one character down.
  $ADD0,$03 Advance this entity into the next room.
  $ADD3,$06 Move this entity one character down.
  $ADD9,$03 Point #REGhl at the game event flags (#R$72B3).
  $ADDC,$02 Clear "object has been offered to the trap" (bit #N$03 of #R$72B3).
N $ADDE Force the lever scenery slot onto closed facing left at #R$A827.
@ $ADDE label=Update_Timed_Events_TrapDoorLayout
  $ADDE,$04 Point #REGix at the lever scenery entity (#R$8D8B).
  $ADE2,$03 Load #REGbc with the lever closed, facing left (#R$A827).
  $ADE5,$03 Set the low byte of the current entity's graphic layout address from
. #REGc.
  $ADE8,$03 Set the high byte of the current entity's graphic layout address
. from #REGb.
  $ADEB,$01 Return.
N $ADEC Advance the timed-event entity type, queue a cue, and either raise or
. lower it toward the trap.
@ $ADEC label=Update_Timed_Events_AdvanceTypeAndSound
  $ADEC,$01 Advance the current entity's entity type by one.
  $ADED,$03 Set the timed event latch.
  $ADF0,$05 Is the current entity's entity type equal to #N$0F? If so, jump to
. #R$AE2A.
  $ADF5,$01 Stash #REGaf on the stack.
N $ADF6 #HTML(#AUDIO0(timed-event.wav)(#INCLUDE(TimedEvent)))
  $ADF6,$02 Load #REGa with sound index #N$0C.
  $ADF8,$03 Call #R$F8F9 to queue a sound effect.
  $ADFB,$01 Restore #REGaf from the stack.
  $ADFC,$02 If no borrow/miss was signaled, jump to #R$AE14.
  $ADFE,$06 Move this entity one character up.
  $AE04,$04 Load #REGix from the trap door entity pointer (#R$8D89).
  $AE08,$05 Is bit #N$06 of the current entity's flags byte 1 set? If not,
. return.
  $AE0D,$06 Move this entity one character up.
  $AE13,$01 Return.
N $AE14 Lower the timed-event entity (and the offered trap entity if flagged)
. one character.
@ $AE14 label=Update_Timed_Events_RaiseEntityY
  $AE14,$06 Move this entity one character down.
  $AE1A,$04 Load #REGix from the trap door entity pointer (#R$8D89).
  $AE1E,$05 Is bit #N$06 of the current entity's flags byte 1 set? If not,
. return.
  $AE23,$06 Move this entity one character down.
  $AE29,$01 Return.
N $AE2A When the timed event finishes on task #N($05), latch Berk's eat/action
. path or run the fanfare branch.
@ $AE2A label=Update_Timed_Events_Branch
  $AE2A,$03 Load #REGa with the current task index (#R$72AE).
  $AE2D,$02 Is current task index zero? If so, return.
  $AE2F,$04 Is current task index equal to #N$05? If not, jump to #R$AE54.
  $AE33,$03 Load #REGa with the task status flags (#R$72B4).
  $AE36,$03 Is bit #N$06 of task status flags set? If so, return.
  $AE39,$04 Is bit #N$07 of task status flags set? If not, jump to #R$AE63.
  $AE3D,$02 Set "Berk action / eat latch" (bit #N$06 of #R$72B4).
  $AE3F,$03 Set the task status flags (#R$72B4).
  $AE42,$04 Point #REGiy at the inactive complex-entity slot (#R$907F).
  $AE46,$04 Write #N$17 to the referenced entity's entity type.
  $AE4A,$04 Set bit #N$06 of the referenced entity's flags byte 1.
  $AE4E,$04 Store #REGiy in the trap door entity pointer (#R$8D89).
  $AE52,$02 Jump to #R$AE63 to finish the timed-event pass.
N $AE54 If an entity was offered to the trap, copy its type into the message
. trigger.
@ $AE54 label=Update_Timed_Events_TrapEntityMessage
  $AE54,$04 Load #REGix from the trap door entity pointer (#R$8D89).
  $AE58,$05 Is bit #N$06 of the current entity's flags byte 1 set? If not,
. return.
  $AE5D,$03 Fetch the current entity's type into #REGa.
  $AE60,$03 Set the message trigger (#R$72C5).
N $AE63 Select the task-progress message, clear the offered-to-trap flag, and
. tidy helper slots on task #N$01.
@ $AE63 label=Update_Timed_Events_TaskProgressFanfare
  $AE63,$02 Stash #REGix on the stack.
  $AE65,$03 Call #R$E25E to select Task Progress Message.
  $AE68,$02 Restore #REGix from the stack.
  $AE6A,$03 Load #REGa with the task progress repeat count (#R$72F1).
  $AE6D,$02 Return if the task progress repeat count is zero.
  $AE6F,$03 Load #REGa with the game event flags (#R$72B3).
  $AE72,$02 Clear "object has been offered to the trap" (bit #N$03 of #R$72B3).
  $AE74,$03 Set the game event flags (#R$72B3).
  $AE77,$03 Load #REGa with the current task index (#R$72AE).
  $AE7A,$04 Is current task index equal to #N$01? If not, jump to #R$AE96.
  $AE7E,$01 Clear the current task phase (idle).
  $AE7F,$03 Set the current task phase (#R$72AF).
  $AE82,$04 Point #REGiy at the inactive complex-entity slot (#R$8F9F).
  $AE86,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $AE89,$02 Load #REGb with #N$03 as a loop counter.
N $AE8B Clear helper entity types/flags across the upstairs helper slots.
@ $AE8B label=Update_Timed_Events_ClearHelperTypes
  $AE8B,$03 Set the referenced entity's entity type.
  $AE8E,$04 Reset bit #N$05 of the referenced entity's flags byte 1.
  $AE92,$02 Advance #REGiy to the next entity record.
  $AE94,$02 Decrease the loop counter in #REGb and jump to #R$AE8B if more
. iterations remain.
N $AE96 Deactivate the timed-event entity, advance dialogue, handle Berk's
. action and reload the tick counter.
@ $AE96 label=Update_Timed_Events_AdvanceDialogue
  $AE96,$01 Clear the current entity type (deactivate the slot).
  $AE97,$03 Set the current entity's entity type.
  $AE9A,$03 Set the current task index (#R$72AE).
  $AE9D,$03 Load #REGa with the dialogue line index (#R$72B0).
  $AEA0,$01 Advance dialogue line index by one.
  $AEA1,$03 Set the dialogue line index (#R$72B0).
  $AEA4,$03 Call #R$AECC to handle Berk's action.
  $AEA7,$03 Call #R$AD47 to reset the text position.
  $AEAA,$02 Load #REGa with #N$50 as the game tick reload value.
  $AEAC,$03 Set the game tick counter (#R$72F2).
N $AEAF Choose the held-entity countdown length (#N($0019), doubled outside
. Learner Berk mode).
@ $AEAF label=Update_Timed_Events_HeldCountdownStep
  $AEAF,$03 Load #REGhl with #N($0019,$04,$04) as a delay/count constant.
  $AEB2,$03 Load #REGa with the Learner Berk mode flag (#R$72A9).
  $AEB5,$03 Is Learner Berk mode flag zero? If not, jump to #R$AEB9.
  $AEB8,$01 Double the pointer/offset in #REGhl.
N $AEB9 Store the bonus, refresh the room display/action, and repeat until the
. task progress repeat count hits zero.
@ $AEB9 label=Update_Timed_Events_StoreHeldAndRefresh
  $AEB9,$03 Store #REGhl in the pointer to the entity Berk is holding (#R$72DB).
  $AEBC,$03 Call #R$AF01 to initialise the room display.
  $AEBF,$03 Call #R$AECC to handle Berk's action.
  $AEC2,$03 Load #REGa with the task progress repeat count (#R$72F1).
  $AEC5,$01 Decrease the task progress repeat count in #REGa by one.
  $AEC6,$03 Set the task progress repeat count (#R$72F1).
  $AEC9,$02 If the result was non-zero, jump to #R$AEAF.
  $AECB,$01 Return.

c $AECC Handle Berk Action
@ $AECC label=Handle_Berk_Action
D $AECC Flash the status attribute strip, play a stinger, clear messaging attrs,
. then count down #R$72DB / score.
  $AECC,$03 Point #REGhl at attribute-file address #N$5AB9 (attribute buffer).
  $AECF,$02 Load #REGb with #N$06 as a loop counter.
N $AED1 Paint the status attribute strip bright, play Berk's action stinger,
. then clear messaging attrs.
@ $AED1 label=Handle_Berk_Action_FillAttributes
  $AED1,$02 Write attribute/value #N$78 through the pointer in #REGhl.
  $AED3,$01 Advance #N$5AB9 (attribute buffer) by one byte.
  $AED4,$02 Decrease the loop counter in #REGb and jump to #R$AED1 if more
. iterations remain.
N $AED6 #HTML(#AUDIO0(berk-action.wav)(#INCLUDE(BerkAction)))
  $AED6,$02 Load #REGa with sound index #N$02.
  $AED8,$03 Call #R$F8F9 to queue a sound effect.
  $AEDB,$03 Call #R$F9AF to play a fanfare / stinger.
  $AEDE,$03 Call #R$AD98 to clear messaging attributes.
N $AEE1 Count down the held-entity pointer and bump the score while #R$72DB is
. non-zero.
@ $AEE1 label=Handle_Berk_Action_ScoreHeldCountdown
  $AEE1,$03 Load #REGhl with the pointer to the entity Berk is holding
. (#R$72DB).
  $AEE4,$01 Copy the high byte of the pointer into #REGa.
  $AEE5,$01 OR #REGl into #REGa to test whether #R$72DB is zero.
  $AEE6,$03 If the result was zero, jump to #R$AF01.
  $AEE9,$01 Step pointer to the entity Berk is holding back by one byte.
  $AEEA,$03 Store #REGhl in the pointer to the entity Berk is holding (#R$72DB).
  $AEED,$03 Load #REGhl with the score (#R$72DD).
  $AEF0,$01 Advance score by one byte.
  $AEF1,$03 Store #REGhl in the score (#R$72DD).
  $AEF4,$03 Call #R$AF01 to initialise the room display.
N $AEF7 #HTML(#AUDIO0(score.wav)(#INCLUDE(Score)))
  $AEF7,$02 Load #REGa with sound index #N$01.
  $AEF9,$03 Call #R$F8F9 to queue a sound effect.
  $AEFC,$03 Call #R$F9AF to play a fanfare / stinger.
  $AEFF,$02 Jump to #R$AEE1 to keep scanning held-entity slots.

c $AF01 Initialise Room Display
@ $AF01 label=Initialise_Room_Display
D $AF01 Print the score and a short attr-file label stream via #R$AD6F, then the
. held-countdown stream.
  $AF01,$03 Load #REGhl with the score (#R$72DD).
  $AF04,$04 Point #REGix at room-display data (#R$AF17).
  $AF08,$03 Call #R$EB20 to print Score Digits.
  $AF0B,$03 Point #REGhl at #SKOOLKID$3D00(CHARSET)-#N$0100.
  $AF0E,$03 Write the pointer in #REGhl to the temporary screen pointer
. (#R$72F9).
  $AF11,$03 Call #R$AD6F to print Menu Strings.
  $AF14,$01 Swap the main register pairs with their alternates.
  $AF15,$01 Copy #REGd into #REGe (build a pointer/offset).
  $AF16,$01 Keep #REGa in #REGb for later.
  $AF17,$02 If the result was non-zero, jump to #R$AF01(#N$AF39).
  $AF19,$02 If the result was non-zero, jump to #R$AF4B.
  $AF1B,$02 If no borrow/miss was signaled, jump to #R$AF3C(#N$AF4D).
  $AF1D,$01 Copy #REGl into #REGe (build a pointer/offset).
N $AF1E Print the held-entity countdown digits and its trailing menu-string
. stream.
@ $AF1E label=Initialise_Room_Display_HeldEntity
  $AF1E,$03 Load #REGhl with the pointer to the entity Berk is holding
. (#R$72DB).
  $AF21,$04 Point #REGix at room-display data (#R$AF34).
  $AF25,$03 Call #R$EB20 to print Score Digits.
  $AF28,$03 Point #REGhl at #SKOOLKID$3D00(CHARSET)-#N$0100.
  $AF2B,$03 Write the pointer in #REGhl to the temporary screen pointer
. (#R$72F9).
  $AF2E,$03 Call #R$AD6F to print Menu Strings.
  $AF31,$01 Compare #REGa with #REGc (menu-string scan marker).
  $AF32,$01 Copy #REGd into #REGe (build a pointer/offset).
  $AF33,$01 Load #REGb from the byte at #REGhl.
  $AF34,$02 If the result was non-zero, jump to #R$AF56.
  $AF36,$02 If the result was non-zero, jump to #R$AF68.
  $AF38,$02 If no borrow/miss was signaled, jump to #R$AF6A.
  $AF3A,$01 Copy #REGl into #REGe (build a pointer/offset).
  $AF3B,$01 Return.

c $AF3C Initialise New Game
@ $AF3C label=Initialise_New_Game
D $AF3C Start a new game: reset display buffers, tick counter, menu glyphs and
. room state for Learner or Super Berk.
  $AF3C,$03 Call #R$AFA9 to backup Entity And Game State.
  $AF3F,$03 Point #REGhl at Primary Display Buffer (#R$63A0).
  $AF42,$03 Store #REGhl in Pointer: Current Display Buffer (#R$72F5).
  $AF45,$01 Clear the display-buffer select flag.
  $AF46,$03 Set Display Buffer Select Flag (#R$72EA).
  $AF49,$02 Load #REGa with #N$64 as the initial game tick counter.
N $AF4B Set the game tick counter, clear both display buffers, and set the
. border/speaker state.
@ $AF4B label=Initialise_New_Game_SetTickCounter
  $AF4B,$03 Set the game tick counter (#R$72F2).
  $AF4E,$03 Call #R$EA3C to clear both display buffers.
  $AF51,$02 Load #REGa with #N$02.
  $AF53,$03 Call #R$EA6D to set Border And Speaker State.
N $AF56 Point the glyph printer at #R$AD17 and choose the Learner (#N$7A) vs
. Super Berk (#N$68) room byte.
@ $AF56 label=Initialise_New_Game_SetGlyphPointer
  $AF56,$03 Point #REGhl at the menu/glyph bitmap data (#R$AD17).
  $AF59,$03 Write the pointer in #REGhl to the temporary screen pointer
. (#R$72F9).
  $AF5C,$02 Load #REGe with #N$04 as a small loop/position count.
  $AF5E,$03 Load #REGa with the Learner Berk mode flag (#R$72A9).
  $AF61,$03 Is Learner Berk mode flag zero? If so, jump to #R$AF68.
  $AF64,$02 Load #REGa with #N$7A.
  $AF66,$02 Jump to #R$AF6B to set the temporary room/state byte.
N $AF68 Super Berk path: use room/state byte #N$68.
@ $AF68 label=Initialise_New_Game_SuperBerkRoomByte
  $AF68,$02 Load #REGa with #N$68.
N $AF6A Advance the small position count before writing the room/state byte.
@ $AF6A label=Initialise_New_Game_Branch
  $AF6A,$01 Advance the low byte of the pointer/offset in #REGde.
N $AF6B Write the room/state byte and prepare to fill the attribute-file base
. row.
@ $AF6B label=Initialise_New_Game_WriteRoomByte
  $AF6B,$03 Set the temporary room/state byte (#R$7307).
  $AF6E,$02 Load #REGb with #N$80 as a loop counter.
  $AF70,$02 Clear #REGd (high byte of a pointer/offset).
  $AF72,$03 Point #REGhl at the attribute-file base
. (#N$5A80 (attribute buffer)).
N $AF75 Print a full attribute-file row of glyphs, then initialise the room
. display.
@ $AF75 label=Initialise_New_Game_PrintAttrRow
  $AF75,$03 Call #R$EB67 to print Character.
  $AF78,$01 Advance #N$5A80 (attribute buffer) by one byte.
  $AF79,$02 Decrease the loop counter in #REGb and jump to #R$AF75 if more
. iterations remain.
  $AF7B,$03 Call #R$AF01 to initialise the room display.
  $AF7E,$01 Return.

c $AF7F Check Task Completion
@ $AF7F label=Check_Task_Completion
D $AF7F Check Task Completion for the current Thing Upstairs task.
  $AF7F,$03 Load #REGa with the current task index (#R$72AE).
  $AF82,$03 Is current task index equal to #N$05? If not, return.
  $AF85,$03 Load #REGa with the task status flags (#R$72B4).
  $AF88,$03 Is bit #N$07 of task status flags set? If so, return.
  $AF8B,$03 Point #REGhl at Boney's complex entity state (#R$8EE9).
  $AF8E,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
N $AF91 Scan Boney's complex state for the #N$37 busy pattern that marks task
. completion.
@ $AF91 label=Check_Task_Completion_ScanBerk
  $AF91,$01 Fetch the next byte from Boney's complex entity state.
  $AF92,$04 Is task status flags equal to #N$37? If so, jump to #R$AFA3.
  $AF96,$04 Is task status flags equal to #N$01? If so, jump to #R$AFA0.
  $AF9A,$04 Is bit #N$07 of task status flags set? If so, jump to #R$AFA0.
  $AF9E,$02 Is task status flags zero? If not, return.
N $AFA0 Advance to the next Berk state record and keep scanning for completion.
@ $AFA0 label=Check_Task_Completion_NextBerkRecord
  $AFA0,$01 Add the offset in #REGde to the pointer in #REGhl.
  $AFA1,$02 Jump to #R$AF91 to keep testing task-status combinations.
N $AFA3 Mark task status bit #N$07 so Berk's script/dialogue is busy.
@ $AFA3 label=Check_Task_Completion_SetBusyBit7
  $AFA3,$03 Point #REGhl at the task status flags (#R$72B4).
  $AFA6,$02 Set "Berk script / dialogue busy" (bit #N$07 of #R$72B4).
  $AFA8,$01 Return.

c $AFA9 Backup Entity And Game State
@ $AFA9 label=Backup_Entity_And_Game_State
D $AFA9 Backup entity and game state walking the entity tables at #R$8B69 /
. #R$8EE9.
N $AFA9 Measure and copy Boney's complex entity state into the backup buffer at
. #R$FA0E.
  $AFA9,$03 Point #REGhl at State Data: Scenery Entities (#R$90B7).
  $AFAC,$03 Point #REGde at Boney's complex entity state (#R$8EE9).
  $AFAF,$01 Clear the success marker and test whether #REGa is zero.
  $AFB0,$02 Subtract #REGde from #REGhl with carry.
  $AFB2,$03 Store #REGhl in the entity-state copy length (#R$72A3).
  $AFB5,$01 Copy the high byte of the pointer into #REGb.
  $AFB6,$01 Copy the low byte of the pointer into #REGc.
  $AFB7,$03 Point #REGhl at Boney's complex entity state (#R$8EE9).
  $AFBA,$03 Point #REGde at the entity-state backup buffer (#R$FA0E).
  $AFBD,$02 Copy the block at #REGhl to #REGde.
  $AFBF,$01 Advance the pointer in #REGde by one.
  $AFC0,$04 Store #REGde in Pointer: Entity State Backup End (#R$72A7).
  $AFC4,$01 Stash #REGde on the stack.
N $AFC5 Measure and copy the task/game-status block that follows the entity
. backup.
  $AFC5,$03 Point #REGhl at saved room index (#R$72E8).
  $AFC8,$03 Point #REGde at the current task index (#R$72AE).
  $AFCB,$02 Subtract #REGde from #REGhl with carry.
  $AFCD,$03 Store #REGhl in the game-state copy length (#R$72A5).
  $AFD0,$01 Copy the high byte of the pointer into #REGb.
  $AFD1,$01 Copy the low byte of the pointer into #REGc.
  $AFD2,$03 Point #REGhl at the current task index (#R$72AE).
  $AFD5,$01 Restore #REGde from the stack.
  $AFD6,$02 Copy the block at #REGhl to #REGde.
  $AFD8,$01 Return.

g $AFD9 Temporary Entity Pointer
@ $AFD9 label=TemporaryEntityPointer_Drutt
D $AFD9 Pointer used by Drutt / trap door animation routines.
W $AFD9,$02

g $AFDB Drutt: Saved Entity Type
@ $AFDB label=Drutt_SavedEntityType
D $AFDB Entity type remembered while Drutt's trap door animation runs (#R$B034).
B $AFDB,$01

c $AFDC Script Routine: (#N$1B) Animate trap door / update Berk interaction
@ $AFDC label=ScriptRoutine_AnimateTrapDoorBerk
D $AFDC Animate the trap door for Drutt's current action and refresh Berk's
. interaction with it.
  $AFDC,$03 Load #REGa with Drutt's animation counter (#R$72BB).
  $AFDF,$04 Is Drutt's animation counter (#R$72BB) zero? If not, jump to #R$EC2E
. to run the next script instruction.
N $AFE3 #HTML(#AUDIO0(timed-event.wav)(#INCLUDE(TimedEvent)))
  $AFE3,$02 Load #REGa with sound index #N$0C.
  $AFE5,$03 Call #R$F8F9 to queue a sound effect.
  $AFE8,$04 Point #REGiy at complex entity state #R$908D.
  $AFEC,$06 Move the referenced entity one character up.
  $AFF2,$03 Load #REGa with the referenced entity's y-extent.
  $AFF5,$04 Is the y-extent still below the trap door open threshold #N$16? If
. not, jump to #R$B002.
  $AFF9,$03 Call #R$B01E to reset trap door animation state.
  $AFFC,$01 Clear the trap door flags.
  $AFFD,$03 Set the trap door flags (#R$72BA).
  $B000,$02 Jump to #R$B013 to handle the trap door.
N $B002 Toggle the lever animation phase and choose open facing left
. (#R$A818) or closed facing left (#R$A827).
@ $B002 label=AnimateTrapDoor_ToggleFrame
  $B002,$03 Load #REGa with the trap door flags (#R$72BA).
  $B005,$02,b$01 Toggle the trap door animation phase bit in #REGa.
  $B007,$03 Set the trap door flags (#R$72BA).
  $B00A,$02 Shift the trap door animation phase bit into the success marker.
  $B00C,$02 Jump to #R$B013 to handle the trap door if the result did not
. underflow.
  $B00E,$03 Point #REGbc at the lever open, facing left (#R$A818).
  $B011,$02 Jump to #R$B016 to handle the trap door.
N $B013 Use the lever closed, facing left at #R$A827.
@ $B013 label=AnimateTrapDoor_SetLayoutB
  $B013,$03 Point #REGbc at the lever closed, facing left (#R$A827).
N $B016 Install the chosen lever layout into #R$91AF and continue the
. script.
@ $B016 label=AnimateTrapDoor_WriteLayout
  $B016,$04 Store #REGbc in the animating scenery layout pointer (#R$91AF).
  $B01A,$03 Jump to #R$EC2E to run the next script instruction.
g $B01D Drutt: Saved Animation State
@ $B01D label=Drutt_SavedAnimationState
D $B01D Secondary state byte for Drutt's trap door animation (#R$B01E /
. #R$B034).
B $B01D,$01

c $B01E Reset Trap Door Animation State
@ $B01E label=Reset_Trap_Door_Animation_State
D $B01E Reset Trap Door Animation State used when opening or closing the trap
. door.
  $B01E,$03 Load #REGa with the current entity's y-extent.
  $B021,$03 Set Drutt's saved animation state (#R$B01D).
  $B024,$01 Clear the trap door flags.
  $B025,$03 Set the trap door flags (#R$72BA).
  $B028,$01 Advance the current entity's y-extent by one.
  $B029,$03 Set Drutt's animation counter (#R$72BB).
  $B02C,$03 Load #REGbc with the lever closed, facing left (#R$A827).
  $B02F,$04 Store #REGbc in the lever layout slot at #R$91AF.
  $B033,$01 Return.

c $B034 Update Drutt
@ $B034 label=Update_Drutt
D $B034 Advance Drutt's trap door animation and collection logic using the
. weight-chain slot at #R$908D and Drutt's state at #R$8EF7.
N $B034 Finish a pending weight-chain layout swap, then either tick the
. animation counter or watch for Berk near the trap.
  $B034,$04 Point #REGix at the weight-chain entity (#R$908D).
  $B038,$03 Point #REGhl at the trap door flags (#R$72BA).
  $B03B,$04 Is a weight-chain layout swap pending (bit #N$01)? If not,
. continue at #R$B049.
  $B03F,$02 Clear the layout-swap latch.
  $B041,$03 Load the resting weight-chain layout address (#R$9E61).
  $B044,$04 Write that layout into the creature's layout field
. (#R$8EF3(#N$9097)).
  $B048,$01 Return, then the swap is done for this frame.
N $B049 If Drutt's animation counter is idle, watch for Berk; otherwise tick it
. and animate.
@ $B049 label=Update_Drutt_CheckCounter
  $B049,$03 Fetch Drutt's animation counter (#R$72BB).
  $B04C,$04 Is the counter idle (zero)? If so, watch for Berk at #R$B14F.
  $B050,$01 Keep the remaining tick count in #REGb.
  $B051,$01 Advance the animation counter by one.
  $B052,$03 Store the updated counter at #R$72BB.
N $B055 Handle animation: move the creature down a row and finish or keep going.
@ $B055 label=Update_Drutt_AnimateFrame
  $B055,$03 Move the creature down one character (raise y).
  $B058,$03 Grow its y-extent to match.
  $B05B,$03 Load the new y-extent.
  $B05E,$04 Has it reached the open-trap row (y-extent #N$25)? If not, keep
. animating at #R$B0A3.
N $B062 #HTML(#AUDIO0(thump.wav)(#INCLUDE(Thump)))
  $B062,$02 Queue sound effect #N$8E (trap door thump).
  $B064,$03 Call #R$F8F9 to play that effect.
  $B067,$01 Clear #REGa so the animation counter can stop.
  $B068,$03 Clear Drutt's animation counter (#R$72BB).
  $B06B,$03 Load the closed-trap graphic layout (#R$A827).
  $B06E,$04 Write it into the lever layout slot (#R$91AF).
  $B072,$03 Is Drutt mid trap door animation (bit #N$02)? If not, nothing more
. to do.
  $B075,$02 Clear the mid-animation latch.
  $B077,$02 Request a weight-chain layout swap next frame (set bit #N$01).
  $B079,$03 Fetch the entity type Drutt saved at #R$AFDB.
  $B07C,$04 Was it type #N$20? If so, boil the cauldron at #R$B085.
  $B080,$03 Point #REGhl at #R$9E48.
  $B083,$02 Skip the pot update and install that layout at #R$B08B.
N $B085 Update the cauldron after a type-#N$20 catch and use the weight
. chain layout.
@ $B085 label=Update_Drutt_CaughtPot
  $B085,$03 Call #R$C60D to update the cauldron after Drutt's catch.
  $B088,$03 Point #REGhl at #R$9E40.
N $B08B Install the chosen post-catch layout into the weight-chain slot.
@ $B08B label=Update_Drutt_InstallLayout
  $B08B,$03 Write the chosen layout into the weight-chain layout field
. (#R$8EF3(#N$9097)).
N $B08E Step Drutt's chew animation; special type #N$1F gets #R$EA73, else clear
. the chewed slot.
@ $B08E label=Update_Drutt_EatLoop
  $B08E,$03 Call #R$B16E to step Drutt's eat / chew animation.
  $B091,$01 Return if that animation has finished.
  $B092,$03 Load the type of the entity Drutt is chewing.
  $B095,$04 Is it type #N$1F (inedible / special)? If not, clear the slot at
. #R$B09D.
  $B099,$03 Call #R$EA73 to handle the special chew.
  $B09C,$01 Return.
N $B09D Clear the chewed entity type and keep looping the eat animation.
@ $B09D label=Update_Drutt_ClearChewed
  $B09D,$04 Clear the chewed entity's type (deactivate the slot).
  $B0A1,$02 Keep chewing via #R$B08E.
N $B0A3 While mid trap door animation, wait until the mouth reaches the grabbed
. entity's centre, then swallow it.
@ $B0A3 label=Update_Drutt_MidAnimation
  $B0A3,$04 Still mid trap door animation (bit #N$02)? If not, look for a new
. catch at #R$B0C4.
  $B0A7,$04 Load the entity Drutt is currently grabbing (#R$AFD9).
  $B0AB,$03 Load that entity's y-extent.
  $B0AE,$03 Subtract its y-coordinate to get its height.
  $B0B1,$02 Halve the height.
  $B0B3,$03 Add the y-coordinate back to get the vertical centre.
  $B0B6,$01 Keep the grabbed entity's vertical centre in #REGc.
  $B0B7,$03 Load the creature's y-extent.
  $B0BA,$03 Has the creature's mouth reached that centre yet? If not, keep
. animating at #R$B0C1.
  $B0BD,$04 Clear the grabbed entity's type (Drutt swallowed it).
N $B0C1 Consume the remaining animation ticks by looping back to #R$B055.
@ $B0C1 label=Update_Drutt_NextAnimTick
  $B0C1,$02 Decrease the remaining tick count and loop to #R$B055 while ticks
. remain.
  $B0C3,$01 Return when the animation ticks are exhausted.
N $B0C4 Handle catch: find a candidate entity under the mouth and classify it.
@ $B0C4 label=Update_Drutt_SeekCatch
  $B0C4,$03 Call #R$B16E to see whether Drutt can start a catch this frame.
  $B0C7,$02 If not, just consume an animation tick at #R$B0C1.
  $B0C9,$03 Load the creature's y-extent.
  $B0CC,$01 Peek one row below the mouth.
  $B0CD,$05 Does that row meet the candidate entity's y? If not, keep waiting at
. #R$B0C1.
  $B0D2,$04 Remember this candidate at #R$AFD9.
  $B0D6,$03 Load the candidate's y-coordinate.
  $B0D9,$05 Is the candidate a flat / already-swallowed slot (y == y-extent)? If
. not, classify it at #R$B0E4.
  $B0DE,$04 Clear that empty slot's type.
  $B0E2,$02 Treat it as a failed catch at #R$B13A.
N $B0E4 Handle collectible types: worms, eyes and special catches.
@ $B0E4 label=Update_Drutt_ClassifyCatch
  $B0E4,$03 Load the candidate's entity type.
  $B0E7,$03 Save it at #R$AFDB for the layout chooser.
  $B0EA,$04 Type #N$16 (worm)?, then play the catch sound at #R$B130.
  $B0EE,$04 Type #N$18 (collectible eyeball variant)?, then same catch sound at
. #R$B130.
  $B0F2,$04 Type #N$17? If not, mark a failed catch at #R$B13A.
  $B0F6,$03 Fetch Drutt's saved animation state (#R$B01D).
  $B0F9,$04 Is that saved state #N$1C? If so, take the type-#N$1C collect path
. at #R$B11E.
  $B0FD,$02 If the saved state is above #N($1C), just play the catch sound at
. #R$B130.
  $B0FF,$02 Lift the catch three rows (loop counter #N$03).
N $B101 Lift the caught entity with the creature, retype it as a collected eye,
. and mark task progress.
@ $B101 label=Update_Drutt_LiftCatch
  $B101,$03 Raise the creature's y.
  $B104,$03 Grow its y-extent.
  $B107,$03 Raise the caught entity's y with it.
  $B10A,$02 Loop to #R$B101 for each remaining row.
  $B10C,$04 Retype the catch as #N$18 (collected eye).
  $B110,$03 Point #REGde at the collected-eye layout (#R$9F55).
  $B113,$04 Write that layout into entity state at #R$8EF3(#N$9089).
  $B117,$03 Point #REGhl at the task status flags (#R$72B4).
  $B11A,$02 Mark "Drutt collected a type-#N$18 object" (bit #N$04).
  $B11C,$02 Finish the collect at #R$B12A.
N $B11E Install the type-#N$1C collect layout and mark that collection on the
. task status flags.
@ $B11E label=Update_Drutt_CollectSafeLoot
  $B11E,$03 Point #REGde at the type-#N$1C collect layout (#R$9F06).
  $B121,$04 Write that layout into entity state at #R$8EF3(#N$9089).
  $B125,$03 Point #REGhl at the task status flags (#R$72B4).
  $B128,$02 Mark "Drutt collected a type-#N$1C object" (bit #N$05).
N $B12A Gate task progress and clear the current task index after a successful
. collect.
@ $B12A label=Update_Drutt_CollectDone
  $B12A,$02 Set the task-progress gate (bit #N$00 of #R$72B4).
  $B12C,$01 Clear #REGa so the current task index can reset.
  $B12D,$03 Clear the current task index (#R$72AE).
N $B130 #HTML(#AUDIO0(thump.wav)(#INCLUDE(Thump)))
@ $B130 label=Update_Drutt_CatchSound
  $B130,$02 Queue sound effect #N$8E (catch thump).
  $B132,$03 Call #R$F8F9 to play it.
  $B135,$01 Clear #REGa to stop further animation ticks.
  $B136,$03 Clear Drutt's animation counter (#R$72BB).
  $B139,$01 Return.
N $B13A Failed catch: special-case type #N($1F), clear the mid-animation latch,
. then consume a tick.
@ $B13A label=Update_Drutt_CatchFailed
  $B13A,$04 Was the saved type #N$1F? If not, stay mid-animation at #R$B14A.
  $B13E,$03 Call #R$EA73 for the special failure case.
  $B141,$01 Clear #REGa so the saved entity type can be wiped.
  $B142,$03 Clear Drutt's saved entity type (#R$AFDB).
  $B145,$02 Clear the mid-animation latch (bit #N$02 of #R$72BA).
  $B147,$03 Consume an animation tick at #R$B0C1.
N $B14A Keep the mid-animation latch set and consume an animation tick.
@ $B14A label=Update_Drutt_StayMidAnimation
  $B14A,$02 Keep the mid-animation latch set (bit #N$02 of #R$72BA).
  $B14C,$03 Consume an animation tick at #R$B0C1.
N $B14F Handle idle watch: start a trap door animation only when Berk is in the
. mouth band.
@ $B14F label=Update_Drutt_WatchBerk
  $B14F,$03 Load the creature's y-extent.
  $B152,$03 Is the mouth still above the trigger row (y-extent < #N$1E)? If not,
. return.
  $B155,$03 Fetch Berk's X-coordinate copy (#R$7303).
  $B158,$03 Is Berk left of the trap mouth (x < #N$A0)? If so, return.
  $B15B,$03 Is Berk right of the trap mouth (x >= #N$E0)? If so, return.
  $B15E,$03 Call #R$B16E to see whether a catchable entity is present.
  $B161,$01 Return if nothing is ready.
  $B162,$03 Load that entity's y-coordinate.
  $B165,$01 Step one row up from the candidate entity's y-coordinate.
  $B166,$01 Step a second row up.
  $B167,$04 Has the creature's mouth reached that row yet? If not, return.
  $B16B,$03 Jump to #R$B01E to reset the trap door animation state and begin.

c $B16E Update Drutt Animation
@ $B16E label=Update_Drutt_Animation
D $B16E Update Drutt Animation for Drutt using complex state at #R$8EF7.
  $B16E,$04 Point #REGiy at Boney's complex entity state (#R$8EE9).
  $B172,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
N $B175 Accept only a live room-#N$03 entity under Drutt's mouth band; otherwise
. scan on.
@ $B175 label=Update_Drutt_Animation_CheckType
  $B175,$03 Load #REGa with the referenced entity's entity type.
  $B178,$05 Is referenced entity's entity type equal to #N$32? If so, return? If
. not, jump to #R$B1A5.
  $B17D,$03 Is referenced entity's entity type zero? If so, jump to #R$B1A5.
  $B180,$04 Is bit #N$07 of referenced entity's entity type set? If so, jump to
. #R$B1A5.
  $B184,$03 Load #REGa with the referenced entity's room index.
  $B187,$04 Is referenced entity's room index equal to #N$03? If not, jump to
. #R$B1A5.
  $B18B,$03 Load #REGa with the referenced entity's x-coordinate.
  $B18E,$04 Is referenced entity's x-coordinate less than #N$AB? If so, jump to
. #R$B1A5.
  $B192,$02 Load #REGa with #N$B1.
  $B194,$05 Is #N$B1 less than the referenced entity's x-extent? If so, jump to
. #R$B1A5.
  $B199,$06 Is bit #N$05 of the referenced entity's flags byte 1 set? If so,
. jump to #R$B1A5.
  $B19F,$02 Compare #N$B1 with #N$AB.
  $B1A1,$03 Load #REGa with the referenced entity's entity type.
  $B1A4,$01 Return.
N $B1A5 Advance to the next entity and continue the Drutt catchability scan.
@ $B1A5 label=Update_Drutt_Animation_NextEntity
  $B1A5,$02 Advance #REGiy to the next entity record.
  $B1A7,$02 Jump to #R$B175 to continue the Drutt animation scan.

c $B1A9 Process Falling Entities
@ $B1A9 label=Process_Falling_Entities
D $B1A9 Walk entities marked as falling, apply gravity to their Y fields and
. clear the fall latch when they land.
  $B1A9,$03 Point #REGhl at the game event flags (#R$72B3).
  $B1AC,$03 Is the falling-entity latch (bit #N$02 of #R$72B3. set at #R$B203)
. set? If not, return.
  $B1AF,$02 Clear the falling-entity latch (bit #N$02 of #R$72B3).
  $B1B1,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $B1B4,$04 Point #REGix at the simple entity table (#R$8B69).
N $B1B8 Scan for falling entities and advance each marked one up to three steps
. before clearing the latch.
@ $B1B8 label=Process_Falling_Entities_Scan
  $B1B8,$03 Fetch the current entity's type for the type test.
  $B1BB,$03 Is the current entity's entity type equal to #N$FF? If so, return.
  $B1BE,$06 Is bit #N$00 of the current entity's flags byte 2 set? If not,
. jump to #R$B1D3.
  $B1C4,$05 Call #R$B1E3 to advance Falling Entity? If not, jump to #R$B1D7.
  $B1C9,$05 Call #R$B1E3 again to advance Falling Entity? If not, jump to
. #R$B1D7.
  $B1CE,$05 Call #R$B1E3 a third time to advance Falling Entity? If not, jump to
. #R$B1D7.
N $B1D3 Advance to the next entity in the falling-entity walk.
@ $B1D3 label=Process_Falling_Entities_NextEntity
  $B1D3,$02 Advance #REGix to the next entity record.
  $B1D5,$02 Jump to #R$B1B8 to advance to the next falling entity.
N $B1D7 Clear the falling flag, set the landed flag, raise a room/script event,
. and continue the scan.
@ $B1D7 label=Process_Falling_Entities_ClearFallBits
  $B1D7,$04 Reset bit #N$00 of the current entity's flags byte 2.
  $B1DB,$04 Set bit #N$07 of the current entity's flags byte 1.
  $B1DF,$02 Set "room / script event raised" (bit #N$00 of #R$72B3).
  $B1E1,$02 Jump to #R$B1D3 to skip this falling entity.

c $B1E3 Advance Falling Entity
@ $B1E3 label=Advance_Falling_Entity
D $B1E3 Advance Falling Entity walking the entity tables at #R$8B69 / #R$8EE9.
R $B1E3 IX Address of complex state data for an entity
  $B1E3,$05 Call #R$F2C2 to test Entity Overlap? If so, jump to #R$B1F6.
  $B1E8,$04 Is #REGa equal to #N$21? If not, jump to #R$B1F6.
  $B1EC,$03 Load #REGa with the task-two flags (#R$72B5).
  $B1EF,$02 Set "task-two script should advance" (bit #N$01 of #R$72B5).
  $B1F1,$03 Set the task-two flags (#R$72B5).
  $B1F4,$01 Clear #REGa as a false / no-match result.
  $B1F5,$01 Return.
N $B1F6 Lower the falling entity one character; keep falling, or relocate it
. when it reaches the floor band.
@ $B1F6 label=Advance_Falling_Entity_LowerY
  $B1F6,$06 Move this entity one character up.
  $B1FC,$03 Load #REGa with the current entity's y-extent.
  $B1FF,$04 Is the current entity's y-extent less than #N$0C? If so, jump to
. #R$B207.
  $B203,$02 Set the falling-entity latch (bit #N$02 of #R$72B3).
  $B205,$01 Signal success.
  $B206,$01 Return.
N $B207 Snap the fallen entity into room #N$03 at floor x #N$6D and finish the
. fall.
@ $B207 label=Advance_Falling_Entity_RelocateAtFloor
  $B207,$04 Write #N$03 to the current entity's room index.
  $B20B,$03 Load #REGa with the current entity's x-extent.
  $B20E,$03 Subtract the current entity's x-coordinate from #REGa.
  $B211,$01 Keep the current entity's x-extent in #REGc for later.
  $B212,$02 Load #REGa with floor x-coordinate #N$6D.
  $B214,$03 Set the current entity's x-coordinate.
  $B217,$01 Add the saved count in #REGc to #REGa.
  $B218,$03 Set the current entity's x-extent.
  $B21B,$01 Restore #REGbc from the stack.
  $B21C,$02 Jump to #R$B1D7 to finish the falling-entity pass.

c $B21E Process Rising Entities
@ $B21E label=Process_Rising_Entities
D $B21E Walk entities marked as rising (lifts / bubblers), nudge their Y fields
. up and clear the rise latch at the top.
  $B21E,$03 Point #REGhl at the game event flags (#R$72B3).
  $B221,$03 Is "special put-down / room-transition event" (bit #N$06 of #R$72B3)
. set? If not, return.
  $B224,$02 Clear "special put-down / room-transition event" (bit #N$06 of
. #R$72B3).
  $B226,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $B229,$04 Point #REGix at the simple entity table (#R$8B69).
N $B22D Scan for rising entities: nudge right while x < #N($6D), else clear the
. rise latch.
@ $B22D label=Process_Rising_Entities_Scan
  $B22D,$03 Fetch the current entity's type for the type test.
  $B230,$03 Is the current entity's entity type equal to #N$FF? If so, return.
  $B233,$06 Is bit #N$04 of the current entity's flags byte 2 set? If not,
. jump to #R$B249.
  $B239,$03 Load #REGa with the current entity's x-coordinate.
  $B23C,$04 Is the current entity's x-coordinate less than #N$6D? If not, jump
. to #R$B24D.
  $B240,$06 Move this entity one character right.
  $B246,$02 Set "special put-down / room-transition event" (bit #N$06 of
. #R$72B3).
  $B248,$01 Return.
N $B249 Advance to the next entity in the rising-entity walk.
@ $B249 label=Process_Rising_Entities_NextEntity
  $B249,$02 Advance #REGix to the next entity record.
  $B24B,$02 Jump to #R$B22D to advance to the next rising entity.
N $B24D Clear the rising flag, set the risen flag, and raise a room/script
. event.
@ $B24D label=Process_Rising_Entities_ClearRiseBits
  $B24D,$04 Reset bit #N$04 of the current entity's flags byte 2.
  $B251,$04 Set bit #N$05 of the current entity's flags byte 2.
  $B255,$02 Set "room / script event raised" (bit #N$00 of #R$72B3).
  $B257,$01 Return.

c $B258 Process Special Entity Flags
@ $B258 label=Process_Special_Entity_Flags
D $B258 Process Special Entity Flags walking the entity tables at #R$8B69 /
. #R$8EE9.
  $B258,$03 Point #REGhl at the game event flags (#R$72B3).
  $B25B,$03 Is "room / script event raised" (bit #N$00 of #R$72B3) set? If not,
. return.
  $B25E,$02 Clear "room / script event raised" (bit #N$00 of #R$72B3).
  $B260,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $B263,$04 Point #REGix at Boney's complex entity state (#R$8EE9).
N $B267 Scan special-flag entities: raise them while y < #N($28), else
. deactivate, or try an entity-slot update.
@ $B267 label=Process_Special_Entity_Flags_Scan
  $B267,$03 Fetch the current entity's type for the type test.
  $B26A,$03 Is the current entity's entity type equal to #N$32? If so, return.
  $B26D,$06 Is bit #N$05 of the current entity's flags byte 2 set? If not,
. jump to #R$B298.
  $B273,$03 Load #REGa with the current entity's y-coordinate.
  $B276,$04 Is the current entity's y-coordinate less than #N$28? If so, jump to
. #R$B288.
  $B27A,$04 Write #N$00 to the current entity's entity type.
  $B27E,$04 Reset bit #N$07 of the current entity's flags byte 1.
  $B282,$04 Reset bit #N$05 of the current entity's flags byte 2.
  $B286,$02 Jump to #R$B2A6 to finish this special-flag entity.
N $B288 Raise the special-flag entity two characters and keep the room/script
. event latched.
@ $B288 label=Process_Special_Entity_Flags_RaiseY
  $B288,$0C Move this entity two characters down.
  $B294,$02 Set "room / script event raised" (bit #N$00 of #R$72B3).
  $B296,$02 Jump to #R$B2A6 to finish this special-flag entity.
N $B298 When bit #N$07 is set, call #R$B2AA to update the entity slot (once or
. twice).
@ $B298 label=Process_Special_Entity_Flags_TryUpdateSlot
  $B298,$06 Is bit #N$07 of the current entity's flags byte 1 set? If not,
. jump to #R$B2A6.
  $B29E,$05 Call #R$B2AA to update Entity Slot? If so, jump to #R$B2A6.
  $B2A3,$03 Call #R$B2AA to update Entity Slot.
N $B2A6 Advance to the next entity and continue the special-flag scan.
@ $B2A6 label=Process_Special_Entity_Flags_Branch
  $B2A6,$02 Advance #REGix to the next entity record.
  $B2A8,$02 Jump to #R$B267 to advance to the next special-flag entity.

c $B2AA Update Entity Slot
@ $B2AA label=Update_Entity_Slot
D $B2AA Update Entity Slot walking the entity tables at #R$8B69 / #R$8EE9.
R $B2AA IX Address of complex state data for an entity
  $B2AA,$06 Call #R$F2BD to test Entity Overlap (Allow Special)? If so, jump to
. #R$B3BE.
  $B2B0,$04 Is #REGa equal to #N$41? If not, jump to #R$B2E4.
  $B2B4,$03 Load #REGa with the current entity's x-extent.
  $B2B7,$04 Is the current entity's x-extent less than #N$73? If so, jump to
. #R$B2BD.
  $B2BB,$02 Jump to #R$B2E4 to continue the entity-slot update.
N $B2BD At column #N($6B), nudge the entity up and right before latching the
. rise path.
@ $B2BD label=Update_Entity_Slot_AtColumn6B
  $B2BD,$03 Load #REGa with the current entity's x-coordinate.
  $B2C0,$04 Is the current entity's x-coordinate equal to #N$6B? If not, jump to
. #R$B2D0.
  $B2C4,$06 Move this entity one character up.
  $B2CA,$06 Move this entity one character right.
N $B2D0 Set the risen flag, raise a room/script event, and maybe poke Bad
. Tempered Thing state #N$06.
@ $B2D0 label=Update_Entity_Slot_SetRiseAndEvent
  $B2D0,$04 Set bit #N$05 of the current entity's flags byte 2.
  $B2D4,$02 Set "room / script event raised" (bit #N$00 of #R$72B3).
  $B2D6,$03 Fetch the current entity's type for the type test.
  $B2D9,$04 Is the current entity's entity type equal to #N$01? If not, jump to
. #R$B2E2.
  $B2DD,$02 Load #REGa with Bad Tempered Thing state #N$06 for #R$72C7.
  $B2DF,$03 Set the Bad Tempered Thing state (#R$72C7).
N $B2E2 Signal success and return from the entity-slot update.
@ $B2E2 label=Update_Entity_Slot_ReturnSuccess
  $B2E2,$01 Signal success.
  $B2E3,$01 Return.
N $B2E4 Test overlap with the last-collided entity; type #N$04/#N$06 spawns a
. task entity, else compare heights.
@ $B2E4 label=Update_Entity_Slot_Branch
  $B2E4,$04 Load #REGiy with the last-collided entity pointer (#R$72AA).
  $B2E8,$07 Is bit #N$01 of the referenced entity's flags byte 2 set? If not,
. jump to #R$B3BE.
  $B2EF,$03 Load #REGa with the current entity's x-coordinate.
  $B2F2,$06 Is this entity's x left of the referenced entity's x? If so, no
. horizontal overlap, so jump to #R$B3BE.
  $B2F8,$03 Load #REGa with the referenced entity's x-extent.
  $B2FB,$06 Is the referenced entity's x-extent left of this entity's x-extent?
. If so, no horizontal overlap, so jump to #R$B3BE.
  $B301,$03 Load #REGa with the referenced entity's entity type.
  $B304,$04 Is referenced entity's entity type equal to #N$04? If not, jump to
. #R$B31A.
  $B308,$03 Fetch the current entity's type for the type test.
  $B30B,$05 Is the current entity's entity type equal to #N$06? If not, jump to
. #R$B3BE.
  $B310,$03 Call #R$C06E to spawn Task Entity.
  $B313,$04 Write #N$00 to the current entity's entity type.
  $B317,$03 Jump to #R$B3B3 to finish the entity-slot update.
N $B31A Require vertical overlap with the collided entity before dispatching by
. type.
@ $B31A label=Update_Entity_Slot_CompareHeights
  $B31A,$03 Load #REGa with the current entity's y-extent.
  $B31D,$03 Subtract the current entity's y-coordinate from #REGa.
  $B320,$02 If the result was zero, jump to #R$B32D.
  $B322,$01 Keep the current entity's y-extent in #REGc for later.
  $B323,$03 Load #REGa with the referenced entity's y-extent.
  $B326,$03 Subtract the referenced entity's y-coordinate from #REGa.
  $B329,$04 Is the referenced entity's y-extent less than #REGc? If so, no
. vertical overlap, jump to #R$B3BE.
N $B32D Type-#N$0F path: clear a type-#N$0D offer, bump the plant state, and set
. interaction flags.
@ $B32D label=Update_Entity_Slot_PlantOfferPath
  $B32D,$03 Load #REGa with the referenced entity's entity type.
  $B330,$04 Is referenced entity's entity type equal to #N$0F? If not, jump to
. #R$B357.
  $B334,$03 Fetch the current entity's type for the type test.
  $B337,$05 Is the current entity's entity type equal to #N$0D? If not, jump to
. #R$B3BE.
  $B33C,$04 Write #N$00 to the current entity's entity type.
  $B340,$04 Reset bit #N$01 of the referenced entity's flags byte 2.
  $B344,$03 Increment the referenced entity's direction / state.
  $B347,$04 Write #N$32 to the referenced entity's extra state.
  $B34B,$03 Load #REGa with the entity interaction flag (#R$72B9).
  $B34E,$02 Set bit #N$01 of #R$72B9.
  $B350,$02 Set bit #N$03 of #R$72B9.
  $B352,$03 Set the entity interaction flag (#R$72B9).
  $B355,$02 Jump to #R$B3B3 to finish the entity-slot update.
N $B357 Stove path: when type #N$09 meets type #N($14), update the stove and
. mark the slot complete.
@ $B357 label=Update_Entity_Slot_StoveCollision
  $B357,$04 Is the referenced entity's entity type equal to #N$14? If not, jump
. to #R$B367.
  $B35B,$03 Fetch the current entity's type for the type test.
  $B35E,$04 Is the current entity's entity type equal to #N$09? If not, jump to
. #R$B367.
  $B362,$03 Call #R$C63B to update Stove.
  $B365,$02 Jump to #R$B3A2 to mark the entity slot complete.
N $B367 Gate past type #N$05 / reject type #N$09 before testing type-#N$08
. collisions.
@ $B367 label=Update_Entity_Slot_YellowCupCollision
  $B367,$04 Is the current entity's entity type equal to #N$05? If so, jump to
. #R$B375.
  $B36B,$03 Fetch the current entity's type for the type test.
  $B36E,$04 Is the current entity's entity type equal to #N$09? If so, jump to
. #R$B3BE.
  $B372,$03 Load #REGa with the referenced entity's entity type.
N $B375 Type-#N$08/#N$0B collision path: check entity collision then mark the
. slot complete.
@ $B375 label=Update_Entity_Slot_BasketCollision
  $B375,$04 Is referenced entity's entity type equal to #N$08? If not, jump to
. #R$B385.
  $B379,$03 Fetch the current entity's type for the type test.
  $B37C,$04 Is the current entity's entity type equal to #N$0B? If not, jump to
. #R$B385.
  $B380,$03 Call #R$D446 to check Entity Collision.
  $B383,$02 Jump to #R$B3A2 to mark the entity slot complete.
N $B385 Crusher path: type #N$16 meeting type #N$0E updates the crusher and
. completes the slot.
@ $B385 label=Update_Entity_Slot_CrusherCollision
  $B385,$04 Is the current entity's entity type equal to #N$16? If not, jump to
. #R$B396.
  $B389,$03 Fetch the current entity's type for the type test.
  $B38C,$05 Is the current entity's entity type equal to #N$0E? If not, jump to
. #R$B3BE.
  $B391,$03 Call #R$CF1E to update Crusher.
  $B394,$02 Jump to #R$B3A2 to mark the entity slot complete.
N $B396 If this slot is type #N($01), set Bad Tempered Thing state #N$03 before
. completing.
@ $B396 label=Update_Entity_Slot_BadTemperedThing
  $B396,$03 Fetch the current entity's type for the type test.
  $B399,$04 Is the current entity's entity type equal to #N$01? If not, jump to
. #R$B3A2.
  $B39D,$02 Load #REGa with Bad Tempered Thing state #N$03 for #R$72C7.
  $B39F,$03 Set the Bad Tempered Thing state (#R$72C7).
N $B3A2 Mark the entity slot complete: set risen/extra-state bits and type bit
. #N$07.
@ $B3A2 label=Update_Entity_Slot_MarkComplete
  $B3A2,$04 Set bit #N$05 of the current entity's flags byte 1.
  $B3A6,$02 Stash #REGiy on the stack.
  $B3A8,$01 Restore #REGbc from the stack.
  $B3A9,$03 Store #REGc in the current entity's extra state.
  $B3AC,$03 Store #REGb in the current entity's extra state.
  $B3AF,$04 Set bit #N$07 of the current entity's entity type.
N $B3B3 Clear entity-flags bit #N($07), queue the entity-slot sound, and return
. success.
@ $B3B3 label=Update_Entity_Slot_ClearBit7AndSound
  $B3B3,$04 Reset bit #N$07 of the current entity's flags byte 1.
N $B3B7 #HTML(#AUDIO0(entity-slot.wav)(#INCLUDE(EntitySlot)))
  $B3B7,$02 Load #REGa with sound index #N$84.
  $B3B9,$03 Call #R$F8F9 to queue a sound effect.
  $B3BC,$01 Signal success.
  $B3BD,$01 Return.
N $B3BE Snap the entity to the room-floor y band, restore helper layout when
. type #N($06), else fall through.
@ $B3BE label=Update_Entity_Slot_SnapToRoomFloor
  $B3BE,$03 Load #REGa with the current entity's room index.
  $B3C1,$02 Add #N$22 to #REGa (adjust an entity coordinate).
  $B3C3,$01 Keep the current entity's room index in #REGb for later.
  $B3C4,$05 Does room+#N$22 match this entity's y-extent? If not, jump to
. #R$B410.
  $B3C9,$03 Load #REGa with the current entity's y-extent.
  $B3CC,$03 Subtract the current entity's y-coordinate from #REGa.
  $B3CF,$01 Keep the current entity's y-extent in #REGc for later.
  $B3D0,$03 Store #REGb in the current entity's y-extent.
  $B3D3,$01 Copy the loop counter from #REGb into #REGa.
  $B3D4,$01 Subtract #REGc from the current entity's y-extent.
  $B3D5,$03 Set the current entity's y-coordinate.
  $B3D8,$04 Reset bit #N$07 of the current entity's flags byte 1.
  $B3DC,$03 Fetch the current entity's type for the type test.
  $B3DF,$04 Is the current entity's entity type equal to #N$06? If not, jump to
. #R$B3F4.
  $B3E3,$03 Load #REGa with the task-two flags (#R$72B5).
  $B3E6,$02 Set "helper entity needs its layout restoring" (bit #N$03 of
. #R$72B5).
  $B3E8,$03 Set the task-two flags (#R$72B5).
  $B3EB,$03 Load #REGbc with helper graphic layout address #R$9DC0.
  $B3EE,$04 Write the layout address into the spawned helper's layout field
. (#R$8EF3(#N$8FE1)).
  $B3F2,$02 Jump to #R$B409 to queue the entity-slot wait sound.
N $B3F4 When task-two flags are #N($01), set Bad Tempered Thing state #N$02.
@ $B3F4 label=Update_Entity_Slot_MaybeSetBTT
  $B3F4,$04 Is task-two flags equal to #N$01? If not, jump to #R$B3FD.
  $B3F8,$02 Load #REGa with Bad Tempered Thing state #N$02 for #R$72C7.
  $B3FA,$03 Set the Bad Tempered Thing state (#R$72C7).
N $B3FD Maybe set SlimyLoose on the task-three flags before queuing the land
. sound.
@ $B3FD label=Update_Entity_Slot_MaybeTaskThreeBit
  $B3FD,$04 Is #N$02 equal to #N$09? If not, jump to #R$B409.
  $B401,$03 Load #REGa with the task-three flags (#R$72B6).
  $B404,$02 Set SlimyLoose (bit #N$02 of #R$72B6. #R$D907 skips that line while
. set).
  $B406,$03 Set the task-three flags (#R$72B6).
N $B409 #HTML(#AUDIO0(entity-slot-wait.wav)(#INCLUDE(EntitySlotWait)))
@ $B409 label=Update_Entity_Slot_QueueLandSound
  $B409,$02 Load #REGa with sound index #N$87.
  $B40B,$03 Call #R$F8F9 to queue a sound effect.
  $B40E,$01 Signal success.
  $B40F,$01 Return.
N $B410 Land-step: drop the entity one row and raise a room/script event on
. #R$72B3.
@ $B410 label=Update_Entity_Slot_RaiseYAndEvent
  $B410,$06 Move this entity one character down.
  $B416,$02 Set "room / script event raised" (bit #N$00 of #R$72B3).
  $B418,$01 Clear #REGa as a false / no-match result.
  $B419,$01 Return.

c $B41A Update Berk Controller
@ $B41A label=Update_Berk_Controller
D $B41A Copy room/x/x-extent from the camera-follow entity (#R$909B) into
. #R$7305/#R$7303/#R$7304, then call #R$B440 with that IX.
  $B41A,$04 Point #REGix at the camera-follow entity (#R$909B).
  $B41E,$03 Load #REGa with the current entity's room index.
  $B421,$03 Set Berk's room-index copy (#R$7305).
  $B424,$03 Load #REGa with the current entity's x-coordinate.
  $B427,$03 Set Berk's X-coordinate copy (#R$7303).
  $B42A,$03 Load #REGa with the current entity's x-extent.
  $B42D,$03 Set Berk's X-extent copy (#R$7304).
  $B430,$03 Load #REGhl with Berk's script position pointer (#R$72B1).
  $B433,$03 Store #REGhl in the active script cursor (#R$72CF).
  $B436,$03 Call #R$B440 to read Berk's controls and choose a script.
  $B439,$03 Load #REGhl with the active script cursor (#R$72CF).
  $B43C,$03 Store #REGhl in Berk's script position pointer (#R$72B1).
  $B43F,$01 Return.

c $B440 Update Berk: Read Controls
@ $B440 label=Update_Berk_ReadControls
D $B440 Drive Berk from the control input bitmap at #R$F5F8: walk, turn,
. fire (pick up / put down / trap door offer) or idle scripts.
R $B440 IX Address of the camera-follow entity (#R$909B) (loaded by #R$B41A)
N $B440 Script lock and held-entity gate: ignore controls while a script is
. already running.
  $B440,$07 Is Berk script-locked (bit #N$00 of #REGix+#N$03)? If so,
. advance the current script at #R$EC2E.
  $B447,$06 Is Berk carrying / mid put-down (bit #N$04)? If not, read the
. controls at #R$B45D.
  $B44D,$04 Point #REGiy at the held entity (#R$72AC).
  $B451,$06 Is that held entity still marked "held" (bit #N$03)? If not, read
. the controls at #R$B45D.
  $B457,$03 Point #REGhl at Berk's "still holding" interaction script
. (#R$B9A5(#N$BA31)).
  $B45A,$03 Run that script via #R$EC30.
N $B45D Read the control input bitmap (#R$F5F8) and branch on direction / fire.
@ $B45D label=Berk_ReadControls_Dispatch
  $B45D,$03 Fetch the control input bitmap from #R$F5F8.
  $B460,$05 Has right been pressed? If so, jump to #R$B8C6 to walk Berk right.
  $B465,$05 Has left been pressed? If so, jump to #R$B810 to walk Berk left.
  $B46A,$05 Has down (forward) been pressed? If so, jump to #R$B6F9 to move Berk
. forward.
  $B46F,$05 Has up (back) been pressed? If so, jump to #R$B560 to move Berk back
. / up.
  $B474,$05 Has fire been pressed? If so, jump to #R$B4A5 to pick up, put down
. or offer to the trap.
  $B479,$05 Has the secondary action key been pressed? If so, jump to #R$B52E
. for the alternate fire path.
N $B47E Handle idle: clear the holding lock and pick a facing script.
@ $B47E label=Berk_ReadControls_Idle
  $B47E,$04 Reset bit #N$03 of flags byte 3 (#REGix+#N$03).
  $B482,$06 Is Berk facing left (bit #N$01)? If not, use the right-facing idle
. script at #R$B49F.
  $B488,$0A Test the mid-interaction latch (bit #N$02). Clear that latch. If
. it was set, still use the right-facing idle script at #R$B49F.
  $B492,$07 Is Berk's direction byte already "face left" bit #N$03? If not,
. continue the current script at #R$EC2E.
  $B499,$03 Point #REGhl at Berk's left-facing idle script (#R$B9A5(#N$B9CD)).
  $B49C,$03 Run that script via #R$EC30.
N $B49F Idle facing right: run Berk's right-facing idle script at
. #R$B9AD via #R$EC30.
@ $B49F label=Berk_ReadControls_IdleFaceRight
  $B49F,$03 Point #REGhl at Berk's right-facing idle script (#R$B9AD).
  $B4A2,$03 Run that script via #R$EC30.
N $B4A5 Handle fire: pick up, put down or offer an item to the trap door.
@ $B4A5 label=Berk_ReadControls_OfferOrPutDown
  $B4A5,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, fall
. back to idle at #R$B47E.
  $B4AC,$03 Load Berk's y-extent.
  $B4AF,$04 Is Berk standing on the trap door row (y-extent #N$1B)? If so,
. handle the offer at #R$B4B8.
  $B4B3,$05 Is he still below the offer band (y-extent < #N$23)? If so, idle at
. #R$B47E.
N $B4B8 Facing-left trap offer: test the held entity with #R$F25F, then offer or
. put down.
@ $B4B8 label=Berk_ReadControls_OfferOrPutDownOfferTrap
  $B4B8,$06 Is Berk facing left? If not, try the right-facing offer path at
. #R$B4FF.
  $B4BE,$02 Stash #REGix on the stack.
  $B4C0,$04 Switch #REGix to the held entity (#R$72AC).
  $B4C4,$03 Call #R$F25F to test whether that entity can be offered to the trap.
  $B4C7,$02 Restore #REGix from the stack.
  $B4C9,$02 If the offer was rejected, skip ahead to the reject script at
. #R$B4F3.
  $B4CB,$04 Is Berk's y-extent exactly the trap mouth (#N$3D)? If not, use the
. put-down script at #R$B4F9.
  $B4CF,$03 Fetch the game event flags (#R$72B3).
  $B4D2,$04 Has an object already been offered to the trap (bit #N$03)? If so,
. just put down at #R$B4F9.
  $B4D6,$02 Mark "object offered to the trap" (set bit #N$03).
  $B4D8,$03 Write the updated game event flags back to #R$72B3.
  $B4DB,$04 Point #REGiy at the held entity (#R$72AC).
  $B4DF,$04 Set that entity's can-fall latch (bit #N$06).
  $B4E3,$04 Remember it as the trap door entity pointer slot (#R$8D89).
  $B4E7,$03 Load the held entity's type.
  $B4EA,$04 Is it type #N$01 (Berk's own slot)? If not, run the offer script at
. #R$B4F3.
  $B4EE,$02 Load the Bad Tempered Thing "object offered" state (#N$08).
  $B4F0,$03 Store it at #R$72C7.
N $B4F3 Run Berk's trap-offer script (#R$B9A5(#N$BA3F)) after accepting or
. rejecting the offer.
@ $B4F3 label=Berk_ReadControls_OfferOrPutDownOfferScript
  $B4F3,$03 Point #REGhl at Berk's trap-offer script (#R$B9A5(#N$BA3F)).
  $B4F6,$03 Run that script via #R$EC30.
N $B4F9 Put the held item down with Berk's standard put-down script (#R$B9A5).
@ $B4F9 label=Berk_ReadControls_OfferOrPutDownPutDown
  $B4F9,$03 Point #REGhl at Berk's standard put-down script (#R$B9A5).
  $B4FC,$03 Run that script via #R$EC30.
N $B4FF Right-facing fire path: test a trap offer or fall back to idle / hold.
@ $B4FF label=Berk_ReadControls_OfferOrPutDownFaceRight
  $B4FF,$03 Load Berk's y-extent.
  $B502,$02 Stash #REGix on the stack.
  $B504,$04 Switch #REGix to the held entity (#R$72AC).
  $B508,$04 Is Berk on the trap door row (y-extent #N$1B)? If so, handle that
. offer at #R$B51E.
  $B50C,$03 Call #R$F2C2 to test a right-facing trap offer.
  $B50F,$02 Restore #REGix from the stack.
  $B511,$02 If the offer was accepted, run the holding script at #R$B518.
  $B513,$05 Is Berk still below the mid-room band (y-extent < #N$32)? If so,
. idle at #R$B47E.
N $B518 Keep holding: run Berk's "still holding" script (#R$B9A5(#N$BA31)).
@ $B518 label=Berk_ReadControls_OfferOrPutDownHoldScript
  $B518,$03 Point #REGhl at Berk's "still holding" script (#R$B9A5(#N$BA31)).
  $B51B,$03 Run that script via #R$EC30.
N $B51E On the trap door row facing right: validate the offer, then run the
. trap-row script.
@ $B51E label=Berk_ReadControls_OfferOrPutDownTrapRow
  $B51E,$03 Call #R$F2C2 to test the trap-row offer.
  $B521,$02 Restore #REGix from the stack.
  $B523,$05 Is Berk's y-extent exactly #N$35? If so, idle at #R$B47E.
  $B528,$03 Point #REGhl at Berk's trap-row interaction script
. (#R$B9A5(#N$BA67)).
  $B52B,$03 Run that script via #R$EC30.
N $B52E Handle secondary fire: put down when carrying, otherwise idle.
@ $B52E label=Berk_ReadControls_SecondaryFire
  $B52E,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, idle at
. #R$B47E.
  $B535,$06 Is Berk facing left? If not, try the right-facing secondary path at
. #R$B541.
  $B53B,$03 Point #REGhl at Berk's standard put-down script (#R$B9A5).
  $B53E,$03 Run that script via #R$EC30.
N $B541 Right-facing secondary fire: validate the held entity with #R$F2C2, then
. put it down.
@ $B541 label=Berk_ReadControls_SecondaryFireRight
  $B541,$02 Stash #REGix on the stack.
  $B543,$04 Switch #REGix to the held entity (#R$72AC).
  $B547,$03 Load the held entity's flags byte 2.
  $B54A,$02,b$01 Keep only bits #N$06 and #N$01 (can-fall / facing-left).
  $B54C,$02 If neither bit is set, abandon the secondary action at #R$B55B.
  $B54E,$03 Call #R$F2C2 to validate the put-down.
  $B551,$02 If validation failed, abandon at #R$B55B.
  $B553,$02 Restore #REGix from the stack.
  $B555,$03 Point #REGhl at Berk's alternate put-down script (#R$B9A5(#N$BBA1)).
  $B558,$03 Run that script via #R$EC30.
N $B55B Abort secondary fire and return Berk to idle at #R$B47E.
@ $B55B label=Berk_ReadControls_SecondaryFireAbort
  $B55B,$02 Restore #REGix from the stack.
  $B55D,$03 Idle at #R$B47E.
N $B560 Handle up / back: turn or walk Berk toward the back of the room.
@ $B560 label=Berk_ReadControls_Up
  $B560,$07 Is Berk already facing left? If so, continue the up-walk at #R$B56D.
  $B567,$03 Point #REGhl at Berk's turn-to-face-back script (#R$B9A5(#N$B9C5)).
  $B56A,$03 Run that script via #R$EC30.
N $B56D Walk Berk back/up: probe the row above, clamp the camera, then branch on
. collision height.
@ $B56D label=Berk_ReadControls_UpWalk
  $B56D,$03 Probe one character above Berk's current y.
  $B570,$03 Call #R$F252 to clamp Camera Position.
  $B573,$03 Restore Berk's y after the camera clamp probe.
  $B576,$03 If a hit/borrow was signaled, jump to #R$B617.
  $B579,$05 Is #REGa less than #N$64? If not, jump to #R$B624.
  $B57E,$05 Is #REGa equal to #N$41? If so, jump to #R$B6EA.
  $B583,$04 Is #REGa less than #N$32? If not, jump to #R$B58C.
  $B587,$05 Is #REGa less than #N$1E? If not, jump to #R$B986.
N $B58C Up-path interact: offer to the trap, grab scenery, or hand off to
. #R$B7F3.
@ $B58C label=Berk_ReadControls_UpInteract
  $B58C,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B6AC.
  $B593,$04 Load #REGiy with the last-collided entity pointer (#R$72AA).
  $B597,$03 Load #REGa with the referenced entity's entity type.
  $B59A,$05 Is referenced entity's entity type equal to #N$0F? If so, jump to
. #R$B642.
  $B59F,$07 Is bit #N$04 of the referenced entity's flags byte 1 set? If so,
. jump to #R$B642.
  $B5A6,$06 Is bit #N$03 of the referenced entity's flags byte 1 set? If not,
. jump to #R$B5F8.
  $B5AC,$09 Call #R$B7F3 to let Berk interact with an entity? If so, jump to
. #R$B7A3? If not, jump to #R$B7B4.
  $B5B5,$02 Stash #REGix on the stack.
  $B5B7,$04 Load #REGix with the last-collided entity pointer (#R$72AA).
  $B5BB,$03 Load #REGa with the current entity's room index.
  $B5BE,$03 Is the current entity's room index zero? If so, jump to #R$B5F6.
  $B5C1,$04 Is the current entity's room index equal to #N$01? If not, jump to
. #R$B5D4.
  $B5C5,$04 Store #REGix in the trap door entity pointer (#R$8D89).
  $B5C9,$04 Set bit #N$06 of the current entity's flags byte 1.
  $B5CD,$03 Point #REGhl at the game event flags (#R$72B3).
  $B5D0,$02 Set "object has been offered to the trap" (bit #N$03 of #R$72B3).
  $B5D2,$02 Jump to #R$B5FE to store Berk's extra state.
N $B5D4 Room-specific up checks: camera tweak, trap mouth (#N$3D), or special X
. band (#N$68).
@ $B5D4 label=Berk_ReadControls_UpRoomCheck
  $B5D4,$05 Call #R$F25B to adjust Camera X? If so, jump to #R$B5FE.
  $B5D9,$04 Is the current entity's room index equal to #N$3D? If so, jump to
. #R$B5FE.
  $B5DD,$04 Is the current entity's room index equal to #N$68? If not, jump to
. #R$B5F6.
  $B5E1,$03 Load #REGa with the game event flags (#R$72B3).
  $B5E4,$04 Is bit #N$03 of game event flags set? If so, jump to #R$B5F6.
  $B5E8,$03 Load #REGa with the current entity's x-coordinate.
  $B5EB,$04 Is the current entity's x-coordinate less than #N$98? If so, jump to
. #R$B5F6.
  $B5EF,$02 Load #REGa with #N$9D.
  $B5F1,$05 Does #REGa match this entity's x-extent? If not, jump to #R$B5FE.
N $B5F6 Failed up-path grab: restore Berk's entity pointer and fall into the
. put-down script.
@ $B5F6 label=Berk_ReadControls_UpRestore
  $B5F6,$02 Restore #REGix from the stack.
N $B5F8 Run a left-facing idle/put-down fragment (#R$B9A5(#N$B9CD)) when the up
. grab is rejected.
@ $B5F8 label=Berk_ReadControls_UpPutDownScript
  $B5F8,$03 Point #REGhl at a Berk put-down script fragment (#R$B9A5(#N$B9CD)).
  $B5FB,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B5FE Commit the grabbed entity into Berk's held state and launch script
. #R$BABB.
@ $B5FE label=Berk_ReadControls_UpGrabEntity
  $B5FE,$02 Stash #REGix on the stack.
  $B600,$03 Restore #REGbc and #REGix from the stack.
  $B603,$03 Store #REGc in the current entity's extra state.
  $B606,$03 Store #REGb in the current entity's extra state.
  $B609,$04 Set bit #N$03 of the current entity's flags byte 3.
  $B60D,$04 Reset bit #N$02 of the current entity's flags byte 3.
  $B611,$03 Point #REGhl at Berk control/put-down script data (#R$BABB).
  $B614,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B617 Camera-clamp hit on up: drop/control put-down via #R$BA8F, or keep the
. current script.
@ $B617 label=Update_Berk_Movement_And_Script_PartA
  $B617,$07 Is bit #N$03 of the current entity's direction / state set? If so,
. jump to #R$EC2E.
  $B61E,$03 Point #REGhl at Berk control/put-down script data (#R$BA8F).
  $B621,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B624 Up-path collision: let #R$B7F3 decide interact vs the shared down-branch
. at #R$B7B4.
@ $B624 label=Update_Berk_Movement_And_Script_PartB
  $B624,$08 Call #R$B7F3 to let Berk interact with an entity? If so, jump to
. #R$B62F? If not, jump to #R$B7B4.
  $B62C,$03 Jump to #R$B7A3.
N $B62F Special room interact: refresh the camera origin from Berk movement data
. and resume.
@ $B62F label=Update_Berk_Movement_And_Script_PartC
  $B62F,$01 Copy the saved count/flag from #REGc into #REGa.
  $B630,$04 Is #N$9D equal to #N$66? If not, jump to #R$B617.
  $B634,$01 Stash #REGhl on the stack.
  $B635,$03 Point #REGhl at Berk movement script data (#R$B63D).
  $B638,$02 Load #REGa with #N$A0.
  $B63A,$03 Jump to #R$B781 to refresh the camera room origin.
  $B63D,$01 Advance the layout-table index in #REGb.
  $B63E,$03 Point #REGhl at graphic layout/table #R$A1F8(#N$A227).
  $B641,$01 Test whether #N$A0 is zero (clear carry).
N $B642 Plant-pot / type-#N$0F up interact: retarget layout #R$A0B5 and
. update plant pots.
@ $B642 label=Update_Berk_Movement_And_Script_PartD
  $B642,$09 Call #R$B7F3 to let Berk interact with an entity? If so, jump to
. #R$B7A3? If not, jump to #R$B7B4.
  $B64B,$03 Load #REGb with the current entity's y-extent.
  $B64E,$01 Step the loop counter in #REGb back by one.
  $B64F,$04 Load #REGiy with the last-collided entity pointer (#R$72AA).
  $B653,$03 Load #REGa with the referenced entity's entity type.
  $B656,$04 Is referenced entity's entity type equal to #N$0F? If not, jump to
. #R$B67C.
  $B65A,$03 Load #REGa with the referenced entity's direction / state.
  $B65D,$05 Is referenced entity's direction / state equal to #N$07? If not,
. jump to #R$B5F8.
  $B662,$04 Write #N$0B to the referenced entity's direction / state.
  $B666,$03 Load #REGbc with graphic layout address #R$A0B5.
  $B669,$03 Set the low byte of the referenced entity's graphic layout address
. from #REGc.
  $B66C,$03 Set the high byte of the referenced entity's graphic layout address
. from #REGb.
  $B66F,$02 Stash #REGix on the stack.
  $B671,$04 Load #REGix with the last-collided entity pointer (#R$72AA).
  $B675,$02 Load #REGc with #N$06 as an entity/loop count.
  $B677,$03 Call #R$CEE1 to update Plant Pots.
  $B67A,$02 Restore #REGix from the stack.
N $B67C Adopt the collided entity as held and clear any pending trap-offer flag.
@ $B67C label=Update_Berk_Movement_And_Script_PartE
  $B67C,$04 Store #REGiy in the current-entity pointer (#R$72AC).
  $B680,$06 Is bit #N$06 of the referenced entity's flags byte 1 set? If not,
. jump to #R$B68F.
  $B686,$04 Reset bit #N$06 of the referenced entity's flags byte 1.
  $B68A,$03 Point #REGhl at the game event flags (#R$72B3).
  $B68D,$02 Clear "object has been offered to the trap" (bit #N$03 of #R$72B3).
N $B68F Choose a pick-up/put-down script from the collided entity's y-extent vs
. Berk.
@ $B68F label=Update_Berk_Movement_And_Script_PartF
  $B68F,$03 Load #REGa with the referenced entity's y-extent.
  $B692,$05 Does #REGa match this entity's y-coordinate? If so, jump to #R$B6A6.
  $B697,$03 Does the referenced entity's y-extent equal #REGb? If so, jump to
. #R$B6A0.
  $B69A,$03 Point #REGhl at Berk control/put-down script data
. (#R$BA07).
  $B69D,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B6A0 Run put-down script #R$B9A5(#N$B9EB) when y-extents match the stepped
. collision band.
@ $B6A0 label=Update_Berk_Movement_And_Script_PartG
  $B6A0,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$B9EB)).
  $B6A3,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B6A6 Run put-down script #R$B9A5(#N$B9F9) when the collided entity sits on
. Berk's own y.
@ $B6A6 label=Update_Berk_Movement_And_Script_PartH
  $B6A6,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$B9F9)).
  $B6A9,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B6AC Carrying-flag up path: require a latch-set collidee, with a type-#N$15
. special case.
@ $B6AC label=Update_Berk_Movement_And_Script_PartI
  $B6AC,$04 Load #REGiy with the last-collided entity pointer (#R$72AA).
  $B6B0,$03 Load #REGa with the referenced entity's entity type.
  $B6B3,$07 Is bit #N$02 of the referenced entity's flags byte 2 set? If not,
. jump to #R$B5F8.
  $B6BA,$04 Is referenced entity's entity type equal to #N$15? If not, jump to
. #R$B6C8.
  $B6BE,$04 Load #REGbc with the current-entity pointer (#R$72AC).
  $B6C2,$01 Fetch a byte through the pointer in #REGbc.
  $B6C3,$05 Is referenced entity's entity type equal to #N$04? If not, jump to
. #R$B5F8.
N $B6C8 Align held-entity y-extent (#R$72E9) and pick script #R$B9A5(#N$BA5B) or
. #R$B9A5(#N$BA4D).
@ $B6C8 label=Update_Berk_Movement_And_Script_PartJ
  $B6C8,$09 Call #R$B7F3 to let Berk interact with an entity? If so, jump to
. #R$B7A3? If not, jump to #R$B7B4.
  $B6D1,$03 Load #REGc with the current entity's y-coordinate.
  $B6D4,$03 Load #REGa with the referenced entity's y-coordinate.
  $B6D7,$01 Step referenced entity's y-coordinate back by one.
  $B6D8,$03 Set held-entity y-extent (#R$72E9).
  $B6DB,$03 Does the referenced entity's y equal #REGc? If so, jump to #R$B6E4.
  $B6DE,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$BA5B)).
  $B6E1,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B6E4 Run put-down script #R$B9A5(#N$BA4D) once the held entity's y matches
. Berk.
@ $B6E4 label=Update_Berk_Movement_And_Script_PartK
  $B6E4,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$BA4D)).
  $B6E7,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B6EA Flags-#N$41 up interact: hand off to #R$B7F3, then run script
. #R$B9A5(#N$BB4F).
@ $B6EA label=Update_Berk_Movement_And_Script_PartL
  $B6EA,$09 Call #R$B7F3 to let Berk interact with an entity? If so, jump to
. #R$B7A3? If not, jump to #R$B7B4.
  $B6F3,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$BB4F)).
  $B6F6,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B6F9 Handle down / forward: turn or walk Berk toward the front of the room.
@ $B6F9 label=Berk_ReadControls_Down
  $B6F9,$07 Is the current entity facing left (bit #N$01 of #REGix+#N$03)?
. If not, jump to #R$B706.
  $B700,$03 Point #REGhl at Berk put-down script data (#R$B9A5).
  $B703,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B706 Walk Berk forward/down: depth-overlap test, then branch on collidee
. height and flags.
@ $B706 label=Berk_ReadControls_DownWalk
  $B706,$05 Call #R$F2C7 to test Entity Overlap At Depth? If so, jump to
. #R$B764.
  $B70B,$05 Is referenced entity's y-coordinate less than #N$64? If not, jump to
. #R$B771.
  $B710,$05 Is referenced entity's y-coordinate equal to #N$41? If so, jump to
. #R$B7E6.
  $B715,$05 Is referenced entity's y-coordinate less than #N$32? If not, jump to
. #R$B47E.
  $B71A,$05 Is referenced entity's y-coordinate less than #N$1E? If not, jump to
. #R$B986.
  $B71F,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B47E.
  $B726,$04 Load #REGbc with the last-collided entity pointer (#R$72AA).
  $B72A,$01 Advance the counter/pointer in #REGbc by one.
  $B72B,$01 Fetch a byte through the pointer in #REGbc.
  $B72C,$05 Is bit #N$04 of referenced entity's y-coordinate set? If so, jump to
. #R$B7C5.
  $B731,$05 Is bit #N$03 of referenced entity's y-coordinate set? If not, jump
. to #R$B47E.
  $B736,$08 Call #R$B7F3 to let Berk interact with an entity? If so, jump to
. #R$B7A3? If not, jump to #R$B7B4.
  $B73E,$02 Stash #REGix on the stack.
  $B740,$04 Load #REGix with the last-collided entity pointer (#R$72AA).
  $B744,$03 Load #REGa with the current entity's room index.
  $B747,$04 Is the current entity's room index less than #N$04? If not, jump to
. #R$B750.
  $B74B,$05 Call #R$F2C7 to test Entity Overlap At Depth? If so, jump to
. #R$B755.
N $B750 Abort the down-path grab and return Berk to idle at #R$B47E.
@ $B750 label=Berk_ReadControls_DownAbort
  $B750,$02 Restore #REGix from the stack.
  $B752,$03 Jump to #R$B47E to resume Berk's controller.
N $B755 Mark the collided entity held and fall into the down put-down script.
@ $B755 label=Berk_ReadControls_DownGrab
  $B755,$02 Stash #REGix on the stack.
  $B757,$03 Restore #REGbc and #REGix from the stack.
  $B75A,$03 Store #REGc in the current entity's extra state.
  $B75D,$03 Store #REGb in the current entity's extra state.
  $B760,$04 Set bit #N$03 of the current entity's flags byte 3.
N $B764 Down put-down: continue the active script, or launch #R$BAA5.
@ $B764 label=Berk_ReadControls_DownScript
  $B764,$07 Is bit #N$02 of the current entity's direction / state set? If so,
. jump to #R$EC2E.
  $B76B,$03 Point #REGhl at Berk control/put-down script data (#R$BAA5).
  $B76E,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B771 Deep down-interact: call #R$B7F3, then maybe retarget the camera room
. origin.
@ $B771 label=Berk_ReadControls_DownInteract
  $B771,$05 Call #R$B7F3 to let Berk interact with an entity? If not, jump to
. #R$B7A1.
  $B776,$01 Copy the saved count/flag from #REGc into #REGa.
  $B777,$04 Is the current entity's room index equal to #N$65? If not, jump to
. #R$B764.
  $B77B,$01 Stash #REGhl on the stack.
  $B77C,$03 Point #REGhl at Berk movement script data (#R$B79C).
  $B77F,$02 Load #REGa with #N$E0.
N $B781 Publish a new camera room-origin and copy follow fields, then resume
. idle.
@ $B781 label=Berk_ReadControls_DownCameraCopy
  $B781,$01 Keep #N$E0 in #REGe for later.
  $B782,$02 Add #N$1F to #REGa (step down one screen row in the attribute map).
  $B784,$01 Keep #N$E0 in #REGd for later.
  $B785,$04 Store #REGde in the camera room-origin pointer (#R$72FB).
  $B789,$03 Point #REGde at camera-follow entity fields (#R$8EF3(#N$909F)).
  $B78C,$03 Load #REGbc with #N($0005,$04,$04) as a short copy length.
  $B78F,$02 Copy the block at #REGhl to #REGde.
  $B791,$01 Restore #REGhl from the stack.
  $B792,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, call
. #R$F0E9.
  $B799,$03 Jump to #R$B47E to resume Berk's controller.

b $B79C Data: Berk Movement Scripts
@ $B79C label=Data_BerkMovementScripts
D $B79C Short script fragment referenced while Berk walks, turns and interacts.
  $B79C,$05 Bytes: #N($00), #N($15), #N($1B), #N($E2), #N$E7.

c $B7A1 Berk Read Controls: Down Branches
@ $B7A1 label=Berk_ReadControls_DownBranch
D $B7A1 Continue the down-control handler: bit tests, interact calls and
. put-down script launches.
N $B7A1 Skip ahead to #R$B7B4 when the carry flag is clear.
  $B7A1,$02 Jump to #R$B7B4 if the previous compare did not take carry.
N $B7A3 Test direction/state bit #N$01; otherwise continue the active script.
@ $B7A3 label=Berk_ReadControls_DownBitTest
  $B7A3,$04 Is bit #N$01 of the current entity's direction / state set?.
  $B7A7,$03 If not, jump to #R$EC2E.
N $B7AA Face-left put-down when the bit test passed.
  $B7AA,$04 Set bit #N$02 of the current entity's flags byte 3.
  $B7AE,$03 Point #REGhl at #R$BA83.
  $B7B1,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B7B4 Shared down-branch: test direction bit #N$01 again, else run walk-right
. put-down.
@ $B7B4 label=Berk_ReadControls_DownPartT
  $B7B4,$04 Is bit #N$01 of the current entity's direction / state set?.
  $B7B8,$03 If not, jump to #R$EC2E.
  $B7BB,$04 Set bit #N$02 of the current entity's flags byte 3.
  $B7BF,$03 Point #REGhl at #R$BA77.
  $B7C2,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B7C5 Choose interact vs continue from the referenced entity's y-extent.
@ $B7C5 label=Berk_ReadControls_DownPartU
  $B7C5,$03 Load #REGa with the current entity's y-extent.
  $B7C8,$02 Is the y-extent equal to #N$1B?.
  $B7CA,$02 If so, jump to #R$B7D1.
  $B7CC,$02 Is the y-extent less than #N$23?.
  $B7CE,$03 If so, jump to #R$EC2E.
N $B7D1 Interact, then either abort or copy the collided entity and run a
. put-down.
@ $B7D1 label=Berk_ReadControls_DownPartV
  $B7D1,$03 Call #R$B7F3 to let Berk interact with an entity.
  $B7D4,$02 If carry is set, jump to #R$B7A3.
  $B7D6,$02 If not zero, jump to #R$B7B4.
  $B7D8,$04 Load #REGbc with the last-collided entity pointer (#R$72AA).
  $B7DC,$04 Store #REGbc in the current-entity pointer (#R$72AC).
  $B7E0,$03 Point #REGhl at #R$BA1F.
  $B7E3,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B7E6 High y-extent interact path leading to the #R$BB5D put-down.
@ $B7E6 label=Berk_ReadControls_DownPartW
  $B7E6,$03 Call #R$B7F3 to let Berk interact with an entity.
  $B7E9,$02 If carry is set, jump to #R$B7A3.
  $B7EB,$02 If not zero, jump to #R$B7B4.
  $B7ED,$03 Point #REGhl at #R$BB5D.
  $B7F0,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $B7F3 Berk Interact With Entity
@ $B7F3 label=Berk_Interact_With_Entity
D $B7F3 Test horizontal alignment with the last-collided entity (#R$72AA); on
. match clear bit #N$02 of IX+#N$03.
R $B7F3 IX Address of complex state data for an entity
N $B7F3 Handles Berk colliding with doors, the trap door and interactive
. scenery.
  $B7F3,$04 Load #REGiy with the last-collided entity pointer (#R$72AA).
  $B7F7,$03 Load #REGc with the referenced entity's entity type.
  $B7FA,$03 Load #REGa with the referenced entity's x-extent.
  $B7FD,$03 Subtract the referenced entity's x-coordinate from #REGa.
  $B800,$02 Shift the flag/value in #REGa right one bit.
  $B802,$03 Add the referenced entity's x-coordinate to #REGa.
  $B805,$02 Subtract #N$02 from #REGa.
  $B807,$04 Does #REGa match this entity's x-coordinate? If not, return.
  $B80B,$04 Reset bit #N$02 of the current entity's flags byte 3.
  $B80F,$01 Return.
N $B810 Handle left: clear facing-left, then walk or turn Berk left.
@ $B810 label=Berk_WalkLeft
  $B810,$04 Clear Berk's facing-left flag (bit #N$01 of #REGix+#N$03) so he
. faces right-to-left motion.
  $B814,$03 Fetch Berk's room index.
  $B817,$04 Is Berk in room #N$00? If not, continue the left-walk at #R$B823.
  $B81B,$03 Fetch Berk's y-extent.
  $B81E,$05 Is he still on the trap door row (y-extent #N$1B)? If not, continue
. the current script at #R$EC2E.
N $B823 Left walk outside room #N$00: test an entity on the right before turning
. or interacting.
@ $B823 label=Berk_WalkLeft_TestEntityOnRight
  $B823,$05 Call #R$F32E to test Entity On Right? If not, jump to #R$B835.
N $B828 Already facing the walk-left way: continue the script or run face-left
. put-down #R$BA83.
@ $B828 label=Berk_WalkLeft_FacingScript
  $B828,$07 Is bit #N$01 of the current entity's direction / state set? If so,
. jump to #R$EC2E.
  $B82F,$03 Point #REGhl at Berk control/put-down script data (#R$BA83).
  $B832,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B835 Left interact by height: close the trap door at y-extent #N($40), or
. take trap scripts at #N$39.
@ $B835 label=Berk_Interact_With_Entity_Branch
  $B835,$04 Is the current entity's y-extent equal to #N$39? If so, jump to
. #R$B8AC.
  $B839,$04 Is the current entity's y-extent equal to #N$40? If not, jump to
. #R$B84A.
  $B83D,$07 Is bit #N$01 of the current entity's direction / state set? If not,
. jump to #R$B47E.
  $B844,$03 Call #R$EDDB to close the trap door.
  $B847,$03 Jump to #R$EC2E to run the next script instruction.
N $B84A Below mid-room on left: either keep walking/turning or attempt a
. pick-up.
@ $B84A label=Berk_WalkLeft_BelowBand
  $B84A,$05 Is the current entity's y-extent less than #N$32? If not, jump to
. #R$B47E.
  $B84F,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B828.
  $B855,$04 Load #REGbc with the last-collided entity pointer (#R$72AA).
  $B859,$01 Advance the counter/pointer in #REGbc by one.
  $B85A,$01 Fetch a byte through the pointer in #REGbc.
  $B85B,$02,b$01 Keep only bit #N$04 of the flag byte in #REGa (mask #N$10).
  $B85D,$02 If the result was non-zero, jump to #R$B828.
  $B85F,$06 Is bit #N$03 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B86C.
  $B865,$07 Is bit #N$01 of the current entity's direction / state set? If so,
. jump to #R$EC2E.
N $B86C Try #R$B87C to pick up; on success lock held-state and run script
. #R$BB01.
@ $B86C label=Berk_WalkLeft_TryPickUp
  $B86C,$06 Call #R$B87C to let Berk pick up an entity? If not, jump to #R$B47E.
  $B872,$04 Set bit #N$03 of the current entity's flags byte 3.
  $B876,$03 Point #REGhl at Berk control/put-down script data
. (#R$BB01).
  $B879,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $B87C Berk Pick Up Entity
@ $B87C label=Berk_Pick_Up_Entity
D $B87C Berk Pick Up Entity for the player character using complex state at
. #R$8EE9.
R $B87C IX Address of complex state data for an entity
  $B87C,$04 Load #REGbc with the last-collided entity pointer (#R$72AA).
  $B880,$01 Advance the counter/pointer in #REGbc by one.
  $B881,$01 Fetch a byte through the pointer in #REGbc.
  $B882,$02,b$01 Keep only bit #N$03 of the flag byte in #REGa (mask #N$08).
  $B884,$02 If the result was non-zero, jump to #R$B888.
  $B886,$01 Clear #REGa as a false / no-match result.
  $B887,$01 Return.
N $B888 Pick-up from the last collision: reject if X is too far left, else test
. on-left.
@ $B888 label=Berk_Pick_Up_Entity_FromCollision
  $B888,$02 Stash #REGix on the stack.
  $B88A,$04 Load #REGix with the last-collided entity pointer (#R$72AA).
  $B88E,$03 Load #REGa with the current entity's x-coordinate.
  $B891,$04 Is the current entity's x-coordinate less than #N$49? If not, jump
. to #R$B898.
  $B895,$01 Clear #REGa as a no-entity-found result.
  $B896,$02 Jump to #R$B8A1 to restore #REGix and return with no pick-up.
N $B898 Confirm the collidee sits on Berk's left before marking the pick-up.
@ $B898 label=Berk_Pick_Up_Entity_TestOnLeft
  $B898,$05 Call #R$F32A to test Entity On Left? If not, jump to #R$B8A4.
N $B89D Mark the picked-up entity's direction/state as held (#N$82).
@ $B89D label=Berk_Pick_Up_Entity_MarkDirection
  $B89D,$04 Write #N$82 to the current entity's direction / state.
N $B8A1 Exit the pick-up attempt, restoring Berk's entity pointer in #REGix.
@ $B8A1 label=Berk_Pick_Up_Entity_RestoreReturn
  $B8A1,$02 Restore #REGix from the stack.
  $B8A3,$01 Return.
N $B8A4 Retry pick-up via #R$B87C after the on-left test failed.
@ $B8A4 label=Berk_Pick_Up_Entity_RetryCollision
  $B8A4,$05 Call #R$B87C to let Berk pick up an entity? If so, jump to #R$B89D.
  $B8A9,$02 Restore #REGix from the stack.
  $B8AB,$01 Return.
N $B8AC Trap door height on left: choose open vs closed trap scripts from bit
. #N$01 of #R$72B3.
@ $B8AC label=Berk_Pick_Up_Entity_TrapDoorScripts
  $B8AC,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B47E.
  $B8B3,$03 Point #REGhl at the game event flags (#R$72B3).
  $B8B6,$04 Is "trap door is open / trap door event armed" (bit #N$01 of
. #R$72B3) set? If so, jump to #R$B8C0.
  $B8BA,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$BB33)).
  $B8BD,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B8C0 Trap already open: run the open-trap interaction script
. (#R$BB41).
@ $B8C0 label=Berk_Pick_Up_Entity_TrapOpenScript
  $B8C0,$03 Point #REGhl at Berk control/put-down script data
. (#R$BB41).
  $B8C3,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B8C6 Handle right: clear facing-left, then walk or turn Berk right.
@ $B8C6 label=Berk_WalkRight
  $B8C6,$04 Clear Berk's facing-left flag (bit #N$01 of #REGix+#N$03).
  $B8CA,$03 Fetch Berk's room index.
  $B8CD,$04 Is Berk in room #N$00? If not, continue the right-walk at #R$B8D9.
  $B8D1,$03 Fetch Berk's y-extent.
  $B8D4,$05 Is he still on the trap door row (y-extent #N$1B)? If not, continue
. the current script at #R$EC2E.
N $B8D9 Right walk outside room #N$00: test an entity below before turning or
. interacting.
@ $B8D9 label=Berk_WalkRight_TestBelow
  $B8D9,$05 Call #R$F391 to test Entity Below? If not, jump to #R$B8EB.
N $B8DE Already facing the walk-right way: continue the script or run face-right
. put-down #R$BA77.
@ $B8DE label=Berk_WalkRight_FaceCheck
  $B8DE,$07 Is bit #N$00 of the current entity's direction / state set? If so,
. jump to #R$EC2E.
  $B8E5,$03 Point #REGhl at Berk control/put-down script data (#R$BA77).
  $B8E8,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B8EB Right walk by y-extent: high rows put down, mid rows idle, else try a
. put-down.
@ $B8EB label=Berk_WalkRight_ByYExtent
  $B8EB,$05 Is the current entity's y-extent equal to #N$41? If so, jump to
. #R$B980.
  $B8F0,$04 Is the current entity's y-extent equal to #N$38? If so, jump to
. #R$B96C.
  $B8F4,$05 Is the current entity's y-extent equal to #N$3B? If so, jump to
. #R$B990.
  $B8F9,$05 Is the current entity's y-extent less than #N$32? If not, jump to
. #R$B47E.
  $B8FE,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B8DE.
  $B905,$04 Load #REGbc with the last-collided entity pointer (#R$72AA).
  $B909,$01 Advance the counter/pointer in #REGbc by one.
  $B90A,$01 Fetch a byte through the pointer in #REGbc.
  $B90B,$02,b$01 Keep only bit #N$04 of the flag byte in #REGa (mask #N$10).
  $B90D,$02 If the result was non-zero, jump to #R$B8DE.
  $B90F,$06 Is bit #N$03 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B91C.
  $B915,$07 Is bit #N$00 of the current entity's direction / state set? If so,
. jump to #R$EC2E.
N $B91C Try #R$B92C to put down; on success lock held-state and run script
. #R$BAF1.
@ $B91C label=Berk_WalkRight_TryPutDown
  $B91C,$06 Call #R$B92C to let Berk put down an entity? If not, jump to
. #R$B47E.
  $B922,$04 Set bit #N$03 of the current entity's flags byte 3.
  $B926,$03 Point #REGhl at Berk control/put-down script data
. (#R$BAF1).
  $B929,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $B92C Berk Put Down Entity
@ $B92C label=Berk_Put_Down_Entity
D $B92C Berk Put Down Entity for the player character using complex state at
. #R$8EE9.
R $B92C IX Address of complex state data for an entity
  $B92C,$04 Load #REGbc with the last-collided entity pointer (#R$72AA).
  $B930,$01 Advance the counter/pointer in #REGbc by one.
  $B931,$01 Fetch a byte through the pointer in #REGbc.
  $B932,$02,b$01 Keep only bit #N$03 of the flag byte in #REGa (mask #N$08).
  $B934,$02 If the result was non-zero, jump to #R$B938.
  $B936,$01 Clear #REGa as a false / no-match result.
  $B937,$01 Return.
N $B938 Put-down from the last collision: room-transition special case or
. above-entity test.
@ $B938 label=Berk_Put_Down_Entity_FromCollision
  $B938,$02 Stash #REGix on the stack.
  $B93A,$04 Load #REGix with the last-collided entity pointer (#R$72AA).
  $B93E,$03 Load #REGa with the current entity's x-extent.
  $B941,$04 Is the current entity's x-extent less than #N$B4? If not, jump to
. #R$B962.
  $B945,$05 Call #R$F38D to test Entity Above? If so, jump to #R$B965.
  $B94A,$04 Is the current entity's x-extent equal to #N$41? If not, jump to
. #R$B95D.
  $B94E,$04 Write #N$03 to the current entity's room index.
  $B952,$04 Set bit #N$04 of the current entity's flags byte 2.
  $B956,$03 Point #REGhl at the game event flags (#R$72B3).
  $B959,$02 Set "special put-down / room-transition event" (bit #N$06 of
. #R$72B3).
  $B95B,$02 Jump to #R$B965 to finish putting the entity down.
N $B95D Retry put-down via #R$B92C after the first collision path did not
. finish.
@ $B95D label=Berk_Put_Down_Entity_CollisionRetry
  $B95D,$05 Call #R$B92C to let Berk put down an entity? If so, jump to #R$B965.
N $B962 Exit the put-down attempt, restoring Berk's entity pointer in #REGix.
@ $B962 label=Berk_Put_Down_Entity_RestoreReturn
  $B962,$02 Restore #REGix from the stack.
  $B964,$01 Return.
N $B965 Mark the put-down entity's direction/state as released (#N$81).
@ $B965 label=Berk_Put_Down_Entity_SetDirection
  $B965,$04 Write #N$81 to the current entity's direction / state.
  $B969,$02 Restore #REGix from the stack.
  $B96B,$01 Return.
N $B96C Y-extent #N$38 put-down: run script #R$BB11 when no timed event
. is pending.
@ $B96C label=Berk_Put_Down_Entity_AtYExtent38
  $B96C,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B47E.
  $B973,$03 Load #REGa with the timed event latch (#R$72CE).
  $B976,$04 Is timed event latch zero? If not, jump to #R$B47E.
  $B97A,$03 Point #REGhl at Berk control/put-down script data
. (#R$BB11).
  $B97D,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B980 Y-extent #N$41 put-down: run script #R$B9A5(#N$BB7B).
@ $B980 label=Berk_Put_Down_Entity_AtYExtent41
  $B980,$03 Point #REGhl at Berk control/put-down script data
. (#R$B9A5(#N$BB7B)).
  $B983,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $B986 Low-band abort: refill attribute rows and republish Berk's script
. cursor.
@ $B986 label=Berk_Put_Down_Entity_PublishScriptPos
  $B986,$03 Call #R$EA73 to fill Attribute Rows.
  $B989,$03 Load #REGhl with Berk's script position pointer (#R$72B1).
  $B98C,$03 Store #REGhl in the active script cursor (#R$72CF).
  $B98F,$01 Return.
N $B990 Trap door y-extent put-down: run #R$BB21 unless carrying or trap flags
. block it.
@ $B990 label=Berk_Put_Down_Entity_TrapDoor
  $B990,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$B47E.
  $B997,$03 Load #REGa with the trap door flags (#R$72BA).
  $B99A,$05 Is bit #N$03 of trap door flags set? If so, jump to #R$B47E.
  $B99F,$03 Point #REGhl at a Berk put-down script (#R$BB21).
  $B9A2,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
b $B9A5 Data: Berk Put-Down Scripts
@ $B9A5 label=Data_BerkPutDownScripts
D $B9A5 Script and table data used when Berk puts an entity down (#R$B9A5,
. #R$BB21).
N $B9A5 #UDGTABLE { #SCRIPTANIM$B9A5(script-b9a5) } UDGTABLE#
W $B9A5,$02 Script opcode #N$08 (move entity up two characters).
W $B9A7,$02 Script opcode #N$13 (position put-down entity to the right).
  $B9A9,$02 Graphic-layout pointer #R$9208.
  $B9AB,$02 Graphic-layout pointer #R$9214.
W $B9AD,$02 Script opcode #N$0A (reset entity direction flags).
W $B9AF,$02 Script opcode #N$09 (move entity down two characters).
W $B9B1,$02 Script opcode #N$07 (move entity right two characters).
W $B9B3,$02 Script opcode #N$15 (jump if carrying).
  $B9B5,$02 Graphic-layout pointer #R$B9BD.
  $B9B7,$02 Graphic-layout pointer #R$9647.
W $B9B9,$02 Script opcode #N$01 (load script address).
  $B9BB,$02 Graphic-layout pointer #R$B9B7.
W $B9BD,$02 Script opcode #N$10 (have entity face left after putting down).
N $B9BF Continuation after the standard put-down preamble.
@ $B9BF label=BerkPutDownScript_AfterStandard
  $B9BF,$02 Graphic-layout pointer #R$9742.
W $B9C1,$02 Script opcode #N$01 (load script address).
  $B9C3,$04 Graphic-layout pointer #R$B9BD; Script opcode #N$08 (move
. entity up two characters).
W $B9C7,$02 Script opcode #N$12 (position put-down entity to the left).
  $B9C9,$02 Graphic-layout pointer #R$9458.
  $B9CB,$04 Graphic-layout pointer #R$9461; Script opcode #N$09 (move
. entity down two characters).
W $B9CF,$02 Script opcode #N$06 (task entity script is active).
W $B9D1,$02 Script opcode #N$0A (reset entity direction flags).
W $B9D3,$02 Script opcode #N$15 (jump if carrying).
  $B9D5,$02 Graphic-layout pointer #R$BA11.
  $B9D7,$02 Graphic-layout pointer #R$9869.
  $B9D9,$02 Graphic-layout pointer #R$9869.
  $B9DB,$02 Graphic-layout pointer #R$9869.
  $B9DD,$02 Graphic-layout pointer #R$9869.
  $B9DF,$02 Graphic-layout pointer #R$9869.
  $B9E1,$02 Graphic-layout pointer #R$9869.
  $B9E3,$02 Graphic-layout pointer #R$9869.
  $B9E5,$02 Graphic-layout pointer #R$9869.
W $B9E7,$02 Script opcode #N$01 (load script address).
  $B9E9,$04 Graphic-layout pointer #R$B9A5; Script opcode #N$0A (reset entity
. direction flags).
W $B9ED,$02 Script opcode #N$08 (move entity up two characters).
  $B9EF,$02 Graphic-layout pointer #R$985A.
  $B9F1,$02 Graphic-layout pointer #R$9BC1.
W $B9F3,$02 Script opcode #N$0F (put down carried entity).
W $B9F5,$02 Script opcode #N$01 (load script address).
  $B9F7,$04 Graphic-layout pointer #R$BA11; Script opcode #N$0A (reset
. entity direction flags).
W $B9FB,$02 Script opcode #N$08 (move entity up two characters).
  $B9FD,$02 Graphic-layout pointer #R$9C06.
  $B9FF,$02 Graphic-layout pointer #R$9C06.
W $BA01,$02 Script opcode #N$0F (put down carried entity).
W $BA03,$02 Script opcode #N$01 (load script address).
  $BA05,$02 Graphic-layout pointer #R$BA11.
W $BA07,$02 Script opcode #N$0A (reset entity direction flags).
W $BA09,$02 Script opcode #N$08 (move entity up two characters).
  $BA0B,$02 Graphic-layout pointer #R$985A.
  $BA0D,$02 Graphic-layout pointer #R$98B4.
W $BA0F,$02 Script opcode #N$0F (put down carried entity).
W $BA11,$02 Script opcode #N$11 (face right after put-down).
  $BA13,$02 Graphic-layout pointer #R$98B4.
  $BA15,$02 Graphic-layout pointer #R$98B4.
  $BA17,$02 Graphic-layout pointer #R$98B4.
  $BA19,$02 Graphic-layout pointer #R$98B4.
W $BA1B,$02 Script opcode #N$01 (load script address).
  $BA1D,$02 Graphic-layout pointer #R$B9A5.
N $BA1F Script used when the down-control interact path loads a put-down.
@ $BA1F label=BerkPutDownScript_DownInteract
W $BA1F,$02 Script opcode #N$08 (move entity up two characters).
W $BA21,$02 Script opcode #N$0A (reset entity direction flags).
  $BA23,$02 Graphic-layout pointer #R$963B.
  $BA25,$02 Graphic-layout pointer #R$9B67.
  $BA27,$02 Graphic-layout pointer #R$9B67.
  $BA29,$02 Graphic-layout pointer #R$9B67.
W $BA2B,$02 Script opcode #N$0F (put down carried entity).
W $BA2D,$02 Script opcode #N$01 (load script address).
  $BA2F,$04 Graphic-layout pointer #R$B9AD; Script opcode #N$08 (move
. entity up two characters).
W $BA33,$02 Script opcode #N$10 (have entity face left after putting down).
N $BA35 Script installed into Berk's script pointer when camera-follow engages.
@ $BA35 label=BerkPutDownScript_CameraFollow
  $BA35,$02 Graphic-layout pointer #R$963B.
W $BA37,$02 Script opcode #N$18 (start loop).
N $BA39 Body of the camera-follow put-down script.
@ $BA39 label=BerkPutDownScript_CameraFollowCont
  $BA39,$02 Graphic-layout pointer #R$963B.
W $BA3B,$02 Script opcode #N$01 (load script address).
  $BA3D,$04 Graphic-layout pointer #R$B9AD; Script opcode #N$08 (move
. entity up two characters).
W $BA41,$02 Script opcode #N$14 (pick up / restore held entity).
  $BA43,$02 Graphic-layout pointer #R$9BC1.
  $BA45,$02 Graphic-layout pointer #R$9BC1.
  $BA47,$02 Graphic-layout pointer #R$985A.
W $BA49,$02 Script opcode #N$01 (load script address).
  $BA4B,$04 Graphic-layout pointer #R$B9A5(#N$B9CD); Script opcode #N$08 (move
. entity up two characters).
W $BA4F,$02 Script opcode #N$11 (face right after put-down).
W $BA51,$02 Script opcode #N$14 (pick up / restore held entity).
  $BA53,$02 Graphic-layout pointer #R$9C06.
  $BA55,$02 Graphic-layout pointer #R$9C06.
W $BA57,$02 Script opcode #N$01 (load script address).
  $BA59,$04 Graphic-layout pointer #R$B9A5; Script opcode #N$08 (move entity up
. two characters).
W $BA5D,$02 Script opcode #N$11 (face right after put-down).
W $BA5F,$02 Script opcode #N$14 (pick up / restore held entity).
  $BA61,$02 Graphic-layout pointer #R$985A.
W $BA63,$02 Script opcode #N$01 (load script address).
  $BA65,$04 Graphic-layout pointer #R$B9A5; Script opcode #N$08 (move entity up
. two characters).
W $BA69,$02 Script opcode #N$10 (have entity face left after putting down).
N $BA6B Script fragment that loops back toward the standard put-down.
@ $BA6B label=BerkPutDownScript_NearLoop
  $BA6B,$02 Graphic-layout pointer #R$963B.
W $BA6D,$02 Script opcode #N$17 (load script parameter into A).
  $BA6F,$02 Graphic-layout pointer #R$963B.
W $BA71,$02 Script opcode #N$18 (start loop).
N $BA73 Script just before the walk-left facing put-down.
@ $BA73 label=BerkPutDownScript_BeforeWalkLeft
W $BA73,$02 Script opcode #N$01 (load script address).
  $BA75,$02 Graphic-layout pointer #R$B9AD.
N $BA77 Put-down script when Berk faces right while walking.
@ $BA77 label=BerkPutDownScript_WalkRightFace
W $BA77,$02 Script opcode #N$0C (face left).
W $BA79,$02 Script opcode #N$13 (position put-down entity to the right).
  $BA7B,$02 Graphic-layout pointer #R$9226.
W $BA7D,$02 Script opcode #N$03 (task-two helper busy).
W $BA7F,$02 Script opcode #N$01 (load script address).
  $BA81,$02 Graphic-layout pointer #R$BA7B.
N $BA83 Put-down script when Berk faces left while walking.
@ $BA83 label=BerkPutDownScript_WalkLeftFace
W $BA83,$02 Script opcode #N$0B (face right).
W $BA85,$02 Script opcode #N$12 (position put-down entity to the left).
  $BA87,$02 Graphic-layout pointer #R$9470.
N $BA89 Script just before the drop / control put-down.
@ $BA89 label=BerkPutDownScript_BeforeDrop
W $BA89,$02 Script opcode #N$02 (object has been offered to the trap (Bad
. Tempered Thing path)).
W $BA8B,$02 Script opcode #N$01 (load script address).
  $BA8D,$02 Graphic-layout pointer #R$BA87.
N $BA8F Control put-down script used when Berk drops / releases an entity.
@ $BA8F label=BerkPutDownScript_Drop
W $BA8F,$02 Script opcode #N$0D (face up).
W $BA91,$02 Script opcode #N$15 (jump if carrying).
  $BA93,$02 Graphic-layout pointer #R$BACD.
  $BA95,$02 Graphic-layout pointer #R$9878.
W $BA97,$02 Script opcode #N$04 (reserved / unused in the observed call sites).
  $BA99,$02 Graphic-layout pointer #R$9887.
  $BA9B,$02 Graphic-layout pointer #R$9896.
W $BA9D,$02 Script opcode #N$04 (reserved / unused in the observed call sites).
  $BA9F,$02 Graphic-layout pointer #R$98A5.
W $BAA1,$02 Script opcode #N$01 (load script address).
  $BAA3,$02 Graphic-layout pointer #R$BA95.
N $BAA5 Put-down script from the down-control handler.
@ $BAA5 label=BerkPutDownScript_DownControl
W $BAA5,$02 Script opcode #N$0E (face down).
W $BAA7,$02 Script opcode #N$15 (jump if carrying).
  $BAA9,$02 Graphic-layout pointer #R$BADF.
  $BAAB,$02 Graphic-layout pointer #R$9706.
W $BAAD,$02 Script opcode #N$05 (task-two room-transition latch).
  $BAAF,$02 Graphic-layout pointer #R$9715.
  $BAB1,$02 Graphic-layout pointer #R$9724.
W $BAB3,$02 Script opcode #N$05 (task-two room-transition latch).
  $BAB5,$02 Graphic-layout pointer #R$9733.
W $BAB7,$02 Script opcode #N$01 (load script address).
  $BAB9,$02 Graphic-layout pointer #R$BAAB.
N $BABB Put-down script when direction/state bit #N$03 is set.
@ $BABB label=BerkPutDownScript_Bit3Set
W $BABB,$02 Script opcode #N$08 (move entity up two characters).
  $BABD,$02 Graphic-layout pointer #R$98BD.
W $BABF,$02 Script opcode #N$04 (reserved / unused in the observed call sites).
  $BAC1,$02 Graphic-layout pointer #R$98C6.
  $BAC3,$02 Graphic-layout pointer #R$98CF.
  $BAC5,$02 Graphic-layout pointer #R$98D8.
W $BAC7,$02 Script opcode #N$09 (move entity down two characters).
W $BAC9,$02 Script opcode #N$01 (load script address).
  $BACB,$02 Graphic-layout pointer #R$B9A5(#N$B9CD).
W $BACD,$02 Script opcode #N$11 (face right after put-down).
  $BACF,$02 Graphic-layout pointer #R$98BD.
W $BAD1,$02 Script opcode #N$04 (reserved / unused in the observed call sites).
  $BAD3,$02 Graphic-layout pointer #R$98C6.
  $BAD5,$02 Graphic-layout pointer #R$98CF.
W $BAD7,$02 Script opcode #N$04 (reserved / unused in the observed call sites).
  $BAD9,$02 Graphic-layout pointer #R$98D8.
W $BADB,$02 Script opcode #N$01 (load script address).
  $BADD,$02 Graphic-layout pointer #R$BACF.
W $BADF,$02 Script opcode #N$10 (have entity face left after putting down).
N $BAE1 Self-looping animation fragment within the put-down scripts.
@ $BAE1 label=BerkPutDownScript_AnimLoop
  $BAE1,$02 Graphic-layout pointer #R$974E.
W $BAE3,$02 Script opcode #N$05 (task-two room-transition latch).
  $BAE5,$02 Graphic-layout pointer #R$975A.
  $BAE7,$02 Graphic-layout pointer #R$9766.
W $BAE9,$02 Script opcode #N$05 (task-two room-transition latch).
  $BAEB,$02 Graphic-layout pointer #R$9772.
W $BAED,$02 Script opcode #N$01 (load script address).
  $BAEF,$02 Graphic-layout pointer #R$BAE1.
W $BAF1,$02 Script opcode #N$0C (face left).
W $BAF3,$02 Script opcode #N$08 (move entity up two characters).
  $BAF5,$02 Graphic-layout pointer #R$9220.
W $BAF7,$02 Script opcode #N$03 (task-two helper busy).
W $BAF9,$02 Script opcode #N$09 (move entity down two characters).
  $BAFB,$02 Graphic-layout pointer #R$9220.
W $BAFD,$02 Script opcode #N$01 (load script address).
  $BAFF,$02 Graphic-layout pointer #R$BAF1.
W $BB01,$02 Script opcode #N$0B (face right).
W $BB03,$02 Script opcode #N$08 (move entity up two characters).
  $BB05,$02 Graphic-layout pointer #R$946A.
W $BB07,$02 Script opcode #N$02 (object has been offered to the trap (Bad
. Tempered Thing path)).
W $BB09,$02 Script opcode #N$09 (move entity down two characters).
  $BB0B,$02 Graphic-layout pointer #R$946A.
W $BB0D,$02 Script opcode #N$01 (load script address).
  $BB0F,$02 Graphic-layout pointer #R$BB01.
W $BB11,$02 Script opcode #N$08 (move entity up two characters).
  $BB13,$02 Graphic-layout pointer #R$9251.
  $BB15,$02 Graphic-layout pointer #R$9251.
W $BB17,$02 Script opcode #N$16 (start Drutt script).
  $BB19,$02 Graphic-layout pointer #R$9245.
  $BB1B,$02 Graphic-layout pointer #R$9245.
W $BB1D,$02 Script opcode #N$01 (load script address).
  $BB1F,$02 Graphic-layout pointer #R$B9AD.
N $BB21 Put-down script used at the trap door.
@ $BB21 label=BerkPutDownScript_TrapDoor
W $BB21,$02 Script opcode #N$08 (move entity up two characters).
  $BB23,$02 Graphic-layout pointer #R$9251.
  $BB25,$02 Graphic-layout pointer #R$9251.
W $BB27,$02 Script opcode #N$1B (animate trap door).
  $BB29,$02 Graphic-layout pointer #R$9245.
  $BB2B,$02 Graphic-layout pointer #R$9245.
W $BB2D,$02 Script opcode #N$1B (animate trap door).
W $BB2F,$02 Script opcode #N$01 (load script address).
  $BB31,$04 Graphic-layout pointer #R$B9AD; Script opcode #N$08 (move
. entity up two characters).
  $BB35,$02 Graphic-layout pointer #R$9269.
  $BB37,$02 Graphic-layout pointer #R$9269.
W $BB39,$02 Script opcode #N$1A (open trap door).
  $BB3B,$02 Graphic-layout pointer #R$925D.
W $BB3D,$02 Script opcode #N$01 (load script address).
  $BB3F,$02 Graphic-layout pointer #R$B9AD.
W $BB41,$02 Script opcode #N$08 (move entity up two characters).
  $BB43,$02 Graphic-layout pointer #R$925D.
  $BB45,$02 Graphic-layout pointer #R$925D.
W $BB47,$02 Script opcode #N$1C (close trap door).
  $BB49,$02 Graphic-layout pointer #R$9269.
W $BB4B,$02 Script opcode #N$01 (load script address).
  $BB4D,$04 Graphic-layout pointer #R$B9AD; Script opcode #N$08 (move
. entity up two characters).
W $BB51,$02 Script opcode #N$11 (face right after put-down).
  $BB53,$02 Graphic-layout pointer #R$9878.
W $BB55,$02 Script opcode #N$04 (reserved / unused in the observed call sites).
  $BB57,$02 Graphic-layout pointer #R$9887.
W $BB59,$02 Script opcode #N$01 (load script address).
  $BB5B,$02 Graphic-layout pointer #R$BB99.
N $BB5D Put-down script for the high y-extent down-interact path.
@ $BB5D label=BerkPutDownScript_DownHighY
W $BB5D,$02 Script opcode #N$08 (move entity up two characters).
W $BB5F,$02 Script opcode #N$0E (face down).
W $BB61,$02 Script opcode #N$15 (jump if carrying).
  $BB63,$02 Graphic-layout pointer #R$BB6F.
  $BB65,$02 Graphic-layout pointer #R$9706.
W $BB67,$02 Script opcode #N$05 (task-two room-transition latch).
  $BB69,$02 Graphic-layout pointer #R$9715.
W $BB6B,$02 Script opcode #N$01 (load script address).
  $BB6D,$02 Graphic-layout pointer #R$BB99.
W $BB6F,$02 Script opcode #N$10 (have entity face left after putting down).
N $BB71 Prep fragment ahead of the trap door put-down animation.
@ $BB71 label=BerkPutDownScript_TrapDoorPrep
  $BB71,$02 Graphic-layout pointer #R$974E.
W $BB73,$02 Script opcode #N$05 (task-two room-transition latch).
  $BB75,$02 Graphic-layout pointer #R$975A.
W $BB77,$02 Script opcode #N$01 (load script address).
  $BB79,$04 Graphic-layout pointer #R$BB99; Script opcode #N$08 (move
. entity up two characters).
W $BB7D,$02 Script opcode #N$0C (face left).
W $BB7F,$02 Script opcode #N$13 (position put-down entity to the right).
  $BB81,$02 Graphic-layout pointer #R$9226.
W $BB83,$02 Script opcode #N$03 (task-two helper busy).
  $BB85,$02 Graphic-layout pointer #R$9226.
W $BB87,$02 Script opcode #N$03 (task-two helper busy).
  $BB89,$02 Graphic-layout pointer #R$9226.
W $BB8B,$02 Script opcode #N$03 (task-two helper busy).
  $BB8D,$02 Graphic-layout pointer #R$9226.
W $BB8F,$02 Script opcode #N$03 (task-two helper busy).
  $BB91,$02 Graphic-layout pointer #R$9226.
W $BB93,$02 Script opcode #N$03 (task-two helper busy).
W $BB95,$02 Script opcode #N$10 (have entity face left after putting down).
N $BB97 Trap door put-down animation script.
@ $BB97 label=BerkPutDownScript_TrapDoorAnim
  $BB97,$02 Graphic-layout pointer #R$9706.
W $BB99,$02 Script opcode #N$1D (set event flags after interaction).
  $BB9B,$02 Graphic-layout pointer #R$963B.
W $BB9D,$02 Script opcode #N$01 (load script address).
  $BB9F,$04 Graphic-layout pointer #R$BB9B; Script opcode #N$08 (move
. entity up two characters).
W $BBA3,$02 Script opcode #N$10 (have entity face left after putting down).
N $BBA5 Trap door put-down frame table / script.
@ $BBA5 label=BerkPutDownScript_TrapDoorFrames
  $BBA5,$02 Graphic-layout pointer #R$9742.
  $BBA7,$04 Script opcode #N$1E (berk interact with door ahead); Graphic-layout
. pointer #R$9742.
W $BBAB,$02 Script opcode #N$1F (berk interact with door behind).
  $BBAD,$02 Graphic-layout pointer #R$9742.
  $BBAF,$02 Graphic-layout pointer #R$9742.
  $BBB1,$02 Graphic-layout pointer #R$9742.
W $BBB3,$02 Script opcode #N$1E (berk interact with door ahead).
  $BBB5,$02 Graphic-layout pointer #R$9742.
W $BBB7,$02 Script opcode #N$20 (berk open door ahead).
N $BBB9 Release fragment at the end of the put-down sequence.
@ $BBB9 label=BerkPutDownScript_Release
W $BBB9,$02 Script opcode #N$01 (load script address).
  $BBBB,$04 Graphic-layout pointer #R$B9AD; Script opcode #N$10 (have
. entity face left after putting down).
N $BBBF Tail of the release put-down fragment.
@ $BBBF label=BerkPutDownScript_ReleaseTail
W $BBBF,$02 Script opcode #N$18 (start loop).
N $BBC1 Continuation of the release put-down fragment.
@ $BBC1 label=BerkPutDownScript_ReleaseCont
  $BBC1,$02 Graphic-layout pointer #R$963B.
  $BBC3,$02 Graphic-layout pointer #R$9226.
  $BBC5,$02 Graphic-layout pointer #R$963B.
  $BBC7,$02 Graphic-layout pointer #R$9470.
  $BBC9,$02 Graphic-layout pointer #R$9878.
  $BBCB,$02 Graphic-layout pointer #R$9226.
  $BBCD,$02 Graphic-layout pointer #R$9BC1.
  $BBCF,$02 Graphic-layout pointer #R$9470.
  $BBD1,$02 Graphic-layout pointer #R$9C06.
  $BBD3,$02 Graphic-layout pointer #R$9226.
  $BBD5,$02 Graphic-layout pointer #R$9BC1.
  $BBD7,$02 Graphic-layout pointer #R$9226.
  $BBD9,$02 Graphic-layout pointer #R$9C06.
W $BBDB,$02 Script opcode #N$01 (load script address).
W $BBDD,$02 Script address #R$B9AD.
B $BBDF,$01 Move-delay flag for the Thing Upstairs entity.
W $BBE0,$02 Graphic-layout pointer #R$BDC3.
W $BBE2,$02 Script opcode #N$31 (Thing Upstairs chase step).
W $BBE4,$02 Graphic-layout pointer #R$BDC3.
W $BBE6,$02 Script opcode #N$31 (Thing Upstairs chase step).
W $BBE8,$02 Graphic-layout pointer #R$BDC3.
W $BBEA,$02 Script opcode #N$31 (Thing Upstairs chase step).
W $BBEC,$02 Graphic-layout pointer #R$BDC3.
W $BBEE,$02 Script opcode #N$31 (Thing Upstairs chase step).
W $BBF0,$02 Graphic-layout pointer #R$BDC3.
W $BBF2,$02 Script opcode #N$32 (Thing Upstairs chase variant).
W $BBF4,$02 Graphic-layout pointer #R$BDC3.
W $BBF6,$02 Script opcode #N$34 (Thing Upstairs chase variant).
W $BBF8,$02 Script opcode #N$01 (load script address).
W $BBFA,$02 Script address #R$BBF4.
W $BBFC,$02 Graphic-layout pointer #R$BDD0.
W $BBFE,$02 Graphic-layout pointer #R$BDD0.

b $BC00 Data: Thing Upstairs Script Tail
@ $BC00 label=Data_ThingUpstairsScriptTail
D $BC00 Continuation of the Thing Upstairs script that starts at
. #R$BBE0. #R$BCA9 points #REGhl at #R$BC0E and enters
. #R$EC30; #R$BDBA arms the same script via #R$72D9.
W $BC00,$02 Graphic-layout pointer #R$BDC3.
W $BC02,$02 Script opcode #N$35 (fill attribute rows).
W $BC04,$02 Graphic-layout pointer #R$BDC3.
W $BC06,$02 Graphic-layout pointer #R$BDC3.
W $BC08,$02 Graphic-layout pointer #R$BDC3.
W $BC0A,$02 Script opcode #N$01 (load script address).
W $BC0C,$02 Script address #R$BBF4.
W $BC0E,$02 Graphic-layout pointer #R$BDC3.
W $BC10,$02 Script opcode #N$33 (clear attribute file / reset slot).

c $BC12 Update Thing Upstairs Entity
@ $BC12 label=Update_ThingUpstairs_Entity
D $BC12 Drive complex entity slot #N$20 when its type is #N$22: copy its script
. cursor through #R$72CF, run the next instruction, then save the cursor back.
  $BC12,$05 Return if Learner Berk mode is set.
  $BC17,$08 Jump to #R$BDA0 unless complex entity slot #N$20's type (#R$9001) is
. #N$22.
  $BC1F,$06 Copy #R$72D9 back to the active script cursor.
  $BC25,$03 Call #R$BC2F to update Thing Upstairs Entity State.
  $BC28,$06 Copy the active script cursor to #R$72D9.
  $BC2E,$01 Return.

c $BC2F Update Thing Upstairs Entity State
@ $BC2F label=Update_ThingUpstairs_Entity_State
D $BC2F Point #REGix at complex entity slot #N$20 (#R$9001) and run its next
. script instruction.
  $BC2F,$04 Point #REGix at complex entity slot #N$20 (#R$9001).
  $BC33,$03 Jump to #R$EC2E to run the next script instruction.

c $BC36 Script Routine: (#N$31) Thing Upstairs action
@ $BC36 label=ScriptRoutine_ThingUpstairsRaise
D $BC36 Raise the Thing Upstairs entity two characters as part of its room
. sequence.
R $BC36 IX Address of complex state data for an entity
  $BC36,$03 Decrease the entity's y-coordinate.
  $BC39,$03 Decrease the entity's y-coordinate again.
  $BC3C,$03 Decrease the entity's y-extent.
  $BC3F,$03 Decrease the entity's y-extent again.
  $BC42,$03 Jump to #R$EC2E to run the next script instruction.

c $BC45 Script Routine: (#N$32) Thing Upstairs action
@ $BC45 label=ScriptRoutine_ThingUpstairsResetRoom
D $BC45 Clear the upstairs event latch once the Thing Upstairs room sequence has
. finished.
R $BC45 IX Address of complex state data for an entity
  $BC45,$03 Load #REGa with the game event flags (#R$72B3).
  $BC48,$02 Clear bit #N$04 of the flag byte in #REGa.
  $BC4A,$03 Set the game event flags (#R$72B3).
  $BC4D,$04 Write #N$05 to the current entity's room index.
  $BC51,$03 Jump to #R$EC2E to run the next script instruction.

c $BC54 Script Routine: (#N$35) Thing Upstairs action
@ $BC54 label=ScriptRoutine_ThingUpstairsFillAttributes
D $BC54 Repaint the Thing Upstairs scene's attribute rows before the script
. continues.
  $BC54,$03 Call #R$EA73 to fill Attribute Rows.
  $BC57,$03 Jump to #R$EC2E to run the next script instruction.

b $BC5A Data: Thing Upstairs Entity Template
@ $BC5A label=Data_ThingUpstairsEntityTemplate
D $BC5A Ten-byte entity template copied over complex entity slot #N$20 by
. #R$BC73 when the Thing Upstairs script clears the slot.
  $BC5A,$0A


c $BC64 Script Routine: (#N$33) Thing Upstairs action
@ $BC64 label=ScriptRoutine_ThingUpstairsClearScreen
D $BC64 Blank the attribute file for the Thing Upstairs scene and reset slot
. #N$20.
  $BC64,$02 Load #REGa with #N$36.
  $BC66,$03 Call #R$EA52 to clear the attribute file.
  $BC69,$03 Point #REGhl at #R$BDC3.
  $BC6C,$03 Store #REGhl in Thing Upstairs storage at #R$BBF4.
  $BC6F,$01 Clear complex entity slot #N$20's type (empty the slot).
  $BC70,$03 Store #REGa in complex entity slot #N$20's type (#R$9001).
  $BC73,$03 Point #REGhl at #R$BC5A.
  $BC76,$01 Stash #REGde on the stack.
  $BC77,$03 Point #REGde at complex entity slot #N$20 (#R$9001).
  $BC7A,$03 Load #REGbc with #N($000A,$04,$04) as a short table length.
  $BC7D,$02 Copy the block pointed to by #REGhl into the destination at #REGde.
  $BC7F,$01 Restore #REGde from the stack.
  $BC80,$01 Return.

c $BC81 Script Routine: (#N$34) Thing Upstairs action
@ $BC81 label=ScriptRoutine_ThingUpstairsChase
D $BC81 Chase Berk with the Thing Upstairs entity when the two overlap;
. otherwise keep the script moving.
R $BC81 IX Address of complex state data for an entity
  $BC81,$03 Call #R$BD72 to test whether the Thing Upstairs entity overlaps Berk
. / the camera-follow entity.
  $BC84,$03 Is #REGa zero? If not, jump to #R$BCB5.
  $BC87,$04 Point #REGiy at the camera-follow entity (#R$909B).
  $BC8B,$04 Set bit #N$00 of the referenced entity's flags byte 3.
  $BC8F,$06 Is bit #N$04 of flags byte 3 (#REGiy+#N$03) set? If not, jump to
. #R$BCAF.
  $BC95,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $BC99,$06 Is bit #N$07 of the referenced entity's flags byte 2 set? If not,
. jump to #R$BCAF.
  $BC9F,$01 Clear the referenced entity type (deactivate the slot).
  $BCA0,$03 Set the referenced entity's entity type.
  $BCA3,$03 Point #REGhl at Berk script data #R$BA35.
  $BCA6,$03 Store #REGhl in Berk's script position pointer (#R$72B1).
  $BCA9,$03 Point #REGhl at the Thing Upstairs script tail (#R$BC0E).
  $BCAC,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $BCAF No chase overlap: run the Thing Upstairs storage/idle script at
. #R$BBFC.
@ $BCAF label=ScriptRoutine_ThingUpstairsChase_RunStorage
  $BCAF,$03 Point #REGhl at Thing Upstairs storage at #R$BBFC.
  $BCB2,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $BCB5 Chase tick: random skip, honour move-delay #R$BBDF, else
. retarget via #R$BD3C.
@ $BCB5 label=ScriptRoutine_ThingUpstairsChase_MoveTick
  $BCB5,$02 Load #REGa with #N$0A.
  $BCB7,$03 Call #R$EAE5 to pick a pseudo-random value.
  $BCBA,$05 Is #N$0A less than #N$03? If so, jump to #R$EC2E.
  $BCBF,$03 Load #REGa from #R$BBDF.
  $BCC2,$03 Is #REGa zero? If not, jump to #R$BCCA.
  $BCC5,$03 Call #R$BD3C to update Thing Upstairs Movement.
  $BCC8,$02 Jump to #R$BCCE to continue this routine.
N $BCCA Count down the Thing Upstairs move-delay byte at #R$BBDF.
@ $BCCA label=ScriptRoutine_ThingUpstairsChase_DecMoveDelay
  $BCCA,$01 Step #N$0A back by one.
  $BCCB,$03 Set Thing Upstairs flag byte #R$BBDF.
N $BCCE Apply direction bits: step right, left, down or up, then continue the
. script.
@ $BCCE label=ScriptRoutine_ThingUpstairsChase_ApplyDirection
  $BCCE,$03 Load #REGa with the current entity's direction / state.
  $BCD1,$05 Is bit #N$00 of the current entity's direction / state set? If so,
. call #R$BCE8.
  $BCD6,$05 Is bit #N$01 of the current entity's direction / state set? If so,
. call #R$BCFD.
  $BCDB,$05 Is bit #N$02 of the current entity's direction / state set? If so,
. call #R$BD27.
  $BCE0,$05 Is bit #N$03 of the current entity's direction / state set? If so,
. call #R$BD12.
  $BCE5,$03 Jump to #R$EC2E to run the next script instruction.
N $BCE8 Try moving the Thing Upstairs entity right, or retarget when X-extent
. hits the right bound.
@ $BCE8 label=ScriptRoutine_ThingUpstairsChase_TryMoveRight
  $BCE8,$01 Stash #REGaf on the stack.
  $BCE9,$03 Load #REGa with the current entity's x-extent.
  $BCEC,$04 Is the current entity's x-extent less than #N$FC? If so, jump to
. #R$BCF5.
  $BCF0,$03 Call #R$BD3C to update Thing Upstairs Movement.
  $BCF3,$02 Jump to #R$BCFB to continue this routine.
N $BCF5 Nudge the Thing Upstairs entity one character right (X and X-extent).
@ $BCF5 label=ScriptRoutine_ThingUpstairsChase_IncX
  $BCF5,$03 Increment the entity's x-coordinate.
N $BCF8 Advance the Thing Upstairs entity's X-extent as part of the right-step.
@ $BCF8 label=ScriptRoutine_ThingUpstairsChase_IncXExtent
  $BCF8,$03 Increment the entity's x-extent.
N $BCFB Restore flags and return from the right-step attempt.
@ $BCFB label=ScriptRoutine_ThingUpstairsChase_RestoreReturnRight
  $BCFB,$01 Restore #REGaf from the stack.
  $BCFC,$01 Return.
N $BCFD Try moving the Thing Upstairs entity left, or retarget when X hits the
. left bound.
@ $BCFD label=ScriptRoutine_ThingUpstairsChase_TryMoveLeft
  $BCFD,$01 Stash #REGaf on the stack.
  $BCFE,$03 Load #REGa with the current entity's x-coordinate.
  $BD01,$04 Is the current entity's x-coordinate less than #N$22? If not, jump
. to #R$BD0A.
  $BD05,$03 Call #R$BD3C to update Thing Upstairs Movement.
  $BD08,$02 Jump to #R$BD10 to continue this routine.
N $BD0A Nudge the Thing Upstairs entity one character left.
@ $BD0A label=ScriptRoutine_ThingUpstairsChase_DecX
  $BD0A,$06 Move this entity one character left.
N $BD10 Restore flags and return from the left-step attempt.
@ $BD10 label=ScriptRoutine_ThingUpstairsChase_RestoreReturnLeft
  $BD10,$01 Restore #REGaf from the stack.
  $BD11,$01 Return.
N $BD12 Try moving the Thing Upstairs entity up, or retarget when Y hits the top
. bound.
@ $BD12 label=ScriptRoutine_ThingUpstairsChase_TryMoveUp
  $BD12,$01 Stash #REGaf on the stack.
  $BD13,$03 Load #REGa with the current entity's y-coordinate.
  $BD16,$04 Is the current entity's y-coordinate less than #N$14? If not, jump
. to #R$BD1F.
  $BD1A,$03 Call #R$BD3C to update Thing Upstairs Movement.
  $BD1D,$02 Jump to #R$BD25 to continue this routine.
N $BD1F Nudge the Thing Upstairs entity one character up.
@ $BD1F label=ScriptRoutine_ThingUpstairsChase_DecY
  $BD1F,$06 Move this entity one character up.
N $BD25 Restore flags and return from the up-step attempt.
@ $BD25 label=ScriptRoutine_ThingUpstairsChase_RestoreReturnUp
  $BD25,$01 Restore #REGaf from the stack.
  $BD26,$01 Return.
N $BD27 Try moving the Thing Upstairs entity down, or retarget when Y-extent
. hits the bottom bound.
@ $BD27 label=ScriptRoutine_ThingUpstairsChase_TryMoveDown
  $BD27,$01 Stash #REGaf on the stack.
  $BD28,$03 Load #REGa with the current entity's y-extent.
  $BD2B,$04 Is the current entity's y-extent less than #N$24? If so, jump to
. #R$BD34.
  $BD2F,$03 Call #R$BD3C to update Thing Upstairs Movement.
  $BD32,$02 Jump to #R$BD3A to continue this routine.
N $BD34 Nudge the Thing Upstairs entity one character down.
@ $BD34 label=ScriptRoutine_ThingUpstairsChase_IncY
  $BD34,$06 Move this entity one character down.
N $BD3A Restore flags and return from the down-step attempt.
@ $BD3A label=ScriptRoutine_ThingUpstairsChase_RestoreReturnDown
  $BD3A,$01 Restore #REGaf from the stack.
  $BD3B,$01 Return.

c $BD3C Update Thing Upstairs Movement
@ $BD3C label=Update_ThingUpstairs_Movement
D $BD3C Move the Thing Upstairs entity toward Berk within its room bounds and
. queue a chase sound when it closes in.
R $BD3C IX Address of complex state data for an entity
  $BD3C,$02 Load #REGa with #N$0A.
  $BD3E,$03 Call #R$EAE5 to pick a pseudo-random value.
  $BD41,$02 Add #N$05 to #REGa (adjust an entity/timer value).
  $BD43,$03 Set Thing Upstairs flag byte (#R$BBDF).
  $BD46,$02 Load #REGa with #N$02.
  $BD48,$03 Call #R$EAE5 to pick a pseudo-random value.
  $BD4B,$01 Advance #N$02 by one.
  $BD4C,$02 Multiply #REGa by #N$04 to form a table index.
  $BD4E,$01 Keep #N$02 in #REGc for later.
  $BD4F,$02 Load #REGa with #N$04.
  $BD51,$03 Call #R$EAE5 to pick a pseudo-random value.
  $BD54,$01 Advance #N$04 by one.
  $BD55,$04 Is #N$04 less than #N$03? If not, jump to #R$BD5D.
  $BD59,$01 Merge another flag byte into #N$04.
  $BD5A,$01 Copy the saved count/flag from #REGc into #REGa.
  $BD5B,$02 Jump to #R$BD6E to store the Thing Upstairs direction.
N $BD5D Steer toward Berk on X: face right if aligned, else face left.
@ $BD5D label=Update_ThingUpstairs_Movement_TrackBerkX
  $BD5D,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $BD60,$01 Keep Berk's X-coordinate copy in #REGb for later.
  $BD61,$03 Load #REGa with the current entity's x-coordinate.
  $BD64,$03 Does this entity's x equal #REGb? If not, jump to #R$BD6B.
  $BD67,$02 Set bit #N$00 of the saved flags in #REGc.
  $BD69,$02 Jump to #R$BD6D to keep the Thing Upstairs direction flags.
N $BD6B Face left when the Thing Upstairs entity's X does not match Berk's copy
. at #R$7303.
@ $BD6B label=Update_ThingUpstairs_Movement_FaceRight
  $BD6B,$02 Set bit #N$01 of the saved flags in #REGc.
N $BD6D Commit the chosen chase direction flags into #REGa.
@ $BD6D label=Update_ThingUpstairs_Movement_WriteDirection
  $BD6D,$01 Copy the saved count/flag from #REGc into #REGa.
N $BD6E Store the chase direction/state back onto the Thing Upstairs entity.
@ $BD6E label=Update_ThingUpstairs_Movement_StoreState
  $BD6E,$03 Set the current entity's direction / state.
  $BD71,$01 Return.

c $BD72 Test Thing Upstairs Overlap
@ $BD72 label=Test_ThingUpstairs_Overlap
D $BD72 Return #N$01 in #REGa when the Thing Upstairs entity overlaps Berk on X
. (#R$7303 / #R$7304) and the camera-follow entity (#R$909B) on Y while
. Berk's room copy is #N$00. Otherwise return #N$00.
R $BD72 IX Address of the Thing Upstairs entity's complex state data
N $BD72 Horizontal overlap against Berk's X / X-extent copies.
  $BD72,$03 Load Berk's X-extent copy (#R$7304) into #REGa.
  $BD75,$01 Step that right edge back by one.
  $BD76,$04 Is Berk's right edge left of the Thing Upstairs entity's left edge
. (#REGix+#N$07)? If so, no overlap, so return.
  $BD7A,$03 Load Berk's X-coordinate copy (#R$7303) into #REGa.
  $BD7D,$04 Is Berk's left edge at or beyond the Thing Upstairs entity's right
. edge (#REGix+#N$08)? If so, no overlap, so return.
N $BD81 Vertical overlap against the camera-follow entity.
  $BD81,$03 Load the Thing Upstairs entity's y-extent (bottom edge) into #REGa.
  $BD84,$04 Point #REGiy at the camera-follow entity (#R$909B).
  $BD88,$03 Load the camera-follow entity's y-extent into #REGc.
  $BD8B,$04 Is the Thing Upstairs entity's bottom above the camera-follow
. entity's top (#REGiy+#N$05)? If so, no overlap, so return.
  $BD8F,$03 Load the Thing Upstairs entity's y-coordinate (top edge) into #REGa.
  $BD92,$02 Advance that top edge by two.
  $BD94,$02 Is that raised top at or below the camera-follow entity's bottom in
. #REGc? If so, no overlap, so return.
N $BD96 Accept only when Berk's room copy is #N$00.
  $BD96,$03 Load Berk's room-index copy (#R$7305) into #REGa.
  $BD99,$03 Is Berk in room #N$00? If not, jump to #R$BD9E.
  $BD9C,$01 Set #REGa to #N$01 as a successful overlap result.
  $BD9D,$01 Return.
N $BD9E No Thing Upstairs overlap (wrong room or miss): return #N$00 in #REGa.
@ $BD9E label=Test_ThingUpstairs_Overlap_NoMatch
  $BD9E,$01 Clear #REGa as a false / no-match result.
  $BD9F,$01 Return.
N $BDA0 Entry from #R$BC12 when slot #N$20 is not Thing Upstairs: maybe arm the
. Thing Upstairs script/sound.
@ $BDA0 label=Update_ThingUpstairs_Entity_ArmSpawn
  $BDA0,$03 Load #REGa with the game event flags (#R$72B3).
  $BDA3,$03 Is "trap door is open / trap door event armed" (bit #N$01 of
. #R$72B3) set? If not, return.
  $BDA6,$02 Load #REGa with random maximum #N$3C.
  $BDA8,$03 Call #R$EAE5 to pick a pseudo-random value.
  $BDAB,$02 Is that random value zero? If not, return.
N $BDAD #HTML(#AUDIO0(game-event.wav)(#INCLUDE(GameEvent)))
  $BDAD,$02 Load #REGa with #N$88.
  $BDAF,$03 Call #R$F8F9 to queue a sound effect.
  $BDB2,$03 Point #REGhl at the game event flags (#R$72B3).
  $BDB5,$02 Set "task-two / upstairs event latch" (bit #N$04 of #R$72B3).
  $BDB7,$03 Point #REGhl at the Thing Upstairs script (#R$BBE0).
  $BDBA,$03 Store #REGhl in #R$72D9.
  $BDBD,$02 Load #REGa with #N$22.
  $BDBF,$03 Store #REGa in complex entity slot #N$20's type (#R$9001).
  $BDC2,$01 Return.

b $BDC3 Graphic Layout: Ghost
@ $BDC3 label=GraphicLayout_Ghost
D $BDC3 Ghost. Complex entity slot #N$20 at #R$9001 uses this layout when
. armed. Scripts at #R$BBE0 load #R$BDC3. #R$BBFC loads the BOO layout
. at #R$BDD0. The entry sets graphic set #N$04 then cycles #R$BDE8 and
. #R$BE03.
N $BDC3 Ghost entry cycling #R$BDE8 and #R$BE03.
N $BDC3 #UDGTABLE {
. #LAYOUT$E8,$BD,$00,$04(*ghost-bde8)
. #LAYOUT$03,$BE,$00,$04(*ghost-be03)
. #FRAMES(ghost-bde8,16;ghost-be03)({ScreenshotImagePath}/layout-bdc3)
. } UDGTABLE#
B $BDC3,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $BDC5,$09,$09 Increment the index and jump to one of #R$BDE8, #R$BE03,
. #R$BDE8.
B $BDCE,$02
N $BDD0 BOO.
N $BDD0 #UDGTABLE { #LAYOUT$D0,$BD(layout-bdd0) } UDGTABLE#
@ $BDD0 label=GraphicLayout_GhostBoo
B $BDD0,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $BDD2,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $BDD5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDD8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDDB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDDE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDE1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDE4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDE7,$01 Load the stored coordinates and return.
N $BDE8 Ghost frame #N$01.
N $BDE8 #UDGTABLE { #LAYOUT$E8,$BD,$00,$04(layout-bde8) } UDGTABLE#
@ $BDE8 label=GraphicLayout_GhostFrame1
B $BDE8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $BDEB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDEE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDF1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDF4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDF7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDFA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BDFD,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $BE00,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $BE03 Ghost frame #N$02.
N $BE03 #UDGTABLE { #LAYOUT$03,$BE,$00,$04(layout-be03) } UDGTABLE#
@ $BE03 label=GraphicLayout_GhostFrame2
B $BE03,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $BE06,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE09,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE0C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE0F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE12,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE15,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE18,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
N $BE1B Ghost body.
N $BE1B #UDGTABLE { #LAYOUT$1B,$BE,$00,$04(layout-be1b) } UDGTABLE#
@ $BE1B label=GraphicLayout_GhostBody
B $BE1B,$05 Set the next graphic index from a random list.
B $BE20,$03 Draw a random tile from the list at #R$BE1B with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE23,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE35,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE38,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE3B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE3E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE41,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE44,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE47,$0B,$0B Increment the index and jump to one of #R$BE52, #R$BE59,
. #R$BE52, #R$BE63.
N $BE52 Ghost tail pointing down.
N $BE52 #UDGTABLE { #LAYOUT$52,$BE,$00,$04(layout-be52) } UDGTABLE#
@ $BE52 label=GraphicLayout_GhostTailDown
B $BE52,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE55,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE58,$01 Load the stored coordinates and return.
N $BE59 Ghost tail pointing left.
N $BE59 #UDGTABLE { #LAYOUT$59,$BE,$00,$04(layout-be59) } UDGTABLE#
@ $BE59 label=GraphicLayout_GhostTailLeft
B $BE59,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE5C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE5F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE62,$01 Load the stored coordinates and return.
N $BE63 Ghost tail pointing right.
N $BE63 #UDGTABLE { #LAYOUT$63,$BE,$00,$04(layout-be63) } UDGTABLE#
@ $BE63 label=GraphicLayout_GhostTailRight
B $BE63,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE66,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE69,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $BE6C,$01 Load the stored coordinates and return.
b $BE6D Data: Bird Scripts
@ $BE6D label=Data_BirdScripts
D $BE6D Bird scripts that drive the bird laying an egg. #R$BF38 starts here.
. Other readers enter at #R$BE79, #R$BE81, #R$BE89, #R$BE91, #R$BEB9 and
. #R$BEC1. #R$BF68 pokes the wander loop count at #R$BE9B. Ends immediately
. before #R$BECD.
N $BE6D Start script published by #R$BF2B and #R$BF38.
N $BE6D #UDGTABLE { #SCRIPTANIM$BE6D(script-be6d) } UDGTABLE#
  $BE6D,$02 Graphic-layout pointer #R$C102.
W $BE6F,$02 Script opcode #N$21 (start counted script loop).
  $BE71,$02 Loop count #N$09 (#R$EC53 reads only the low byte).
  $BE73,$02 Graphic-layout pointer #R$C102.
W $BE75,$02 Script opcode #N$22 (end script loop).
W $BE77,$02 Script opcode #N$28 (arm the bird script-active flags).
N $BE79 Rise and vertical-walk loop entered from #R$BFE4.
@ $BE79 label=BirdScript_RiseLoop
  $BE79,$02 Graphic-layout pointer #R$C102.
W $BE7B,$02 Script opcode #N$24 (walk the bird vertically).
W $BE7D,$02 Script opcode #N$01 (jump to script address).
W $BE7F,$02 Jump to script address #R$BE79.
N $BE81 Idle and horizontal-walk loop entered from #R$BFB9 and #R$BFFA.
@ $BE81 label=BirdScript_IdleLoop
  $BE81,$02 Graphic-layout pointer #R$C102.
W $BE83,$02 Script opcode #N$26 (walk the bird horizontally).
W $BE85,$02 Script opcode #N$01 (jump to script address).
W $BE87,$02 Jump to script address #R$BE81.
N $BE89 Turn-around and walk-right loop entered from #R$C021.
@ $BE89 label=BirdScript_TurnLoop
  $BE89,$02 Graphic-layout pointer #R$C102.
W $BE8B,$02 Script opcode #N$25 (walk the bird right).
W $BE8D,$02 Script opcode #N$01 (jump to script address).
W $BE8F,$02 Jump to script address #R$BE89.
N $BE91 Wander script entered from #R$BF6B. #R$BF68 rewrites #R$BE9B.
@ $BE91 label=BirdScript_Wander
W $BE91,$02 Script opcode #N$21 (start counted script loop).
  $BE93,$02 Loop count #N$14 (#R$EC53 reads only the low byte).
  $BE95,$02 Graphic-layout pointer #R$C12F.
W $BE97,$02 Script opcode #N$22 (end script loop).
W $BE99,$02 Script opcode #N$21 (start counted script loop).
  $BE9B,$02 Loop count #N$12 (rewritten by #R$BF68). #R$EC53 reads the low
. byte.
  $BE9D,$02 Graphic-layout pointer #R$C12F.
W $BE9F,$02 Script opcode #N$25 (walk the bird right).
W $BEA1,$02 Script opcode #N$22 (end script loop).
W $BEA3,$02 Script opcode #N$21 (start counted script loop).
  $BEA5,$02 Loop count #N$28 (#R$EC53 reads only the low byte).
  $BEA7,$02 Graphic-layout pointer #R$C119.
W $BEA9,$02 Script opcode #N$22 (end script loop).
W $BEAB,$02 Script opcode #N$21 (start counted script loop).
  $BEAD,$02 Loop count #N$0A (#R$EC53 reads only the low byte).
  $BEAF,$02 Graphic-layout pointer #R$C124.
W $BEB1,$02 Script opcode #N$22 (end script loop).
W $BEB3,$02 Script opcode #N$27 (spawn or refresh the bird helper).
W $BEB5,$02 Script opcode #N$01 (jump to script address).
W $BEB7,$02 Jump to script address #R$BE81.
N $BEB9 Bound and rise-on-event loop entered from #R$BFB3 and #R$C01B.
@ $BEB9 label=BirdScript_BoundLoop
  $BEB9,$02 Graphic-layout pointer #R$C102.
W $BEBB,$02 Script opcode #N$29 (raise the bird on its event bit).
W $BEBD,$02 Script opcode #N$01 (jump to script address).
W $BEBF,$02 Jump to script address #R$BEB9.
N $BEC1 Alternate wander script entered from #R$BF71.
@ $BEC1 label=BirdScript_AltWander
W $BEC1,$02 Script opcode #N$21 (start counted script loop).
  $BEC3,$02 Loop count #N$10 (#R$EC53 reads only the low byte).
  $BEC5,$02 Graphic-layout pointer #R$C12F.
W $BEC7,$02 Script opcode #N$22 (end script loop).
W $BEC9,$02 Script opcode #N$01 (jump to script address).
W $BECB,$02 Jump to script address #R$BE89.

c $BECD Update Task Two Entities
@ $BECD label=Update_Task_Two_Entities
D $BECD Once per frame for the "Thing Upstairs" task: refresh helpers, and
. when the task phase is #N$02 advance the task-two script at #R$72D5.
  $BECD,$03 Call #R$C095 to update the task helper entities.
  $BED0,$03 Fetch the current task phase (#R$72AF).
  $BED3,$03 Is the phase "run task-two scripts" (#N$02)? If not, return.
  $BED6,$03 Load the task-two script position (#R$72D5).
  $BED9,$03 Copy it into the active script cursor (#R$72CF).
  $BEDC,$03 Call #R$BEE6 to advance that script / entity state.
  $BEDF,$03 Reload the (possibly updated) temporary script pointer.
  $BEE2,$03 Write it back to the task-two script position (#R$72D5).
  $BEE5,$01 Return.

c $BEE6 Update Task Two Entity State
@ $BEE6 label=Update_TaskTwoEntityState
D $BEE6 Restore the upstairs helper if needed, then either start/stop its
. script from the game event flags or pick the next wandering script.
  $BEE6,$03 Point #REGhl at the task-two flags (#R$72B5).
  $BEE9,$03 Fetch the current task index (#R$72AE).
  $BEEC,$04 Is task two itself active (index #N$02)? If so, skip the spawn latch
. at #R$BEF6.
  $BEF0,$04 Is the task-two "advance script" bit already set (bit #N$01)? If so,
. skip the spawn latch.
  $BEF4,$02 Otherwise arm the spawn / random-walk latch (set bit #N$02).
N $BEF6 Handle helper restore: rewrite the upstairs helper layout when bit #N$03
. is set.
@ $BEF6 label=Update_TaskTwo_CheckHelperRestore
  $BEF6,$04 Does the helper need its layout restoring (bit #N$03)? If not,
. select the entity at #R$BF07.
  $BEFA,$02 Clear the restore latch.
  $BEFC,$03 Point #REGhl at spawned-helper layout #R$9DB3.
  $BEFF,$03 Write that layout into the helper's record (#R$8EF3(#N$8FE1)).
  $BF02,$03 Point #REGhl at the spawned-helper entity (#R$8FD7).
  $BF05,$02 Mark that helper active (set bit #N$07 of its type/flags byte).
N $BF07 Handle start/stop: use game event flags to run or halt the upstairs
. helper script.
@ $BF07 label=Update_TaskTwo_SelectEntity
  $BF07,$04 Point #REGix at the upstairs helper entity (#R$8FE5).
  $BF0B,$03 Keep the temporary script pointer in #REGhl (#R$72CF).
  $BF0E,$03 Fetch the game event flags (#R$72B3).
  $BF11,$04 Is a task entity script marked active (bit #N$07)? If not, take the
. wander branch at #R$BF50.
  $BF15,$06 Is this helper already running (bit #N$07 of its type)? If not,
. decide whether to stop it at #R$BF21.
  $BF1B,$04 Is the trap door open (game event bit #N$01)? If so, (re)start the
. helper at #R$BF2B.
  $BF1F,$02 Otherwise wander at #R$BF50.
N $BF21 Stop the upstairs helper when the trap is open but the helper was not
. running.
@ $BF21 label=Update_TaskTwo_StopEntity
  $BF21,$03 Is the trap door open? If not, leave the helper alone and return.
  $BF24,$04 Clear the helper's "running" type bit.
  $BF28,$03 Advance its current script at #R$EC2E.
N $BF2B Start the upstairs helper: clear the task latch and publish script
. #R$BE6D.
@ $BF2B label=Update_TaskTwo_StartEntity
  $BF2B,$04 Mark the helper running (set bit #N$07 of its type).
  $BF2F,$03 Point #REGhl at the game event flags (#R$72B3).
  $BF32,$02 Clear "task entity script active" (bit #N$07).
  $BF34,$01 Clear #REGa so the task phase can reset.
  $BF35,$03 Clear the current task phase (#R$72AF).
  $BF38,$03 Point #REGhl at the bird scripts (#R$BE6D).
  $BF3B,$03 Publish it through the active script cursor (#R$72CF).
  $BF3E,$01 Return.
N $BF3F Shared entry used by script routine #R$BFBF when the helper reaches
. column #N$27: clear the upstairs event latch and restart.
@ $BF3F label=Update_TaskTwo_ClearTrapFlags
  $BF3F,$03 Point #REGhl at the game event flags (#R$72B3).
  $BF42,$02 Clear the task-two / upstairs event latch (bit #N$04).
  $BF44,$02 Load a fresh game-tick delay of #N$28 frames.
  $BF46,$03 Store it in the game tick counter (#R$72F2).
  $BF49,$03 Point #REGhl at the task-two flags (#R$72B5).
  $BF4C,$02 Clear the spawn / random-walk latch (bit #N$02).
  $BF4E,$02 Restart the helper at #R$BF2B.
N $BF50 Handle wander: pick the next bird script when no start/stop event is
. pending.
@ $BF50 label=Update_TaskTwo_ScriptBranch
  $BF50,$03 Fetch the task-two flags (#R$72B5).
  $BF53,$05 Is "advance script" still set (bit #N$01)? If so, just step the
. current script at #R$EC2E.
  $BF58,$02 Clear that advance bit.
  $BF5A,$03 Write the updated task-two flags back.
  $BF5D,$04 Is the spawn / random-walk latch set (bit #N$02)? If not, use the
. alternate script at #R$BF71.
  $BF61,$02 Load random range base #N$18 for a wander destination.
  $BF63,$03 Call #R$EAE5 to pick a pseudo-random value.
  $BF66,$02 Bias it into the bird script table (#N$16+#REGa).
  $BF68,$03 Poke that index into task-two storage at #R$BE9B.
  $BF6B,$03 Point #REGhl at the wander script (#R$BE91).
  $BF6E,$03 Run it via #R$EC30.
N $BF71 Wander without the spawn latch: run the alternate bird script
. (#R$BEC1).
@ $BF71 label=Update_TaskTwo_AltScript
  $BF71,$03 Point #REGhl at the alternate bird script (#R$BEC1).
  $BF74,$03 Run it via #R$EC30.

c $BF77 Script Routine: (#N$28) Task-two entity action
@ $BF77 label=ScriptRoutine_TaskTwoArmScriptFlags
D $BF77 Mark the bird script as active so later task-two steps can run.
  $BF77,$01 Stash #REGhl on the stack.
  $BF78,$03 Point #REGhl at the game event flags (#R$72B3).
  $BF7B,$02 Set "task entity script is active" (bit #N$07 of #R$72B3).
  $BF7D,$02 Set "task-two / upstairs event latch" (bit #N$04 of #R$72B3).
  $BF7F,$03 Load #REGa with the entity spawn timer (#R$72C0).
  $BF82,$04 Is entity spawn timer equal to #N$04? If not, jump to #R$BF8B.
  $BF86,$03 Point #REGhl at the task-two flags (#R$72B5).
  $BF89,$02 Set "spawn / random-walk latch" (bit #N$02 of #R$72B5).
N $BF8B Flags armed: restore #REGhl and continue at the next script instruction.
@ $BF8B label=ScriptRoutine_TaskTwoArmScriptFlags_NextInstruction
  $BF8B,$01 Restore #REGhl from the stack.
  $BF8C,$03 Jump to #R$EC2E to run the next script instruction.

c $BF8F Script Routine: (#N$24) Task-two entity action
@ $BF8F label=ScriptRoutine_TaskTwoWalkVertical
D $BF8F Step the task-two entity one character vertically along its walk.
R $BF8F IX Address of complex state data for an entity
  $BF8F,$03 Load #REGa with the current entity's y-coordinate.
  $BF92,$01 Step the current entity's y-coordinate back by one.
  $BF93,$04 Is the current entity's y-coordinate equal to #N$15? If so, jump to
. #R$BFAC.
  $BF97,$04 Is the current entity's y-coordinate equal to #N$1B? If not, jump to
. #R$BFA3.
  $BF9B,$03 Load #REGa with the game event flags (#R$72B3).
  $BF9E,$02 Clear bit #N$04 of the flag byte in #REGa.
  $BFA0,$03 Set the game event flags (#R$72B3).
N $BFA3 Keep walking the task-two entity one row up, then continue the script.
@ $BFA3 label=ScriptRoutine_TaskTwoWalkVertical_DecY
  $BFA3,$06 Move this entity one character up.
  $BFA9,$03 Jump to #R$EC2E to run the next script instruction.
N $BFAC At y #N$15: run bound script #R$BEB9 if the spawn latch is set, else
. idle.
@ $BFAC label=ScriptRoutine_TaskTwoWalkVertical_AtY15
  $BFAC,$03 Load #REGa with the task-two flags (#R$72B5).
  $BFAF,$04 Is bit #N$02 of task-two flags set? If not, jump to #R$BFB9.
  $BFB3,$03 Point #REGhl at bird script data #R$BEB9.
  $BFB6,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $BFB9 Vertical walk finished: run the task-two idle script (#R$BE81).
@ $BFB9 label=ScriptRoutine_TaskTwoWalkVertical_RunIdleScript
  $BFB9,$03 Point #REGhl at bird script data #R$BE81.
  $BFBC,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $BFBF Script Routine: (#N$29) Task-two entity action
@ $BFBF label=ScriptRoutine_TaskTwoRiseOnEvent
D $BFBF Lift the task-two entity when its matching game-event bit is set.
R $BFBF IX Address of complex state data for an entity
  $BFBF,$03 Load #REGa with the game event flags (#R$72B3).
  $BFC2,$04 Is bit #N$01 of game event flags set? If not, jump to #R$BFE4.
  $BFC6,$03 Load #REGa with the current entity's y-coordinate.
  $BFC9,$01 Advance the current entity's y-coordinate by one.
  $BFCA,$05 Is the current entity's y-coordinate equal to #N$27? If so, jump to
. #R$BF3F.
  $BFCF,$04 Is the current entity's y-coordinate equal to #N$1B? If not, jump to
. #R$BFDB.
  $BFD3,$03 Load #REGa with the game event flags (#R$72B3).
  $BFD6,$02 Set bit #N$04 of game event flags.
  $BFD8,$03 Set the game event flags (#R$72B3).
N $BFDB Keep lowering the rising helper one row, then continue the script.
@ $BFDB label=ScriptRoutine_TaskTwoRiseOnEvent_IncY
  $BFDB,$06 Move this entity one character down.
  $BFE1,$03 Jump to #R$EC2E to run the next script instruction.
N $BFE4 Trap closed: restart the rise routine from script #R$BE79.
@ $BFE4 label=ScriptRoutine_TaskTwoRiseOnEvent_RunStartScript
  $BFE4,$03 Point #REGhl at bird script data #R$BE79.
  $BFE7,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $BFEA Script Routine: (#N$25) Task-two entity action
@ $BFEA label=ScriptRoutine_TaskTwoWalkRight
D $BFEA Walk the task-two entity right while its x-extent stays inside the
. allowed band.
R $BFEA IX Address of complex state data for an entity
  $BFEA,$03 Load #REGa with the current entity's x-extent.
  $BFED,$04 Is the current entity's x-extent less than #N$98? If not, jump to
. #R$BFFA.
  $BFF1,$06 Move this entity one character right.
  $BFF7,$03 Jump to #R$EC2E to run the next script instruction.
N $BFFA Right-walk finished at X-extent #N$98: run idle script #R$BE81.
@ $BFFA label=ScriptRoutine_TaskTwoWalkRight_RunIdleScript
  $BFFA,$03 Point #REGhl at bird script data #R$BE81.
  $BFFD,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $C000 Script Routine: (#N$26) Task-two entity action
@ $C000 label=ScriptRoutine_TaskTwoWalkHorizontal
D $C000 Walk the task-two entity left or right according to the task-two flags.
R $C000 IX Address of complex state data for an entity
  $C000,$03 Load #REGa with the task-two flags (#R$72B5).
  $C003,$02 Test bit #N$02 of task-two flags.
  $C005,$03 Load #REGa with the current entity's x-coordinate.
  $C008,$02 Jump to #R$C00E to continue if the comparison matched.
  $C00A,$04 Is the current entity's x-coordinate equal to #N$6E? If so, jump to
. #R$C01B.
N $C00E Walk left while above X #N$63; otherwise turn via #R$C021.
@ $C00E label=ScriptRoutine_TaskTwoWalkHorizontal_WalkLeftOrBound
  $C00E,$04 Is the current entity's x-coordinate less than #N$63? If so, jump to
. #R$C021.
  $C012,$06 Move this entity one character left.
  $C018,$03 Jump to #R$EC2E to run the next script instruction.
N $C01B Hit the right bound (X #N$6E): run bound script #R$BEB9.
@ $C01B label=ScriptRoutine_TaskTwoWalkHorizontal_RunBoundScript
  $C01B,$03 Point #REGhl at bird script data #R$BEB9.
  $C01E,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C021 Hit the left bound: run the turn-around script (#R$BE89).
@ $C021 label=ScriptRoutine_TaskTwoWalkHorizontal_RunTurnScript
  $C021,$03 Point #REGhl at bird script data #R$BE89.
  $C024,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $C027 Script Routine: (#N$27) Task-two entity action
@ $C027 label=ScriptRoutine_TaskTwoSpawnHelper
D $C027 Spawn or refresh a helper entity from the current task-two state.
R $C027 IX Address of complex state data for an entity
  $C027,$03 Load #REGa with the current entity's room index.
  $C02A,$03 Load #REGb with the current entity's y-extent.
  $C02D,$03 Load #REGc with the current entity's x-coordinate.
  $C030,$04 Point #REGiy at the spawned-helper entity (#R$8FD7).
  $C034,$04 Write #N$06 to the referenced entity's entity type.
  $C038,$03 Set the referenced entity's room index.
  $C03B,$01 Advance the helper's x-coordinate in #REGc by one.
  $C03C,$03 Store #REGc in the referenced entity's x-coordinate.
  $C03F,$01 Advance the helper's x-extent base in #REGc by one.
  $C040,$03 Store #REGc in the referenced entity's x-extent.
  $C043,$01 Step the Y value in #REGb on by one.
  $C044,$03 Store #REGb in the referenced entity's y-coordinate.
  $C047,$01 Step the Y value in #REGb on by one.
  $C048,$03 Store #REGb in the referenced entity's y-extent.
  $C04B,$04 Set bit #N$07 of the referenced entity's flags byte 1.
  $C04F,$03 Load #REGa with the game event flags (#R$72B3).
  $C052,$02 Set bit #N$00 of game event flags.
  $C054,$03 Set the game event flags (#R$72B3).
  $C057,$03 Load #REGa with the entity spawn timer (#R$72C0).
  $C05A,$01 Advance entity spawn timer by one.
  $C05B,$03 Set the entity spawn timer (#R$72C0).
  $C05E,$05 Is entity spawn timer equal to #N$04? If not, jump to #R$EC2E.
  $C063,$03 Load #REGa with the task-two flags (#R$72B5).
  $C066,$02 Set bit #N$02 of task-two flags.
  $C068,$03 Set the task-two flags (#R$72B5).
  $C06B,$03 Jump to #R$EC2E to run the next script instruction.

c $C06E Spawn Task Entity
@ $C06E label=Spawn_Task_Entity
D $C06E Spawn Task Entity for the current Thing Upstairs task.
N $C06E Spawns a pan into a free complex-entity slot.
  $C06E,$01 Stash #REGhl on the stack.
  $C06F,$04 Point #REGiy at the pan entity (#R$9055).
  $C073,$04 Set bit #N$07 of the referenced entity's flags byte 2.
  $C077,$03 Point #REGhl at the task-two flags (#R$72B5).
  $C07A,$02 Clear bit #N$04 of #R$72B5 (also set at #R$C0D2. no BIT reader
. found).
  $C07C,$02 Clear bit #N$05 of #R$72B5 (also set at #R$C0D4 / cleared at
. #R$C0F1. no BIT reader found).
  $C07E,$02 Set bit #N$07 of #R$72B5.
  $C080,$03 Load #REGa with the room-transition flag (#R$72BF).
  $C083,$01 Advance room-transition flag by one.
  $C084,$03 Set the room-transition flag (#R$72BF).
  $C087,$04 Is room-transition flag equal to #N$04? If not, jump to #R$C08D.
  $C08B,$02 Set bit #N$06 of #R$72B5 (written here when #R$72BF reaches #N$04 no
. BIT reader found).
N $C08D Point the helper entity at layout #R$9E07 after arming spawn flags.
@ $C08D label=Spawn_Task_Entity_PanLayout
  $C08D,$03 Point #REGhl at the pan layout #R$9E07.
  $C090,$03 Write the layout pointer into the helper entity's layout field
. (#R$8EF3(#N$905F)).
  $C093,$01 Restore #REGhl from the stack.
  $C094,$01 Return.

c $C095 Update Task Helper Entities
@ $C095 label=Update_Task_Helper_Entities
D $C095 Update Task Helper Entities for the current Thing Upstairs task.
  $C095,$03 Load #REGa with the pan entity's type (#R$9055).
  $C098,$02 Is #REGa zero? If so, return.
  $C09A,$03 Load #REGa with the room-transition flag (#R$72BF).
  $C09D,$02 Is room-transition flag zero? If so, return.
  $C09F,$01 Keep room-transition flag in #REGe for later.
  $C0A0,$04 Point #REGix at the pan entity (#R$9055).
  $C0A4,$03 Point #REGhl at the task-two flags (#R$72B5).
  $C0A7,$03 Load #REGa with the current entity's x-coordinate.
  $C0AA,$04 Is the current entity's x-coordinate equal to #N$84? If not, jump to
. #R$C0DD.
  $C0AE,$03 Load #REGa with the current entity's y-coordinate.
  $C0B1,$04 Is the current entity's y-coordinate equal to #N$20? If not, jump to
. #R$C0DD.
  $C0B5,$03 Load #REGa with the stove / heater state (#R$72C4).
  $C0B8,$03 Is stove / heater state equal to #N$FF? If so, return.
  $C0BB,$01 Advance stove / heater state by one.
  $C0BC,$03 Set the stove / heater state (#R$72C4).
  $C0BF,$04 Is stove / heater state equal to #N$32? If so, jump to #R$C0CF.
  $C0C3,$03 Is stove / heater state less than #N$C8? If so, return.
  $C0C6,$04 Set bit #N$03 of the current entity's flags byte 2.
  $C0CA,$03 Point #REGhl at the hot pan layout (#R$9DD8).
  $C0CD,$02 Jump to #R$C0D9 to write the pan layout pointer.
N $C0CF Heater reached #N$32: set task-two layout bits #N$04/#N$05 on #R$72B5.
@ $C0CF label=Update_Task_Helper_Entities_SetLayoutBit
  $C0CF,$01 Copy the saved low byte from #REGe into #REGa.
  $C0D0,$02 Is the saved room-transition flag in #REGa zero? If so, return.
  $C0D2,$02 Set bit #N$04 of #R$72B5.
  $C0D4,$02 Set bit #N$05 of #R$72B5 (cleared by #R$C07C / #R$C0F1. no BIT
. reader found).
N $C0D6 Select the pan cooking layout #R$9DE3.
@ $C0D6 label=Update_Task_Helper_Entities_PanCookingLayout
  $C0D6,$03 Point #REGhl at the pan cooking layout (#R$9DE3).
N $C0D9 Write the chosen pan layout pointer into the pan entity at
. #R$8EF3(#N$905F).
@ $C0D9 label=Update_Task_Helper_Entities_WritePanLayout
  $C0D9,$03 Write the layout pointer into the pan entity's layout field
. (#R$8EF3(#N$905F)).
  $C0DC,$01 Return.
N $C0DD Countdown the stove/heater state (#R$72C4) and refresh pan layouts on
. thresholds.
@ $C0DD label=Update_Task_Helper_Entities_Countdown
  $C0DD,$03 Load #REGa with the stove / heater state (#R$72C4).
  $C0E0,$02 Is stove / heater state zero? If so, return.
  $C0E2,$01 Step stove / heater state back by one.
  $C0E3,$03 Set the stove / heater state (#R$72C4).
  $C0E6,$04 Is stove / heater state equal to #N$C8? If so, jump to #R$C0F5.
  $C0EA,$03 Is stove / heater state equal to #N$32? If not, return.
  $C0ED,$01 Copy the saved low byte from #REGe into #REGa.
  $C0EE,$03 Is the saved room-transition flag zero? If so, jump to #R$C0FD.
  $C0F1,$02 Clear bit #N$05 of #R$72B5.
  $C0F3,$02 Jump to #R$C0FD to finish the pan update.
N $C0F5 Clear the pan entity's bit #N($03), then restore layout #R$9DE3 or
. #R$9E07.
@ $C0F5 label=Update_Task_Helper_Entities_ClearFlagBit3
  $C0F5,$04 Reset bit #N$03 of the current entity's flags byte 2.
  $C0F9,$01 Copy the saved low byte from #REGe into #REGa.
  $C0FA,$03 Is the saved room-transition flag zero? If not, jump to #R$C0D6.
N $C0FD Default pan layout: point at #R$9E07 and write it through #R$C0D9.
@ $C0FD label=Update_Task_Helper_Entities_PanLayout
  $C0FD,$03 Point #REGhl at the pan layout #R$9E07.
  $C100,$02 Jump to #R$C0D9 to write the pan layout pointer.

b $C102 Data: Task Helper Layouts
@ $C102 label=Data_TaskHelperLayouts
D $C102 Graphic layout data for task helpers (#R$C102 layout for #R$8FE5).
B $C102,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C104,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C107,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C10A,$0F,$0F Jump to a time-weighted random layout address (#R$C145,
. #R$C175, #R$C197).
B $C119,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C11B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C11E,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C121,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C124,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C126,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C129,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C12C,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C12F,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C131,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C134,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C137,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $C13A #UDGTABLE { #LAYOUT$3A,$C1,$00,$04(layout-c13a) } UDGTABLE#
B $C13A,$0B,$0B Increment the index and jump to one of #R$C1B9, #R$C1D8,
. #R$C1FD, #R$C222.
N $C145 #UDGTABLE { #LAYOUT$45,$C1,$00,$04(layout-c145) } UDGTABLE#
B $C145,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C148,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C14B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C14E,$0B,$0B Jump to a time-weighted random layout address (#R$C159,
. #R$C162).
N $C159 #UDGTABLE { #LAYOUT$59,$C1,$00,$04(layout-c159) } UDGTABLE#
B $C159,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C15C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C15F,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $C162 #UDGTABLE { #LAYOUT$62,$C1,$00,$04(layout-c162) } UDGTABLE#
B $C162,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C165,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
N $C168 #UDGTABLE { #LAYOUT$68,$C1,$00,$04(layout-c168) } UDGTABLE#
B $C168,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C16B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C16E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C171,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C174,$01 Load the stored coordinates and return.
N $C175 #UDGTABLE { #LAYOUT$75,$C1,$00,$04(layout-c175) } UDGTABLE#
B $C175,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C178,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C17B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C17E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C181,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C184,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C187,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C18A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C18D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C190,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C193,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C196,$01 Load the stored coordinates and return.
N $C197 #UDGTABLE { #LAYOUT$97,$C1,$00,$04(layout-c197) } UDGTABLE#
B $C197,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C19A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C19D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1A0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1A3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1A6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1A9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1AC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1AF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1B2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1B5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1B8,$01 Load the stored coordinates and return.
N $C1B9 #UDGTABLE { #LAYOUT$B9,$C1,$00,$04(layout-c1b9) } UDGTABLE#
B $C1B9,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C1BC,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C1BF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1C2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1C5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1C8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1CB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1D1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1D4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1D7,$01 Load the stored coordinates and return.
N $C1D8 #UDGTABLE { #LAYOUT$D8,$C1,$00,$04(layout-c1d8) } UDGTABLE#
B $C1D8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C1DB,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C1DE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1E1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1E4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1E7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1EA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1ED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1F0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1F3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1F6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1F9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C1FC,$01 Load the stored coordinates and return.
N $C1FD #UDGTABLE { #LAYOUT$FD,$C1,$00,$04(layout-c1fd) } UDGTABLE#
B $C1FD,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C200,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C203,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C206,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C209,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C20C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C20F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C212,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C215,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C218,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C21B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C21E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C221,$01 Load the stored coordinates and return.

b $C222 Graphic Layout: Bird
@ $C222 label=GraphicLayout_Bird
D $C222 Bird. Reached from the task-helper animation at #R$C13A together with
. #R$C1B9, #R$C1D8 and #R$C1FD. Head, body and egg-laying poses continue
. at #R$C244, #R$C269, #R$C28E and #R$C2BC.
N $C222 Wings.
N $C222 #UDGTABLE { #LAYOUT$22,$C2,$00,$04(layout-c222) } UDGTABLE#
B $C222,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C225,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C228,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C22B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C22E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C231,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C234,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C237,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C23A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C23D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C240,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C243,$01 Load the stored coordinates and return.
N $C244 Head.
N $C244 #UDGTABLE { #LAYOUT$44,$C2,$00,$04(layout-c244) } UDGTABLE#
@ $C244 label=GraphicLayout_BirdHead
B $C244,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C247,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C24A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C24D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C250,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C253,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C256,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C259,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C25C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C25F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C262,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C265,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C268,$01 Load the stored coordinates and return.
N $C269 Head looking down.
N $C269 #UDGTABLE { #LAYOUT$69,$C2,$00,$04(layout-c269) } UDGTABLE#
@ $C269 label=GraphicLayout_BirdHeadLookingDown
B $C269,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C26C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C26F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C272,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C275,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C278,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C27B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C27E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C281,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C284,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C287,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C28A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C28D,$01 Load the stored coordinates and return.
N $C28E Body.
N $C28E #UDGTABLE { #LAYOUT$8E,$C2,$00,$04(layout-c28e) } UDGTABLE#
@ $C28E label=GraphicLayout_BirdBody
B $C28E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C291,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C294,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C297,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C29A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C29D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2A0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2A3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2A6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2A9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2AC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2AF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2B2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2B5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2B8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2BB,$01 Load the stored coordinates and return.
N $C2BC Body laying an egg.
N $C2BC #UDGTABLE { #LAYOUT$BC,$C2,$00,$04(layout-c2bc) } UDGTABLE#
@ $C2BC label=GraphicLayout_BirdBodyLayingEgg
B $C2BC,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C2BF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2C2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2C5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2C8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2CB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2D1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2D4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2D7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2DA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2DD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2E0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C2E3,$01 Load the stored coordinates and return.

b $C2E4 Task Three Runtime Workspace
@ $C2E4 label=TaskThree_Workspace
D $C2E4 Scratch bytes for the task-three update at #R$C378: a state byte, a
. frame divider (reloaded with #N$04), a word, and a storage byte.
  $C2E4,$01 State byte (#R$C3E5).
  $C2E5,$01 Frame divider (#R$C381).
W $C2E6,$02 Workspace word (#R$C4A7).
  $C2E8,$01 Storage byte (#R$C616).

b $C2E9 Data: Task Three Tables (continued)
@ $C2E9 label=Data_TaskThreeTables_Continued
D $C2E9 Further task-three tables after the runtime workspace.
  $C2E9,$08 Bytes: #N($C7), #N($21), #N($00), #N($0A), #N($00), #N($0E),
. #N($C7), #N$22.
  $C2F1,$08 Bytes: #N($00), #N($2A), #N($00), #N($0E), #N($C7), #N($21),
. #N($00), #N$07.
  $C2F9,$08 Bytes: #N($00), #N($0E), #N($C7), #N($2C), #N($00), #N($22),
. #N($00), #N$2D.
  $C301,$08 Bytes: #N($00), #N($0A), #N($00), #N($21), #N($00), #N($0A),
. #N($00), #N$1E.
  $C309,$08 Bytes: #N($C7), #N($22), #N($00), #N($21), #N($00), #N($0A),
. #N($00), #N$32.
  $C311,$08 Bytes: #N($C7), #N($22), #N($00), #N($0E), #N($C7), #N($2B),
. #N($00), #N$01.
  $C319,$08 Bytes: #N($00), #N($14), #N($C3), #N($0C), #N($00), #N($46),
. #N($C7), #N$2B.
  $C321,$08 Bytes: #N($00), #N($01), #N($00), #N($1C), #N($C3), #N($0B),
. #N($00), #N$52.
  $C329,$08 Bytes: #N($C7), #N($2B), #N($00), #N($01), #N($00), #N($26),
. #N($C3), #N$0E.
  $C331,$08 Bytes: #N($00), #N($0E), #N($C7), #N($2B), #N($00), #N($01),
. #N($00), #N$30.
  $C339,$08 Bytes: #N($C3), #N($0D), #N($00), #N($16), #N($C7), #N($2B),
. #N($00), #N$01.
  $C341,$08 Bytes: #N($00), #N($3A), #N($C3), #N($21), #N($00), #N($06),
. #N($00), #N$58.
  $C349,$08 Bytes: #N($C7), #N($22), #N($00), #N($30), #N($00), #N($5E),
. #N($C7), #N$2E.
  $C351,$08 Bytes: #N($00), #N($21), #N($00), #N($07), #N($00), #N($5E),
. #N($C7), #N$22.
  $C359,$08 Bytes: #N($00), #N($01), #N($00), #N($02), #N($C3), #N($21),
. #N($00), #N$06.
  $C361,$08 Bytes: #N($00), #N($4C), #N($C7), #N($22), #N($00), #N($30),
. #N($00), #N$7A.
  $C369,$08 Bytes: #N($C7), #N($2F), #N($00), #N($21), #N($00), #N($07),
. #N($00), #N$7A.
  $C371,$07 Bytes: #N($C7), #N($22), #N($00), #N($01), #N($00), #N($02),
. #N$C3.

c $C378 Update Task Three Entities
@ $C378 label=Update_Task_Three_Entities
D $C378 Once per frame while task three is active: tick the task-three
. timers, refresh the cauldron layout when the frame divider hits
. zero, and run the task-three entity state machine at #R$C3B2.
N $C378 Tick the task-three frame divider and timer.
  $C378,$03 Call #R$C65C to update the task-three helpers.
  $C37B,$03 Load #REGa with the task-three timer (#R$72C3).
  $C37E,$03 Is the task-three timer zero? If so, skip the divider at #R$C39C.
  $C381,$03 Point #REGhl at the task-three frame divider (#R$C2E5).
  $C384,$03 Decrease the frame divider. if it is still non-zero, skip to
. #R$C39C.
  $C387,$02 Reload the frame divider with #N$04.
  $C389,$04 Step the task-three timer (#R$72C3) back by one.
  $C38D,$04 Is the task-three timer less than #N$0A? If not, skip to #R$C39C.
N $C391 When the timer is in the low band, point the cauldron at layout
. #R$9F9D and clear bit #N$05 of the task-three flags.
  $C391,$03 Point #REGhl at the cauldron layout (#R$9F9D).
  $C394,$03 Write that layout into the graphic-layout field of #R$9063
. (#R$8EF3(#N$906D)).
  $C397,$03 Point #REGhl at the task-three flags (#R$72B6).
  $C39A,$02 Clear bit #N$05 of the task-three flags.
N $C39C Run the task-three entity state machine while the phase is #N$03.
@ $C39C label=Update_Task_Three_Entities_RunStateMachine
  $C39C,$03 Load #REGa with the current task phase (#R$72AF).
  $C39F,$03 Is the current task phase equal to #N$03? If not, return.
  $C3A2,$06 Copy the task-three script position (#R$72D1) into the temporary
. script-position pointer (#R$72CF).
  $C3A8,$03 Call #R$C3B2 to update the task-three entity state.
  $C3AB,$06 Write the active script cursor (#R$72CF) back to #R$72D1.
  $C3B1,$01 Return.

c $C3B2 Update Task Three Entity State
@ $C3B2 label=Update_Task_Three_Entity_State
D $C3B2 Update Task Three Entity State for the current Thing Upstairs task.
  $C3B2,$04 Point #REGix at the inactive complex slot (#R$90A9).
  $C3B6,$03 Load #REGa with the game event flags (#R$72B3).
  $C3B9,$01 Keep game event flags in #REGc for later.
  $C3BA,$05 Is bit #N$07 of the saved game-event flags in #REGc set? If so, jump
. to #R$EC2E.
  $C3BF,$03 Fetch the current entity's type for the type test.
  $C3C2,$03 Is the current entity's entity type zero? If so, jump to #R$C3CD.
  $C3C5,$05 Is bit #N$01 of the saved game-event flags in #REGc set? If so, jump
. to #R$EC2E.
  $C3CA,$03 Jump to #R$C60D.
N $C3CD Trap open and slot empty: mark the task-three entity type #N$20 and
. continue its script.
@ $C3CD label=Update_Task_Three_Entity_State_MarkHelper
  $C3CD,$03 Is bit #N$01 of the saved game-event flags in #REGc set? If not,
. return.
  $C3D0,$04 Write #N$20 to the current entity's entity type.
  $C3D4,$03 Jump to #R$EC2E to run the next script instruction.

c $C3D7 Script Routine: (#N$30) Task-three entity action
@ $C3D7 label=ScriptRoutine_TaskThreeQueueSound
D $C3D7 Queue sound #N$14 for the current task-three script beat.
N $C3D7 #HTML(#AUDIO0(task-three.wav)(#INCLUDE(TaskThree)))
  $C3D7,$02 Load #REGa with #N$14.
  $C3D9,$03 Call #R$F8F9 to queue a sound effect.
  $C3DC,$03 Jump to #R$EC2E to run the next script instruction.

c $C3DF Script Routine: (#N$2B) Task-three entity action
@ $C3DF label=ScriptRoutine_TaskThreeSeekBerk
D $C3DF Steer the task-three creature toward Berk while pursuit flags allow it.
R $C3DF IX Address of complex state data for an entity
  $C3DF,$06 Is the current entity script-locked (bit #N$00 of #REGix+#N$03)?
. If not, jump to #R$C404.
  $C3E5,$03 Load #REGa with the task-three byte (#R$C2E4).
  $C3E8,$03 Is the task-three byte (#R$C2E4) zero? If so, jump to #R$C404.
  $C3EB,$01 Step task-three byte back by one.
  $C3EC,$03 Set the task-three byte (#R$C2E4).
  $C3EF,$03 Load #REGa with the current entity's direction / state.
  $C3F2,$05 Is bit #N$00 of the current entity's direction / state set? If so,
. jump to #R$C493.
  $C3F7,$05 Is bit #N$01 of the current entity's direction / state set? If so,
. jump to #R$C4DE.
  $C3FC,$04 Is bit #N$02 of the current entity's direction / state set? If so,
. jump to #R$C412.
  $C400,$04 Is bit #N$03 of the current entity's direction / state set? If so,
. jump to #R$C44D.
N $C404 Clear the seek latch and chase Berk by room: same room compares X; else
. move up or down toward him.
@ $C404 label=ScriptRoutine_TaskThreeSeekBerk_ClearActiveAndSeekBerk
  $C404,$04 Reset bit #N$00 of the current entity's flags byte 3.
  $C408,$03 Load #REGa with Berk's room-index copy (#R$7305).
  $C40B,$05 Is Berk in the same room as this entity (#REGix+#N$04)? If so, jump
. to #R$C47E.
  $C410,$02 Jump to #R$C44D if the result underflowed.
N $C412 Climb toward Berk: at room #N$04 arm Slimy (#R$C542); else rise when bit
. #N$02 is set, or run the climb script.
@ $C412 label=ScriptRoutine_TaskThreeSeekBerk_MoveRoomUp
  $C412,$03 Load #REGa with the current entity's room index.
  $C415,$05 Is the current entity's room index equal to #N$04? If so, jump to
. #R$C542.
  $C41A,$03 Load #REGa with the current entity's direction / state.
  $C41D,$04 Is bit #N$02 of the current entity's direction / state set? If so,
. jump to #R$C427.
  $C421,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C330).
  $C424,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C427 Probe the path above with #R$F2C7 before rising into the next room.
@ $C427 label=ScriptRoutine_TaskThreeSeekBerk_TestOverlapThenRise
  $C427,$03 Call #R$F2C7 to test collectible / room collision.
  $C42A,$02 Jump to #R$C43B if the result did not underflow.
N $C42C Step down a room toward Berk, refresh the heater at #R$C635, and
. continue the script.
@ $C42C label=ScriptRoutine_TaskThreeSeekBerk_IncRoomAndHeater
  $C42C,$06 Move this entity one character down.
  $C432,$03 Advance this entity into the next room.
  $C435,$03 Call #R$C635 to update Heater.
  $C438,$03 Jump to #R$EC2E to run the next script instruction.
N $C43B Blocked rise: treat direction #N$1F as a door hit (#R$C59A), otherwise
. arm Slimy at #R$C542.
@ $C43B label=ScriptRoutine_TaskThreeSeekBerk_MaybeArmSlimyFromRise
  $C43B,$05 Is the current entity's direction / state equal to #N$1F? If so,
. jump to #R$C59A.
  $C440,$03 Jump to #R$C542 to continue this routine.

c $C443 Script Routine: (#N$2D) Task-three entity action
@ $C443 label=ScriptRoutine_TaskThreeClearUpstairs
D $C443 Clear the upstairs event bit, then resume the task-three script.
R $C443 IX Address of complex state data for an entity
  $C443,$03 Load #REGa with the game event flags (#R$72B3).
  $C446,$02 Clear bit #N$04 of the flag byte in #REGa.
  $C448,$03 Set the game event flags (#R$72B3).
  $C44B,$02 Jump to #R$C42C to continue this routine.
N $C44D Descend toward Berk: at room #N$02 arm Slimy (#R$C542); else fall when
. bit #N$03 is set, or run the descend script.
@ $C44D label=ScriptRoutine_TaskThreeSeekBerk_MoveRoomDown
  $C44D,$03 Load #REGa with the current entity's room index.
  $C450,$05 Is the current entity's room index equal to #N$02? If so, jump to
. #R$C542.
  $C455,$03 Load #REGa with the current entity's direction / state.
  $C458,$04 Is bit #N$03 of the current entity's direction / state set? If so,
. jump to #R$C462.
  $C45C,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C33A).
  $C45F,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C462 Probe with #R$F252, then fall one room toward Berk and refresh the
. heater.
@ $C462 label=ScriptRoutine_TaskThreeSeekBerk_TestCameraThenFall
  $C462,$03 Call #R$F252 to clamp the camera position.
  $C465,$02 Jump to #R$C476 if the result did not underflow.
  $C467,$06 Move this entity one character up.
  $C46D,$03 Move this entity back one room.
  $C470,$03 Call #R$C635 to update Heater.
  $C473,$03 Jump to #R$EC2E to run the next script instruction.
N $C476 Blocked fall: treat direction #N$1F as a door hit (#R$C59A), otherwise
. arm Slimy at #R$C542.
@ $C476 label=ScriptRoutine_TaskThreeSeekBerk_MaybeArmSlimyFromFall
  $C476,$05 Is the current entity's direction / state equal to #N$1F? If so,
. jump to #R$C59A.
  $C47B,$03 Jump to #R$C542 to continue this routine.
N $C47E Same-room chase: compare Berk's X band (#R$7303/#R$7304) and walk right,
. left, or stop.
@ $C47E label=ScriptRoutine_TaskThreeSeekBerk_CompareBerkXEdges
  $C47E,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $C481,$01 Keep Berk's X coordinate in #REGc.
  $C482,$03 Load #REGa with the current entity's x-extent.
  $C485,$03 Is this entity's x-extent left of Berk's X-coordinate copy
. (#R$7303)? If so, jump to #R$C493.
  $C488,$03 Load #REGa with Berk's X-extent copy (#R$7304).
  $C48B,$05 Is Berk's X-extent copy left of this entity's x (#REGix+#N$07)? If
. so, jump to #R$C4DE.
  $C490,$03 Jump to #R$C59A to finish this handler.
N $C493 Build the right-side Berk window into #R$C2E6 and run the peek script
. when he sits in that band.
@ $C493 label=ScriptRoutine_TaskThreeSeekBerk_BuildRightWindow
  $C493,$03 Load #REGa with Berk's room-index copy (#R$7305).
  $C496,$05 Is Berk in the same room as this entity (#REGix+#N$04)? If not, jump
. to #R$C4BA.
  $C49B,$03 Is #REGa zero? If so, jump to #R$C4BA.
  $C49E,$03 Load #REGa with the current entity's x-extent.
  $C4A1,$02 Add #N$03 to #REGa (adjust a task phase/index).
  $C4A3,$01 Keep the index in #REGc.
  $C4A4,$02 Add #N$04 to #REGa (step a coordinate/index).
  $C4A6,$01 Keep a copy of #REGa in #REGb.
  $C4A7,$04 Store #REGbc in the task-three word (#R$C2E6).
  $C4AB,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $C4AE,$03 Is Berk's X-coordinate copy (#R$7303) at or beyond this entity's
. x-extent? If so, jump to #R$C4BA.
  $C4B1,$03 Is Berk's X-coordinate copy (#R$7303) left of this entity's
. x-extent? If so, jump to #R$C4BA.
  $C4B4,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C35E).
  $C4B7,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C4BA Walk right toward Berk until the right edge (#N$B6), then arm Slimy or
. keep stepping.
@ $C4BA label=ScriptRoutine_TaskThreeSeekBerk_WalkRight
  $C4BA,$03 Load #REGa with the current entity's x-extent.
  $C4BD,$04 Is the current entity's x-extent less than #N$B6? If not, jump to
. #R$C529.
  $C4C1,$06 Is bit #N$00 of the current entity's direction / state set? If so,
. jump to #R$C4CD.
  $C4C7,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C31C).
  $C4CA,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C4CD If the way below is clear (#R$F391), step right and refresh the heater.
@ $C4CD label=ScriptRoutine_TaskThreeSeekBerk_TestBelowThenIncX
  $C4CD,$03 Call #R$F391 to test whether an entity is below.
  $C4D0,$02 Jump to #R$C529 if the result did not underflow.
  $C4D2,$06 Move this entity one character right.
  $C4D8,$03 Call #R$C635 to update Heater.
  $C4DB,$03 Jump to #R$EC2E to run the next script instruction.
N $C4DE Build the left-side Berk window into #R$C2E6 and run the peek script
. when he sits in that band.
@ $C4DE label=ScriptRoutine_TaskThreeSeekBerk_BuildLeftWindow
  $C4DE,$03 Load #REGa with Berk's room-index copy (#R$7305).
  $C4E1,$05 Is Berk in the same room as this entity (#REGix+#N$04)? If not, jump
. to #R$C505.
  $C4E6,$03 Is #REGa zero? If so, jump to #R$C505.
  $C4E9,$03 Load #REGa with the current entity's x-coordinate.
  $C4EC,$02 Subtract #N$03 from #REGa.
  $C4EE,$01 Keep the delta in #REGc.
  $C4EF,$02 Subtract #N$03 from #REGa.
  $C4F1,$01 Keep a copy of #REGa in #REGb.
  $C4F2,$04 Store #REGbc in the task-three word (#R$C2E6).
  $C4F6,$03 Load #REGa with Berk's X-extent copy (#R$7304).
  $C4F9,$03 Is Berk's X-extent copy (#R$7304) left of the entity's x
. (#REGix+#N$07)? If so, jump to #R$C505.
  $C4FC,$03 Is Berk's X-extent copy (#R$7304) at or beyond the entity's x
. (#REGix+#N$07)? If so, jump to #R$C505.
  $C4FF,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C344).
  $C502,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C505 Walk left toward Berk until the left edge (#N$49), then arm Slimy or
. keep stepping.
@ $C505 label=ScriptRoutine_TaskThreeSeekBerk_WalkLeft
  $C505,$03 Load #REGa with the current entity's x-coordinate.
  $C508,$04 Is the current entity's x-coordinate less than #N$49? If so, jump to
. #R$C529.
  $C50C,$06 Is bit #N$01 of the current entity's direction / state set? If so,
. jump to #R$C518.
  $C512,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C326).
  $C515,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C518 If the way on the right is clear (#R$F32E), step left and refresh the
. heater.
@ $C518 label=ScriptRoutine_TaskThreeSeekBerk_TestRightThenDecX
  $C518,$03 Call #R$F32E to test whether an entity is on the right.
  $C51B,$02 Jump to #R$C529 if the result did not underflow.
  $C51D,$06 Move this entity one character left.
  $C523,$03 Call #R$C635 to update Heater.
  $C526,$03 Jump to #R$EC2E to run the next script instruction.
N $C529 Edge / stuck path: arm Slimy with range #N$06 via #R$C556, then pick a
. seek or descend script.
@ $C529 label=ScriptRoutine_TaskThreeSeekBerk_ArmSlimyRange06
  $C529,$05 Is the current entity's x-coordinate equal to #N$1F? If so, jump to
. #R$C59A.
  $C52E,$02 Load #REGa with #N$06.
  $C530,$03 Call #R$C556 to update Slimy Creature.
  $C533,$03 Is #REGa zero? If so, jump to #R$C53C.
  $C536,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C33A).
  $C539,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C53C Run the climb/seek script at table entry #R$C2E9(#N$C330).
@ $C53C label=ScriptRoutine_TaskThreeSeekBerk_RunSeekScript
  $C53C,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C330).
  $C53F,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C542 Arm Slimy with range #N$10 via #R$C556, then pick an approach or
. walk-left script.
@ $C542 label=ScriptRoutine_TaskThreeSeekBerk_ArmSlimyRange10
  $C542,$02 Load #REGa with #N$10.
  $C544,$03 Call #R$C556 to update the slimy creature.
  $C547,$03 Is the random result in #REGa zero? If so, jump to #R$C550.
  $C54A,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C326).
  $C54D,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $C550 Run the walk-right approach script at table entry #R$C2E9(#N$C31C).
@ $C550 label=ScriptRoutine_TaskThreeSeekBerk_RunApproachScript
  $C550,$03 Point #REGhl at task-three table entry #R$C2E9(#N$C31C).
  $C553,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $C556 Update Slimy Creature
@ $C556 label=Update_Slimy_Creature
D $C556 Arm the slimy-creature timer at #R$C2E4, set bit #N$00 of the entity
. flags, and return a fresh random byte in #REGa.
R $C556 IX Address of complex state data for an entity
  $C556,$03 Call #R$EAE5 to pick a pseudo-random value.
  $C559,$02 Add #N$02 to #REGa (step a word index).
  $C55B,$03 Set the task-three byte (#R$C2E4).
  $C55E,$04 Set bit #N$00 of the current entity's flags byte 3.
  $C562,$02 Load #REGa with #N$02.
  $C564,$03 Call #R$EAE5 to pick a pseudo-random value.
  $C567,$01 Return.

c $C568 Script Routine: (#N$2F) Task-three entity action
@ $C568 label=ScriptRoutine_TaskThreeBerkLeftWindow
D $C568 Run the task-three left-window encounter when Berk is at that window.
R $C568 IX Address of complex state data for an entity
  $C568,$03 Load #REGa with Berk's room-index copy (#R$7305).
  $C56B,$05 Is Berk in the same room as this entity (#REGix+#N$04)? If not, jump
. to #R$C5BA.
  $C570,$04 Load #REGbc from #R$C2E6.
  $C574,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $C577,$03 Is Berk's X-coordinate copy (#R$7303) at or beyond #REGb? If so,
. jump to #R$C5BA.
  $C57A,$03 Load #REGa with Berk's X-extent copy (#R$7304).
  $C57D,$03 Is Berk's X-extent copy (#R$7304) left of #REGc? If so, jump to
. #R$C5BA.
  $C580,$02 Jump to #R$C59A to finish this handler.

c $C582 Script Routine: (#N$2E) Task-three entity action
@ $C582 label=ScriptRoutine_TaskThreeBerkRightWindow
D $C582 Run the task-three right-window encounter when Berk is at that window.
R $C582 IX Address of complex state data for an entity
  $C582,$03 Load #REGa with Berk's room-index copy (#R$7305).
  $C585,$05 Is Berk in the same room as this entity (#REGix+#N$04)? If not, jump
. to #R$C5A0.
  $C58A,$04 Load #REGbc from #R$C2E6.
  $C58E,$03 Load #REGa with Berk's X-extent copy (#R$7304).
  $C591,$03 Is Berk's X-extent copy (#R$7304) left of #REGb? If so, jump to
. #R$C5A0.
  $C594,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $C597,$03 Is Berk's X-coordinate copy (#R$7303) at or beyond #REGc? If so,
. jump to #R$C5A0.
N $C59A Resolve a door / interaction hit via #R$EA73, then advance the script.
@ $C59A label=TaskThree_DoorHitThenNextScript
  $C59A,$03 Call #R$EA73 to handle the door / interaction hit.
  $C59D,$03 Jump to #R$EC2E to run the next script instruction.
N $C5A0 Right-window miss: only continue if the cauldron (#R$9063) overlaps
. the stored X window.
@ $C5A0 label=ScriptRoutine_TaskThreeBerkRightWindow_CheckCreatureXExtent
  $C5A0,$04 Point #REGiy at the cauldron entity at #R$9063.
  $C5A4,$03 Load #REGa with the current entity's room index.
  $C5A7,$06 Is Berk in the same room as this entity (#REGix+#N$04)? If not, jump
. to #R$EC2E.
  $C5AD,$03 Load #REGa with the referenced entity's x-extent.
  $C5B0,$04 Is the referenced entity's x-extent less than #REGb? If so, jump to
. #R$EC2E.
  $C5B4,$04 Is the referenced entity's x-extent at or beyond #REGc? If not, jump
. to #R$EC2E.
  $C5B8,$02 Jump to #R$C5D2 to continue this routine.
N $C5BA Left-window miss: only continue if the cauldron (#R$9063) overlaps
. the stored X window.
@ $C5BA label=ScriptRoutine_TaskThreeBerkLeftWindow_CheckCreatureX
  $C5BA,$04 Point #REGiy at the cauldron entity at #R$9063.
  $C5BE,$03 Load #REGa with the current entity's room index.
  $C5C1,$06 Does this entity share the referenced entity's room (#REGiy+#N$04)?
. If not, jump to #R$EC2E.
  $C5C7,$03 Load #REGa with the referenced entity's x-coordinate.
  $C5CA,$04 Is the referenced entity's x at or beyond #REGb? If not, jump to
. #R$EC2E.
  $C5CE,$04 Is the referenced entity's x less than #REGc? If so, jump to
. #R$EC2E.
N $C5D2 Raise BoilEmUp / BoilEmUpLatch on #R$72B6, swap in layout #R$9F75, and
. bump the task-three timer.
@ $C5D2 label=ScriptRoutine_TaskThreeBerkRightWindow_SetFlagsAndLayout
  $C5D2,$03 Load #REGa with the task-three flags (#R$72B6).
  $C5D5,$05 Is bit #N$07 of task-three flags set? If not, jump to #R$EC2E.
  $C5DA,$02 Set BoilEmUp (bit #N$04 of #R$72B6. cleared by #R$C63B. tested by
. #R$D927).
  $C5DC,$02 Set BoilEmUpLatch (bit #N$05 of #R$72B6. cleared by #R$C63B /
. #R$C39A).
  $C5DE,$03 Set the task-three flags (#R$72B6).
  $C5E1,$03 Point #REGbc at the cauldron cooking layout (#R$9F75).
  $C5E4,$04 Write the layout address into the cauldron entity
. (#R$8EF3(#N$906D)).
  $C5E8,$03 Load #REGa with the task-three timer (#R$72C3).
  $C5EB,$02 Add #N$32 to the task-three timer in #REGa.
  $C5ED,$03 If that add overflowed (carry), jump to #R$EC2E without storing.
  $C5F0,$03 Set the task-three timer (#R$72C3).
  $C5F3,$03 Jump to #R$EC2E to run the next script instruction.

c $C5F6 Script Routine: (#N$2C) Slimy-creature action
@ $C5F6 label=ScriptRoutine_SlimyDropAndHeat
D $C5F6 Drop the slimy creature and arm the heater-related game flags.
R $C5F6 IX Address of complex state data for an entity
  $C5F6,$06 Move this entity one character up.
  $C5FC,$03 Call #R$C635 to update Heater.
  $C5FF,$03 Jump to #R$EC2E to run the next script instruction.

c $C602 Script Routine: (#N$2A) Cauldron / heater action
@ $C602 label=ScriptRoutine_ArmCauldronFlags
D $C602 Arm the cauldron / heater event flags for the current script beat.
  $C602,$03 Load #REGa with the game event flags (#R$72B3).
  $C605,$02,b$01 Set bits #N$07 and #N$04 of #R$72B3 (task entity script active
. + upstairs event latch).
  $C607,$03 Set the game event flags (#R$72B3).
  $C60A,$03 Jump to #R$EC2E to run the next script instruction.

c $C60D Update Cauldron
@ $C60D label=Update_Cauldron
D $C60D Refresh the cauldron entity after Drutt drops something in, then idle
. the current task phase.
  $C60D,$01 Clear the current task phase (idle).
  $C60E,$03 Set the current task phase (#R$72AF).
  $C611,$03 Point #REGhl at the game event flags (#R$72B3).
  $C614,$02 Clear "task entity script is active" (bit #N$07 of #R$72B3).
  $C616,$03 Point #REGhl at task-three storage (#R$C2E8).
  $C619,$03 Store #REGhl in the active script cursor (#R$72CF).
  $C61C,$03 Store #REGhl in the task-three script-position pointer (#R$72D1).
  $C61F,$03 Point #REGhl at the #N$0A-byte init template at #R$C62B (copied into
. #R$90A9).
  $C622,$03 Point #REGde at the task-three helper entity slot (#R$90A9).
  $C625,$03 Load #REGbc with #N($000A,$04,$04) (bytes to copy into the helper
. entity slot).
  $C628,$02 Copy the block at #REGhl to #REGde.
  $C62A,$01 Return.

b $C62B Cauldron Init Template
@ $C62B label=Data_CauldronInitTemplate
D $C62B Template bytes pointed by #REGhl at #R$C61F before #R$C635.
  $C62B,$0A

c $C635 Update Heater
@ $C635 label=Update_Heater
D $C635 Queue heater sound effect #N$12 via #R$F8F9.
N $C635 #HTML(#AUDIO0(heater.wav)(#INCLUDE(Heater)))
  $C635,$02 Load #REGa with #N$12.
  $C637,$03 Call #R$F8F9 to queue a sound effect.
  $C63A,$01 Return.

c $C63B Update Stove
@ $C63B label=Update_Stove
D $C63B When the collided entity's type is #N$14 and the current entity's type
. is #N$09. Clears SlimyLoose, BoilEmUp and BoilEmUpLatch; raises
. StoveUpdated; advances #R$72BE (setting StoveReady on the fourth tick); and
. repoints the cauldron at idle layout #R$9F9D.
N $C63B Clear SlimyLoose / BoilEmUp / BoilEmUpLatch; raise StoveUpdated.
  $C63B,$01 Stash #REGhl on the stack.
  $C63C,$03 Point #REGhl at the task-three flags (#R$72B6).
  $C63F,$02 Clear SlimyLoose (bit #N$02 of #R$72B6. set by #R$B401 / #R$C6FC
. tested by #R$D907).
  $C641,$02 Clear BoilEmUp (bit #N$04 of #R$72B6. set by #R$C5D2. tested by
. #R$D927).
  $C643,$02 Clear BoilEmUpLatch (bit #N$05 of #R$72B6. set by #R$C5D2. also
. cleared at #R$C39A).
  $C645,$02 Set StoveUpdated (bit #N$07 of #R$72B6. tested by #R$C5D2 before it
. sets BoilEmUp / BoilEmUpLatch).
N $C647 Count another stove tick (#R$72BE); has it reached #N$04?.
  $C647,$03 Load the stove tick (#R$72BE) into #REGa.
  $C64A,$01 Advance the stove tick by one.
  $C64B,$03 Store the stove tick (#R$72BE).
  $C64E,$04 Has the stove tick reached #N$04? If not, skip to #R$C654.
  $C652,$02 Set StoveReady (bit #N$06 of #R$72B6. tested by #R$D915 / #R$D91B).
N $C654 Point the cauldron at its idle layout and return.
@ $C654 label=Update_Stove_IdleLayout
  $C654,$03 Point #REGhl at the cauldron layout (#R$9F9D).
  $C657,$03 Write that layout into the graphic-layout field of #R$9063
. (#R$8EF3(#N$906D)).
  $C65A,$01 Restore #REGhl from the stack.
  $C65B,$01 Return.

c $C65C Update Task Three Helpers
@ $C65C label=Update_Task_Three_Helpers
D $C65C Update Task Three Helpers for the current Thing Upstairs task.
  $C65C,$04 Point #REGix at the first Slimies entity (#R$8F13).
  $C660,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $C663,$02 Load #REGb with #N$04 as a loop counter.
N $C665 Scan each upstairs helper: skip inactive / low slots, then randomly
. wander, climb, or drop a room.
@ $C665 label=Update_Task_Three_Helpers_Scan
  $C665,$01 Stash #REGbc on the stack.
  $C666,$03 Load #REGa with the current entity's flags byte 1.
  $C669,$02,b$01 Keep only the top bits #N$E0 of the flag/coordinate in #REGa.
  $C66B,$02 If the result was non-zero, jump to #R$C6E3.
  $C66D,$03 Load #REGa with the current entity's y-extent.
  $C670,$04 Is the current entity's y-extent less than #N$22? If so, jump to
. #R$C6E3.
  $C674,$07 Is bit #N$07 of the current entity's entity type set? If not, call
. #R$C6F1.
  $C67B,$02 Load #REGa with #N$15.
  $C67D,$03 Call #R$EAE5 to pick a pseudo-random value.
  $C680,$03 Is #N$15 zero? If so, jump to #R$C6EB.
  $C683,$04 Is #N$15 less than #N$06? If so, jump to #R$C6B3.
  $C687,$04 Is #N$15 less than #N$0B? If so, jump to #R$C6CC.
  $C68B,$04 Is #N$15 less than #N$10? If so, jump to #R$C6A1.
  $C68F,$03 Load #REGa with the current entity's room index.
  $C692,$04 Is the current entity's room index equal to #N$05? If so, jump to
. #R$C6E3.
  $C696,$06 Move this entity one character down.
  $C69C,$03 Advance this entity into the next room.
  $C69F,$02 Jump to #R$C6E3 to advance to the next helper entity.
N $C6A1 Move this helper up one room (unless already in room #N$01).
@ $C6A1 label=Update_Task_Three_Helpers_MoveRoomDown
  $C6A1,$03 Load #REGa with the current entity's room index.
  $C6A4,$04 Is the current entity's room index equal to #N$01? If so, jump to
. #R$C6E3.
  $C6A8,$06 Move this entity one character up.
  $C6AE,$03 Move this entity back one room.
  $C6B1,$02 Jump to #R$C6E3 to advance to the next helper entity.
N $C6B3 Try a left wander step, respecting the high-X and low-X bounds.
@ $C6B3 label=Update_Task_Three_Helpers_TryMoveLeft
  $C6B3,$03 Load #REGa with the current entity's x-coordinate.
  $C6B6,$04 Is the current entity's x-coordinate less than #N$E0? If so, jump to
. #R$C6C0.
  $C6BA,$04 Is the current entity's x-coordinate less than #N$E4? If so, jump to
. #R$C6E3.
  $C6BE,$02 Jump to #R$C6C4 to decrease the helper's x-coordinate.
N $C6C0 Left-bound check: below #N$43 step right instead of left.
@ $C6C0 label=Update_Task_Three_Helpers_LeftBoundCheck
  $C6C0,$04 Is the current entity's x-coordinate less than #N$43? If so, jump to
. #R$C6DD.
N $C6C4 Nudge the helper one character left.
@ $C6C4 label=Update_Task_Three_Helpers_DecX
  $C6C4,$06 Move this entity one character left.
  $C6CA,$02 Jump to #R$C6E3 to advance to the next helper entity.
N $C6CC Try a right wander step, respecting the high-X and mid-X bounds.
@ $C6CC label=Update_Task_Three_Helpers_TryMoveRight
  $C6CC,$03 Load #REGa with the current entity's x-coordinate.
  $C6CF,$04 Is the current entity's x-coordinate less than #N$E0? If so, jump to
. #R$C6D9.
  $C6D3,$04 Is the current entity's x-coordinate less than #N$FB? If not, jump
. to #R$C6E3.
  $C6D7,$02 Jump to #R$C6DD to increase the helper's x-coordinate.
N $C6D9 Right-bound check: at or beyond #N$BB step left instead of right.
@ $C6D9 label=Update_Task_Three_Helpers_RightBoundCheck
  $C6D9,$04 Is the current entity's x-coordinate less than #N$BB? If not, jump
. to #R$C6C4.
N $C6DD Nudge the helper one character right.
@ $C6DD label=Update_Task_Three_Helpers_IncX
  $C6DD,$06 Move this entity one character right.
N $C6E3 Advance to the next helper slot and loop until all #N$04 are done.
@ $C6E3 label=Update_Task_Three_Helpers_AdvanceSlot
  $C6E3,$02 Advance #REGix to the next entity record.
  $C6E5,$01 Restore #REGbc from the stack.
  $C6E6,$01 Step the loop counter in #REGb back by one.
  $C6E7,$03 If the result was non-zero, jump to #R$C665.
  $C6EA,$01 Return.
N $C6EB Clear type bit #N$07 (end the 'loose' pose) and advance.
@ $C6EB label=Update_Task_Three_Helpers_ClearTypeBit7
  $C6EB,$04 Reset bit #N$07 of the current entity's entity type.
  $C6EF,$02 Jump to #R$C6E3 to advance to the next helper entity.
N $C6F1 When X is below #N($E0), clear type bit #N$07 and raise SlimyLoose on
. #R$72B6.
@ $C6F1 label=Update_Task_Three_Helpers_MaybeSetFlagBit2
  $C6F1,$03 Load #REGa with the current entity's x-coordinate.
  $C6F4,$04 Is the current entity's x-coordinate less than #N$E0? If not, jump
. to #R$C702.
  $C6F8,$04 Reset bit #N$07 of the current entity's entity type.
  $C6FC,$03 Point #REGhl at the task-three flags (#R$72B6).
  $C6FF,$02 Set SlimyLoose (bit #N$02 of #R$72B6. #R$D907 skips that line while
. set).
  $C701,$01 Return.
N $C702 Rarely set type bit #N$07 so this helper can enter the SlimyLoose path.
@ $C702 label=Update_Task_Three_Helpers_MaybeSetTypeBit7
  $C702,$02 Load #REGa with #N$0A.
  $C704,$03 Call #R$EAE5 to pick a pseudo-random value.
  $C707,$02 Is the random result in #REGa zero? If not, return.
  $C709,$04 Set bit #N$07 of the current entity's entity type.
  $C70D,$01 Return.

b $C70E Graphic Layout: Mobile Flamer
@ $C70E label=GraphicLayout_MobileFlamer
D $C70E Mobile flamer, front facing. Complex entity slot at #R$90A9 uses this
. layout. Head and eye poses continue at #R$C79D, #R$C7D7, #R$C7FD,
. #R$C832 and #R$C86A.
N $C70E Front-facing entry.
N $C70E #UDGTABLE { #SCRIPTANIM$C70E(script-c70e) } UDGTABLE#
B $C70E,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C710,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C713,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C716,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C718,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C71B,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C71E,$02 Queue sound #N(#PEEK(#PC+$01)).
B $C720,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C722,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C725,$0D,$0D Increment the index and jump to one of #R$C79D, #R$C7FD,
. #R$C7D7, #R$C832, #R$C79D.
B $C732,$02 Queue sound #N(#PEEK(#PC+$01)).
B $C734,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C736,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C739,$0D,$0D Increment the index and jump to one of #R$C79D, #R$C832,
. #R$C7D7, #R$C7FD, #R$C79D.
B $C746,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C749,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C74C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C74F,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C752,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C755,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C758,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C75B,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
B $C75E,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C760,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C763,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C766,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C769,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C76C,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C76F,$0B,$0B Increment the index and jump to one of #R$C9A7, #R$C9E5,
. #R$C9C6, #R$CA04.
B $C77A,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C77C,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C77F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C782,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $C785,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C788,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C78B,$0B,$0B Increment the index and jump to one of #R$C92B, #R$C969,
. #R$C94A, #R$C988.
N $C796 #UDGTABLE { #LAYOUT$96,$C7(layout-c796) } UDGTABLE#
B $C796,$07 Increment the index and jump to one of #R$C8ED, #R$C90C.
N $C79D Head facing front.
N $C79D #UDGTABLE { #LAYOUT$9D,$C7,$00,$05(layout-c79d) } UDGTABLE#
@ $C79D label=GraphicLayout_MobileFlamerHeadFront
B $C79D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C79F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C7A2,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C7A5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C7A8,$13,$13 Jump to a time-weighted random layout address (#R$C7BB,
. #R$C7C9, #R$C7C2, #R$C7D0).
N $C7BB Eyes frame #N$01.
N $C7BB #UDGTABLE { #LAYOUT$BB,$C7,$00,$05(layout-c7bb) } UDGTABLE#
@ $C7BB label=GraphicLayout_MobileFlamerEyes1
B $C7BB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7BE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7C1,$01 Load the stored coordinates and return.
N $C7C2 Eyes frame #N$02.
N $C7C2 #UDGTABLE { #LAYOUT$C2,$C7,$00,$05(layout-c7c2) } UDGTABLE#
@ $C7C2 label=GraphicLayout_MobileFlamerEyes2
B $C7C2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7C5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7C8,$01 Load the stored coordinates and return.
N $C7C9 Eyes frame #N$03.
N $C7C9 #UDGTABLE { #LAYOUT$C9,$C7,$00,$05(layout-c7c9) } UDGTABLE#
@ $C7C9 label=GraphicLayout_MobileFlamerEyes3
B $C7C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7CC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7CF,$01 Load the stored coordinates and return.
N $C7D0 Eyes blinking.
N $C7D0 #UDGTABLE { #LAYOUT$D0,$C7,$00,$05(layout-c7d0) } UDGTABLE#
@ $C7D0 label=GraphicLayout_MobileFlamerEyesBlink
B $C7D0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7D3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7D6,$01 Load the stored coordinates and return.
N $C7D7 Head facing rear.
N $C7D7 #UDGTABLE { #LAYOUT$D7,$C7(layout-c7d7) } UDGTABLE#
@ $C7D7 label=GraphicLayout_MobileFlamerHeadRear
B $C7D7,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C7D9,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C7DC,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C7DF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7E8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7F7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C7FA,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $C7FD Head facing right.
N $C7FD #UDGTABLE { #LAYOUT$FD,$C7(layout-c7fd) } UDGTABLE#
@ $C7FD label=GraphicLayout_MobileFlamerHeadRight
B $C7FD,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C7FF,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C802,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C805,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C808,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C80B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C80E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C811,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C814,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C817,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C81A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C81D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C820,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C823,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C826,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C829,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C82C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C82F,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $C832 Head facing left.
N $C832 #UDGTABLE { #LAYOUT$32,$C8(layout-c832) } UDGTABLE#
@ $C832 label=GraphicLayout_MobileFlamerHeadLeft
B $C832,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $C834,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $C837,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C83A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C83D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C840,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C843,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C846,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C849,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C84C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C84F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C852,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C855,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C858,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C85B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C85E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C861,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C864,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C867,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $C86A Head with no features.
N $C86A #UDGTABLE { #LAYOUT$6A,$C8,$00,$05(layout-c86a) } UDGTABLE#
@ $C86A label=GraphicLayout_MobileFlamerHeadBlank
B $C86A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C86D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C870,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C873,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C876,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C879,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C87C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
N $C87F #UDGTABLE { #LAYOUT$7F,$C8,$00,$05(layout-c87f) } UDGTABLE#
B $C87F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C882,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C885,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C888,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
N $C88B #UDGTABLE { #LAYOUT$8B,$C8,$00,$05(layout-c88b) } UDGTABLE#
B $C88B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C88E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C891,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C894,$01 Load the stored coordinates and return.
N $C895 #UDGTABLE { #LAYOUT$95,$C8,$00,$05(layout-c895) } UDGTABLE#
B $C895,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C898,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C89B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C89E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8AD,$05 Set the next graphic index from a random list.
B $C8B2,$03 Draw a random tile from the list at #R$C8AD with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8B5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8B8,$01 Load the stored coordinates and return.
N $C8B9 #UDGTABLE { #LAYOUT$B9,$C8,$00,$05(layout-c8b9) } UDGTABLE#
B $C8B9,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C8BC,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
B $C8BE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8C0,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8C2,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8C4,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8C6,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8C8,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8CA,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8CC,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8CE,$02 Draw tile #N(#PEEK(#PC)) and move
. #TILESTEP(#PEEK(#PC+$01),#PEEK($C8BD)).
B $C8D0,$01 Load the stored coordinates and return.
N $C8D1 #UDGTABLE { #LAYOUT$D1,$C8,$00,$05(layout-c8d1) } UDGTABLE#
B $C8D1,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C8D4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8D7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8DA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8DD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8E0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8E3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8E6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8E9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8EC,$01 Load the stored coordinates and return.
N $C8ED #UDGTABLE { #LAYOUT$ED,$C8(layout-c8ed) } UDGTABLE#
B $C8ED,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C8F0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8F3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8F6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8F9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8FC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C8FF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C902,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C905,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C908,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C90B,$01 Load the stored coordinates and return.
N $C90C #UDGTABLE { #LAYOUT$0C,$C9(layout-c90c) } UDGTABLE#
B $C90C,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $C90F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C912,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C915,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C918,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C91B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C91E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C921,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C924,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C927,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C92A,$01 Load the stored coordinates and return.
N $C92B #UDGTABLE { #LAYOUT$2B,$C9(layout-c92b) } UDGTABLE#
B $C92B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C92E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C931,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C934,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C937,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C93A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C93D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C940,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C943,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C946,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C949,$01 Load the stored coordinates and return.
N $C94A #UDGTABLE { #LAYOUT$4A,$C9(layout-c94a) } UDGTABLE#
B $C94A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C94D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C950,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C953,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C956,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C959,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C95C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C95F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C962,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C965,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C968,$01 Load the stored coordinates and return.
N $C969 #UDGTABLE { #LAYOUT$69,$C9(layout-c969) } UDGTABLE#
B $C969,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C96C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C96F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C972,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C975,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C978,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C97B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C97E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C981,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C984,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C987,$01 Load the stored coordinates and return.
N $C988 #UDGTABLE { #LAYOUT$88,$C9(layout-c988) } UDGTABLE#
B $C988,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C98B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C98E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C991,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C994,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C997,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C99A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C99D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9A0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9A3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9A6,$01 Load the stored coordinates and return.
N $C9A7 #UDGTABLE { #LAYOUT$A7,$C9(layout-c9a7) } UDGTABLE#
B $C9A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9B0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9B3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9B6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9B9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9BC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9BF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9C2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9C5,$01 Load the stored coordinates and return.
N $C9C6 #UDGTABLE { #LAYOUT$C6,$C9(layout-c9c6) } UDGTABLE#
B $C9C6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9CC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9CF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9D2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9D5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9D8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9DB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9DE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9E1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9E4,$01 Load the stored coordinates and return.
N $C9E5 #UDGTABLE { #LAYOUT$E5,$C9(layout-c9e5) } UDGTABLE#
B $C9E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9E8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9EB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9F7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9FA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $C9FD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA00,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA03,$01 Load the stored coordinates and return.
N $CA04 #UDGTABLE { #LAYOUT$04,$CA(layout-ca04) } UDGTABLE#
B $CA04,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA07,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA0A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA0D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA10,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA13,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA16,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA19,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA1C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA1F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CA22,$01 Load the stored coordinates and return.

b $CA23 Data: Task Four Script
@ $CA23 label=Data_TaskFourScript
D $CA23 Task-four script words for #R$EC30. #R$CADF loads this address into
. #REGhl and #R$CAE2 stores it in the active script cursor (#R$72CF).
. #R$CAC0 later copies that cursor to #R$72D7. #R$CAFE enters at #R$CA79.
. #R$CB44 enters at #R$CA9B.
N $CA23 Script entry loaded by #R$CADF.
W $CA23,$02 Graphic-layout pointer #R$CCBA.
W $CA25,$02 Script opcode #N$21 (start counted script loop).
  $CA27,$02 Loop count #N$06 (#R$EC53 reads only the low byte).
W $CA29,$02 Graphic-layout pointer #R$CCBA.
W $CA2B,$02 Script opcode #N$22 (end script loop).
W $CA2D,$02 Script opcode #N$4E (arm the task-four script-active flags).
W $CA2F,$02 Script opcode #N$49 (raise the task-four creature).
W $CA31,$02 Graphic-layout pointer #R$CCE6.
W $CA33,$02 Script opcode #N$49 (raise the task-four creature).
W $CA35,$02 Script opcode #N$4F (randomise the creature's extra state).
W $CA37,$02 Script opcode #N$01 (jump to script address).
W $CA39,$02 Jump to script address #R$CA43.
N $CA3B Script fragment reached from #R$CA77.
W $CA3B,$02 Graphic-layout pointer #R$CCC8.
W $CA3D,$02 Graphic-layout pointer #R$CCCE.
W $CA3F,$02 Graphic-layout pointer #R$CCD4.
W $CA41,$02 Graphic-layout pointer #R$CCDA.
N $CA43 Script fragment reached from #R$CA39.
W $CA43,$02 Script opcode #N$21 (start counted script loop).
  $CA45,$02 Loop count #N$04 (#R$EC53 reads only the low byte).
W $CA47,$02 Graphic-layout pointer #R$CCE6.
W $CA49,$02 Script opcode #N$49 (raise the task-four creature).
W $CA4B,$02 Script opcode #N$22 (end script loop).
N $CA4D Script fragment reached from #R$CA99.
W $CA4D,$02 Script opcode #N$21 (start counted script loop).
  $CA4F,$02 Loop count #N$05 (#R$EC53 reads only the low byte).
W $CA51,$02 Graphic-layout pointer #R$CCB9.
W $CA53,$02 Script opcode #N$22 (end script loop).
W $CA55,$02 Script opcode #N$4B (nudge the creature toward its target).
W $CA57,$02 Script opcode #N$21 (start counted script loop).
  $CA59,$02 Loop count #N$02 (#R$EC53 reads only the low byte).
W $CA5B,$02 Graphic-layout pointer #R$CCE6.
W $CA5D,$02 Script opcode #N$4A (lower the task-four creature).
W $CA5F,$02 Script opcode #N$22 (end script loop).
W $CA61,$02 Script opcode #N$48 (snap the creature onto its target).
W $CA63,$02 Script opcode #N$21 (start counted script loop).
  $CA65,$02 Loop count #N$02 (#R$EC53 reads only the low byte).
W $CA67,$02 Graphic-layout pointer #R$CCE6.
W $CA69,$02 Script opcode #N$4A (lower the task-four creature).
W $CA6B,$02 Script opcode #N$22 (end script loop).
W $CA6D,$02 Script opcode #N$4C (test Berk overlap with the creature).
W $CA6F,$02 Graphic-layout pointer #R$CCE0.
W $CA71,$02 Graphic-layout pointer #R$CCD4.
W $CA73,$02 Graphic-layout pointer #R$CCCE.
W $CA75,$02 Script opcode #N$01 (jump to script address).
W $CA77,$02 Jump to script address #R$CA3B.
N $CA79 Script entry loaded by #R$CAFE.
W $CA79,$02 Graphic-layout pointer #R$CCE6.
W $CA7B,$02 Script opcode #N$4A (lower the task-four creature).
W $CA7D,$02 Graphic-layout pointer #R$CCE0.
W $CA7F,$02 Graphic-layout pointer #R$CCD4.
W $CA81,$02 Graphic-layout pointer #R$CCCE.
W $CA83,$02 Graphic-layout pointer #R$CCC8.
W $CA85,$02 Script opcode #N$4D (tick the offer-item timer).
W $CA87,$02 Graphic-layout pointer #R$CCCE.
W $CA89,$02 Graphic-layout pointer #R$CCD4.
W $CA8B,$02 Graphic-layout pointer #R$CCDA.
W $CA8D,$02 Script opcode #N$21 (start counted script loop).
  $CA8F,$02 Loop count #N$03 (#R$EC53 reads only the low byte).
W $CA91,$02 Graphic-layout pointer #R$CCE6.
W $CA93,$02 Script opcode #N$49 (raise the task-four creature).
W $CA95,$02 Script opcode #N$22 (end script loop).
W $CA97,$02 Script opcode #N$01 (jump to script address).
W $CA99,$02 Jump to script address #R$CA4D.
N $CA9B Script entry loaded by #R$CB44.
W $CA9B,$02 Script opcode #N$21 (start counted script loop).
  $CA9D,$02 Loop count #N$06 (#R$EC53 reads only the low byte).
W $CA9F,$02 Graphic-layout pointer #R$CCE6.
W $CAA1,$02 Script opcode #N$4A (lower the task-four creature).
W $CAA3,$02 Script opcode #N$22 (end script loop).
W $CAA5,$02 Script opcode #N$50 (clear the task-four script flags).

c $CAA7 Update Task Four Entities
@ $CAA7 label=Update_Task_Four_Entities
D $CAA7 Update Task Four Entities for the current Thing Upstairs task.
N $CAA7 Runs task-four entity scripts while the task phase is #N$04.
  $CAA7,$03 Call #R$CE4B to update Ghosts.
  $CAAA,$03 Load #REGa with the current task phase (#R$72AF).
  $CAAD,$03 Is current task phase equal to #N$04? If not, return.
  $CAB0,$03 Load #REGhl with the task-four script-position pointer (#R$72D7).
  $CAB3,$03 Store #REGhl in the active script cursor (#R$72CF).
  $CAB6,$04 Point #REGix at the task-three/four entity at #R$8FF3.
  $CABA,$03 Call #R$CAC4 to update Task Four Entity State.
  $CABD,$03 Load #REGhl with the active script cursor (#R$72CF).
  $CAC0,$03 Store #REGhl in the task-four script-position pointer (#R$72D7).
  $CAC3,$01 Return.

c $CAC4 Update Task Four Entity State
@ $CAC4 label=Update_TaskFourEntityState
D $CAC4 Advance task-four entity scripts and start/stop the entity when game
. event flags at #R$72B3 change.
  $CAC4,$03 Load #REGa with the game event flags (#R$72B3).
  $CAC7,$05 Is bit #N$07 of game event flags set? If so, jump to #R$EC2E.
  $CACC,$06 Is bit #N$07 of the current entity's entity type set? If so, jump to
. #R$CAE6.
  $CAD2,$05 Is bit #N$01 of game event flags set? If so, jump to #R$EC2E.
N $CAD7 Shared entry used by script routine #R$CAF0 to start the task-four
. entity script.
@ $CAD7 label=Update_TaskFour_StartEntity
  $CAD7,$04 Set bit #N$07 of the current entity's entity type.
  $CADB,$01 Clear the current task phase (idle).
  $CADC,$03 Set the current task phase (#R$72AF).
  $CADF,$03 Point #REGhl at task-four script #R$CA23.
  $CAE2,$03 Store #REGhl in the active script cursor (#R$72CF).
  $CAE5,$01 Return.
N $CAE6 Stop the task-four entity when game-event bit #N$01 is set: clear type
. bit #N$07 and continue the script.
@ $CAE6 label=Update_TaskFour_StopEntity
  $CAE6,$03 Is bit #N$01 of game event flags set? If not, return.
  $CAE9,$04 Reset bit #N$07 of the current entity's entity type.
  $CAED,$03 Jump to #R$EC2E to run the next script instruction.

c $CAF0 Script Routine: (#N$50) Task-four entity action
@ $CAF0 label=ScriptRoutine_TaskFourClearScriptFlags
D $CAF0 Clear the task-four script flags so the next task-four beat can start
. cleanly.
  $CAF0,$03 Point #REGhl at the game event flags (#R$72B3).
  $CAF3,$02 Clear bit #N$07 of #R$72B3 (task entity script active).
  $CAF5,$02 Clear bit #N$04 of #R$72B3 (upstairs event latch).
  $CAF7,$02 Load #REGa with #N$28.
  $CAF9,$03 Set the game tick counter (#R$72F2).
  $CAFC,$02 Jump to #R$CAD7 to start the entity.

c $CAFE Script Routine: (#N$48) Task-four entity action
@ $CAFE label=ScriptRoutine_TaskFourAlignCreature
D $CAFE Snap the task-four creature onto its target position.
R $CAFE IX Address of complex state data for an entity
  $CAFE,$04 Point #REGiy at the vat entity at #R$9071.
  $CB02,$03 Load #REGa with the current entity's x-coordinate.
  $CB05,$06 Does this entity's x match the referenced entity's x (#REGiy+#N$07)?
. If not, jump to #R$EC2E.
  $CB0B,$03 Load #REGa with the current entity's room index.
  $CB0E,$06 Does this entity share the referenced entity's room (#REGiy+#N$04)?
. If not, jump to #R$EC2E.
  $CB14,$04 Set bit #N$02 of the current entity's extra state.
  $CB18,$03 Point #REGhl at task-four script entry #R$CA79.
  $CB1B,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $CB1E Script Routine: (#N$4F) Task-four entity action
@ $CB1E label=ScriptRoutine_TaskFourRandomiseExtra
D $CB1E Pick a new extra-state value for the task-four creature's next beat.
R $CB1E IX Address of complex state data for an entity
  $CB1E,$04 Write #N$04 to the current entity's extra state.
  $CB22,$02 Load #REGa with #N$05.
  $CB24,$03 Call #R$EAE5 to pick a pseudo-random value.
  $CB27,$02 Add #N$06 to #REGa (adjust a task-four index/counter).
  $CB29,$01 Keep the index in #REGc.
  $CB2A,$02 Load #REGa with #N$02.
  $CB2C,$03 Call #R$EAE5 to pick a pseudo-random value.
  $CB2F,$03 Is #REGa zero? If so, jump to #R$CB36.
  $CB32,$01 Copy the saved count/flag from #REGc into #REGa.
  $CB33,$02 Negate #REGa (flip a delta/direction).
  $CB35,$01 Keep the delta in #REGc.
N $CB36 Keep the signed step delta, drop the upstairs latch on #R$72B3, and
. continue the script.
@ $CB36 label=ScriptRoutine_TaskFourRandomiseExtra_StoreDeltaClearBit4
  $CB36,$03 Store #REGc in the current entity's direction / state.
  $CB39,$03 Load #REGa with the game event flags (#R$72B3).
  $CB3C,$02 Clear bit #N$04 of the flag byte in #REGa.
  $CB3E,$03 Set the game event flags (#R$72B3).
  $CB41,$03 Jump to #R$EC2E to run the next script instruction.

c $CB44 Script Routine: (#N$4B) Task-four entity action
@ $CB44 label=ScriptRoutine_TaskFourStepToward
D $CB44 Nudge the task-four creature one character toward its target.
R $CB44 IX Address of complex state data for an entity
  $CB44,$03 Load #REGa with the current entity's extra state.
  $CB47,$04 Is bit #N$04 of the current entity's extra state set? If not, jump
. to #R$CB52.
  $CB4B,$02 Clear bit #N$04 of the flag byte in #REGa.
  $CB4D,$03 Set the current entity's extra state.
  $CB50,$02 Jump to #R$CB57 to continue this routine.
N $CB52 Require extra-state bit #N$02 before stepping; otherwise bail to the
. next script.
@ $CB52 label=ScriptRoutine_TaskFourStepToward_RequireExtraBit2
  $CB52,$05 Is bit #N$02 of the current entity's extra state set? If so, jump to
. #R$EC2E.
N $CB57 At extra-state ends (#N$0B or #N$00), reverse the signed step via
. #R$CBB8.
@ $CB57 label=ScriptRoutine_TaskFourStepToward_MaybeNegateDelta
  $CB57,$03 Load #REGa with the current entity's extra state.
  $CB5A,$05 Is the current entity's extra state equal to #N$0B? If so, call
. #R$CBB8.
  $CB5F,$04 Is #REGa zero? If so, call #R$CBB8.
N $CB63 Apply the signed step: grow or shrink extra state, then rewrite X /
. X-extent.
@ $CB63 label=ScriptRoutine_TaskFourStepToward_ApplySignedStep
  $CB63,$03 Load #REGc with the current entity's direction / state.
  $CB66,$04 Is bit #N$07 of the direction/state in #REGc set (negative delta)?
. If so, jump to #R$CB6D.
  $CB6A,$01 Advance the current entity's extra state by one.
  $CB6B,$02 Jump to #R$CB6E to continue this routine.
N $CB6D Negative delta path: shrink extra state before rewriting coordinates.
@ $CB6D label=ScriptRoutine_TaskFourStepToward_DecExtraState
  $CB6D,$01 Step the current entity's extra state back by one.
N $CB6E Commit the stepped X band, clear latch bit #N($04), and at X=#N$6C raise
. it and maybe reverse.
@ $CB6E label=ScriptRoutine_TaskFourStepToward_WriteCoordsAndFlags
  $CB6E,$03 Set the current entity's extra state.
  $CB71,$01 Copy the saved count/flag from #REGc into #REGa.
  $CB72,$03 Add the current entity's x-coordinate to #REGa.
  $CB75,$03 Set the current entity's x-coordinate.
  $CB78,$01 Copy the saved count/flag from #REGc into #REGa.
  $CB79,$03 Add the current entity's x-extent to #REGa.
  $CB7C,$03 Set the current entity's x-extent.
  $CB7F,$03 Load #REGa with the game event flags (#R$72B3).
  $CB82,$02 Clear bit #N$04 of the flag byte in #REGa.
  $CB84,$03 Set the game event flags (#R$72B3).
  $CB87,$03 Load #REGa with the current entity's x-coordinate.
  $CB8A,$05 Is the current entity's x-coordinate equal to #N$6C? If not, jump to
. #R$EC2E.
  $CB8F,$03 Load #REGa with the game event flags (#R$72B3).
  $CB92,$02 Set bit #N$04 of game event flags.
  $CB94,$03 Set the game event flags (#R$72B3).
  $CB97,$04 Is bit #N$01 of game event flags set? If not, jump to #R$CBA1.
  $CB9B,$03 Point #REGhl at task-four script entry #R$CA9B.
  $CB9E,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $CBA1 At the turnaround X, retrace only when aligned with the vat
. (#R$9071) in room #N$03.
@ $CBA1 label=ScriptRoutine_TaskFourStepToward_MatchCreatureThenRetrace
  $CBA1,$04 Point #REGiy at the vat entity at #R$9071.
  $CBA5,$03 Load #REGa with the current entity's x-coordinate.
  $CBA8,$06 Does this entity's x match the referenced entity's x (#REGiy+#N$07)?
. If not, jump to #R$EC2E.
  $CBAE,$03 Load #REGa with the referenced entity's room index.
  $CBB1,$05 Is referenced entity's room index equal to #N$03? If not, jump to
. #R$EC2E.
  $CBB6,$02 Jump to #R$CB63 to continue this routine.
N $CBB8 Negate the stored direction / step delta so the entity walks the other
. way.
@ $CBB8 label=ScriptRoutine_TaskFourStepToward_NegateDirection
  $CBB8,$01 Stash #REGaf on the stack.
  $CBB9,$03 Load #REGa with the current entity's direction / state.
  $CBBC,$02 Negate #REGa (flip a delta/direction).
  $CBBE,$03 Set the current entity's direction / state.
  $CBC1,$01 Restore #REGaf from the stack.
  $CBC2,$01 Return.

c $CBC3 Script Routine: (#N$4E) Task-four entity action
@ $CBC3 label=ScriptRoutine_TaskFourArmScriptFlags
D $CBC3 Arm the task-four script-active flags for the following beats.
  $CBC3,$03 Load #REGa with the game event flags (#R$72B3).
  $CBC6,$02,b$01 Set bits #N$07 and #N$04 of #R$72B3 (task entity script active
. + upstairs event latch).
  $CBC8,$03 Set the game event flags (#R$72B3).
  $CBCB,$03 Jump to #R$EC2E to run the next script instruction.

c $CBCE Script Routine: (#N$4D) Task-four entity action
@ $CBCE label=ScriptRoutine_TaskFourTickOfferItem
D $CBCE Tick the task-four offer-item timer that gates its dialogue.
R $CBCE IX Address of complex state data for an entity
  $CBCE,$03 Load the shared tick (#R$72C2) into #REGa.
  $CBD1,$03 Is the shared tick (#R$72C2) zero? If not, jump to #R$CBDB.
  $CBD4,$04 Reset bit #N$02 of the current entity's extra state.
  $CBD8,$03 Jump to #R$EC2E to run the next script instruction.
N $CBDB Tick #R$72C2, flash layout #R$A166 on the creature, and test whether the
. offered item is hit.
@ $CBDB label=ScriptRoutine_TaskFourTickOfferItem_TickAndOfferItem
  $CBDB,$01 Step the shared tick back by one.
  $CBDC,$03 Store the shared tick (#R$72C2).
  $CBDF,$04 Point #REGiy at the vat entity at #R$9071.
  $CBE3,$03 Point #REGbc at graphic layout #R$A166.
  $CBE6,$04 Store #REGbc in the inactive complex-entity slot fields at
. #R$8EF3(#N$907B).
  $CBEA,$04 Set bit #N$03 of the current entity's extra state.
  $CBEE,$03 Load #REGa with the referenced entity's x-extent.
  $CBF1,$01 Advance referenced entity's x-extent by one.
  $CBF2,$03 Load #REGc with the referenced entity's room index.
  $CBF5,$04 Point #REGiy at the task-item entity (#R$900F).
  $CBF9,$06 Does this entity's x match the referenced entity's x (#REGiy+#N$07)?
. If so, jump to #R$CC12.
N $CBFF Missed the offered item: set interaction bit #N$02 of #R$72B9 and clear
. the offer latch.
@ $CBFF label=ScriptRoutine_TaskFourTickOfferItem_MissItemSetFlags
  $CBFF,$03 Load #REGa with the entity interaction flag (#R$72B9).
  $CC02,$02 Set bit #N$02 of #R$72B9.
  $CC04,$03 Set the entity interaction flag (#R$72B9).
  $CC07,$04 Set bit #N$04 of the current entity's extra state.
  $CC0B,$04 Reset bit #N$02 of the current entity's extra state.
  $CC0F,$03 Jump to #R$EC2E to run the next script instruction.
N $CC12 Hit the offered item: play the vat cue, clear the miss flag, and advance
. its layout animation.
@ $CC12 label=ScriptRoutine_TaskFourTickOfferItem_HitItemAdvanceAnim
  $CC12,$01 Copy the saved count/flag from #REGc into #REGa.
  $CC13,$05 Does this entity share the referenced entity's room (#REGiy+#N$04)?
. If not, jump to #R$CBFF.
N $CC18 #HTML(#AUDIO0(vat.wav)(#INCLUDE(Vat)))
  $CC18,$02 Load #REGa with #N$91.
  $CC1A,$03 Call #R$F8F9 to queue a sound effect.
  $CC1D,$04 Write #N$80 to the referenced entity's flags byte 2.
  $CC21,$03 Load #REGa with the entity interaction flag (#R$72B9).
  $CC24,$02 Clear bit #N$02 of the flag byte in #REGa.
  $CC26,$03 Set the entity interaction flag (#R$72B9).
  $CC29,$03 Load #REGa with the animation frame counter (#R$72C1).
  $CC2C,$01 Advance animation frame counter by one.
  $CC2D,$03 Set the animation frame counter (#R$72C1).
  $CC30,$03 Load #REGa with the referenced entity's direction / state.
  $CC33,$01 Advance referenced entity's direction / state by one.
  $CC34,$03 Set the referenced entity's direction / state.
  $CC37,$01 Stash #REGhl on the stack.
  $CC38,$03 Point #REGhl at task-four script data #R$CC4B.
  $CC3B,$01 Double #REGa to form a word index into the script/handler table.
  $CC3C,$01 Keep the index in #REGc.
  $CC3D,$02 Clear #REGb so #REGbc is the word index into #R$CC4B.
  $CC3F,$01 Add the length/offset in #REGbc to the pointer in #REGhl.
  $CC40,$03 Fetch the new script address into #REGbc.
  $CC43,$01 Restore #REGhl from the stack.
  $CC44,$04 Store #REGbc in the task-item entity's layout field
. (#R$8EF3(#N$9019)).
  $CC48,$03 Jump to #R$EC2E to run the next script instruction.
  $CC4B,$01 Copy referenced entity's direction / state into #REGd.
  $CC4C,$01 Mask referenced entity's direction / state with #REGb.
  $CC4D,$01 Copy the low byte from #REGe into #REGc (build a count/address).
  $CC4E,$01 Mask referenced entity's direction / state with #REGb.
  $CC4F,$01 Copy the low byte from #REGl into #REGb (build a count/address).
  $CC50,$01 Mask referenced entity's direction / state with #REGb.
  $CC51,$01 Invert the success marker.
  $CC52,$01 Mask referenced entity's direction / state with #REGb.

c $CC53 Script Routine: (#N$49) Task-four entity action
@ $CC53 label=ScriptRoutine_TaskFourRaiseY
D $CC53 Raise the task-four creature one character.
R $CC53 IX Address of complex state data for an entity
  $CC53,$03 Load #REGa with the current entity's y-coordinate.
  $CC56,$02 Subtract #N$04 from #REGa.
  $CC58,$03 Set the current entity's y-coordinate.
  $CC5B,$03 Load #REGa with the current entity's y-extent.
  $CC5E,$02 Subtract #N$04 from #REGa.
  $CC60,$03 Set the current entity's y-extent.
  $CC63,$07 Is bit #N$03 of the current entity's extra state set? If not, jump
. to #R$EC2E.
  $CC6A,$04 Reset bit #N$03 of the current entity's extra state.
  $CC6E,$03 Point #REGbc at the vat layout (#R$A18B).
  $CC71,$04 Store #REGbc in the inactive complex-entity slot fields at
. #R$8EF3(#N$907B).
  $CC75,$03 Jump to #R$EC2E to run the next script instruction.

c $CC78 Script Routine: (#N$4A) Task-four entity action
@ $CC78 label=ScriptRoutine_TaskFourLowerY
D $CC78 Lower the task-four creature one character.
R $CC78 IX Address of complex state data for an entity
  $CC78,$03 Load #REGa with the current entity's y-coordinate.
  $CC7B,$02 Add #N$04 to #REGa (step a coordinate/index).
  $CC7D,$03 Set the current entity's y-coordinate.
  $CC80,$03 Load #REGa with the current entity's y-extent.
  $CC83,$02 Add #N$04 to #REGa (step a coordinate/index).
  $CC85,$03 Set the current entity's y-extent.
  $CC88,$03 Jump to #R$EC2E to run the next script instruction.

c $CC8B Script Routine: (#N$4C) Task-four entity action
@ $CC8B label=ScriptRoutine_TaskFourBerkOverlap
D $CC8B Test whether the task-four creature currently overlaps Berk.
R $CC8B IX Address of complex state data for an entity
N $CC8B #HTML(#AUDIO0(thump.wav)(#INCLUDE(Thump)))
  $CC8B,$02 Load #REGa with #N$8E.
  $CC8D,$03 Call #R$F8F9 to queue a sound effect.
  $CC90,$03 Load #REGa with Berk's room-index copy (#R$7305).
  $CC93,$05 Is Berk in the same room as this entity (#REGix+#N$04)? If so, jump
. to #R$CC9F.
  $CC98,$01 Advance Berk's room-index copy by one.
  $CC99,$06 Is Berk in the same room as this entity (#REGix+#N$04)? If not, jump
. to #R$EC2E.
N $CC9F Same-room Berk overlap: if X bands intersect, treat it as a door /
. interaction hit via #R$EA73.
@ $CC9F label=ScriptRoutine_TaskFourBerkOverlap_TestBerkOverlap
  $CC9F,$03 Load #REGa with Berk's X-extent copy (#R$7304).
  $CCA2,$06 Is Berk's X-extent copy left of this entity's x (#REGix+#N$07)? If
. so, no overlap, jump to #R$EC2E.
  $CCA8,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $CCAB,$01 Keep Berk's X coordinate in #REGc.
  $CCAC,$03 Load #REGa with the current entity's x-extent.
  $CCAF,$04 Is this entity's x-extent left of Berk's X-coordinate copy
. (#R$7303)? If so, no overlap, jump to #R$EC2E.
  $CCB3,$03 Call #R$EA73 to handle the door / interaction hit.
N $CCB6 Advance to the next script instruction after the Berk-overlap hit.
@ $CCB6 label=ScriptRoutine_TaskFourBerkOverlap_NextScript
  $CCB6,$03 Jump to #R$EC2E to run the next script instruction.

b $CCB9 Data: Task Four Script / Table Residue
@ $CCB9 label=Data_TaskFourResidue
D $CCB9 Data following script routine #R$CC8B (not executable code).
N $CCB9 #UDGTABLE { #SCRIPTANIM$CCB9(script-ccb9) } UDGTABLE#
B $CCB9,$01 Load the stored coordinates and return.
B $CCBA,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $CCBD,$0B,$0B Increment the index and jump to one of #R$CCC8, #R$CCCE,
. #R$CCD4, #R$CCCE.
N $CCC8 #UDGTABLE { #LAYOUT$C8,$CC(layout-ccc8) } UDGTABLE#
B $CCC8,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCCB,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CCCE #UDGTABLE { #LAYOUT$CE,$CC(layout-ccce) } UDGTABLE#
B $CCCE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCD1,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CCD4 #UDGTABLE { #LAYOUT$D4,$CC(layout-ccd4) } UDGTABLE#
B $CCD4,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCD7,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CCDA #UDGTABLE { #LAYOUT$DA,$CC,$00,$04(layout-ccda) } UDGTABLE#
B $CCDA,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCDD,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CCE0 #UDGTABLE { #LAYOUT$E0,$CC,$00,$04(layout-cce0) } UDGTABLE#
B $CCE0,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCE3,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CCE6 #UDGTABLE { #LAYOUT$E6,$CC,$00,$04,$23(layout-cce6) } UDGTABLE#
B $CCE6,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCE9,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CCEC #UDGTABLE { #LAYOUT$EC,$CC(layout-ccec) } UDGTABLE#
B $CCEC,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $CCEE,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CCF1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CCF4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CCF7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CCFA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CCFD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD00,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD03,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CD06 #UDGTABLE { #LAYOUT$06,$CD,$00,$04(layout-cd06) } UDGTABLE#
B $CD06,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $CD08,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $CD0B,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CD0E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CD11,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD14,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD17,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD1A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD1D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD20,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD23,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD35,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CD38 #UDGTABLE { #LAYOUT$38,$CD,$00,$04(layout-cd38) } UDGTABLE#
B $CD38,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $CD3A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $CD3D,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $CD40,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CD43,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD46,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD49,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD4C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD4F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD52,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD55,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD58,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD5B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD5E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD61,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD64,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD67,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD6A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD6D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD70,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD73,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD76,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD79,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD7C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD7F,$01 Load the stored coordinates and return.
N $CD80 #UDGTABLE { #LAYOUT$80,$CD,$00,$04(layout-cd80) } UDGTABLE#
B $CD80,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD83,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD86,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD89,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD8C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD8F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD92,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD95,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CD98,$01 Load the stored coordinates and return.
N $CD99 #UDGTABLE { #LAYOUT$99,$CD,$00,$04(layout-cd99) } UDGTABLE#
B $CD99,$0F,$0F Jump to a time-weighted random layout address (#R$CDA8,
. #R$CDB4, #R$CDC0).
N $CDA8 #UDGTABLE { #LAYOUT$A8,$CD,$00,$04(layout-cda8) } UDGTABLE#
B $CDA8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CDAB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDAE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDB1,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).
N $CDB4 #UDGTABLE { #LAYOUT$B4,$CD,$00,$04(layout-cdb4) } UDGTABLE#
B $CDB4,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CDB7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDBA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDBD,$03 Jump to the layout at #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100).

b $CDC0 Graphic Layout Data: Ghost And Plant
@ $CDC0 label=GraphicLayout_GhostAndPlant
D $CDC0 Layout branches used by the ghost / plant-pot routines, including the F9
. entry at this address and F8 targets #R$CDC9, #R$CDE5, #R$CE01 and #R$CE23.
N $CDC0 #UDGTABLE { #LAYOUT$C0,$CD,$00,$04(layout-cdc0) } UDGTABLE#
B $CDC0,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CDC3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDC6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
N $CDC9 #UDGTABLE { #LAYOUT$C9,$CD,$00,$04(layout-cdc9) } UDGTABLE#
B $CDC9,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CDCC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDCF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDD2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDD5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDD8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDDB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDDE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDE1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDE4,$01 Load the stored coordinates and return.
N $CDE5 #UDGTABLE { #LAYOUT$E5,$CD,$00,$04(layout-cde5) } UDGTABLE#
B $CDE5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CDE8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDEB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDEE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDF1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDF4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDF7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDFA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CDFD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE00,$01 Load the stored coordinates and return.
N $CE01 #UDGTABLE { #LAYOUT$01,$CE,$00,$04(layout-ce01) } UDGTABLE#
B $CE01,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CE04,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE07,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE0A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE0D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE10,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE13,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE16,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE19,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE1C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE1F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE22,$01 Load the stored coordinates and return.
N $CE23 #UDGTABLE { #LAYOUT$23,$CE,$00,$04(layout-ce23) } UDGTABLE#
B $CE23,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $CE26,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE29,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE2C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE2F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE32,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE35,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE38,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE3B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE3E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE41,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE44,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE47,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $CE4A,$01 Load the stored coordinates and return.

c $CE4B Update Ghosts
@ $CE4B label=Update_Ghosts
D $CE4B Update the ghost entities: clear their interaction latch, walk their
. scripts and queue a moan if one is active.
  $CE4B,$03 Point #REGhl at the entity interaction flag (#R$72B9).
  $CE4E,$03 Is bit #N$03 of #R$72B9 set? If not, return.
  $CE51,$02 Clear bit #N$03 of #R$72B9.
  $CE53,$04 Point #REGix at the plant-pot complex entity (#R$8F75).
  $CE57,$02 Load #REGb with #N$03 as a loop counter.
N $CE59 Scan each ghost slot: idle ones skip; active ones tick their delay or
. advance a moan frame.
@ $CE59 label=Update_Ghosts_Scan
  $CE59,$03 Load #REGa with the current entity's direction / state.
  $CE5C,$03 Is the current entity's direction / state zero? If so, jump to
. #R$CEBF.
  $CE5F,$04 Is the current entity's direction / state less than #N$0B? If not,
. jump to #R$CEBF.
  $CE63,$03 Load #REGa with the current entity's extra state.
  $CE66,$03 Is the current entity's extra state zero? If so, jump to #R$CE6E.
  $CE69,$03 Decrease the current entity's extra state.
  $CE6C,$02 Jump to #R$CEBD to mark this ghost slot done.
N $CE6E Advance the ghost frame; at the end spawn a plant shoot via #R$CEE1 and
. raise game-event bit #N$00.
@ $CE6E label=Update_Ghosts_AdvanceFrame
  $CE6E,$03 Load #REGa with the current entity's direction / state.
  $CE71,$04 Is the current entity's direction / state less than #N$0A? If so,
. jump to #R$CE8B.
  $CE75,$02 Load #REGc with #N$0C (vertical offset passed to #R$CEE1).
  $CE77,$03 Call #R$CEE1 to update Plant Pots.
  $CE7A,$04 Set bit #N$07 of the referenced entity's flags byte 1.
  $CE7E,$03 Increment the referenced entity's room index.
  $CE81,$03 Load #REGa with the game event flags (#R$72B3).
  $CE84,$02 Set bit #N$00 of game event flags.
  $CE86,$03 Set the game event flags (#R$72B3).
  $CE89,$02 Load #REGa with #N$0A.
N $CE8B Install the next ghost layout from table #R$CEC9; frame #N$07 uses a
. fixed moan delay.
@ $CE8B label=Update_Ghosts_WriteLayoutFromTable
  $CE8B,$01 Advance the ghost frame index in #REGa by one.
  $CE8C,$03 Set the current entity's direction / state.
  $CE8F,$01 Double #N$0A (word index).
  $CE90,$01 Keep #N$0A in #REGe for later.
  $CE91,$02 Clear #REGd (high byte of a pointer/offset).
  $CE93,$01 Stash #REGhl on the stack.
  $CE94,$03 Point #REGhl at ghost script/table data (#R$CEC9).
  $CE97,$01 Add the offset in #REGde to the pointer in #REGhl.
  $CE98,$01 Fetch the next byte from #R$CEC9.
  $CE99,$03 Set the current entity's graphic layout address (low).
  $CE9C,$01 Advance #R$CEC9 by one byte.
  $CE9D,$01 Fetch the next byte from #R$CEC9.
  $CE9E,$03 Set the current entity's graphic layout address (high).
  $CEA1,$01 Restore #REGhl from the stack.
  $CEA2,$03 Load #REGa with the current entity's direction / state.
  $CEA5,$04 Is the current entity's direction / state equal to #N$07? If not,
. jump to #R$CEAD.
  $CEA9,$02 Load #REGa with #N$05.
  $CEAB,$02 Jump to #R$CEB5 to store the ghost's extra state.
N $CEAD Pick a random extra-state delay from the current frame index.
@ $CEAD label=Update_Ghosts_RandomExtraState
  $CEAD,$01 Double the frame index in #REGa.
  $CEAE,$02 Multiply #REGa by #N$04 to form a table index.
  $CEB0,$01 Keep #N$05 in #REGc for later.
  $CEB1,$04 Call #R$EAE5 to pick a pseudo-random value and add the saved count
. in #REGc.
N $CEB5 Arm the ghost's moan delay and queue sound #N$0F via #R$F8F9.
@ $CEB5 label=Update_Ghosts_StoreExtraAndMoan
  $CEB5,$03 Set the current entity's extra state.
N $CEB8 #HTML(#AUDIO0(ghost.wav)(#INCLUDE(Ghost)))
  $CEB8,$02 Load #REGa with #N$0F.
  $CEBA,$03 Call #R$F8F9 to queue a sound effect.
N $CEBD Retrigger interaction bit #N$03 of #R$72B9 so #R$CE4B will scan again.
@ $CEBD label=Update_Ghosts_RetriggerBit3
  $CEBD,$02 Set bit #N$03 of #R$72B9.
N $CEBF Advance to the next ghost slot and loop until all #N$03 are done.
@ $CEBF label=Update_Ghosts_AdvanceSlot
  $CEBF,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
  $CEC2,$02 Advance #REGix to the next entity record.
  $CEC4,$01 Step the loop counter in #REGb back by one.
  $CEC5,$03 If the result was non-zero, jump to #R$CE59.
  $CEC8,$01 Return.
  $CEC9,$01 Add #REGd into #REGa while building a 16-bit entity/screen address.
  $CECA,$01 Mask #N$0F with #REGb.
  $CECB,$01 Add #REGd into #REGa while building a 16-bit entity/screen address.
  $CECC,$03 Mask #REGa with #REGb.
  $CECF,$01 Toggle bits of the flag byte in #REGa using #REGc.
  $CED0,$01 Mask #N$0F with #REGb.
  $CED1,$01 Clear #REGa.
  $CED2,$01 Mask #N$0F with #REGb.
  $CED3,$01 Merge another flag byte into #N$0F.
  $CED4,$01 Mask #N$0F with #REGb.
  $CED5,$01 Compare #N$0F with #REGe.
  $CED6,$01 Mask #N$0F with #REGb.
  $CED7,$02 Add #N$A0 into #REGa (with carry) for an attribute address.
  $CED9,$03 If a hit/borrow was signaled, jump to #R$E376(#N$E3A0).
  $CEDC,$01 Mask #N$0F with #REGb.
  $CEDD,$03 Jump to #R$F8A0 if the sign flag is reset.
  $CEE0,$01 Mask #N$0F with #REGb.

c $CEE1 Update Plant Pots
@ $CEE1 label=Update_Plant_Pots
D $CEE1 Spawn a plant shoot into the first free collectible-eye slot when a pot
. germinates. #REGix addresses the pot; free slots are sought from #R$8F4B
. onwards.
R $CEE1 IX Address of the plant-pot complex state data
R $CEE1 C Vertical offset applied when placing the shoot above the pot
N $CEE1 Stash #REGde (caller-preserved) while the free eye slot is found.
  $CEE1,$01 Stash #REGde on the stack.
  $CEE2,$04 Point #REGiy at the first collectible-eye slot (#R$8F4B).
  $CEE6,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGde.
N $CEE9 Find the first free collectible-eye slot.
@ $CEE9 label=Update_Plant_Pots_FindFreeSlot
  $CEE9,$04 Fetch this eye slot's entity type, then is the slot empty (type
. #N$00)?.
  $CEED,$02 If so, plant the shoot here at #R$CEF3.
  $CEEF,$02 Otherwise advance #REGiy to the next entity record.
  $CEF1,$02 Keep scanning at #R$CEE9.
N $CEF3 Place the shoot in that slot, matching the pot's room and position.
@ $CEF3 label=Update_Plant_Pots_PlaceShoot
  $CEF3,$04 Mark the free slot as a plant shoot (type #N$0E).
  $CEF7,$03 Load the pot's y-coordinate.
  $CEFA,$01 Raise the shoot by the caller's offset in #REGc.
  $CEFB,$03 Write that as the shoot's y-coordinate.
  $CEFE,$02 Make the shoot two characters tall.
  $CF00,$03 Write the shoot's y-extent.
  $CF03,$03 Fetch the pot's x-coordinate.
  $CF06,$03 Place the shoot on the same x.
  $CF09,$02 Make the shoot two characters wide.
  $CF0B,$03 Write the shoot's x-extent.
  $CF0E,$03 Fetch the pot's room index.
  $CF11,$03 Keep the shoot in the same room as the pot.
  $CF14,$08 Set the shoot's graphic layout to #R$A11B.
  $CF1C,$01 Restore #REGde from the stack.
  $CF1D,$01 Return.

c $CF1E Update Crusher
@ $CF1E label=Update_Crusher
D $CF1E Called from #R$B2AA on the crusher entity path: set bit #N$04 of
. #R$72B9, advance the shared tick at #R$72C2, and once that tick reaches
. #N$03 also set bit #N$06. Bit #N$07 is set on every call.
N $CF1E Mark Berk crushed and advance the shared tick.
  $CF1E,$01 Stash #REGhl on the stack.
  $CF1F,$03 Point #REGhl at the entity interaction flag (#R$72B9).
  $CF22,$02 Set bit #N$04 of #R$72B9.
  $CF24,$03 Load the shared tick (#R$72C2) into #REGa.
  $CF27,$01 Advance the shared tick by one.
  $CF28,$03 Store the shared tick (#R$72C2).
  $CF2B,$04 Is the shared tick still under #N$03? If so, skip bit #N$06 at
. #R$CF31.
  $CF2F,$02 Set bit #N$06 of #R$72B9.
N $CF31 Raise bit #N$07 of #R$72B9 and return.
@ $CF31 label=Update_Crusher_Active
  $CF31,$02 Set bit #N$07 of #R$72B9.
  $CF33,$01 Restore #REGhl from the stack.
  $CF34,$01 Return.

g $CF35 Temporary Entity Pointer
@ $CF35 label=TemporaryEntityPointer_Misc
D $CF35 Pointer used while updating miscellaneous entities.
W $CF35,$02

c $CF37 Update Miscellaneous Entities
@ $CF37 label=Update_Miscellaneous_Entities
D $CF37 Per-frame hook for non-task entities: refresh collectibles and the vat,
. then snapshot the script cursor so the next vat pass can reload it.
  $CF37,$03 Call #R$D45B to update Collectibles.
  $CF3A,$03 Call #R$D012 to update Vat.
N $CF3D Copy the script position from #R$72CF to #R$72D3 so #R$D012 can reload
. that cursor into #R$72CF on its next entry.
  $CF3D,$03 Load #REGhl with the active script cursor (#R$72CF).
  $CF40,$03 Store #REGhl in the Drutt script-position pointer (#R$72D3).
  $CF43,$01 Return.


b $CF44 Data: Drutt Scripts
@ $CF44 label=Data_DruttScripts
D $CF44 Drutt animation scripts. The type-#N$0C entity in the crusher slot
. at #R$8FC9 uses Drutt's layout #R$D234. #R$D030 runs #R$CF44 when that
. entity is active. #R$D057 enters #R$CF88, #R$D0E0 enters #R$CFFE, and
. #R$D22E enters #R$CFF4.
N $CF44 Idle and bubble script entered from #R$D030.
N $CF44 #UDGTABLE { #SCRIPTANIM$CF44(script-cf44) } UDGTABLE#
  $CF44,$04 Graphic-layout pointer #R$D25C; Graphic-layout pointer
. #R$D234.
  $CF48,$02 Graphic-layout pointer #R$D243.
  $CF4A,$02 Graphic-layout pointer #R$D243.
  $CF4C,$02 Graphic-layout pointer #R$D234.
  $CF4E,$02 Graphic-layout pointer #R$D243.
  $CF50,$02 Graphic-layout pointer #R$D243.
W $CF52,$02 Script opcode #N$3E (Drutt action).
N $CF54 Near-range Drutt script.
@ $CF54 label=DruttScript_Near
  $CF54,$02 Graphic-layout pointer #R$D2B1.
W $CF56,$02 Script opcode #N$40 (Drutt action).
  $CF58,$02 Graphic-layout pointer #R$D2C5.
W $CF5A,$02 Script opcode #N$40 (Drutt action).
  $CF5C,$02 Graphic-layout pointer #R$D2D2.
W $CF5E,$02 Script opcode #N$43 (Drutt action).
W $CF60,$02 Script opcode #N$42 (Drutt action).
  $CF62,$02 Graphic-layout pointer #R$D2DC.
W $CF64,$02 Script opcode #N$42 (Drutt action).
W $CF66,$02 Script opcode #N$3E (Drutt action).
W $CF68,$02 Script opcode #N$42 (Drutt action).
  $CF6A,$02 Graphic-layout pointer #R$D2DC.
W $CF6C,$02 Script opcode #N$42 (Drutt action).
  $CF6E,$02 Graphic-layout pointer #R$D2DC.
W $CF70,$02 Script opcode #N$44 (Drutt action).
  $CF72,$02 Graphic-layout pointer #R$D2B1.
W $CF74,$02 Script opcode #N$3E (Drutt action).
N $CF76 Alternate Drutt script.
@ $CF76 label=DruttScript_Alt
  $CF76,$02 Graphic-layout pointer #R$D2B1.
W $CF78,$02 Script opcode #N$40 (Drutt action).
  $CF7A,$02 Graphic-layout pointer #R$D2C5.
W $CF7C,$02 Script opcode #N$40 (Drutt action).
  $CF7E,$02 Graphic-layout pointer #R$D2D2.
W $CF80,$02 Script opcode #N$42 (Drutt action).
  $CF82,$02 Graphic-layout pointer #R$D2DC.
W $CF84,$02 Script opcode #N$44 (Drutt action).
W $CF86,$02 Script opcode #N$3E (Drutt action).
N $CF88 Drutt script launched after copying the template.
@ $CF88 label=DruttScript_Copy
  $CF88,$02 Graphic-layout pointer #R$D2FB.
W $CF8A,$02 Script opcode #N$3F (Drutt action).
  $CF8C,$02 Graphic-layout pointer #R$D30F.
W $CF8E,$02 Script opcode #N$3F (Drutt action).
  $CF90,$02 Graphic-layout pointer #R$D31C.
W $CF92,$02 Script opcode #N$43 (Drutt action).
W $CF94,$02 Script opcode #N$41 (Drutt action).
  $CF96,$02 Graphic-layout pointer #R$D326.
W $CF98,$02 Script opcode #N$41 (Drutt action).
W $CF9A,$02 Script opcode #N$3E (Drutt action).
W $CF9C,$02 Script opcode #N$41 (Drutt action).
  $CF9E,$02 Graphic-layout pointer #R$D326.
W $CFA0,$02 Script opcode #N$41 (Drutt action).
  $CFA2,$02 Graphic-layout pointer #R$D326.
W $CFA4,$02 Script opcode #N$44 (Drutt action).
  $CFA6,$02 Graphic-layout pointer #R$D2FB.
W $CFA8,$02 Script opcode #N$3E (Drutt action).
N $CFAA Drutt script used when the scan picks a candidate.
@ $CFAA label=DruttScript_Scan
  $CFAA,$02 Graphic-layout pointer #R$D2FB.
W $CFAC,$02 Script opcode #N$3F (Drutt action).
  $CFAE,$02 Graphic-layout pointer #R$D30F.
W $CFB0,$02 Script opcode #N$3F (Drutt action).
  $CFB2,$02 Graphic-layout pointer #R$D31C.
W $CFB4,$02 Script opcode #N$41 (Drutt action).
  $CFB6,$02 Graphic-layout pointer #R$D326.
W $CFB8,$02 Script opcode #N$44 (Drutt action).
W $CFBA,$02 Script opcode #N$3E (Drutt action).
  $CFBC,$02 Graphic-layout pointer #R$D275.
W $CFBE,$02 Script opcode #N$45 (Drutt action).
W $CFC0,$02 Script opcode #N$45 (Drutt action).
  $CFC2,$02 Graphic-layout pointer #R$D28D.
W $CFC4,$02 Script opcode #N$45 (Drutt action).
W $CFC6,$02 Script opcode #N$45 (Drutt action).
  $CFC8,$02 Graphic-layout pointer #R$D28D.
W $CFCA,$02 Script opcode #N$46 (Drutt action).
  $CFCC,$02 Graphic-layout pointer #R$D28D.
W $CFCE,$02 Script opcode #N$44 (Drutt action).
W $CFD0,$02 Script opcode #N$44 (Drutt action).
  $CFD2,$02 Graphic-layout pointer #R$D28D.
W $CFD4,$02 Script opcode #N$44 (Drutt action).
W $CFD6,$02 Script opcode #N$44 (Drutt action).
W $CFD8,$02 Script opcode #N$3E (Drutt action).
  $CFDA,$02 Graphic-layout pointer #R$D234.
W $CFDC,$02 Script opcode #N$45 (Drutt action).
W $CFDE,$02 Script opcode #N$45 (Drutt action).
  $CFE0,$02 Graphic-layout pointer #R$D25C.
W $CFE2,$02 Script opcode #N$45 (Drutt action).
W $CFE4,$02 Script opcode #N$45 (Drutt action).
  $CFE6,$02 Graphic-layout pointer #R$D25C.
W $CFE8,$02 Script opcode #N$44 (Drutt action).
W $CFEA,$02 Script opcode #N$44 (Drutt action).
  $CFEC,$02 Graphic-layout pointer #R$D25C.
W $CFEE,$02 Script opcode #N$44 (Drutt action).
W $CFF0,$02 Script opcode #N$44 (Drutt action).
W $CFF2,$02 Script opcode #N$3E (Drutt action).
W $CFF4,$02 Script opcode #N$44 (Drutt action).
W $CFF6,$02 Script opcode #N$44 (Drutt action).
  $CFF8,$02 Graphic-layout pointer #R$D28D.
W $CFFA,$02 Script opcode #N$44 (Drutt action).
W $CFFC,$02 Script opcode #N$44 (Drutt action).
  $CFFE,$02 Graphic-layout pointer #R$D389.
W $D000,$02 Script opcode #N$47 (Drutt action).
  $D002,$02 Graphic-layout pointer #R$D389.
  $D004,$02 Graphic-layout pointer #R$D389.
  $D006,$02 Graphic-layout pointer #R$D389.
  $D008,$02 Graphic-layout pointer #R$D371.
  $D00A,$02 Graphic-layout pointer #R$D371.
  $D00C,$02 Graphic-layout pointer #R$D371.
  $D00E,$02 Graphic-layout pointer #R$D371.
W $D010,$02 Script opcode #N$3E (Drutt action).

c $D012 Update Vat
@ $D012 label=Update_Vat
D $D012 Animate the vat entity for the current room: bubble state, contained
. objects and whether Berk can interact.
  $D012,$03 Load #REGhl with the Drutt script-position pointer
. (#R$72D3).
  $D015,$03 Store #REGhl in the active script cursor (#R$72CF).
  $D018,$04 Point #REGix at the crusher entity (#R$8FC9).
  $D01C,$03 Fetch the current entity's type for the type test.
  $D01F,$04 Is the current entity's entity type equal to #N$0C? If not, jump to
. #R$D040.
  $D023,$06 Is bit #N$07 of the current entity's flags byte 1 set? If so, jump
. to #R$D030.
  $D029,$07 Is bit #N$00 of the current entity's flags byte 2 set? If not,
. jump to #R$EC2E.
N $D030 Run the Drutt script at #R$CF44 for an active type-#N$0C entity.
@ $D030 label=Update_Drutt_RunScript
  $D030,$03 Point #REGhl at the Drutt script (#R$CF44).
  $D033,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

b $D036 Crusher Entity Template
@ $D036 label=Data_CrusherEntityTemplate
D $D036 Ten-byte entity template copied into the crusher slot by #R$D040.
  $D036,$0A Bytes: #N($0C), #N($03), #N($00), #N($00), #N($04), #N($26),
. #N($26), #N($6E), #N($6E), #N$00.

c $D040 Update Vat: Event And Direction
@ $D040 label=Update_Vat_TestEventAndDirBit0
D $D040 When the vat entity is not type #N($0C), test game-event / direction
. bits and either copy the #R$D036 template into the crusher slot or randomly
. set direction bit #N$00.
N $D040 Load game-event flags and test direction bit #N$00.
  $D040,$03 Load #REGa with the game event flags (#R$72B3).
  $D043,$04 Is bit #N$00 of the current entity's direction / state set?.
  $D047,$02 If not, jump to #R$D05D.
  $D049,$02 Is bit #N$01 of #REGa set?.
  $D04B,$01 If not, return.
  $D04C,$03 Point #REGde at the crusher entity (#R$8FC9).
  $D04F,$03 Point #REGhl at the vat template (#R$D036).
  $D052,$03 Load #REGbc with length #N($000A,$04,$04).
  $D055,$02 Copy the template into the crusher entity slot.
  $D057,$03 Point #REGhl at #R$CF88.
  $D05A,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D05D Randomly set direction bit #N$00 when bit #N$01 of #REGa is clear.
@ $D05D label=Update_Vat_RandomSetDirBit0
  $D05D,$02 Is bit #N$01 of #REGa set?.
  $D05F,$01 If so, return.
  $D060,$02 Load #REGa with #N$3C.
  $D062,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D065,$01 Is #REGa zero?.
  $D066,$01 If not, return.
  $D067,$04 Set bit #N$00 of the current entity's direction / state.
  $D06B,$01 Return.

c $D06C Script Routine: (#N$47) Vat action
@ $D06C label=ScriptRoutine_VatQueueSound
D $D06C Play the vat's action sound, then continue its script.
N $D06C #HTML(#AUDIO0(vat.wav)(#INCLUDE(Vat)))
  $D06C,$02 Load #REGa with sound index #N$11.
  $D06E,$03 Call #R$F8F9 to queue a sound effect.
  $D071,$03 Jump to #R$EC2E to run the next script instruction.

c $D074 Script Routine: (#N$3E) Vat action
@ $D074 label=ScriptRoutine_VatScanNearbySlots
D $D074 Scan nearby entity slots for something the vat can interact with.
R $D074 IX Address of complex state data for an entity
  $D074,$02 Load #REGe with #N$FF.
  $D076,$04 Point #REGiy at an inactive complex-entity slot (#R$8F9F).
  $D07A,$02 Load #REGb with #N$03 as a loop counter.
N $D07C Scan nearby type-#N$0B slots for the closest X neighbour within #N$28 of
. the vat.
@ $D07C label=ScriptRoutine_VatScanNearbySlots_ScanEntitySlot
  $D07C,$01 Stash #REGbc on the stack.
  $D07D,$03 Load #REGa with the referenced entity's entity type.
  $D080,$04 Is referenced entity's entity type equal to #N$0B? If not, jump to
. #R$D0A8.
  $D084,$06 Is bit #N$07 of the referenced entity's flags byte 1 set? If so,
. jump to #R$D0A8.
  $D08A,$03 Load #REGa with the referenced entity's y-coordinate.
  $D08D,$04 Is referenced entity's y-coordinate less than #N$1D? If so, jump to
. #R$D0A8.
  $D091,$03 Load #REGa with the current entity's x-coordinate.
  $D094,$03 Subtract the referenced entity's x-coordinate from #REGa.
  $D097,$01 Copy the signed x-delta into #REGd (bit #N$07 = sign).
  $D098,$02 Jump to #R$D09C if the subtraction did not underflow.
  $D09A,$02 Negate #REGa to get abs(x-delta).
N $D09C Keep the nearest in-range candidate in #REGe / #R$CF35.
@ $D09C label=ScriptRoutine_VatScanNearbySlots_TrackBestAbsDeltaX
  $D09C,$04 Is abs(x-delta) less than #N$28? If not, jump to #R$D0A8.
  $D0A0,$03 Is abs(x-delta) greater than or equal to the best-so-far in #REGe?
. If so, jump to #R$D0A8.
  $D0A3,$01 Store this abs(x-delta) as the new best in #REGe.
  $D0A4,$04 Store #REGiy in the miscellaneous-entity temp pointer (#R$CF35).
N $D0A8 Advance to the next candidate slot and finish the scan when #REGb hits
. zero.
@ $D0A8 label=ScriptRoutine_VatScanNearbySlots_AdvanceEntitySlot
  $D0A8,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGbc.
  $D0AB,$02 Add the offset in #REGbc to the entity pointer in #REGiy.
  $D0AD,$01 Restore #REGbc from the stack.
  $D0AE,$02 Decrease the loop counter in #REGb and jump to #R$D07C if more
. iterations remain.
  $D0B0,$02 Load #REGa with #N$28 (no-candidate sentinel matching the initial
. #REGe).
  $D0B2,$04 Was no nearer entity found (#REGe still #N$28)? If carry set, jump
. to #R$D124.
  $D0B6,$04 Load #REGiy from #R$CF35.
  $D0BA,$03 Load #REGa with the current entity's room index.
  $D0BD,$05 Does the candidate share this entity's room (#REGiy+#N$04)? If so,
. jump to #R$D0D0.
  $D0C2,$02 Jump to #R$D0CA if the result underflowed.
  $D0C4,$04 Set bit #N$03 of the current entity's direction / state.
  $D0C8,$02 Jump to #R$D0F0 to continue this routine.
N $D0CA Candidate is in a lower room: set direction bit #N$02 before choosing a
. chase script.
@ $D0CA label=ScriptRoutine_VatScanNearbySlots_SetDirBit2
  $D0CA,$04 Set bit #N$02 of the current entity's direction / state.
  $D0CE,$02 Jump to #R$D0F0 to continue this routine.
N $D0D0 Same-room and aligned in X: clear the candidate type and run the capture
. script; else check Y.
@ $D0D0 label=ScriptRoutine_VatScanNearbySlots_SameRoomCheckY
  $D0D0,$01 Copy the best abs(x-delta) from #REGe into #REGa.
  $D0D1,$03 Is the best abs(x-delta) zero? If not, jump to #R$D0F0.
  $D0D4,$03 Load #REGa with the current entity's y-coordinate.
  $D0D7,$05 Does this entity's y match the candidate's y (#REGiy+#N$05)? If not,
. jump to #R$D0E6.
  $D0DC,$04 Write #N$00 to the referenced entity's entity type.
  $D0E0,$03 Point #REGhl at Drutt script data #R$CFFE.
  $D0E3,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D0E6 Same-room Y mismatch: set direction bit #N$06 and run the lift/absorb
. script.
@ $D0E6 label=ScriptRoutine_VatScanNearbySlots_YMismatchSetBit6
  $D0E6,$04 Set bit #N$06 of the current entity's direction / state.
  $D0EA,$03 Point #REGhl at Drutt script data #R$CFBC.
  $D0ED,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D0F0 Positive X-delta: randomly pick the copy script (#R$CF88) or the scan
. script (#R$CFAA).
@ $D0F0 label=ScriptRoutine_VatScanNearbySlots_DeltaSignPlus
  $D0F0,$04 Is bit #N$07 of the signed x-delta in #REGd set? If so, jump to
. #R$D108.
  $D0F4,$02 Load #REGa with #N$02 as the #R$EAE5 random maximum.
  $D0F6,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D0F9,$03 Is #REGa zero? If so, jump to #R$D102.
  $D0FC,$03 Point #REGhl at Drutt script data #R$CF88.
  $D0FF,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D102 Run the vat-scan candidate script at #R$CFAA.
@ $D102 label=ScriptRoutine_VatScanNearbySlots_RunScanScript
  $D102,$03 Point #REGhl at Drutt script data #R$CFAA.
  $D105,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D108 Negative X-delta: randomly pick the near script (#R$CF54) or the
. alternate (#R$CF76).
@ $D108 label=ScriptRoutine_VatScanNearbySlots_DeltaSignMinus
  $D108,$02 Load #REGa with #N$02 as the #R$EAE5 random maximum.
  $D10A,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D10D,$03 Is #REGa zero? If so, jump to #R$D116.
  $D110,$03 Point #REGhl at Drutt script data #R$CF54.
  $D113,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D116 Run the alternate near-range Drutt script at #R$CF76.
@ $D116 label=ScriptRoutine_VatScanNearbySlots_RunAltScript
  $D116,$03 Point #REGhl at Drutt script data #R$CF76.
  $D119,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
  $D11C,$01 Copy the high byte of the pointer into #REGd.
  $D11D,$01 Call the restart routine.
  $D11E,$01 Add #REGb into #REGa, including the previous success marker.
  $D11F,$01 Call the restart routine.
  $D120,$03 Jump to #N$46CF (screen buffer) if the result underflowed.
  $D123,$01 Call the restart routine.
N $D124 No nearby candidate: rarely run a positional script, else index the
. random vat table.
@ $D124 label=ScriptRoutine_VatScanNearbySlots_NoCandidateNearby
  $D124,$02 Load #REGa with #N$05 as the #R$EAE5 random maximum.
  $D126,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D129,$03 Is #REGa zero? If not, jump to #R$D13F.
  $D12C,$03 Load #REGa with the current entity's x-coordinate.
  $D12F,$04 Is the current entity's x-coordinate less than #N$70? If so, jump to
. #R$D139.
  $D133,$03 Point #REGhl at Drutt script data #R$CFAA.
  $D136,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D139 Run the near-range Drutt script at #R$CF54 when the vat sits left of
. #N$70.
@ $D139 label=ScriptRoutine_VatScanNearbySlots_RunNearScript
  $D139,$03 Point #REGhl at Drutt script data #R$CF54.
  $D13C,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D13F Pick a random word from the Drutt script table at #R$D11C and
. execute it.
@ $D13F label=ScriptRoutine_VatScanNearbySlots_IndexTable
  $D13F,$02 Load #REGa with #N$04 as the #R$EAE5 random maximum.
  $D141,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D144,$01 Double #REGa to form a word index into the table at #R$D11C.
  $D145,$01 Copy that word index into #REGe.
  $D146,$02 Clear #REGd (high byte of a pointer/offset).
  $D148,$03 Point #REGhl at Drutt routine data #R$D11C.
  $D14B,$01 Add the offset in #REGde to the pointer in #REGhl.
  $D14C,$03 Fetch the word at #REGhl into #REGde.
  $D14F,$01 Swap the destination and source pointers in #REGde/#REGhl.
  $D150,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $D153 Script Routine: (#N$43) Vat action
@ $D153 label=ScriptRoutine_VatRoomTransition
D $D153 Run the vat's room-transition sequence when its direction bit asks for
. it.
R $D153 IX Address of complex state data for an entity
  $D153,$06 Is bit #N$02 of the current entity's direction / state set? If so,
. jump to #R$D186.
  $D159,$07 Is bit #N$03 of the current entity's direction / state set? If not,
. jump to #R$EC2E.
  $D160,$04 Reset bit #N$03 of the current entity's direction / state.
  $D164,$03 Load #REGa with the current entity's room index.
  $D167,$05 Is the current entity's room index equal to #N$01? If so, jump to
. #R$EC2E.
  $D16C,$03 Call #R$F25F to adjust the camera Y coordinate.
  $D16F,$03 If #R$F25F cleared carry, jump to #R$EC2E to run the next script
. instruction.
  $D172,$03 Call #R$F25B to adjust the camera X coordinate.
  $D175,$02 Jump to #R$D17C if the result underflowed.
  $D177,$05 Is the current entity's room index equal to #N$1F? If so, jump to
. #R$EC2E.
N $D17C Complete a downward room transition: move the vat back one room.
@ $D17C label=ScriptRoutine_VatRoomTransition_DecRoom
  $D17C,$03 Load #REGde with entity-field offset #N($0004,$04,$04).
  $D17F,$01 Add the offset in #REGde to the pointer in #REGhl.
  $D180,$03 Move this entity back one room.
  $D183,$03 Jump to #R$EC2E to run the next script instruction.
N $D186 Clear direction bit #N$02 and try an upward room transition when not
. already in room #N$05.
@ $D186 label=ScriptRoutine_VatRoomTransition_ClearDirBit2
  $D186,$04 Reset bit #N$02 of the current entity's direction / state.
  $D18A,$03 Load #REGa with the current entity's room index.
  $D18D,$05 Is the current entity's room index equal to #N$05? If so, jump to
. #R$EC2E.
  $D192,$03 Call #R$F2C7 to test collectible / room collision.
  $D195,$03 If #R$F2C7 cleared carry, jump to #R$EC2E to run the next script
. instruction.
  $D198,$03 Call #R$F2C2 to set Entity Attribute Byte.
  $D19B,$02 Jump to #R$D1A2 if the result underflowed.
  $D19D,$05 Is the current entity's room index equal to #N$1F? If so, jump to
. #R$EC2E.
N $D1A2 Complete an upward room transition: advance the vat into the next room.
@ $D1A2 label=ScriptRoutine_VatRoomTransition_IncRoom
  $D1A2,$03 Load #REGde with #N($0008,$04,$04) as a field offset within an
. entity.
  $D1A5,$01 Add the offset in #REGde to the pointer in #REGhl.
  $D1A6,$03 Advance this entity into the next room.
  $D1A9,$03 Jump to #R$EC2E to run the next script instruction.

c $D1AC Script Routine: (#N$40) Vat shift right when clear above
@ $D1AC label=ScriptRoutine_VatIncXIfClearAbove
D $D1AC Probe above with #R$F38D. On a clear miss (carry set) jump to #R$D1B5 to
. shift the vat right, then drop Y at #R$D1CC. On a hit, if the distance in
. #REGa is still under #N$32 continue into that same nudge; otherwise jump
. straight to #R$D1CC to drop Y only.
R $D1AC IX Address of complex state data for an entity
N $D1AC Probe above; carry set = miss (path clear).
  $D1AC,$03 Call #R$F38D to test whether a solid entity sits above this vat.
  $D1AF,$02 Was the space above clear (carry set)? If so, jump to #R$D1B5 to
. shift right.
  $D1B1,$04 On a hit: is the distance in #REGa still under #N$32? If not, jump
. to #R$D1CC to drop Y only (skip the nudge).
N $D1B5 Shift right (reached by jump on miss, or when A<#N$32 on a hit), then
. drop Y.
@ $D1B5 label=ScriptRoutine_VatIncXIfClearAbove_IncX
  $D1B5,$06 Move the vat one character right.
  $D1BB,$02 Jump to #R$D1CC to decrease y / y-extent.

c $D1BD Script Routine: (#N$3F) Vat action
@ $D1BD label=ScriptRoutine_VatDecXIfClearLeft
D $D1BD Slide the vat one character left when the left side is clear.
R $D1BD IX Address of complex state data for an entity
  $D1BD,$03 Call #R$F32A to test whether a solid entity sits on the left.
  $D1C0,$02 Is the space on the left clear (carry set)? If so, jump to #R$D1C6
. to shift left.
  $D1C2,$04 Is #REGa less than #N$32? If not, jump to #R$D1CC.
N $D1C6 Shift the vat one character left when the left side is clear (or close).
@ $D1C6 label=ScriptRoutine_VatDecXIfClearLeft_DecX
  $D1C6,$06 Move this entity one character left.

c $D1CC Script Routine: (#N$45) Vat action
@ $D1CC label=ScriptRoutine_VatDecY
D $D1CC Lower the vat one character.
R $D1CC IX Address of complex state data for an entity
  $D1CC,$06 Move this entity one character up.
  $D1D2,$03 Jump to #R$EC2E to run the next script instruction.

c $D1D5 Script Routine: (#N$42) Vat action
@ $D1D5 label=ScriptRoutine_VatIncXIfClearAboveThenRise
D $D1D5 Slide the vat right when the space above is clear, then raise it.
R $D1D5 IX Address of complex state data for an entity
  $D1D5,$03 Call #R$F38D to test whether a solid entity sits above.
  $D1D8,$02 Is the space above clear (carry set)? If so, jump to #R$D1DE to
. shift right.
  $D1DA,$04 Is #REGa less than #N$32? If not, jump to #R$D1F5.
N $D1DE Shift the vat one character right when the space above is clear (or
. close), then rise.
@ $D1DE label=ScriptRoutine_VatIncXIfClearAboveThenRise_IncX
  $D1DE,$06 Move this entity one character right.
  $D1E4,$02 Jump to #R$D1F5 to increase y / y-extent.

c $D1E6 Script Routine: (#N$41) Vat action
@ $D1E6 label=ScriptRoutine_VatDecXIfClearLeftThenRise
D $D1E6 Slide the vat left when the left side is clear, then raise it.
R $D1E6 IX Address of complex state data for an entity
  $D1E6,$03 Call #R$F32A to test whether a solid entity sits on the left.
  $D1E9,$02 Is the space on the left clear (carry set)? If so, jump to #R$D1EF
. to shift left.
  $D1EB,$04 Is #REGa less than #N$32? If not, jump to #R$D1F5.
N $D1EF Shift the vat one character left when the left side is clear (or close),
. then rise.
@ $D1EF label=ScriptRoutine_VatDecXIfClearLeftThenRise_DecX
  $D1EF,$06 Move this entity one character left.

c $D1F5 Script Routine: (#N$44) Vat action
@ $D1F5 label=ScriptRoutine_VatIncY
D $D1F5 Raise the vat one character.
R $D1F5 IX Address of complex state data for an entity
  $D1F5,$06 Move this entity one character down.
  $D1FB,$03 Jump to #R$EC2E to run the next script instruction.

c $D1FE Script Routine: (#N$46) Vat action
@ $D1FE label=ScriptRoutine_VatClearBit6AndReset
D $D1FE Clear the vat's busy bit and reset it onto the post-reset script at
. #R$CFF4.
R $D1FE IX Address of complex state data for an entity
  $D1FE,$07 Is bit #N$06 of the current entity's direction / state set? If not,
. jump to #R$EC2E.
  $D205,$04 Reset bit #N$06 of the current entity's direction / state.
  $D209,$02 Stash #REGix on the stack.
  $D20B,$04 Load #REGix from #R$CF35.
  $D20F,$04 Write #N$00 to the current entity's entity type.
  $D213,$06 Is bit #N$05 of the current entity's flags byte 1 set? If not,
. jump to #R$D227.
  $D219,$04 Point #REGix at the camera-follow entity (#R$909B).
  $D21D,$04 Set bit #N$00 of the current entity's flags byte 3.
  $D221,$03 Point #REGhl at Berk script data #R$BA35.
  $D224,$03 Store #REGhl in Berk's script position pointer (#R$72B1).
N $D227 Restore #REGix, queue the vat sound, and run the post-reset script at
. #R$CFF4.
@ $D227 label=ScriptRoutine_VatClearBit6AndReset_RestoreQueueSound
  $D227,$02 Restore #REGix from the stack.
N $D229 #HTML(#AUDIO0(vat.wav)(#INCLUDE(Vat)))
  $D229,$02 Load #REGa with sound index #N$11.
  $D22B,$03 Call #R$F8F9 to queue a sound effect.
  $D22E,$03 Point #REGhl at Drutt script data #R$CFF4.
  $D231,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

b $D234 Data: Drutt Script / Animation
@ $D234 label=Data_DruttScriptAnim
D $D234 Drutt's script and animation data. Referenced from Drutt's script
. animation table and the code that drives those frames.
N $D234 #UDGTABLE { #SCRIPTANIM$D234(script-d234) } UDGTABLE#
B $D234,$02 Queue sound #N(#PEEK(#PC+$01)).
B $D236,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D239,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D23C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D23F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D242,$01 Load the stored coordinates and return.
N $D243 #UDGTABLE { #LAYOUT$43,$D2(layout-d243) } UDGTABLE#
B $D243,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically, and store as the base coordinates.
B $D246,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D249,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D24C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D24F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D252,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D255,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D258,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D25B,$01 Load the stored coordinates and return.
N $D25C #UDGTABLE { #LAYOUT$5C,$D2(layout-d25c) } UDGTABLE#
B $D25C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D25F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D262,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D265,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D268,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D26B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D26E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D271,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D274,$01 Load the stored coordinates and return.
N $D275 #UDGTABLE { #LAYOUT$75,$D2(layout-d275) } UDGTABLE#
B $D275,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D277,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D27A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D27D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D280,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D283,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D286,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D289,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D28C,$01 Load the stored coordinates and return.
N $D28D #UDGTABLE { #LAYOUT$8D,$D2(layout-d28d) } UDGTABLE#
B $D28D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D28F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D292,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D295,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D298,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D29B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D29E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2A7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2AA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2B0,$01 Load the stored coordinates and return.
N $D2B1 #UDGTABLE { #LAYOUT$B1,$D2(layout-d2b1) } UDGTABLE#
B $D2B1,$02 Queue sound #N(#PEEK(#PC+$01)).
B $D2B3,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D2B5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D2B8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2BB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2BE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2C1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2C4,$01 Load the stored coordinates and return.
N $D2C5 #UDGTABLE { #LAYOUT$C5,$D2(layout-d2c5) } UDGTABLE#
B $D2C5,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D2C8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D2CB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2CE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2D1,$01 Load the stored coordinates and return.
N $D2D2 #UDGTABLE { #LAYOUT$D2,$D2(layout-d2d2) } UDGTABLE#
B $D2D2,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D2D5,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D2D8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2DB,$01 Load the stored coordinates and return.
N $D2DC #UDGTABLE { #LAYOUT$DC,$D2(layout-d2dc) } UDGTABLE#
B $D2DC,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D2DF,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D2E2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2E5,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2E8,$01 Load the stored coordinates and return.
N $D2E9 #UDGTABLE { #LAYOUT$E9,$D2,$00,$06(layout-d2e9) } UDGTABLE#
B $D2E9,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D2EB,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D2EE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2F1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2F4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2F7,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D2FA,$01 Load the stored coordinates and return.
N $D2FB #UDGTABLE { #LAYOUT$FB,$D2(layout-d2fb) } UDGTABLE#
B $D2FB,$02 Queue sound #N(#PEEK(#PC+$01)).
B $D2FD,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D2FF,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D302,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D305,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D308,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D30B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D30E,$01 Load the stored coordinates and return.
N $D30F #UDGTABLE { #LAYOUT$0F,$D3(layout-d30f) } UDGTABLE#
B $D30F,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D312,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D315,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D318,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D31B,$01 Load the stored coordinates and return.
N $D31C #UDGTABLE { #LAYOUT$1C,$D3(layout-d31c) } UDGTABLE#
B $D31C,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D31F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D322,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D325,$01 Load the stored coordinates and return.
N $D326 #UDGTABLE { #LAYOUT$26,$D3(layout-d326) } UDGTABLE#
B $D326,$03 Process the nested layout at
. #R(#PEEK(#PC+$01)+#PEEK(#PC+$02)*$0100), then return to the base coordinates.
B $D329,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D32C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D32F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D332,$01 Load the stored coordinates and return.
N $D333 #UDGTABLE { #LAYOUT$33,$D3,$00,$06(layout-d333) } UDGTABLE#
B $D333,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D335,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D338,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D33B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D33E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D341,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D344,$01 Load the stored coordinates and return.
N $D345 #UDGTABLE { #LAYOUT$45,$D3(layout-d345) } UDGTABLE#
B $D345,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D347,$05 Set the next graphic index from a random list.
B $D34C,$03 Draw a random tile from the list at #R$D347 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D34F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D352,$0B,$0B Jump to a time-weighted random layout address (#R$D35D,
. #R$D367).
N $D35D #UDGTABLE { #LAYOUT$5D,$D3,$00,$06(layout-d35d) } UDGTABLE#
B $D35D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D360,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D363,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D366,$01 Load the stored coordinates and return.
N $D367 #UDGTABLE { #LAYOUT$67,$D3,$00,$06(layout-d367) } UDGTABLE#
B $D367,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D36A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D36D,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D370,$01 Load the stored coordinates and return.
N $D371 #UDGTABLE { #LAYOUT$71,$D3(layout-d371) } UDGTABLE#
B $D371,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D373,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D376,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D379,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D37C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D37F,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D382,$07 Increment the index and jump to one of #R$D35D, #R$D367.
N $D389 #UDGTABLE { #LAYOUT$89,$D3(layout-d389) } UDGTABLE#
B $D389,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D38B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D38E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D391,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D394,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D397,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D39A,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D39D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D3A0,$04 Set the next graphic index from a random list.
B $D3A4,$03 Draw a random tile from the list at #R$D3A0 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3A7,$09,$09 Increment the index and jump to one of #R$D3B0, #R$D3BA,
. #R$D3C1.
N $D3B0 #UDGTABLE { #LAYOUT$B0,$D3,$00,$06(layout-d3b0) } UDGTABLE#
B $D3B0,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D3B3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3B6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3B9,$01 Load the stored coordinates and return.
N $D3BA #UDGTABLE { #LAYOUT$BA,$D3,$00,$06(layout-d3ba) } UDGTABLE#
B $D3BA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3C0,$01 Load the stored coordinates and return.
N $D3C1 #UDGTABLE { #LAYOUT$C1,$D3,$00,$06(layout-d3c1) } UDGTABLE#
B $D3C1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3C4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D3C7,$01 Load the stored coordinates and return.
  $D3C8,$04 Tile/delta bytes #N($92), #N($D7), #N($01), #N$00.
  $D3CC,$08 Tile/delta bytes #N($C8), #N($D3), #N($7D), #N($D6), #N($36),
. #N($00), #N($01), #N$00.
  $D3D4,$08 Tile/delta bytes #N($CE), #N($D3), #N($92), #N($D7), #N($37),
. #N($00), #N($01), #N$00.
  $D3DC,$08 Tile/delta bytes #N($D6), #N($D3), #N($B5), #N($D6), #N($38),
. #N($00), #N($C4), #N$D6.
  $D3E4,$08 Tile/delta bytes #N($01), #N($00), #N($DE), #N($D3), #N($D6),
. #N($D6), #N($39), #N$00.
  $D3EC,$06 Tile/delta bytes #N($E5), #N($D6), #N($01), #N($00), #N($E8),
. #N$D3.
B $D3F2,$01 Layout #N$F7 (timer-based random graphic index).
  $D3F3,$01 Tile/delta bytes #N$D6.
  $D3F4,$06 Tile/delta bytes #N($3A), #N($00), #N($03), #N($D7), #N($01),
. #N$00.
B $D3FA,$02 Set the current attribute to
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))).
  $D3FC,$08 Tile/delta bytes #N($12), #N($D7), #N($3B), #N($00), #N($1B),
. #N($D7), #N($01), #N$00.
B $D404,$01 Layout #N$FC (conditional jump or skip).
  $D405,$07 Tile/delta bytes #N($D3), #N($2A), #N($D7), #N($2A), #N($D7),
. #N($01), #N$00.
  $D40C,$08 Tile/delta bytes #N($DE), #N($D3), #N($39), #N($D7), #N($39),
. #N($D7), #N($01), #N$00.
  $D414,$08 Tile/delta bytes #N($E8), #N($D3), #N($48), #N($D7), #N($01),
. #N($00), #N($16), #N$D4.
  $D41C,$08 Tile/delta bytes #N($03), #N($D7), #N($7D), #N($D6), #N($3C),
. #N($00), #N($3D), #N$00.
  $D424,$06 Tile/delta bytes #N($12), #N($D7), #N($01), #N($00), #N($D6),
. #N$D3.
B $D42A,$01 Layout #N$FA (adjust coordinates without storing).
  $D42B,$01 Tile/delta bytes #N$D6.
B $D42C,$01 Layout #N$FA (adjust coordinates without storing).
  $D42D,$05 Tile/delta bytes #N($D6), #N($3D), #N($00), #N($03), #N$D7.
B $D432,$01 Layout #N$F7 (timer-based random graphic index).
  $D433,$01 Tile/delta bytes #N$D6.
  $D434,$08 Tile/delta bytes #N($01), #N($00), #N($D6), #N($D3), #N($80),
. #N($D7), #N($80), #N$D7.
  $D43C,$08 Tile/delta bytes #N($3D), #N($00), #N($E5), #N($D6), #N($D6),
. #N($D6), #N($01), #N$00.
  $D444,$02 Tile/delta bytes #N($D6), #N$D3.

c $D446 Check Entity Collision
@ $D446 label=Check_Entity_Collision
D $D446 Check Entity Collision against the complex entity table at #R$8EE9.
N $D446 Called from #R$B380 on a type-#N$08 / type-#N$0B pair: set bit #N$07 of
. #R$72B8, bump #R$72BD, and on the third bump set bit #N$06 of #R$72B8
. (cleared by #R$EDB8).
  $D446,$01 Stash #REGhl on the stack.
  $D447,$03 Point #REGhl at task-one / collision flags (#R$72B8).
  $D44A,$02 Set bit #N$07 of #R$72B8.
  $D44C,$03 Load the collision scratch byte (#R$72BD) into #REGa.
  $D44F,$01 Advance that counter by one.
  $D450,$03 Store the counter back to #R$72BD.
  $D453,$04 Has #R$72BD reached #N$03? If not, jump to #R$D459.
  $D457,$02 Set bit #N$06 of #R$72B8.
N $D459 Restore #REGhl and return after recording the type-#N$08 / #N$0B
. collision.
@ $D459 label=Check_Entity_Collision_RestoreReturn
  $D459,$01 Restore #REGhl from the stack.
  $D45A,$01 Return.

c $D45B Update Collectibles
@ $D45B label=Update_Collectibles
D $D45B Update Collectibles against the complex entity table at #R$8EE9.
  $D45B,$03 Point #REGhl at collectible slot state (#R$72DF).
  $D45E,$04 Point #REGix at an inactive complex-entity slot (#R$8F9F).
  $D462,$02 Load #REGb with #N$03 as a loop counter.
N $D464 For each collectible slot: reload its script cursor / counter, run
. #R$D48E, then save them back.
@ $D464 label=Update_Collectibles_Scan
  $D464,$01 Stash #REGbc on the stack.
  $D465,$03 Fetch the word at #REGhl into #REGbc.
  $D468,$01 Advance #R$72DF by one byte.
  $D469,$01 Fetch the next byte from #R$72DF.
  $D46A,$03 Set the collectible counter (#R$72BC).
  $D46D,$04 Store #REGbc in the active script cursor (#R$72CF).
  $D471,$01 Stash #REGhl on the stack.
  $D472,$03 Call #R$D48E to collect Entity.
  $D475,$01 Restore #REGhl from the stack.
  $D476,$03 Load #REGa with the collectible counter (#R$72BC).
  $D479,$01 Write collectible counter through #R$72DF.
  $D47A,$01 Step #R$72DF back by one byte.
  $D47B,$04 Load #REGbc with the active script cursor (#R$72CF).
  $D47F,$01 Write the loop counter through the pointer in #REGhl.
  $D480,$01 Step #R$72DF back by one byte.
  $D481,$01 Write the saved count in #REGc through the pointer in #REGhl.
  $D482,$03 Advance #REGhl onto the next collectible slot record.
  $D485,$03 Each entity record is #N($000E,$04,$04) bytes long, then load that
. length into #REGbc.
  $D488,$02 Advance #REGix to the next entity record.
  $D48A,$01 Restore #REGbc from the stack.
  $D48B,$02 Decrease the loop counter in #REGb and jump to #R$D464 if more
. iterations remain.
  $D48D,$01 Return.

c $D48E Collect Entity
@ $D48E label=Collect_Entity
D $D48E Collect Entity against the complex entity table at #R$8EE9.
R $D48E IX Address of complex state data for an entity
N $D48E Awards score and clears a collectible when Berk touches it.
  $D48E,$04 Load #REGde with the camera room-origin pointer (#R$72FB).
  $D492,$01 Copy the low byte from #REGc into #REGl (build #REGhl).
  $D493,$01 Copy the high byte from #REGb into #REGh (build #REGhl).
  $D494,$03 Load #REGa with the game event flags (#R$72B3).
  $D497,$01 Keep game event flags in #REGb for later.
  $D498,$03 Fetch the current entity's type for the type test.
  $D49B,$03 Is bit #N$07 of the current entity's entity type set? If so, return.
  $D49E,$03 Is the current entity's entity type zero? If so, jump to #R$D4AF.
  $D4A1,$04 Is the current entity's entity type equal to #N$0B? If so, jump to
. #R$D4C2.
  $D4A5,$05 Is bit #N$01 of the loop/flags byte in #REGb set? If so, jump to
. #R$EC2E.
  $D4AA,$04 Write #N$00 to the current entity's entity type.
  $D4AE,$01 Return.
N $D4AF Empty slot with bit #N$05 set: under the event latch, become type #N$0A
. and clear that bit.
@ $D4AF label=Collect_Entity_TypeZeroBit5
  $D4AF,$07 Is bit #N$05 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$D518.
  $D4B6,$03 Is bit #N$01 of the loop/flags byte in #REGb set? If not, return.
  $D4B9,$04 Write #N$0A to the current entity's entity type.
  $D4BD,$04 Reset bit #N$05 of flags byte 3 (#REGix+#N$03).
  $D4C1,$01 Return.
N $D4C2 Type-#N$0B collectible: score it, branch on flags, or tick its counter /
. wander script.
@ $D4C2 label=Collect_Entity_AsHeld
  $D4C2,$03 Load #REGa with the current entity's flags byte 1.
  $D4C5,$04 Is bit #N$06 of the current entity's flags byte 1 set? If so, jump
. to #R$D4D4.
  $D4C9,$02,b$01 Keep only bits #N$07 and #N$05 of that flags byte (mask #N$A0).
  $D4CB,$02 If the result was non-zero, jump to #R$D4DA.
  $D4CD,$03 Load #REGa with the current entity's y-extent.
  $D4D0,$04 Is the current entity's y-extent less than #N$23? If not, jump to
. #R$D4E4.
N $D4D4 Run the collectible score script at #R$D3C8.
@ $D4D4 label=Collect_Entity_RunScoreScript
  $D4D4,$03 Point #REGhl at collectible/score table data (#R$D3C8).
  $D4D7,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D4DA Flagged type-#N$0B path: clear the counter and run the alternate score
. script at #R$D234(#N$D416).
@ $D4DA label=Collect_Entity_Branch
  $D4DA,$01 Clear the collectible counter.
  $D4DB,$03 Set the collectible counter (#R$72BC).
  $D4DE,$03 Point #REGhl at collectible/score table data (#R$D234(#N$D416)).
  $D4E1,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D4E4 High collectibles skip scripting while counter bit #N$07 is set.
@ $D4E4 label=Collect_Entity_TestCounterBit7
  $D4E4,$03 Load #REGa with the collectible counter (#R$72BC).
  $D4E7,$05 Is bit #N$07 of collectible counter set? If so, jump to #R$EC2E.
N $D4EC Tick the collectible counter down, or reseed it and launch a wander
. script when it hits zero.
@ $D4EC label=Collect_Entity_DecCounterOrScript
  $D4EC,$03 Is collectible counter zero? If so, jump to #R$D4F6.
  $D4EF,$01 Step collectible counter back by one.
  $D4F0,$03 Set the collectible counter (#R$72BC).
  $D4F3,$03 Jump to #R$EC2E to run the next script instruction.
N $D4F6 Reseed the counter to #N$84 plus a random and run the wander script at
. #R$D234(#N$D3CE).
@ $D4F6 label=Collect_Entity_RandomiseCounterScript
  $D4F6,$02 Load #REGa with #N$06 as the #R$EAE5 random maximum.
  $D4F8,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D4FB,$02 Add #N$84 to #REGa (build a score/message digit address).
  $D4FD,$03 Set the collectible counter (#R$72BC).
  $D500,$03 Point #REGhl at collectible/score table data (#R$D234(#N$D3CE)).
  $D503,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
  $D506,$01 Advance the collectible-slot counter in #REGb.
  $D507,$01 Keep #REGl unchanged (alignment byte in the compiled routine).
  $D508,$01 Advance the high byte of the pointer in #REGhl.
  $D509,$01 Write the computed score/digit byte through #REGbc.
  $D50A,$03 Load #REGhl from #N$05D4.
  $D50D,$01 Keep #REGl unchanged (alignment byte in the compiled routine).
  $D50E,$01 Decimal-adjust #REGa after adding to a score digit.
  $D50F,$01 Advance the counter/pointer in #REGbc by one.
  $D510,$01 Advance the low byte of the pointer/offset in #REGde.
  $D511,$03 If not below, call #R$6B00.
  $D514,$01 Step the high byte of the score/table pointer back by one.
  $D515,$01 Advance the counter/pointer in #REGbc by one.
  $D516,$02 If a hit/borrow was signaled, jump to #R$D4EC.
N $D518 Idle empty slot: rarely raise bit #N$05 and copy spawn coordinates from
. table #R$D506.
@ $D518 label=Collect_Entity_MaybeSetBit5
  $D518,$03 Is bit #N$01 of the loop/flags byte in #REGb set? If so, return.
  $D51B,$02 Load #REGa with #N$0A.
  $D51D,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D520,$02 Is #N$0A zero? If not, return.
  $D522,$04 Set bit #N$05 of flags byte 3 (#REGix+#N$03).
  $D526,$02 Load #REGa with #N$03.
  $D528,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D52B,$01 Double #N$03 (word index).
  $D52C,$01 Keep #N$03 in #REGc for later.
  $D52D,$01 Double #N$03 (word index).
  $D52E,$01 Add the saved count in #REGc to #REGa.
  $D52F,$01 Keep #N$03 in #REGc for later.
  $D530,$02 Load #REGb with #N$00 as a loop counter.
  $D532,$04 Point #REGiy at collectible storage (#R$D506).
  $D536,$02 Add the offset in #REGbc to the entity pointer in #REGiy.
  $D538,$03 Load #REGa with the referenced entity's entity type.
  $D53B,$03 Is referenced entity's entity type zero? If so, jump to #R$D541.
  $D53E,$03 Call #R$EAE5 to pick a pseudo-random value.
N $D541 Copy the chosen spawn coords / room from #REGiy into this slot and
. launch its script.
@ $D541 label=Collect_Entity_CopyIYCoordsToIX
  $D541,$03 Add the referenced entity's flags byte 1 to #REGa.
  $D544,$03 Set the current entity's x-coordinate.
  $D547,$03 Set the current entity's x-extent.
  $D54A,$03 Load #REGa with the referenced entity's flags byte 2.
  $D54D,$03 Set the current entity's y-coordinate.
  $D550,$03 Set the current entity's y-extent.
  $D553,$03 Load #REGa with the referenced entity's flags byte 3.
  $D556,$03 Set the current entity's room index.
  $D559,$03 Load #REGl with the referenced entity's room index.
  $D55C,$03 Load #REGh with the referenced entity's y-coordinate.
  $D55F,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

b $D562 Collectible Script Table Base
@ $D562 label=Data_CollectibleScriptTable
D $D562 Script / table base loaded into #REGhl by #R$D56A before #R$EC30.
  $D562,$08

c $D56A Script Routine: (#N$37) Collectible action
@ $D56A label=ScriptRoutine_CollectibleRandomScript
D $D56A Pick a random continuation from the collectible's script table.
R $D56A IX Address of complex state data for an entity
  $D56A,$02 ..
  $D56C,$04 Call #R$EAE5 to pick a pseudo-random value and keep it in #REGb.
  $D570,$01 Advance the loop index in #REGb.
  $D571,$01 Double #REGa to form a word index into the script/handler table.
  $D572,$01 Keep the index in #REGc.
  $D573,$02 Load #REGa with #N$80.
N $D575 Rotate a bit mask until it differs from this collectible's direction /
. state.
@ $D575 label=ScriptRoutine_CollectibleRandomScript_RotateMask
  $D575,$02 Rotate the collectible bitmask in #REGa left circular.
  $D577,$02 Decrease the loop counter in #REGb and jump to #R$D575 if more
. iterations remain.
  $D579,$05 Does #REGa match this entity's direction/state (#REGix+#N$09)? If
. so, jump to #R$D56A.
  $D57E,$03 Set the current entity's direction / state.
  $D581,$02,b$01 Keep only the low two direction bits of #REGa.
  $D583,$02 Jump to #R$D589 to continue if the comparison did not match.
  $D585,$02 Load #REGa with #N$02.
  $D587,$02 Jump to #R$D58B to continue this routine.
N $D589 Use random maximum #N$1E when the new mask is not in the low two
. direction bits.
@ $D589 label=ScriptRoutine_CollectibleRandomScript_RandomMax1E
  $D589,$02 Load #REGa with #N$1E.
N $D58B Reseed the collectible counter and launch the matching script word from
. #R$D562.
@ $D58B label=ScriptRoutine_CollectibleRandomScript_SetCounterAndScript
  $D58B,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D58E,$01 Advance #N$1E by one.
  $D58F,$03 Set the collectible counter (#R$72BC).
  $D592,$03 Point #REGhl at unused padding before the collectible script
. (#R$D562).
  $D595,$01 Add the length/offset in #REGbc to the pointer in #REGhl.
  $D596,$03 Fetch the new script address into #REGbc.
  $D599,$02 Copy the script address from #REGbc into #REGhl.
  $D59B,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $D59E Script Routine: (#N$36) Collectible action
@ $D59E label=ScriptRoutine_CollectibleScanCounter
D $D59E Update the collectible counter for this entity's current state.
R $D59E IX Address of complex state data for an entity
  $D59E,$03 Load #REGa with the collectible counter (#R$72BC).
  $D5A1,$04 Is collectible counter equal to #N$80? If not, jump to #R$D5AB.
  $D5A5,$03 Point #REGhl at the dialogue/message table (#R$D234(#N$D3D6)).
  $D5A8,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D5AB Tick the counter and, if the crusher (#R$8FC9) is live, measure its X
. delta.
@ $D5AB label=ScriptRoutine_CollectibleScanCounter_DecCounterScan
  $D5AB,$01 Step collectible counter back by one.
  $D5AC,$03 Set the collectible counter (#R$72BC).
  $D5AF,$04 Point #REGiy at the crusher entity (#R$8FC9).
  $D5B3,$03 Load #REGa with the referenced entity's entity type.
  $D5B6,$04 Is the referenced entity's entity type zero? If so, jump to #R$EC2E
. to run the next script instruction.
  $D5BA,$07 Is bit #N$05 of the referenced entity's flags byte 1 set? If so,
. jump to #R$EC2E.
  $D5C1,$03 Load #REGa with the referenced entity's x-coordinate.
  $D5C4,$01 Advance referenced entity's x-coordinate by one.
  $D5C5,$03 Subtract the current entity's x-coordinate from #REGa.
  $D5C8,$01 Stash #REGaf on the stack.
  $D5C9,$02 Jump to #R$D5CD if the result did not underflow.
  $D5CB,$02 Negate #REGa (flip a delta/direction).
N $D5CD Only react when the crusher is within #N$0A characters horizontally.
@ $D5CD label=ScriptRoutine_CollectibleScanCounter_TestAbsDeltaX
  $D5CD,$04 Is referenced entity's x-coordinate less than #N$0A? If so, jump to
. #R$D5D5.
  $D5D1,$01 Restore #REGaf from the stack.
  $D5D2,$03 Jump to #R$EC2E to run the next script instruction.
N $D5D5 Pick the left or right reaction script from the sign of the crusher X
. delta.
@ $D5D5 label=ScriptRoutine_CollectibleScanCounter_PickScriptBySign
  $D5D5,$01 Restore #REGaf from the stack.
  $D5D6,$02 Jump to #R$D5DD if the result underflowed.
  $D5D8,$03 Point #REGhl at collectible/score table data #R$D234(#N$D40E).
  $D5DB,$02 Jump to #R$D5E0 to continue this routine.
N $D5DD Use the leftward crusher-reaction script at #R$D234(#N$D406).
@ $D5DD label=ScriptRoutine_CollectibleScanCounter_RunScript
  $D5DD,$03 Point #REGhl at collectible/score table data #R$D234(#N$D406).
N $D5E0 Reseed the counter to #N$0A plus a random and run the chosen reaction
. script.
@ $D5E0 label=ScriptRoutine_CollectibleScanCounter_RandomiseCounterAndRun
  $D5E0,$02 Load #REGa with #N$32 as the #R$EAE5 random maximum.
  $D5E2,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D5E5,$02 Add #N$0A to #REGa (adjust a collectible/timer value).
  $D5E7,$03 Set the collectible counter (#R$72BC).
  $D5EA,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $D5ED Script Routine: (#N$3D) Collectible action
@ $D5ED label=ScriptRoutine_CollectibleSetHeld
D $D5ED Promote the collectible to entity type #N$0B.
R $D5ED IX Address of complex state data for an entity
  $D5ED,$04 Write #N$0B to the current entity's entity type.
  $D5F1,$03 Jump to #R$EC2E to run the next script instruction.

c $D5F4 Script Routine: (#N$3C) Collectible action
@ $D5F4 label=ScriptRoutine_CollectibleIncRoomTwice
D $D5F4 Advance the collectible's room index twice to force a room change.
R $D5F4 IX Address of complex state data for an entity
  $D5F4,$04 Set bit #N$02 of the current entity's direction / state.
  $D5F8,$06 Advance this entity two rooms ahead.
  $D5FE,$03 Jump to #R$EC2E to run the next script instruction.

c $D601 Script Routine: (#N$38) Collectible action
@ $D601 label=ScriptRoutine_CollectibleIncXIfClearAbove
D $D601 Slide the collectible right when the cell above is clear.
R $D601 IX Address of complex state data for an entity
  $D601,$03 Call #R$F38D to test whether a solid entity sits above.
  $D604,$02 Is the space above clear (carry set)? If so, jump to #R$D614.
  $D606,$04 Is #REGa less than #N$32? If so, jump to #R$D614.
  $D60A,$04 Set bit #N$00 of the current entity's direction / state.
  $D60E,$03 Point #REGhl at the dialogue/message table (#R$D234(#N$D3D6)).
  $D611,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D614 Nudge the collectible one character right when the space above is clear
. (or close).
@ $D614 label=ScriptRoutine_CollectibleIncXIfClearAbove_IncX
  $D614,$06 Move this entity one character right.
  $D61A,$03 Jump to #R$EC2E to run the next script instruction.

c $D61D Script Routine: (#N$39) Collectible action
@ $D61D label=ScriptRoutine_CollectibleDecXIfClearLeft
D $D61D Slide the collectible left when the cell to the left is clear.
R $D61D IX Address of complex state data for an entity
  $D61D,$03 Call #R$F32A to test whether a solid entity sits on the left.
  $D620,$02 Is the space on the left clear (carry set)? If so, jump to #R$D630.
  $D622,$04 Is #REGa less than #N$32? If so, jump to #R$D630.
  $D626,$04 Set bit #N$01 of the current entity's direction / state.
  $D62A,$03 Point #REGhl at the dialogue/message table (#R$D234(#N$D3D6)).
  $D62D,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D630 Nudge the collectible one character left when the left side is clear (or
. close).
@ $D630 label=ScriptRoutine_CollectibleDecXIfClearLeft_DecX
  $D630,$06 Move this entity one character left.
  $D636,$03 Jump to #R$EC2E to run the next script instruction.

c $D639 Script Routine: (#N$3A) Collectible action
@ $D639 label=ScriptRoutine_CollectibleLeaveRoomDown
D $D639 Send the collectible out of the room downward.
R $D639 IX Address of complex state data for an entity
  $D639,$03 Load #REGa with the current entity's room index.
  $D63C,$04 Is the current entity's room index equal to #N$01? If so, jump to
. #R$D645.
  $D640,$03 Call #R$F25B to adjust the camera X coordinate.
  $D643,$02 Jump to #R$D64F if the result underflowed.
N $D645 Blocked leaving downward: set direction bit #N$03 and run the stop
. script at #R$D234(#N$D3D6).
@ $D645 label=ScriptRoutine_CollectibleLeaveRoomDown_SetDirBit3Script
  $D645,$04 Set bit #N$03 of the current entity's direction / state.
  $D649,$03 Point #REGhl at the dialogue/message table (#R$D234(#N$D3D6)).
  $D64C,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D64F Leave downward: move up one character and back one room.
@ $D64F label=ScriptRoutine_CollectibleLeaveRoomDown_DecYAndRoom
  $D64F,$06 Move this entity one character up.
  $D655,$03 Move this entity back one room.
  $D658,$03 Jump to #R$EC2E to run the next script instruction.

c $D65B Script Routine: (#N$3B) Collectible action
@ $D65B label=ScriptRoutine_CollectibleLeaveRoomUp
D $D65B Send the collectible out of the room upward.
R $D65B IX Address of complex state data for an entity
  $D65B,$03 Load #REGa with the current entity's room index.
  $D65E,$04 Is the current entity's room index equal to #N$05? If so, jump to
. #R$D667.
  $D662,$03 Call #R$F2C7 to test collectible / room collision.
  $D665,$02 Jump to #R$D671 if the result underflowed.
N $D667 Blocked leaving upward: set direction bit #N$02 and run the stop script
. at #R$D234(#N$D3D6).
@ $D667 label=ScriptRoutine_CollectibleLeaveRoomUp_SetDirBit2Script
  $D667,$04 Set bit #N$02 of the current entity's direction / state.
  $D66B,$03 Point #REGhl at the dialogue/message table (#R$D234(#N$D3D6)).
  $D66E,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $D671 Leave upward: move down one character and into the next room.
@ $D671 label=ScriptRoutine_CollectibleLeaveRoomUp_IncYAndRoom
  $D671,$06 Move this entity one character down.
  $D677,$03 Advance this entity into the next room.
  $D67A,$03 Jump to #R$EC2E to run the next script instruction.

b $D67D Data: Collectible Script / Table Residue
@ $D67D label=Data_CollectibleResidue
D $D67D Data following script routine #R$D65B (not executable code).
N $D67D #UDGTABLE { #SCRIPTANIM$D67D(script-d67d) } UDGTABLE#
B $D67D,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D67F,$0F,$0F Increment the index and jump to one of #R$D68E, #R$D69B,
. #R$D69B, #R$D68E, #R$D6A8, #R$D6A8.
N $D68E #UDGTABLE { #LAYOUT$8E,$D6,$00,$06(layout-d68e) } UDGTABLE#
B $D68E,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D691,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D694,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D697,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D69A,$01 Load the stored coordinates and return.
N $D69B #UDGTABLE { #LAYOUT$9B,$D6,$00,$06(layout-d69b) } UDGTABLE#
B $D69B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D69E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6A1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6A4,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6A7,$01 Load the stored coordinates and return.
N $D6A8 #UDGTABLE { #LAYOUT$A8,$D6,$00,$06(layout-d6a8) } UDGTABLE#
B $D6A8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D6AB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6AE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6B1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6B4,$01 Load the stored coordinates and return.
B $D6B5,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D6B7,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D6BA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6BD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6C0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6C3,$01 Load the stored coordinates and return.
B $D6C4,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D6C6,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D6C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6CC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6CF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6D2,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6D5,$01 Load the stored coordinates and return.
B $D6D6,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D6D8,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D6DB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6DE,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6E1,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6E4,$01 Load the stored coordinates and return.
B $D6E5,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D6E7,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D6EA,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6ED,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6F0,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6F3,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6F6,$01 Load the stored coordinates and return.
B $D6F7,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D6FA,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D6FC,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D6FF,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D702,$01 Load the stored coordinates and return.
B $D703,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D705,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D708,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D70B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D70E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D711,$01 Load the stored coordinates and return.
B $D712,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D714,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D717,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D71A,$01 Load the stored coordinates and return.
B $D71B,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D71D,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D720,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D723,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D726,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D729,$01 Load the stored coordinates and return.
B $D72A,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D72C,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D72F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D732,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D735,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D738,$01 Load the stored coordinates and return.
B $D739,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D73B,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D73E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D741,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D744,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D747,$01 Load the stored coordinates and return.
B $D748,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D74A,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D74D,$0B,$0B Increment the index and jump to one of #R$D758, #R$D762,
. #R$D76C, #R$D776.
N $D758 #UDGTABLE { #LAYOUT$58,$D7,$00,$06(layout-d758) } UDGTABLE#
B $D758,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D75B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D75E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D761,$01 Load the stored coordinates and return.
N $D762 #UDGTABLE { #LAYOUT$62,$D7,$00,$06(layout-d762) } UDGTABLE#
B $D762,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D765,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D768,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D76B,$01 Load the stored coordinates and return.
N $D76C #UDGTABLE { #LAYOUT$6C,$D7,$00,$06(layout-d76c) } UDGTABLE#
B $D76C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D76F,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D772,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D775,$01 Load the stored coordinates and return.
N $D776 #UDGTABLE { #LAYOUT$76,$D7,$00,$06(layout-d776) } UDGTABLE#
B $D776,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D779,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D77C,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D77F,$01 Load the stored coordinates and return.
B $D780,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D782,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D785,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D788,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D78B,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D78E,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D791,$01 Load the stored coordinates and return.
B $D792,$02 Set the graphic set to #GRAPHICSET(#PEEK(#PC+$01)).
B $D794,$03 Move the cursor by
. #IF(#PEEK(#PC+$02)<$80)(#N(#PEEK(#PC+$02)),-#N($0100-#PEEK(#PC+$02)))
. horizontally and
. #IF(#PEEK(#PC+$01)<$80)(#N(#PEEK(#PC+$01)),-#N($0100-#PEEK(#PC+$01)))
. vertically.
B $D797,$0F,$0F Jump to a time-weighted random layout address (#R$D7A6,
. #R$D7B1, #R$D7BF).
N $D7A6 #UDGTABLE { #LAYOUT$A6,$D7,$00,$06(layout-d7a6) } UDGTABLE#
B $D7A6,$04 Set the next graphic index from a random list.
B $D7AA,$03 Draw a random tile from the list at #R$D7A6 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7AD,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7B0,$01 Load the stored coordinates and return.
N $D7B1 #UDGTABLE { #LAYOUT$B1,$D7,$00,$06(layout-d7b1) } UDGTABLE#
B $D7B1,$04 Set the next graphic index from a random list.
B $D7B5,$03 Draw a random tile from the list at #R$D7B1 with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7B8,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7BB,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7BE,$01 Load the stored coordinates and return.
N $D7BF #UDGTABLE { #LAYOUT$BF,$D7,$00,$06(layout-d7bf) } UDGTABLE#
B $D7BF,$04 Set the next graphic index from a random list.
B $D7C3,$03 Draw a random tile from the list at #R$D7BF with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7C6,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7C9,$03 Draw tile #N(#PEEK(#PC)) with
. #COLOUR(#PEEK(#PC+$01)) (#N(#PEEK(#PC+$01))) and move
. #TILESTEP(#PEEK(#PC+$02),#PEEK(#PC+$01)).
B $D7CC,$01 Load the stored coordinates and return.
  $D7CD,$06 Tile/delta bytes #N($00), #N($00), #N($00), #N($00), #N($00),
. #N$00.

c $D7D3 Update Bad Tempered Thing Dialogue
@ $D7D3 label=Update_Bad_Tempered_Thing_Dialogue
  $D7D3,$03 Load #REGa with the Bad Tempered Thing state (#R$72C7).
  $D7D6,$03 Is Bad Tempered Thing state equal to #N$FF? If so, return.
  $D7D9,$03 Point #REGhl at #SKOOLKID$3D00(CHARSET)-#N$0100.
  $D7DC,$03 Write the pointer in #REGhl to the temporary screen pointer
. (#R$72F9).
  $D7DF,$03 Point #REGhl at Bad Tempered Thing dialogue state
. (#R$D67D(#N$D7D2)).
  $D7E2,$01 Increment the Bad Tempered Thing dialogue counter at #REGhl.
  $D7E3,$03 Point #REGhl at Bad Tempered Thing dialogue bytes (#R$D7CD).
  $D7E6,$03 Load #REGa with the Bad Tempered Thing state (#R$72C7).
  $D7E9,$03 Is Bad Tempered Thing state zero? If so, jump to #R$D810.
  $D7EC,$01 Keep Bad Tempered Thing state in #REGe for later.
  $D7ED,$03 Load #REGa from #R$D67D(#N$D7D2).
  $D7F0,$04 Is Bad Tempered Thing state less than #N$32? If not, jump to
. #R$D826.
  $D7F4,$05 Has this Bad Tempered Thing aside already been shown (bit #N$00 of
. #R$D7CD)? If so, jump to #R$DA1A.
  $D7F9,$03 Load #REGa with the Bad Tempered Thing state (#R$72C7).
  $D7FC,$03 Is Bad Tempered Thing state equal to #N$FE? If so, return.
  $D7FF,$02 Mark this Bad Tempered Thing aside as already shown (bit #N$00 of
. #R$D7CD).
  $D801,$03 Call #R$DA5B to clear Dialogue Area.
  $D804,$01 Copy the low byte from #REGe into #REGb (build a dialogue index).
  $D805,$03 Point #REGhl at dialogue string data (#R$DD54).
N $D808 Skip #REGb dialogue fragments via #R$DA23, then start printing at
. #R$D9C2.
@ $D808 label=Update_Bad_Tempered_Thing_Dialogue_AdvanceChars
  $D808,$03 Call #R$DA23 to advance Dialogue Character.
  $D80B,$02 Decrease the loop counter in #REGb and jump to #R$D808 if more
. iterations remain.
  $D80D,$03 Jump to #R$D9C2 to continue Bad Tempered Thing dialogue.
N $D810 When Berk is held (flags bit #N$05), either resume a mid-line print or
. open the task branch.
@ $D810 label=Update_Bad_Tempered_Thing_Dialogue_BerkHeldBit5
  $D810,$04 Load #REGix with Boney's complex entity state (#R$8EE9).
  $D814,$06 Is bit #N$05 of the current entity's flags byte 1 set? If not,
. jump to #R$D826.
  $D81A,$05 Has this Bad Tempered Thing aside already been shown (bit #N$00 of
. #R$D7CD)? If so, jump to #R$DA1A.
  $D81F,$03 Load #REGa from #R$D67D(#N$D7D2).
  $D822,$04 Is Bad Tempered Thing state less than #N$32? If so, jump to #R$D838.
N $D826 Reset the dialogue tick, restore layout #R$9C9E (Boney), and clear the
. dialogue strip.
@ $D826 label=Update_Bad_Tempered_Thing_Dialogue_ResetTickLayout
  $D826,$01 Clear the Bad Tempered Thing dialogue tick.
  $D827,$03 Set the Bad Tempered Thing dialogue state (#R$D67D(#N$D7D2)).
  $D82A,$01 Write Bad Tempered Thing state through #R$DD54.
  $D82B,$01 Step Bad Tempered Thing state back by one.
  $D82C,$03 Set the Bad Tempered Thing state (#R$72C7).
  $D82F,$03 Point #REGhl at #R$9C9E.
  $D832,$03 Write that layout pointer to Boney's graphic-layout field
. (#R$8EF3).
  $D835,$03 Jump to #R$DA5B.
N $D838 At dialogue state #N($06), clear the strip and pick task-#N$01..#N$04
. (or menu) gate logic.
@ $D838 label=Update_Bad_Tempered_Thing_Dialogue_Branch
  $D838,$03 Is Bad Tempered Thing state equal to #N$06? If not, return.
  $D83B,$02 Set bit #N$00 of #R$9C9E.
  $D83D,$03 Call #R$DA5B to clear Dialogue Area.
  $D840,$03 Load #REGa with the current task index (#R$72AE).
  $D843,$04 Is current task index equal to #N$01? If so, jump to #R$D863.
  $D847,$04 Is current task index equal to #N$02? If so, jump to #R$D891.
  $D84B,$05 Is current task index equal to #N$03? If so, jump to #R$D8DE.
  $D850,$05 Is current task index equal to #N$04? If so, jump to #R$D930.
  $D855,$02 Load #REGb with #N$01 as a loop counter.
  $D857,$03 Load #REGa with the task status flags (#R$72B4).
  $D85A,$05 Is bit #N$07 of task status flags set? If not, jump to #R$D971.
  $D85F,$01 Advance the dialogue-check counter in #REGb.
  $D860,$03 Jump to #R$D971.
N $D863 Task #N$01 gates: empty slot #R$9001, collision count #R$72BD, and door
. X choose the line index.
@ $D863 label=Update_Bad_Tempered_Thing_Dialogue_Task1Gates
  $D863,$02 Load #REGb with #N$01 as a loop counter.
  $D865,$03 Load #REGa with the type of complex entity slot #N$20 (#R$9001).
  $D868,$04 Is the type at #R$9001 non-zero? If so, jump to #R$D971.
  $D86C,$01 Advance the dialogue-check counter in #REGb.
  $D86D,$03 Load #REGa with the collision scratch byte (#R$72BD).
  $D870,$03 Is #R$72BD non-zero? If so, jump to #R$D882.
  $D873,$04 Point #REGix at the worm-can entity (#R$902B).
  $D877,$03 Load #REGa with the current entity's x-coordinate.
  $D87A,$05 Is the current entity's x-coordinate less than #N$5E? If so, jump to
. #R$D971.
  $D87F,$03 Load #REGa with the collision scratch byte (#R$72BD).
N $D882 Refine the task-#N$01 line from how far #R$72BD has progressed (zero /
. mid / #N$03).
@ $D882 label=Update_Bad_Tempered_Thing_Dialogue_Task1CounterGates
  $D882,$01 Advance the dialogue-line index in #REGb.
  $D883,$04 Is #R$72BD zero? If so, jump to #R$D971.
  $D887,$01 Advance the dialogue-line index in #REGb.
  $D888,$05 Is #R$72BD equal to #N$03? If not, jump to #R$D971.
  $D88D,$01 Advance the dialogue-check counter in #REGb.
  $D88E,$03 Jump to #R$D971.
N $D891 Task #N$02 gates: require the script-active flag and phase #N$02 before
. deeper checks.
@ $D891 label=Update_Bad_Tempered_Thing_Dialogue_Task2Gates
  $D891,$02 Load #REGb with #N$01 as a loop counter.
  $D893,$03 Load #REGa with the game event flags (#R$72B3).
  $D896,$04 Is bit #N$07 of game event flags set? If not, jump to #R$D8A2.
  $D89A,$03 Load #REGa with the current task phase (#R$72AF).
  $D89D,$05 Is current task phase equal to #N$02? If not, jump to #R$D971.
N $D8A2 Task-#N$02 pan X checks before looking at the spawn timer.
@ $D8A2 label=Update_Bad_Tempered_Thing_Dialogue_Task2Creature
  $D8A2,$01 Advance the dialogue-check counter in #REGb.
  $D8A3,$03 Load #REGa with the pan entity's type (#R$9055).
  $D8A6,$03 Is the type at #R$9055 zero? If so, jump to #R$D8B1.
  $D8A9,$03 Load #REGa from #R$8EF3(#N$905C).
  $D8AC,$05 Is the byte at #R$8EF3(#N$905C) less than #N$5E? If so, jump to
. #R$D971.
N $D8B1 Task-#N$02 spawn-timer zero path: only continue while the script-active
. flag is set.
@ $D8B1 label=Update_Bad_Tempered_Thing_Dialogue_Task2SpawnZero
  $D8B1,$01 Advance the dialogue-check counter in #REGb.
  $D8B2,$03 Load #REGa with the entity spawn timer (#R$72C0).
  $D8B5,$03 Is entity spawn timer zero? If not, jump to #R$D8C0.
  $D8B8,$03 Load #REGa with the game event flags (#R$72B3).
  $D8BB,$05 Is bit #N$07 of game event flags set? If not, jump to #R$D971.
N $D8C0 Task-#N$02 spawn-timer path: match #R$72BF and require timer #N$04 for
. the final line.
@ $D8C0 label=Update_Bad_Tempered_Thing_Dialogue_Task2SpawnMatch
  $D8C0,$01 Advance the dialogue-check counter in #REGb.
  $D8C1,$03 Load #REGa with the entity spawn timer (#R$72C0).
  $D8C4,$04 Is entity spawn timer zero? If so, jump to #R$D971.
  $D8C8,$01 Advance the dialogue-check counter in #REGb.
  $D8C9,$01 Keep entity spawn timer in #REGc for later.
  $D8CA,$03 Load #REGa with the room-transition flag (#R$72BF).
  $D8CD,$04 Does the room-transition flag equal the spawn timer in #REGc? If
. not, jump to #R$D971.
  $D8D1,$01 Advance the dialogue-check counter in #REGb.
  $D8D2,$03 Load #REGa with the entity spawn timer (#R$72C0).
  $D8D5,$05 Is entity spawn timer equal to #N$04? If not, jump to #R$D971.
  $D8DA,$01 Advance the dialogue-check counter in #REGb.
  $D8DB,$03 Jump to #R$D971.
N $D8DE Task #N$03 gates: require the script-active flag and phase #N$03 before
. Slimy / stove checks.
@ $D8DE label=Update_Bad_Tempered_Thing_Dialogue_Task3Gates
  $D8DE,$02 Load #REGb with #N$01 as a loop counter.
  $D8E0,$03 Load #REGa with the game event flags (#R$72B3).
  $D8E3,$04 Is bit #N$07 of game event flags set? If not, jump to #R$D8EF.
  $D8E7,$03 Load #REGa with the current task phase (#R$72AF).
  $D8EA,$05 Is current task phase equal to #N$03? If not, jump to #R$D971.
N $D8EF Task-#N$03 creature X and Slimies / SlimyLoose / StoveReady flags choose
. the line index.
@ $D8EF label=Update_Bad_Tempered_Thing_Dialogue_Task3CreatureFlags
  $D8EF,$02 Advance the dialogue-check counter in #REGb by two.
  $D8F1,$04 Point #REGix at the cauldron entity (#R$9063).
  $D8F5,$03 Load #REGa with the current entity's x-coordinate.
  $D8F8,$05 Is the current entity's x-coordinate less than #N$5E? If so, jump to
. #R$D971.
  $D8FD,$01 Advance the dialogue-check counter in #REGb.
  $D8FE,$03 Point #REGhl at the task-three flags (#R$72B6).
  $D901,$05 Is Slimies (bit #N$01 of #R$72B6) set? If not, jump to #R$D971.
  $D906,$01 Advance the dialogue-check counter in #REGb.
  $D907,$05 Is SlimyLoose (bit #N$02 of #R$72B6) set? If so, jump to #R$D971.
  $D90C,$02 Advance the dialogue-check counter in #REGb by two.
  $D90E,$03 Load #REGa with the game event flags (#R$72B3).
  $D911,$04 Is bit #N$07 of game event flags set? If not, jump to #R$D91A.
  $D915,$05 Is StoveReady (bit #N$06 of #R$72B6) set? If not, jump to #R$D971.
N $D91A Final task-#N$03 gates: StoveReady, MobileHeater, and BoilEmUp must all
. be set.
@ $D91A label=Update_Bad_Tempered_Thing_Dialogue_Task3FlagWalk
  $D91A,$01 Advance the dialogue-check counter in #REGb.
  $D91B,$05 Is StoveReady (bit #N$06 of #R$72B6) set? If not, jump to #R$D971.
  $D920,$01 Advance the dialogue-check counter in #REGb.
  $D921,$05 Is MobileHeater (bit #N$00 of #R$72B6) set? If not, jump to #R$D971.
  $D926,$01 Advance the dialogue-check counter in #REGb.
  $D927,$05 Is BoilEmUp (bit #N$04 of #R$72B6) set? If not, jump to #R$D971.
  $D92C,$01 Advance the dialogue-check counter in #REGb.
  $D92D,$03 Jump to #R$D971.
N $D930 Task #N$04 gates: animation frame, interaction bits on #R$72B9, and
. phase #N$04 choose the line.
@ $D930 label=Update_Bad_Tempered_Thing_Dialogue_Task4Gates
  $D930,$02 Load #REGb with #N$01 as a loop counter.
  $D932,$03 Load #REGa with the animation frame counter (#R$72C1).
  $D935,$05 Is animation frame counter equal to #N$03? If so, jump to #R$D971.
  $D93A,$01 Advance the dialogue-check counter in #REGb.
  $D93B,$03 Point #REGhl at the entity interaction flag (#R$72B9).
  $D93E,$05 Is bit #N$01 of #R$72B9 set? If not, jump to #R$D971.
  $D943,$01 Advance the dialogue-check counter in #REGb.
  $D944,$05 Is bit #N$04 of #R$72B9 set? If not, jump to #R$D971.
  $D949,$01 Advance the dialogue-check counter in #REGb.
  $D94A,$03 Load #REGa with the game event flags (#R$72B3).
  $D94D,$05 Is bit #N$07 of game event flags set? If not, jump to #R$D971.
  $D952,$01 Advance the dialogue-check counter in #REGb.
  $D953,$03 Load #REGa with the current task phase (#R$72AF).
  $D956,$05 Is current task phase equal to #N$04? If not, jump to #R$D971.
  $D95B,$01 Advance the dialogue-check counter in #REGb.
  $D95C,$05 Is bit #N$02 of #R$72B9 set? If so, jump to #R$D971.
  $D961,$01 Advance the dialogue-check counter in #REGb.
  $D962,$03 Jump to #R$D971.

g $D965 Table: Bad Tempered Thing Dialogue
@ $D965 label=Data_BadTemperedThingDialogue
D $D965 Per-task dialogue pointers indexed by #R$D983. Task #N$00 skips this
. table and uses #R$D7CD instead.
W $D965,$02 Task #N$00 (unused, #N($0000,$04,$04)).
W $D967,$02 Task #N$01 dialogue at #R$DAC3.
W $D969,$02 Task #N$02 dialogue at #R$DB22.
W $D96B,$02 Task #N$03 dialogue at #R$DBA6.
W $D96D,$02 Task #N$04 dialogue at #R$DC56.
W $D96F,$02 Task #N$05 dialogue at #R$DCE9.

c $D971 Continue Bad Tempered Thing Dialogue
@ $D971 label=Continue_Bad_Tempered_Thing_Dialogue
D $D971 Continuation of #R$D7D3 after the dialogue table at #R$D965.
  $D971,$03 Load #REGa with the current task index (#R$72AE).
  $D974,$03 Is #REGa zero? If not, jump to #R$D983.
  $D977,$03 Point #REGhl at Bad Tempered Thing dialogue bytes (#R$D7CD).
  $D97A,$02 Mark this Bad Tempered Thing aside as already shown (bit #N$00 of
. #R$D7CD).
  $D97C,$03 Point #REGhl at Messaging: Task Menu Options (#R$DA66).
  $D97F,$02 Load #REGa with #N$06.
  $D981,$02 Jump to #R$D9AE to pick a random dialogue variant.
N $D983 Index the per-task dialogue table at #R$D965 by the current task.
@ $D983 label=Update_Bad_Tempered_Thing_Dialogue_IndexTable
  $D983,$01 Double #REGa.
  $D984,$01 Copy #REGa into #REGe for later use.
  $D985,$02 Clear #REGd (high byte of a pointer/offset).
  $D987,$03 Point #REGhl at the dialogue table (#R$D965).
  $D98A,$01 Add the offset in #REGde to the pointer in #REGhl.
  $D98B,$03 Fetch the dialogue pointer into #REGde.
  $D98E,$01 Swap the destination and source pointers in #REGde/#REGhl.
N $D98F Skip join markers (#CHR$26) and walk #REGb fragments to the gated line.
@ $D98F label=Update_Bad_Tempered_Thing_Dialogue_SkipJoinMarkers
  $D98F,$03 Call #R$DA23 to advance Dialogue Character.
  $D992,$04 Is #REGa equal to #N$26? If so, jump to #R$D98F.
  $D996,$02 Decrease the loop counter in #REGb and jump to #R$D98F if more
. iterations remain.
N $D998 If the gate byte is non-zero, decrement it and fall back to a random
. aside; else start Part A.
@ $D998 label=Update_Bad_Tempered_Thing_Dialogue_GateByteOrAside
  $D998,$01 Fetch the byte at #REGhl.
  $D999,$03 Is #REGa zero? If so, jump to #R$D9BA.
  $D99C,$01 Decrease the counter/flag byte at #REGhl.
  $D99D,$03 Call #R$DA23 to advance Dialogue Character.
  $D9A0,$04 Is #REGa equal to #N$26? If so, jump to #R$D998.
  $D9A4,$03 Point #REGhl at Bad Tempered Thing dialogue bytes (#R$D7CD).
  $D9A7,$02 Set bit #N$00 of #R$D7CD (aside-already-shown).
  $D9A9,$03 Point #REGhl at #R$DD1C.
  $D9AC,$02 Load #REGa with #N$04.
N $D9AE Pick a random aside variant and skip that many fragments before
. printing.
@ $D9AE label=Update_Bad_Tempered_Thing_Dialogue_Hit
  $D9AE,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D9B1,$01 Turn the random roll into a #N$01-based skip count.
  $D9B2,$01 Copy #REGa into #REGb for later use.
N $D9B3 Consume the remaining skip count via #R$DA23, then enter the print setup
. at #R$D9C2.
@ $D9B3 label=Update_Bad_Tempered_Thing_Dialogue_Exit
  $D9B3,$03 Call #R$DA23 to advance Dialogue Character.
  $D9B6,$02 Decrease the loop counter in #REGb and jump to #R$D9B3 if more
. iterations remain.
  $D9B8,$02 Jump to #R$D9C2 to continue Bad Tempered Thing dialogue.
N $D9BA Seed a fresh random gate byte (#N$01..#N$03) when the previous gate hit
. zero.
@ $D9BA label=Update_Bad_Tempered_Thing_Dialogue_PartA
  $D9BA,$02 Load #REGa with #N$03.
  $D9BC,$03 Call #R$EAE5 to pick a pseudo-random value.
  $D9BF,$01 Turn the random roll into a #N$01-based gate value.
  $D9C0,$01 Set the byte at #REGhl.
  $D9C1,$01 Advance past the freshly written gate byte.
N $D9C2 Stash the dialogue string pointer and begin measuring the fragment
. length.
@ $D9C2 label=Update_Bad_Tempered_Thing_Dialogue_PartB
  $D9C2,$01 Stash #REGhl on the stack.
  $D9C3,$02 Load #REGe with #N$00.
N $D9C5 Count characters until a fragment (#CHR$5B) or join (#CHR$26) marker.
@ $D9C5 label=Update_Bad_Tempered_Thing_Dialogue_PartC
  $D9C5,$01 Fetch the byte at #REGhl.
  $D9C6,$04 Is #REGa equal to #N$5B? If so, jump to #R$D9D2.
  $D9CA,$04 Is #REGa equal to #N$26? If so, jump to #R$D9D2.
  $D9CE,$01 Advance the low byte of the pointer/offset in #REGde.
  $D9CF,$01 Advance through the dialogue fragment.
  $D9D0,$02 Jump to #R$D9C5 to fetch the next dialogue byte.
N $D9D2 Compute left padding so the line centres within the #N$17-character
. dialogue strip.
@ $D9D2 label=Update_Bad_Tempered_Thing_Dialogue_PartD
  $D9D2,$02 Load #REGa with #N$17.
  $D9D4,$01 Subtract #REGe from #REGa.
  $D9D5,$02 If no borrow/miss was signaled, jump to #R$D9D8.
  $D9D7,$01 Clear #REGa to #N$00.
N $D9D8 Halve that padding, restore the string pointer into #REGix, and aim
. #REGhl at #N$5AC1 (attribute buffer).
@ $D9D8 label=Update_Bad_Tempered_Thing_Dialogue_PartE
  $D9D8,$02 Shift the flag/value in #REGa right one bit.
  $D9DA,$02 Pop the dialogue string pointer into #REGix.
  $D9DC,$03 Load #REGhl with #N$5AC1 (attribute buffer).
  $D9DF,$01 Copy #REGa into #REGe for later use.
  $D9E0,$02 Clear #REGd (high byte of a pointer/offset).
  $D9E2,$01 Add the offset in #REGde to the pointer in #REGhl.
N $D9E3 Draw each dialogue character via #R$DA2D, saving the cursor in
. #R$D67D(#N$D7CE) / #R$D67D(#N$D7D0).
@ $D9E3 label=Update_Bad_Tempered_Thing_Dialogue_PartF
  $D9E3,$03 Load #REGe with the next dialogue character code from *(#REGix).
  $D9E6,$02 Clear #REGd (high byte of a pointer/offset).
  $D9E8,$03 Call #R$DA2D to draw Dialogue Character.
  $D9EB,$02 Advance the dialogue source pointer by one character.
  $D9ED,$01 Advance the attribute-file destination by one column.
  $D9EE,$04 Store #REGix in #R$D67D(#N$D7CE).
  $D9F2,$03 Store #REGhl in #R$D67D(#N$D7D0).
  $D9F5,$03 Fetch the next dialogue byte from *(#REGix).
  $D9F8,$04 Is #REGa equal to #N$5B? If so, jump to #R$D9FF.
  $D9FC,$03 Is #REGa equal to #N$26? If not, return.
N $D9FF End of line: clear the aside-shown bit, restore Berk's layout, and arm
. the #N$FE cooldown.
@ $D9FF label=Update_Bad_Tempered_Thing_Dialogue_PartG
  $D9FF,$03 Point #REGhl at Bad Tempered Thing dialogue bytes (#R$D7CD).
  $DA02,$02 Clear bit #N$00 of #R$D7CD (aside-already-shown).
  $DA04,$03 Point #REGhl at #R$9C9E.
  $DA07,$03 Write that layout pointer to Boney's graphic-layout field
. (#R$8EF3).
  $DA0A,$03 Load #REGa with the Bad Tempered Thing state (#R$72C7).
  $DA0D,$02 Is #REGa zero? If so, return.
  $DA0F,$02 Load #REGa with #N$FE.
  $DA11,$03 Set the Bad Tempered Thing state (#R$72C7).
  $DA14,$02 Load #REGa with #N$2F.
  $DA16,$03 Set the Bad Tempered Thing dialogue state (#R$D67D(#N$D7D2)).
  $DA19,$01 Return.
N $DA1A Resume a mid-line print from the saved #R$D67D(#N$D7CE) /
. #R$D67D(#N$D7D0) cursors.
@ $DA1A label=Update_Bad_Tempered_Thing_Dialogue_PartH
  $DA1A,$04 Load #REGix from #R$D67D(#N$D7CE).
  $DA1E,$03 Load #REGhl from #R$D67D(#N$D7D0).
  $DA21,$02 Jump to #R$D9E3 to reload the entity type for dialogue.

c $DA23 Advance Dialogue Character
@ $DA23 label=Advance_DialogueCharacter
D $DA23 Walk #REGhl forward through a dialogue printer string until the next
. fragment marker (#CHR$5B) or join marker (#CHR$26).
  $DA23,$05 Fetch the next dialogue byte. Advance the dialogue pointer. Is it a
. fragment marker (#CHR$5B)? If so, return with #REGhl on that marker.
  $DA28,$03 Is it a join marker (#CHR$26)? If so, return with #REGhl on that
. marker.
  $DA2B,$02 Jump to #R$DA23 to keep scanning.

c $DA2D Draw Dialogue Character
@ $DA2D label=Draw_DialogueCharacter
D $DA2D Draw one ROM/charset glyph for Bad Tempered Thing dialogue. #REGhl is
. the destination attribute-file address; #REGe holds the character code
. Thickens the bitmap (byte OR byte>>#N$01) and points Boney's graphic layout
. at #R$9C8A while the line is shown.
R $DA2D HL Attribute-file address for the glyph
R $DA2D E Character code to draw
N $DA2D Stash callers' registers and paint the glyph attribute.
  $DA2D,$03 Stash #REGde, #REGhl and #REGbc on the stack.
  $DA30,$03 Set the dialogue glyph attribute to bright white on black (#N$47).
N $DA33 Convert the attribute address into a screen-bitmap address and locate
. the glyph.
  $DA33,$04 Multiply the attribute address high byte by #N($08).
  $DA37,$02,b$01 Keep only the screen-bitmap high bits (mask #N$5B).
  $DA39,$01 Write the result back to #REGh.
  $DA3A,$01 Stash #REGhl on the stack.
  $DA3B,$09 Swap the character code into #REGhl, multiply it by #N($08), and add
. the character-set base at #R$72F9 to get the glyph address.
  $DA44,$01 Restore #REGde from the stack.
N $DA45 Copy eight thickened glyph rows to the screen.
  $DA45,$02 There are #N$08 pixel rows in a character.
N $DA47 Copy one thickened glyph row (byte OR byte>>#N$01) and point Berk at
. talking layout #R$9C8A.
@ $DA47 label=Draw_DialogueCharacter_CopyThickRow
  $DA47,$0A Copy one thickened glyph row (byte OR byte>>#N$01) to the screen and
. advance.
  $DA51,$06 Point Boney's graphic layout pointer (#R$8EF3) at #R$9C8A.
  $DA57,$03 Restore #REGbc, #REGhl and #REGde from the stack.
  $DA5A,$01 Return.

c $DA5B Clear Dialogue Area
@ $DA5B label=Clear_DialogueArea
D $DA5B Blank the Bad Tempered Thing dialogue attribute strip at
. #N$5AC1 (attribute buffer) (#N$17 characters).
  $DA5B,$03 Point #REGhl at the dialogue attribute row
. (#N$5AC1 (attribute buffer)).
  $DA5E,$02 Load #REGb with #N$17 as a clear counter.
N $DA60 Blank one attribute cell of the dialogue strip and loop for all #N$17
. columns.
@ $DA60 label=Clear_DialogueArea_WriteBlank
  $DA60,$05 Write ink/paper #N$00 at #REGhl. Advance along the row. Loop until
. the strip is cleared.
  $DA65,$01 Return.

t $DA66 Messaging: What Next ?
@ $DA66 label=Messaging_WhatNext
D $DA66 Task/prompt string. Opens with #CHR$5B separator.
B $DA66,$01 Separator (#CHR$5B); marks the boundary before the next message.
  $DA67,$0B "#STR(#PC,$04,$0B)".

t $DA72 Messaging: Wait
@ $DA72 label=Messaging_Wait
D $DA72 Task/prompt string. Opens with #CHR$5B separator.
B $DA72,$01 Separator (#CHR$5B); marks the boundary before the next message.
  $DA73,$04 "#STR(#PC,$04,$04)".

t $DA77 Messaging: Preparations ?
@ $DA77 label=Messaging_Preparations
D $DA77 Task/prompt string. Opens with #CHR$5B separator.
B $DA77,$01 Separator (#CHR$5B); marks the boundary before the next message.
  $DA78,$0E "#STR(#PC,$04,$0E)".

t $DA86 Messaging: I Needed A Pick-Me-Up
@ $DA86 label=Messaging_INeededAPickMeUp
D $DA86 Task/prompt string. Opens with #CHR$5B separator.
B $DA86,$01 Separator (#CHR$5B); marks the boundary before the next message.
  $DA87,$15 "#STR(#PC,$04,$15)".

t $DA9C Messaging: Berk, Berk, Go To Work
@ $DA9C label=Messaging_BerkBerkGoToWork
D $DA9C Task/prompt string. Opens with #CHR$5B separator.
B $DA9C,$01 Separator (#CHR$5B); marks the boundary before the next message.
  $DA9D,$16 "#STR(#PC,$04,$16)".

t $DAB3 Messaging: Are You Ready ?
@ $DAB3 label=Messaging_AreYouReady
D $DAB3 Task/prompt string. Opens with #CHR$5B separator.
B $DAB3,$01 Separator (#CHR$5B); marks the boundary before the next message.
  $DAB4,$0F "#STR(#PC,$04,$0F)".

t $DAC3 Messaging: Ghost !
@ $DAC3 label=Messaging_Ghost
D $DAC3 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DAC3,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DAC4,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DAC5,$07 "#STR(#PC,$04,$07)".
B $DACC,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DACD Messaging: Give It A Worm
@ $DACD label=Messaging_GiveItAWorm
D $DACD Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DACD,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DACE,$0E "#STR(#PC,$04,$0E)".

t $DADC Messaging: Fetch A Can
@ $DADC label=Messaging_FetchACan
D $DADC Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DADC,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DADD,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DADE,$0B "#STR(#PC,$04,$0B)".

t $DAE9 Messaging: Catch Worms
@ $DAE9 label=Messaging_CatchWorms
D $DAE9 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DAE9,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DAEA,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DAEB,$0B "#STR(#PC,$04,$0B)".
B $DAF6,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DAF7 Messaging: Under The Trap
@ $DAF7 label=Messaging_UnderTheTrap
D $DAF7 Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DAF7,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DAF8,$0E "#STR(#PC,$04,$0E)".

t $DB06 Messaging: More Worms ?
@ $DB06 label=Messaging_MoreWorms
D $DB06 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB06,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB07,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB08,$0C "#STR(#PC,$04,$0C)".

t $DB14 Messaging: Send Them Up
@ $DB14 label=Messaging_SendThemUp
D $DB14 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB14,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB15,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB16,$0C "#STR(#PC,$04,$0C)".

t $DB22 Messaging: Wrong Creature
@ $DB22 label=Messaging_WrongCreature
D $DB22 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB22,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB23,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB24,$0E "#STR(#PC,$04,$0E)".

t $DB32 Messaging: You'll Need A Pan
@ $DB32 label=Messaging_YoullNeedAPan
D $DB32 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB32,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB33,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB34,$11 "#STR(#PC,$04,$11)".

t $DB45 Messaging: Eggs Needed
@ $DB45 label=Messaging_EggsNeeded
D $DB45 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB45,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB46,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB47,$0B "#STR(#PC,$04,$0B)".
B $DB52,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DB53 Messaging: Trap ?
@ $DB53 label=Messaging_Trap
D $DB53 Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DB53,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB54,$06 "#STR(#PC,$04,$06)".

t $DB5A Messaging: Get It To Lay
@ $DB5A label=Messaging_GetItToLay
D $DB5A Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB5A,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB5B,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB5C,$0D "#STR(#PC,$04,$0D)".
B $DB69,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DB6A Messaging: Bullet
@ $DB6A label=Messaging_Bullet
D $DB6A Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DB6A,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB6B,$06 "#STR(#PC,$04,$06)".
B $DB71,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DB72 Messaging: Trap Lid
@ $DB72 label=Messaging_TrapLid
D $DB72 Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DB72,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB73,$08 "#STR(#PC,$04,$08)".

t $DB7B Messaging: In the pan
@ $DB7B label=Messaging_InThePan
D $DB7B Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB7B,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB7C,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB7D,$0A "#STR(#PC,$04,$0A)".

t $DB87 Messaging: More Eggs ?
@ $DB87 label=Messaging_MoreEggs
D $DB87 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB87,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB88,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB89,$0B "#STR(#PC,$04,$0B)".

t $DB94 Messaging: Frying Tonight !
@ $DB94 label=Messaging_FryingTonight
D $DB94 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DB94,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DB95,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DB96,$10 "#STR(#PC,$04,$10)".

t $DBA6 Messaging: Get Rid Of It
@ $DBA6 label=Messaging_GetRidOfIt
D $DBA6 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DBA6,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBA7,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBA8,$0D "#STR(#PC,$04,$0D)".

t $DBB5 Messaging: (Empty)
@ $DBB5 label=Messaging_Empty
D $DBB5 Empty prompt slot. #CHR$5B separator only.
B $DBB5,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DBB6 Messaging: Pot
@ $DBB6 label=Messaging_Pot
D $DBB6 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DBB6,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBB7,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBB8,$03 "#STR(#PC,$04,$03)".
B $DBBB,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DBBC Messaging: Big Pot
@ $DBBC label=Messaging_BigPot
D $DBBC Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DBBC,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBBD,$07 "#STR(#PC,$04,$07)".

t $DBC4 Messaging: Slimies
@ $DBC4 label=Messaging_Slimies
D $DBC4 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DBC4,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBC5,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBC6,$07 "#STR(#PC,$04,$07)".

t $DBCD Messaging: Slimy Loose !
@ $DBCD label=Messaging_SlimyLoose
D $DBCD Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DBCD,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBCE,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBCF,$0D "#STR(#PC,$04,$0D)".

t $DBDC Messaging: Empty Task-Gate Stub
D $DBDC Padding stub between task prompts: #CHR$5B separator and gate byte
. #N$00.
B $DBDC,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBDD,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.

t $DBDE Messaging: Too Soon ?
@ $DBDE label=Messaging_TooSoon
D $DBDE Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DBDE,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBDF,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBE0,$0A "#STR(#PC,$04,$0A)".
B $DBEA,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DBEB Messaging: Hot Stuff
@ $DBEB label=Messaging_HotStuff
D $DBEB Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DBEB,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBEC,$09 "#STR(#PC,$04,$09)".

t $DBF5 Messaging: Got All Slimies ?
@ $DBF5 label=Messaging_GotAllSlimies
D $DBF5 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DBF5,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DBF6,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DBF7,$11 "#STR(#PC,$04,$11)".

t $DC08 Messaging: Mobile Heater
@ $DC08 label=Messaging_MobileHeater
D $DC08 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DC08,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DC09,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC0A,$0D "#STR(#PC,$04,$0D)".
B $DC17,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DC18 Messaging: The Stove's No Help
@ $DC18 label=Messaging_TheStovesNoHelp
D $DC18 Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DC18,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC19,$13 "#STR(#PC,$04,$13)".

t $DC2C Messaging: Boil'Em Up !
@ $DC2C label=Messaging_BoilEmUp
D $DC2C Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DC2C,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DC2D,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC2E,$0C "#STR(#PC,$04,$0C)".
B $DC3A,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DC3B Messaging: Flame ?
@ $DC3B label=Messaging_Flame
D $DC3B Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DC3B,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC3C,$07 "#STR(#PC,$04,$07)".

t $DC43 Messaging: He Likes Them Hot
@ $DC43 label=Messaging_HeLikesThemHot
D $DC43 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DC43,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DC44,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC45,$11 "#STR(#PC,$04,$11)".

t $DC56 Messaging: Send It Up
@ $DC56 label=Messaging_SendItUp
D $DC56 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DC56,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DC57,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC58,$0A "#STR(#PC,$04,$0A)".

t $DC62 Messaging: Sowing Time
@ $DC62 label=Messaging_SowingTime
D $DC62 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DC62,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DC63,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC64,$0B "#STR(#PC,$04,$0B)".
B $DC6F,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DC70 Messaging: Plantpots ?
@ $DC70 label=Messaging_Plantpots
D $DC70 Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DC70,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC71,$0B "#STR(#PC,$04,$0B)".
B $DC7C,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DC7D Messaging: Snatch Their Eyes Off !
@ $DC7D label=Messaging_SnatchTheirEyesOff
D $DC7D Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DC7D,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC7E,$17 "#STR(#PC,$04,$17)".

t $DC95 Messaging: Vat
@ $DC95 label=Messaging_Vat
D $DC95 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DC95,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DC96,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC97,$03 "#STR(#PC,$04,$03)".
B $DC9A,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DC9B Messaging: Ghosts Love Eyes
@ $DC9B label=Messaging_GhostsLoveEyes
D $DC9B Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DC9B,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DC9C,$10 "#STR(#PC,$04,$10)".

t $DCAC Messaging: Crusher Wanted
@ $DCAC label=Messaging_CrusherWanted
D $DCAC Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DCAC,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DCAD,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DCAE,$0E "#STR(#PC,$04,$0E)".

t $DCBC Messaging: Is This A Crusher ?
@ $DCBC label=Messaging_IsThisACrusher
D $DCBC Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DCBC,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DCBD,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DCBE,$13 "#STR(#PC,$04,$13)".

t $DCD1 Messaging: Bottle ?
@ $DCD1 label=Messaging_Bottle
D $DCD1 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DCD1,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DCD2,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DCD3,$08 "#STR(#PC,$04,$08)".

t $DCDB Messaging: Position Vat
@ $DCDB label=Messaging_PositionVat
D $DCDB Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DCDB,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DCDC,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DCDD,$0C "#STR(#PC,$04,$0C)".

t $DCE9 Messaging: Clear The Lot
@ $DCE9 label=Messaging_ClearTheLot
D $DCE9 Task-gated prompt. Opens with #CHR$5B separator, then gate byte #N$00.
B $DCE9,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DCEA,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DCEB,$0D "#STR(#PC,$04,$0D)".
B $DCF8,$01 Joiner (#CHR$26); continues into the next prompt in the same menu
. entry.

t $DCF9 Messaging: Down The Hole
@ $DCF9 label=Messaging_DownTheHole
D $DCF9 Joined prompt after #CHR$26. Leading gate byte #N$00.
B $DCF9,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.
  $DCFA,$0D "#STR(#PC,$04,$0D)".

t $DD07 Messaging: Empty Task-Gate Stub
D $DD07 Padding stub before the Bad Tempered Thing asides: #CHR$5B separator and
. gate byte #N$00.
B $DD07,$01 Separator (#CHR$5B); marks the boundary before the next message.
B $DD08,$01 Task-gate byte (#N$00); show this prompt only when the matching task
. phase allows it.

; =============================================================================
; Bad Tempered Thing asides ($DD09–$DD9E). Text fragments separated by #CHR$5B
; (no "]" terminators). Typos preserved from the original tape.
; =============================================================================

t $DD09 Messaging: Your're On Your Own
@ $DD09 label=Messaging_YourreOnYourOwn
D $DD09 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD09,$13 "#STR(#PC,$04,$13)".
B $DD1C,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD1D Messaging: Hurry Up
@ $DD1D label=Messaging_HurryUp
D $DD1D Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD1D,$08 "#STR(#PC,$04,$08)".
B $DD25,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD26 Messaging: I'm Thinking
@ $DD26 label=Messaging_ImThinking
D $DD26 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD26,$0C "#STR(#PC,$04,$0C)".
B $DD32,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD33 Messaging: Leave Me Alone
@ $DD33 label=Messaging_LeaveMeAlone
D $DD33 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD33,$0E "#STR(#PC,$04,$0E)".
B $DD41,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD42 Messaging: 'Im Upstairs Waits
@ $DD42 label=Messaging_ImUpstairsWaits
D $DD42 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD42,$12 "#STR(#PC,$04,$12)".
B $DD54,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD55 Messaging: Empty Aside Stub
D $DD55 Padding separator stub in the Bad Tempered Thing aside list.
B $DD55,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD56 Messaging: Ow !
@ $DD56 label=Messaging_Ow
D $DD56 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD56,$04 "#STR(#PC,$04,$04)".
B $DD5A,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD5B Messaging: Get Me Out Of Here !
@ $DD5B label=Messaging_GetMeOutOfHere
D $DD5B Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD5B,$14 "#STR(#PC,$04,$14)".
B $DD6F,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD70 Messaging: Empty Aside Stub
D $DD70 Padding separator stub in the Bad Tempered Thing aside list.
B $DD70,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD71 Messaging: No !!
@ $DD71 label=Messaging_No
D $DD71 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD71,$05 "#STR(#PC,$04,$05)".
B $DD76,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD77 Messaging: AAHHHHHhhhhhh !!!
@ $DD77 label=Messaging_AAHHHHHhhhhhh
D $DD77 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD77,$11 "#STR(#PC,$04,$11)".
B $DD88,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD89 Messaging: Wheeeeeeee
@ $DD89 label=Messaging_Wheeeeeeee
D $DD89 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD89,$0A "#STR(#PC,$04,$0A)".
B $DD93,$01 Separator (#CHR$5B); marks the boundary before the next message.

t $DD94 Messaging: Going Up ?
@ $DD94 label=Messaging_GoingUp
D $DD94 Bad Tempered Thing aside. Separated from the next by #CHR$5B.
  $DD94,$0A "#STR(#PC,$04,$0A)".
B $DD9E,$01 Separator (#CHR$5B); marks the boundary before the next message.

S $DD9F,$04

; =============================================================================
; Task feedback / ratings ($DDB4–$DE18).
; =============================================================================

c $DDA3 Print Too-Late Task Feedback
@ $DDA3 label=Print_TooLateTaskFeedback
D $DDA3 When the player runs out of time / fails the current brief, clear task
. phase if this is task #N($01), then print "TOO LATE+I'VE CHANGED MY MIND" from
. #R$DDB4 via #R$E286.
N $DDA3 Reset task #N$01's phase, then print the too-late line.
  $DDA3,$07 Fetch the current task index (#R$72AE). Is it task #N$01? If not,
. skip the phase clear at #R$DDAE.
  $DDAA,$04 Clear #REGa, then write #N$00 to the current task phase (#R$72AF).
N $DDAE Print the too-late feedback at #R$DDB4 via #R$E286.
@ $DDAE label=Print_TooLateTaskFeedback_Print
  $DDAE,$03 Point #REGhl at Messaging: Task Feedback (#R$DDB4).
  $DDB1,$03 Jump to #R$E286 to print that encoded message.

t $DDB4 Messaging: Too Late I've Changed My Mind
@ $DDB4 label=Messaging_TooLateIveChangedMyMind
D $DDB4 Encoded feedback line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DDB4,$20 "#STR(#PC,$04,$20)".
B $DDD4,$01 Terminator (#CHR$5D); ends this encoded message.

t $DDD5 Messaging: As A Learner I Think You Are..
@ $DDD5 label=Messaging_AsALearnerIThinkYouAre
D $DDD5 Encoded feedback line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DDD5,$21 "#STR(#PC,$04,$21)".
B $DDF6,$01 Terminator (#CHR$5D); ends this encoded message.

t $DDF7 Messaging: As A Superberk I Rate You As..
@ $DDF7 label=Messaging_AsASuperberkIRateYouAs
D $DDF7 Encoded feedback line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DDF7,$21 "#STR(#PC,$04,$21)".
B $DE18,$01 Terminator (#CHR$5D); ends this encoded message.

; =============================================================================
; Task briefings and end-of-task ratings ($DE63–$DFB4).
; =============================================================================

c $DE19 Print Status Messages
@ $DE19 label=Print_StatusMessages
D $DE19 Print the Learner/Super rating line from #R$DDB4, then a task-progress
. line chosen from the task status flags (#R$72B4).
N $DE19 Choose the rating message from the Learner Berk mode flag (#R$72A9).
  $DE19,$03 Load #REGa with the Learner Berk mode flag (#R$72A9).
  $DE1C,$03 Is Learner mode selected? If so, use the Learner rating at #R$DDD5.
  $DE1F,$03 Point #REGhl at the Super Berk rating message (#R$DDF7).
  $DE22,$02 Skip to print it at #R$DE27.
N $DE24 Use the Learner Berk rating message at #R$DDD5.
@ $DE24 label=Print_StatusMessages_Learner
  $DE24,$03 Point #REGhl at the Learner rating message (#R$DDD5).
N $DE27 Print the chosen Learner / Super rating line via #R$E286.
@ $DE27 label=Print_StatusMessages_PrintRating
  $DE27,$03 Call #R$E286 to print the encoded rating message.
N $DE2A Choose a task-progress message index from #R$72B4 / #R$72B0.
  $DE2A,$03 Point #REGhl at the task briefing/progress table (#R$DF0D).
  $DE2D,$03 Load the task status flags (#R$72B4).
  $DE30,$03 Any task-status bits set? If not, use the dialogue line index at
. #R$DE33.
N $DE33 Fall back to dialogue-line index #R$72B0 when no task-status bits are
. set.
@ $DE33 label=Print_StatusMessages_UseDialogueIndex
  $DE33,$03 Load the dialogue line index (#R$72B0).
  $DE36,$01 Advance it by one for the table walk.
  $DE37,$02 Jump to #R$DE4A to print that indexed string.
N $DE39 Derive the progress message from task-status flags (#R$72B4), including
. Drutt's type-#N$18 catch.
@ $DE39 label=Print_StatusMessages_FromTaskFlags
  $DE39,$03 Reload the task status flags (#R$72B4).
  $DE3C,$04 Did Drutt collect a type-#N$18 object (bit #N$04)? If so, use index
. #N$06.
  $DE40,$02 Load message index #N$06.
  $DE42,$02 Jump to #R$DE4A to print the indexed status string.
N $DE44 If Drutt caught a type-#N$1C object (bit #N$05), use progress message
. index #N$07.
@ $DE44 label=Print_StatusMessages_SafeLootBit
  $DE44,$04 Did Drutt collect a type-#N$1C object (bit #N$05)? If not, fall back
. to #R$DE33.
  $DE48,$02 Load message index #N$07.
N $DE4A Print the indexed progress string via #R$DE57, then seed menu music and
. wait for a key via #R$FC6C.
@ $DE4A label=Print_StatusMessages_PrintIndexed
  $DE4A,$03 Call #R$DE57 to print the indexed string at #REGhl.
  $DE4D,$03 Call #R$FC6C to seed the menu music and wait for a key.
  $DE50,$01 Return.

c $DE51 Print Message By Index
@ $DE51 label=Print_MessageByIndex
D $DE51 Print briefing message number #REGa from the table at #R$DE63.
  $DE51,$03 Load #REGa with the current task index (#R$72AE).
  $DE54,$03 Point #REGhl at Messaging: Berk ! Get Me A Can Of Worms (#R$DE63)
. (task briefing table).

c $DE57 Print Message String
@ $DE57 label=Print_MessageString
D $DE57 Skip #REGa encoded messages at #REGhl (each ends with #CHR$5D), then
. print the selected one via #R$E286.
  $DE57,$01 Keep the message index in #REGb.
N $DE58 Skip one encoded message at #REGhl (via #R$E2F9) until the selected
. index remains.
@ $DE58 label=Print_MessageString_SkipOneMessage
  $DE58,$06 Call #R$E2F9 to advance #REGhl past one encoded message. Step on by
. one byte. Loop until #REGb messages have been skipped.
  $DE5E,$01 Step back onto the chosen message's terminator.
  $DE5F,$03 Call #R$E286 to print that encoded message.
  $DE62,$01 Return.

t $DE63 Messaging: Berk ! Get Me A Can Of Worms
@ $DE63 label=Messaging_BerkGetMeACanOfWorms
D $DE63 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DE63,$1F "#STR(#PC,$04,$1F)".
B $DE82,$01 Terminator (#CHR$5D); ends this encoded message.

t $DE83 Messaging: Berk ! I Want Some Fried Eggs
@ $DE83 label=Messaging_BerkIWantSomeFriedEggs
D $DE83 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DE83,$20 "#STR(#PC,$04,$20)".
B $DEA3,$01 Terminator (#CHR$5D); ends this encoded message.

t $DEA4 Messaging: Berk ! I Want Boiled Slimies
@ $DEA4 label=Messaging_BerkIWantBoiledSlimies
D $DEA4 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DEA4,$1F "#STR(#PC,$04,$1F)".
B $DEC3,$01 Terminator (#CHR$5D); ends this encoded message.

t $DEC4 Messaging: I Want A Bottle Of Eyeball Crush
@ $DEC4 label=Messaging_IWantABottleOfEyeballCrush
D $DEC4 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DEC4,$23 "#STR(#PC,$04,$23)".
B $DEE7,$01 Terminator (#CHR$5D); ends this encoded message.

t $DEE8 Messaging: Tidy Up And Then Send The Lift Up
@ $DEE8 label=Messaging_TidyUpAndThenSendTheLiftUp
D $DEE8 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DEE8,$24 "#STR(#PC,$04,$24)".
B $DF0C,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF0D Messaging: A Complete Failure You're Fired !
@ $DF0D label=Messaging_ACompleteFailureYoureFired
D $DF0D Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF0D,$26 "#STR(#PC,$04,$26)".
B $DF33,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF34 Messaging: Incompetent
@ $DF34 label=Messaging_Incompetent
D $DF34 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF34,$10 "#STR(#PC,$04,$10)".
B $DF44,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF45 Messaging: Just Employable
@ $DF45 label=Messaging_JustEmployable
D $DF45 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF45,$14 "#STR(#PC,$04,$14)".
B $DF59,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF5A Messaging: Getting There
@ $DF5A label=Messaging_GettingThere
D $DF5A Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF5A,$12 "#STR(#PC,$04,$12)".
B $DF6C,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF6D Messaging: A Little Treasure
@ $DF6D label=Messaging_ALittleTreasure
D $DF6D Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF6D,$16 "#STR(#PC,$04,$16)".
B $DF83,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF84 Messaging: Good But Underpaid
@ $DF84 label=Messaging_GoodButUnderpaid
D $DF84 Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF84,$17 "#STR(#PC,$04,$17)".
B $DF9B,$01 Terminator (#CHR$5D); ends this encoded message.

t $DF9C Messaging: Clever And Overpaid
@ $DF9C label=Messaging_CleverAndOverpaid
D $DF9C Encoded briefing line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DF9C,$18 "#STR(#PC,$04,$18)".
B $DFB4,$01 Terminator (#CHR$5D); ends this encoded message.

; =============================================================================
; Death message ($DFBB–$DFDC).
; =============================================================================

c $DFB5 Print Death Message
@ $DFB5 label=Print_DeathMessage
D $DFB5 Print Messaging: You Silly Suicidal Little Berk (#R$DFBB) via #R$E286.
  $DFB5,$03 Point #REGhl at Messaging: You Silly Suicidal Little Berk (#R$DFBB).
  $DFB8,$03 Jump to #R$E286 to print it.

t $DFBB Messaging: You Silly Suicidal Little Berk
@ $DFBB label=Messaging_YouSillySuicidalLittleBerk
D $DFBB Encoded death line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $DFBB,$21 "#STR(#PC,$04,$21)".
B $DFDC,$01 Terminator (#CHR$5D); ends this encoded message.

; =============================================================================
; Not-tidy progress ($DFE3–$DFF2).
; =============================================================================

c $DFDD Print Task Progress Intro
@ $DFDD label=Print_TaskProgressIntro
D $DFDD Print Messaging: Not Tidy Yet (#R$DFE3) via #R$E286.
  $DFDD,$03 Point #REGhl at Messaging: Not Tidy Yet (#R$DFE3).
  $DFE0,$03 Jump to #R$E286.

t $DFE3 Messaging: Not Tidy Yet
@ $DFE3 label=Messaging_NotTidyYet
D $DFE3 Encoded progress line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, ends with #CHR$5D.
  $DFE3,$0F "#STR(#PC,$04,$0F)".
B $DFF2,$01 Terminator (#CHR$5D); ends this encoded message.

; =============================================================================
; Wages / mid-task progress prompts ($DFF9–$E24D). After #CHR$5B may follow a
; phase byte, #CHR$21 / #CHR$29 tests, then #CHR$60, text, and #CHR$5D or
; #CHR$24.
; =============================================================================

c $DFF3 Print Wages Message
@ $DFF3 label=Print_WagesMessage
D $DFF3 Print Messaging: Here Are Your Wages (#R$DFF9) via #R$E286.
  $DFF3,$03 Point #REGhl at Messaging: Here Are Your Wages (#R$DFF9).
  $DFF6,$03 Jump to #R$E286.

t $DFF9 Messaging: Here Are Your Wages
@ $DFF9 label=Messaging_HereAreYourWages
D $DFF9 Encoded progress line. Opens with #CHR$5B, print-controls #CHR$5F /
. #CHR$60, ends with #CHR$5D.
  $DFF9,$16 "#STR(#PC,$04,$16)".
B $E00F,$01 Terminator (#CHR$5D); ends this encoded message.

t $E010 Messaging: A Can A Tin Can
@ $E010 label=Messaging_ACanATinCan
D $E010 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($00),
. #CHR$21 / #N$08 gate, print-control #CHR$60, #CHR$2B starts a new row, ends
. with #CHR$5D.
  $E010,$14 "#STR(#PC,$04,$14)".
B $E024,$01 Terminator (#CHR$5D); ends this encoded message.

t $E025 Messaging: Where Are The Worms ? Get Them
@ $E025 label=Messaging_WhereAreTheWormsGetThem
D $E025 Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($01),
. print-control #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $E025,$22 "#STR(#PC,$04,$22)".
B $E047,$01 Terminator (#CHR$5D); ends this encoded message.

t $E048 Messaging: OK But I Wanted More Worms !
@ $E048 label=Messaging_OKButIWantedMoreWorms
D $E048 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($02),
. #CHR$29 pointer test (#R$72BD), #N($40), print-control #CHR$60, #CHR$2B starts
. a new row, ends with #CHR$5D.
  $E048,$23 "#STR(#PC,$04,$23)".
B $E06B,$01 Terminator (#CHR$5D); ends this encoded message.

t $E06C Messaging: Lovely Worms ! Well Done, Berk
@ $E06C label=Messaging_LovelyWormsWellDoneBerk
D $E06C Encoded progress line. Opens with #CHR$5B, phase/control byte #N($03),
. print-control #CHR$60, #CHR$2B starts a new row, ends with #CHR$5D.
  $E06C,$21 "#STR(#PC,$04,$21)".
B $E08D,$01 Terminator (#CHR$5D); ends this encoded message.

t $E08E Messaging: I Want My Eggs In A Pan
@ $E08E label=Messaging_IWantMyEggsInAPan
D $E08E Encoded progress line. Opens with #CHR$5B, phase/control byte #N($00),
. #CHR$21 / #N$04 gate, print-control #CHR$60, ends with #CHR$24 alternate end
. (plus linked phase byte).
  $E08E,$1C "#STR(#PC,$04,$1C)".
B $E0AA,$02 Alternate end.

t $E0AC Messaging: No Eggs !
@ $E0AC label=Messaging_NoEggs
D $E0AC Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($01),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E0AC,$0D "#STR(#PC,$04,$0D)".
B $E0B9,$02 Alternate end.

t $E0BB Messaging: Not Cooked !
@ $E0BB label=Messaging_NotCooked
D $E0BB Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($02),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E0BB,$10 "#STR(#PC,$04,$10)".
B $E0CB,$02 Alternate end.

t $E0CD Messaging: Not Hot !
@ $E0CD label=Messaging_NotHot
D $E0CD Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($03),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E0CD,$0D "#STR(#PC,$04,$0D)".
B $E0DA,$02 Alternate end.

t $E0DC Messaging: A Fair Try But Not Enough Eggs !
@ $E0DC label=Messaging_AFairTryButNotEnoughEggs
D $E0DC Encoded progress line. Opens with #CHR$5B, phase/control byte #N($04),
. #CHR$29 pointer test (#R$72BF), #N($40), print-control #CHR$60, #CHR$2B starts
. a new row, ends with #CHR$5D.
  $E0DC,$27 "#STR(#PC,$04,$27)".
B $E103,$01 Terminator (#CHR$5D); ends this encoded message.

t $E104 Messaging: Well Done, Berk
@ $E104 label=Messaging_WellDoneBerk
D $E104 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($05),
. print-control #CHR$60, ends with #CHR$5D.
  $E104,$12 "#STR(#PC,$04,$12)".
B $E116,$01 Terminator (#CHR$5D); ends this encoded message.

t $E117 Messaging: Get The Job Done !
@ $E117 label=Messaging_GetTheJobDone
D $E117 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($08),
. print-control #CHR$60, ends with #CHR$5D.
  $E117,$15 "#STR(#PC,$04,$15)".
B $E12C,$01 Terminator (#CHR$5D); ends this encoded message.

t $E12D Messaging: A Big Pot For Slimies
@ $E12D label=Messaging_ABigPotForSlimies
D $E12D Encoded progress line. Opens with #CHR$5B, phase/control byte #N($0A),
. #CHR$21 / #N$14 gate, print-control #CHR$60, ends with #CHR$24 alternate end
. (plus linked phase byte).
  $E12D,$1A "#STR(#PC,$04,$1A)".
B $E147,$02 Alternate end.

t $E149 Messaging: No Slimies !
@ $E149 label=Messaging_NoSlimies
D $E149 Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($0B),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E149,$10 "#STR(#PC,$04,$10)".
B $E159,$02 Alternate end.

t $E15B Messaging: They're Raw Ugh!
@ $E15B label=Messaging_TheyreRawUgh
D $E15B Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($0C),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E15B,$15 "#STR(#PC,$04,$15)".
B $E170,$02 Alternate end.

t $E172 Messaging: Cold Slimies !
@ $E172 label=Messaging_ColdSlimies
D $E172 Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($0D),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E172,$12 "#STR(#PC,$04,$12)".
B $E184,$02 Alternate end.

t $E186 Messaging: Not Bad But Short On Slimies !
@ $E186 label=Messaging_NotBadButShortOnSlimies
D $E186 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($0E),
. #CHR$29 pointer test (#R$72BE), #N($40), print-control #CHR$60, #CHR$2B starts
. a new row, ends with #CHR$5D.
  $E186,$25 "#STR(#PC,$04,$25)".
B $E1AB,$01 Terminator (#CHR$5D); ends this encoded message.

t $E1AC Messaging: Fantastic, 4 Boiled Slimies
@ $E1AC label=Messaging_Fantastic4BoiledSlimies
D $E1AC Encoded progress line. Opens with #CHR$5B, phase/control byte #N($0F),
. print-control #CHR$60, ends with #CHR$5D.
  $E1AC,$1E "#STR(#PC,$04,$1E)".
B $E1CA,$01 Terminator (#CHR$5D); ends this encoded message.

t $E1CB Messaging: Do Something About It !
@ $E1CB label=Messaging_DoSomethingAboutIt
D $E1CB Encoded progress line. Opens with #CHR$5B, phase/control byte #N($11),
. print-control #CHR$60, ends with #CHR$5D.
  $E1CB,$1A "#STR(#PC,$04,$1A)".
B $E1E5,$01 Terminator (#CHR$5D); ends this encoded message.

t $E1E6 Messaging: In A Bottle
@ $E1E6 label=Messaging_InABottle
D $E1E6 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($14),
. #CHR$21 / #N$11 gate, print-control #CHR$60, ends with #CHR$24 alternate end
. (plus linked phase byte).
  $E1E6,$10 "#STR(#PC,$04,$10)".
B $E1F6,$02 Alternate end.

t $E1F8 Messaging: It's Empty !
@ $E1F8 label=Messaging_ItsEmpty
D $E1F8 Encoded progress line. Opens with #CHR$5B, phase/control bytes #N($15),
. print-control #CHR$60, ends with #CHR$24 alternate end (plus linked phase
. byte).
  $E1F8,$10 "#STR(#PC,$04,$10)".
B $E208,$02 Alternate end.

t $E20A Messaging: A Good Try Did You Drink Some ?
@ $E20A label=Messaging_AGoodTryDidYouDrinkSome
D $E20A Encoded progress line. Opens with #CHR$5B, phase/control byte #N($16),
. #CHR$29 pointer test (#R$72C1), #N($40), print-control #CHR$60, #CHR$2B starts
. a new row, ends with #CHR$5D.
  $E20A,$26 "#STR(#PC,$04,$26)".
B $E230,$01 Terminator (#CHR$5D); ends this encoded message.

t $E231 Messaging: Cheers
@ $E231 label=Messaging_Cheers
D $E231 Encoded progress line. Opens with #CHR$5B, phase/control byte #N($17),
. print-control #CHR$60, ends with #CHR$5D.
  $E231,$09 "#STR(#PC,$04,$09)".
B $E23A,$01 Terminator (#CHR$5D); ends this encoded message.

t $E23B Messaging: I Want My Juice
@ $E23B label=Messaging_IWantMyJuice
D $E23B Encoded progress line. Opens with #CHR$5B, phase/control byte #N($1B),
. print-control #CHR$60, ends with #CHR$5D.
  $E23B,$12 "#STR(#PC,$04,$12)".
B $E24D,$01 Terminator (#CHR$5D); ends this encoded message.

w $E24E Table: Task Progress Message Pointers
@ $E24E label=Table_TaskProgressMessagePointers
D $E24E Four entries for tasks #N$01–#N$04 used by #R$E25E. Each entry is a flag
. address followed by a message address: worms (#R$E010), eggs (#R$E08E),
. slimies (#R$E12D), bottle (#R$E1E6).
W $E24E,$02,$02 Flag pointer / message pointer for task #N$01.
L $E24E,$04,$04

c $E25E Select Task Progress Message
@ $E25E label=Select_TaskProgressMessage
D $E25E Choose which mid-task progress message to show from the current task
. index (#R$72AE), then continue on to #R$E286 to print it. Task #N$05
. branches to #R$DFDD ("NOT TIDY YET") or #R$DFF3 ("HERE ARE YOUR WAGES") from
. bit #N$07 of #R$72B4; tasks #N$01–#N$04 index the pointer pairs at
. #R$E24E (flag byte + message address).
E $E25E Continue on to #R$E286.
N $E25E Handle the wages / not-tidy task specially.
  $E25E,$07 Fetch the current task index (#R$72AE). Is it task #N$05? If not,
. use the pointer table at #R$E270.
  $E265,$0B Fetch the task status flags (#R$72B4). Has the wages bit (bit #N$07)
. been set? If not, jump to #R$DFDD to print "NOT TIDY YET". Otherwise jump to
. #R$DFF3 to print "HERE ARE YOUR WAGES".
N $E270 Index #R$E24E by (task−#N$01)×#N($04), load the mask into #R$72EB and
. the message pointer into #REGhl, then continue on to #R$E286.
@ $E270 label=Select_TaskProgressMessage_FromTable
  $E270,$0A Turn (task−#N$01) into a #N($0004,$04,$04)-byte index, point #REGhl
. at #R$E24E, and keep the table offset in #REGbc.
  $E27A,$08 Fetch the flag-pointer word and advance onto the message address,
. then store the live flag/mask byte as the message colour/mask (#R$72EB).
  $E282,$04 Fetch the message address into #REGhl.

c $E286 Print Encoded Message
@ $E286 label=Print_EncodedMessage
D $E286 Print one #CHR$5B…#CHR$5D encoded message at #REGhl. First runs a short
. border/sound flash, then filters control bytes into the display buffer at
. #R$63A0 and jumps to #R$E300 to paint it. Control bytes before #CHR$60 gate
. fragments by #R$72C5 / #R$72EB; #CHR$2B starts a new row; #CHR$24 marks an
. alternate fragment.
R $E286 HL Address of an encoded message (starts at #CHR$5B)
N $E286 Flash / click #N$0A times before decoding.
  $E286,$01 Stash #REGhl on the stack.
  $E287,$02 Load #REGb with #N$0A flash iterations.
N $E289 Flash the border and click sound #N$0A for each of #N$0A iterations
. before decoding.
@ $E289 label=Print_EncodedMessage_FlashLoop
  $E289,$01 Stash #REGbc on the stack.
  $E28A,$0A Pick a pseudo-random flash/sound parameter via #R$EAE5 and store it
. at #R$F90F(#N$F958).
N $E294 #HTML(#AUDIO0(message-flash.wav)(#INCLUDE(MessageFlash)))
  $E294,$08 Play sound effect #N$0A via #R$F8F9 / #R$F9AF.
  $E29C,$01 Restore #REGbc from the stack.
  $E29D,$02 Loop until the flash sequence is done.
  $E29F,$01 Restore #REGhl from the stack.
N $E2A0 Decode the selected fragment into the buffer at #R$63A0.
  $E2A0,$04 Point #REGix at the display buffer (#R$63A0).
  $E2A4,$04 Clear #REGa, then clear the task progress repeat count (#R$72F1).
N $E2A8 Resume after a skipped fragment by stepping onto the next encoded block.
@ $E2A8 label=Print_EncodedMessage_NextFrag
  $E2A8,$01 Advance past the previous message fragment.
N $E2A9 Scan the encoded stream for #CHR$60 text-start, trigger, indirect, or
. mask controls.
@ $E2A9 label=Print_EncodedMessage_Scan
  $E2A9,$01 Advance the message pointer by one.
  $E2AA,$01 Fetch the next control/text byte.
  $E2AB,$04 Is it the text-start marker (#CHR$60)? If not, try the other
. controls at #R$E2B2.
  $E2AF,$01 Advance past #CHR$60.
  $E2B0,$02 Jump to #R$E2DB to copy literal text into the buffer.
N $E2B2 Gate this fragment on the message trigger in #R$72C5 matching #CHR$21's
. key.
@ $E2B2 label=Print_EncodedMessage_CheckTrigger
  $E2B2,$04 Is it a trigger gate (#CHR$21)? If not, try the indirect-load
. control at #R$E2C2.
  $E2B6,$01 Advance onto the trigger key.
  $E2B7,$06 Fetch the message trigger (#R$72C5). Does it match this fragment's
. key? If not, keep scanning at #R$E2A9.
  $E2BD,$05 Call #R$E2F9 to skip to the next #CHR$5B, then continue with the
. next fragment at #R$E2A8.
N $E2C2 Indirect-load one byte into #R$72F1 from the address that follows
. #CHR$29.
@ $E2C2 label=Print_EncodedMessage_CheckIndirect
  $E2C2,$04 Is it an indirect-load control (#CHR$29)? If not, treat it as a mask
. byte at #R$E2D0.
  $E2C6,$0A Fetch the address word, read that byte into #R$72F1, and continue
. scanning at #R$E2A9.
N $E2D0 Keep the fragment only when its mask ANDs non-zero with the colour mask
. in #R$72EB.
@ $E2D0 label=Print_EncodedMessage_CheckMask
  $E2D0,$06 Fetch the message colour/mask (#R$72EB). AND with this fragment's
. mask byte. If nothing matches, skip to #R$E2A9.
  $E2D6,$05 Call #R$E2F9 to skip to the next #CHR$5B, then continue with the
. next fragment at #R$E2A8.
N $E2DB Copy literal characters into #R$63A0 until #CHR$5D (or a #CHR$24
. alternate).
@ $E2DB label=Print_EncodedMessage_CopyText
  $E2DB,$0B Fetch the next text byte. Store it in the display buffer through
. #REGix. Advance the buffer pointer. Advance the message pointer. Is it an
. alternate-fragment marker (#CHR$24)? If so, handle it at #R$E2EC.
  $E2E6,$06 Is it the message terminator (#CHR$5D)? If so, jump to #R$E300 to
. paint the buffer. Otherwise keep copying at #R$E2DB.
N $E2EC Take the #CHR$24 alternate key and search for the matching #CHR$5B
. fragment.
@ $E2EC label=Print_EncodedMessage_SkipAlternate
  $E2EC,$02 Fetch the alternate key byte, then keep it in #REGc.
N $E2EE Walk successive #CHR$5B markers until the alternate key matches, then
. resume at #R$E2A9.
@ $E2EE label=Print_EncodedMessage_SkipAlternateLoop
  $E2EE,$08 Call #R$E2F9 to find the next #CHR$5B. Step onto the key after that
. marker. Fetch it. Does it match the alternate key? If not, keep searching at
. #R$E2EE.
  $E2F6,$03 Jump to #R$E2A9 to resume scanning after the chosen alternate.

c $E2F9 Skip To Message Marker
@ $E2F9 label=Skip_ToMessageMarker
D $E2F9 Advance #REGhl to the next #CHR$5B message marker (used while skipping
. encoded fragments).
R $E2F9 HL Message pointer to advance
  $E2F9,$04 Fetch the next byte. Is it a message marker (#CHR$5B)? If so, return
. with #REGhl on that marker.
  $E2FD,$01 Advance the pointer.
  $E2FE,$02 Jump to #R$E2F9 to keep scanning.

c $E300 Paint Message Buffer
@ $E300 label=Paint_MessageBuffer
D $E300 Paint the decoded buffer at #R$63A0 with the double-height font at
. #R$E42A, pulsing the attribute through #N$96 frames.
N $E300 Point the character set at the message font and paint the buffer until
. the flash counter hits #N$96.
  $E300,$04 Clear #REGa, then clear the message-frame counter
. (#R$DD94(#N$DDA2)).
  $E304,$06 Point #REGhl at the message font + #N$01 (#R$E42A + #N$01), then
. store it as the current character set.
N $E30A Repaint the decoded buffer at #R$63A0 from attribute row
. #N$58C0 (attribute buffer).
@ $E30A label=Paint_MessageBuffer_Frame
  $E30A,$03 Point #REGhl at the message attribute row
. (#N$58C0 (attribute buffer)).
  $E30D,$04 Point #REGix at the decoded message buffer (#R$63A0).
  $E311,$07 Fetch the message-frame counter (#R$DD94(#N$DDA2)). Has it reached
. #N$96 frames? If not, continue the pulse at #R$E31C.
  $E318,$03 Call #R$EA3C to clear both display buffers.
  $E31B,$01 Return.
N $E31C Pulse the text attribute from the frame counter at #R$DD94(#N$DDA2)
. after dividing by #N($08), never leaving it at zero.
@ $E31C label=Paint_MessageBuffer_PulseAttr
  $E31C,$04 Advance the frame counter and store it back at #R$DD94(#N$DDA2).
  $E320,$06 Divide #REGa by #N$08 to slow the attribute pulse.
  $E326,$03 Is the pulsed value zero? If not, jump to #R$E32A.
  $E329,$01 Force a minimum pulse of #N$01.
N $E32A Clamp the pulsed attribute to white (#N$07) when it reaches #N$08 or
. above.
@ $E32A label=Paint_MessageBuffer_ClampAttr
  $E32A,$06 Is the pulsed attribute < #N$08? If so, keep it at #R$E330.
. Otherwise clamp it to white (#N$07).
N $E330 Store the pulsed ink in #R$7307 and its #N$07−value inverse shift in
. #R$DD94(#N$DDA0).
@ $E330 label=Paint_MessageBuffer_StoreAttr
  $E330,$01 Keep the attribute in #REGc.
  $E331,$03 Store it as the current text attribute (#R$7307).
  $E334,$02 Compute #N$07−attribute.
  $E336,$01 Subtract the centred column from #N$07 to get the left pad.
  $E337,$03 Store that inverse shift at #R$DD94(#N$DDA0) (used while plotting).
N $E33A Centre and draw one message row via #R$E34A, then step three attribute
. rows for the next.
@ $E33A label=Paint_MessageBuffer_RowLoop
  $E33A,$03 Call #R$E34A to centre and draw one message row.
  $E33D,$07 Fetch the row-terminator byte saved by #R$E34A (#R$DD94(#N$DDA1)).
. Was it the message end (#CHR$5D)? If so, restart a new frame at #R$E30A.
  $E344,$03 Step #REGhl down by #N($0060,$04,$04) attribute bytes (three rows).
  $E347,$01 Advance #REGhl by one message row (#N($0060,$04,$04) attribute
. bytes).
  $E348,$02 Draw the next message row at #R$E33A.

c $E34A Centre And Draw Message Row
@ $E34A label=Centre_AndDrawMessageRow
D $E34A Count characters in the current message row (until #CHR$24, #CHR$2B or
. #CHR$5D), centre that run within #N$20 columns, then draw it via #R$E376.
R $E34A HL Attribute-file address for the row
R $E34A IX Pointer into the decoded message buffer
N $E34A Count characters until a row or message end, then centre and draw the
. run.
  $E34A,$03 Stash #REGhl and #REGix on the stack.
  $E34D,$02 Start the character count at #N$FF (pre-increment).
N $E34F Count characters until #CHR$24, #CHR$2B or #CHR$5D to measure the
. current message row.
@ $E34F label=Centre_AndDrawMessageRow_Count
  $E34F,$01 Advance the character count.
  $E350,$03 Fetch the next buffer byte through #REGix.
  $E353,$04 Is it #CHR$24, #CHR$2B or #CHR$5D (row/message end)?, then if
. #CHR$24, stop counting at #R$E363.
  $E357,$04 Is it a new-row marker (#CHR$2B)? If so, stop counting at #R$E363.
  $E35B,$04 Is it the message terminator (#CHR$5D)? If so, stop counting at
. #R$E363.
  $E35F,$02 Advance #REGix to the next buffer byte.
  $E361,$02 Jump to #R$E34F to keep counting.
N $E363 Centre the counted run within #N$20 columns and draw it via #R$E376.
@ $E363 label=Centre_AndDrawMessageRow_Centre
  $E363,$02 Restore #REGix from the stack.
  $E365,$03 Remember the terminator byte in #R$DD94(#N$DDA1).
  $E368,$02 Compute (#N$20−length)/#N$02 as a left-indent.
  $E36A,$01 Subtract the row width from #N$20 to get the left pad.
  $E36B,$02 Halve that pad so the row is centred.
  $E36D,$02 Clear #REGb.
  $E36F,$01 Keep the indent in #REGbc.
  $E370,$01 Add it to the row's attribute address.
  $E371,$03 Call #R$E376 to draw the centred row.
  $E374,$01 Restore #REGhl from the stack.
  $E375,$01 Return.

c $E376 Draw Message Character
@ $E376 label=Draw_MessageCharacter
D $E376 Draw one double-height message character from the buffer at #REGix into
. the attribute/screen pair at #REGhl, then advance. Maps punctuation to fixed
. glyph indices and ASCII from #CHR$30 onward to even glyph slots (two
. #N($0008,$04,$04)-byte halves per character in #R$E42A).
R $E376 HL Attribute-file address for this character
R $E376 IX Pointer into the decoded message buffer
N $E376 Stop on row/message terminators; otherwise map the character to a glyph
. index.
  $E376,$05 Fetch the next buffer byte through #REGix, then advance the buffer
. pointer.
  $E37B,$03 Is it #CHR$24? If so, return (end of alternate/row run).
  $E37E,$03 Is it a new-row marker (#CHR$2B)? If so, return.
  $E381,$03 Is it the message terminator (#CHR$5D)? If so, return.
  $E384,$01 Stash #REGhl on the stack.
  $E385,$04 Is it a full stop (#CHR$2E)? If so, use glyph index #N$14 at
. #R$E39F.
  $E389,$04 Is it a comma (#CHR$2C)? If so, use glyph index #N$16 at #R$E3A3.
  $E38D,$04 Is it an exclamation mark (#CHR$21)? If so, use glyph index #N$1A
. at #R$E3A7.
  $E391,$04 Is it an apostrophe (#CHR$27)? If so, use glyph index #N$18 at
. #R$E3AB.
  $E395,$04 Is it a space (#CHR$20)? If so, keep index #N$20 at #R$E3AD.
  $E399,$02 Convert ASCII ≥ #CHR$30 into an even glyph index.
  $E39B,$02 Double the glyph index to address the double-height font halves.
  $E39D,$02 Jump to #R$E3AD to plot the letter glyph.
N $E39F Map a full stop to glyph index #N$14 in the double-height message font.
@ $E39F label=Draw_MessageCharacter_FullStop
  $E39F,$02 Load glyph index #N$14.
  $E3A1,$02 Jump to #R$E3AD to plot the full-stop glyph.
N $E3A3 Map a comma to glyph index #N$16 in the double-height message font.
@ $E3A3 label=Draw_MessageCharacter_Comma
  $E3A3,$02 Load glyph index #N$16.
  $E3A5,$02 Jump to #R$E3AD to plot the comma glyph.
N $E3A7 Map an exclamation mark to glyph index #N$1A in the double-height
. message font.
@ $E3A7 label=Draw_MessageCharacter_Bang
  $E3A7,$02 Load glyph index #N$1A.
  $E3A9,$02 Jump to #R$E3AD to plot the exclamation glyph.
N $E3AB Map an apostrophe to glyph index #N$18 in the double-height message
. font.
@ $E3AB label=Draw_MessageCharacter_Apostrophe
  $E3AB,$02 Load glyph index #N$18.
N $E3AD Plot the top #N$08 rows, step one attribute row down, plot the bottom
. #N$08 rows, then advance.
@ $E3AD label=Draw_MessageCharacter_Plot
  $E3AD,$03 Keep the glyph index in #REGe, then clear #REGd.
  $E3B0,$08 Load #REGa with #N($08), then call #R$EAE5 (jitter / roll seed for
. #R$DD9F). Store the roll mode at #R$DD9F.
  $E3B8,$03 Call #R$E3C7 to plot the top half of the glyph.
  $E3BB,$03 Step #REGhl down one attribute row (#N($0020,$04,$04) bytes).
  $E3BE,$01 Step #REGhl down one character row (#N($0020,$04,$04) bytes).
  $E3BF,$01 Advance the glyph index onto the bottom half.
  $E3C0,$03 Call #R$E3C7 to plot the bottom half.
  $E3C3,$01 Restore #REGhl from the stack.
  $E3C4,$01 Advance the attribute address onto the next character column.
  $E3C5,$02 Jump to #R$E376 to draw the next character.

c $E3C7 Plot Message Glyph Half
@ $E3C7 label=Plot_MessageGlyphHalf
D $E3C7 Write one #N($0008,$04,$04)-byte half-glyph from the message font into
. the screen bitmap under attribute address #REGhl. Applies the roll/shift
. mode in #R$DD9F and the inverse shift count in #R$DD94(#N$DDA0).
R $E3C7 HL Attribute-file address for this character
R $E3C7 DE Glyph half-index (×#N($0008,$04,$04) into #R$72F9)
N $E3C7 Paint the attribute and resolve the screen and font addresses.
  $E3C7,$03 Stash #REGde, #REGhl and #REGbc on the stack.
  $E3CA,$03 Fetch the current text attribute (#R$7307).
  $E3CD,$02,b$01 Force bright (OR #N$40).
  $E3CF,$01 Write it at #REGhl.
  $E3D0,$04 Multiply the attribute high byte by #N($08).
  $E3D4,$02,b$01 Keep only the screen-bitmap high bits (mask #N$5B).
  $E3D6,$01 Write the result back to #REGh.
  $E3D7,$01 Stash #REGhl on the stack.
  $E3D8,$09 Swap so #REGhl holds the glyph index, multiply it by #N($08), and
. add the character-set base at #R$72F9.
  $E3E1,$01 Restore #REGde from the stack.
N $E3E2 Nudge the font pointer for roll modes #N$02 / #N$03.
  $E3E2,$07 Fetch the roll mode (#R$DD9F). Is it mode #N$02? If not, try mode
. #N$03 at #R$E3EC.
  $E3E9,$01 Advance the font pointer by one (roll left source).
  $E3EA,$02 Jump to #R$E3F1 to plot.
N $E3EC For roll mode #N($03), step the font pointer back one before plotting
. the half-glyph.
@ $E3EC label=Plot_MessageGlyphHalf_CheckMode3
  $E3EC,$05 Is it mode #N$03? If not, plot as-is at #R$E3F1. Otherwise step the
. font pointer back by one (roll right source).
N $E3F1 Plot all #N$08 pixel rows of this half-glyph into the screen bitmap.
@ $E3F1 label=Plot_MessageGlyphHalf_Rows
  $E3F1,$02 There are #N$08 pixel rows in a character.
N $E3F3 Build or roll one glyph row using the inverse shift in #R$DD94(#N$DDA0)
. and the mode in #R$DD9F.
@ $E3F3 label=Plot_MessageGlyphHalf_RowLoop
  $E3F3,$01 Stash #REGbc on the stack.
  $E3F4,$06 Fetch the inverse shift count (#R$DD94(#N$DDA0)). Is it zero (no
. thicken/shift)? If so, take the plain bitmap byte at #R$E3FD.
  $E3FA,$01 Fetch the plain glyph row into #REGa.
  $E3FB,$02 Jump to #R$E40E to apply left/right roll.
N $E3FD Thicken the glyph row by OR-shifting left and right by the count in
. #R$DD94(#N$DDA0).
@ $E3FD label=Plot_MessageGlyphHalf_ShiftBuild
  $E3FD,$01 Keep the shift count in #REGb.
  $E3FE,$01 Stash #REGhl on the stack.
  $E3FF,$03 Fetch the glyph row. Copy it into #REGl. Mirror it into #REGh for
. right-shift thickening.
N $E402 OR left- and right-shifted copies into the thickened glyph bitmap.
@ $E402 label=Plot_MessageGlyphHalf_ShiftLoop
  $E402,$02 Shift left into #REGl and OR.
  $E404,$01 OR in the left-shifted copy.
  $E405,$01 Decrease the shift count.
  $E406,$02 If done, finish at #R$E40D.
  $E408,$02 Also shift right into #REGh and OR (thicken both ways).
  $E40A,$01 OR in the right-shifted copy.
  $E40B,$02 Loop at #R$E402.
N $E40D Finish the thicken pass and continue into the roll/write path.
@ $E40D label=Plot_MessageGlyphHalf_ShiftDone
  $E40D,$01 Restore #REGhl from the stack.
N $E40E Apply roll mode #N$00 (left) or #N$01 (right) before writing the glyph
. row.
@ $E40E label=Plot_MessageGlyphHalf_Roll
  $E40E,$01 Keep the built bitmap in #REGc.
  $E40F,$06 Fetch the roll mode (#R$DD9F). Is it mode #N$00? If not, try mode
. #N$01 at #R$E419.
  $E415,$02 Shift the bitmap left one (roll mode #N$00).
  $E417,$02 Jump to #R$E41F to store.
N $E419 Roll the glyph bitmap one bit right for mode #N$01.
@ $E419 label=Plot_MessageGlyphHalf_RollRight
  $E419,$06 Is it mode #N$01? If not, store as-is at #R$E41F. Shift the bitmap
. right one.
N $E41F Write the finished glyph row to the screen and advance to the next pixel
. row.
@ $E41F label=Plot_MessageGlyphHalf_WriteRow
  $E41F,$01 Write the bitmap row to the screen.
  $E420,$01 Write the thickened glyph row to the screen.
  $E421,$01 Move one pixel-row down.
  $E422,$01 Advance the font pointer.
  $E423,$01 Restore #REGbc from the stack.
  $E424,$02 Loop until all #N$08 rows are plotted.
  $E426,$03 Restore #REGbc, #REGhl and #REGde from the stack.
  $E429,$01 Return.

b $E42A Font: Message Characters
@ $E42A label=Font_MessageCharacters
D $E42A Double-height message font used by #R$E300 and #R$E376. Each glyph is
. #N($0010,$04,$04) bytes: an #N($0008,$04,$04)-byte top half then an
. #N($0008,$04,$04)-byte bottom half, matching the plot order at #R$E3B8 and
. #R$E3C0. #N($002B,$04,$04) glyphs run from #R$E42A through #N$E6D9; #R$E6DA is
. a pad #N$00 before #R$E6DB. #R$E399 maps ASCII codes from #CHR$30 upward to
. glyph slot (ASCII code minus #N$30); #R$E39F through #R$E3AB override full
. stop, comma, apostrophe and exclamation mark onto half-indices #N($14),
. #N($16), #N$18 and #N$1A (slots #N$0A through #N$0D), and space
. (#CHR$20) keeps half-index #N$20 (slot #N$10).
  $E42A,$10 Character #N((#PC-$E42A)/$10)
. (#MAP((#PC-$E42A)/$10)(#CHR($30+(#PC-$E42A)/$10),$0A:#CHR$2E,$0B:#CHR$2C,
. $0C:#CHR$27,$0D:#CHR$21,$10:#CHR$20)):
. #UDGTABLE { #UDGARRAY$01,attr=$07,scale=$04,step=$01((#PC)-(#PC+$08)-$08)(
. message-font-#N((#PC-$E42A)/$10)) } UDGTABLE#
L $E42A,$10,$2B
  $E6DA,$01 Pad byte (#N$00) before #R$E6DB.

c $E6DB Populate Display Buffer For Visible Entities
@ $E6DB label=PopulateDisplayBuffer_VisibleEntities
D $E6DB Walk the simple entity table at #R$8B69 and process graphic layout data
. for each visible entity into the current display buffer.
N $E6DB Walk rooms #N$00–#N$05 and draw every on-camera entity into the current
. display buffer.
  $E6DB,$02 Clear the room-pass index in #REGc to #N$00.
N $E6DD Start a room-pass over the simple entity table at #R$8B69.
@ $E6DD label=PopulateVisible_StartRoomPass
  $E6DD,$04 Point #REGix at the simple entity table (#R$8B69).
  $E6E1,$03 Load #REGde with #N($000E,$04,$04).
N $E6E4 Draw each visible entity whose room and camera-window x-band match this
. pass.
@ $E6E4 label=PopulateDisplayBuffer_VisibleEntitiesContinue
  $E6E4,$03 Fetch the current entity's type for the type test.
  $E6E7,$04 Is #REGa equal to #N$FF? If so, jump to #R$E716.
  $E6EB,$03 Is #REGa zero? If so, jump to #R$E712.
  $E6EE,$04 Is bit #N$07 of #REGa set? If so, jump to #R$E712.
  $E6F2,$01 Copy the saved count/flag from #REGc into #REGa.
  $E6F3,$05 Does the candidate share this entity's room? If not, jump to
. #R$E712.
  $E6F8,$03 Load #REGhl with the camera room-origin pointer (#R$72FB).
  $E6FB,$01 Copy #REGh into #REGa.
  $E6FC,$05 Is the camera origin's high byte left of this entity's x? If so,
. jump to #R$E712.
  $E701,$03 Load #REGa with the current entity's x-extent.
  $E704,$03 Is this entity's x-extent left of the camera origin's low byte in
. #REGl? If so, jump to #R$E712.
  $E707,$04 Stash #REGde, #REGbc and #REGix on the stack.
  $E70B,$03 Call #R$E71D to draw the entity's graphic layout.
  $E70E,$04 Restore #REGix, #REGbc and #REGde from the stack.
N $E712 Advance to the next simple-entity record and keep scanning this room
. pass.
@ $E712 label=PopulateDisplayBuffer_VisibleEntitiesContinueB
  $E712,$02 #REGix+=#REGde.
  $E714,$02 Jump to #R$E6E4 to continue this routine.
N $E716 Bump the room-pass index; return when it passes #N($05), otherwise
. restart at #R$E6DD.
@ $E716 label=PopulateDisplayBuffer_VisibleEntitiesContinueB2
  $E716,$02 Load #REGa with #N$05 (last room index).
  $E718,$01 Advance the room-pass index in #REGc by one.
  $E719,$02 Return if the room-pass index is now greater than #N$05.
  $E71B,$02 Jump to #R$E6DD to continue the loop.

c $E71D Process Graphic Layout Data For Entity
@ $E71D label=Process_GraphicLayoutData_Entity
D $E71D Load the graphic layout address from the entity at #REGix, set drawing
. coordinates relative to the camera, then jump to #R$E73F.
R $E71D IX Address of entity state data
E $E71D View the equivalent code in;
. #LIST
. { #FLUNKY$9878 }
. LIST#
  $E71D,$06 Fetch the current entity's graphic-layout address into #REGde.
  $E723,$03 Load #REGa with the current entity's y-coordinate.
  $E726,$02 #REGa-=#N$14.
  $E728,$01 Copy #REGa into #REGl.
  $E729,$03 Load #REGa with the camera room-origin pointer (#R$72FB).
  $E72C,$01 Keep the camera origin X in #REGc.
  $E72D,$03 Load #REGa with the current entity's x-coordinate.
  $E730,$01 Subtract #REGc from #REGa.
  $E731,$01 Keep the delta in #REGc.
  $E732,$01 Copy #REGc into #REGh.
  $E733,$03 Store #REGhl in the stored drawing coordinates (#R$72F7).
  $E736,$03 Copy #REGde into #REGix (using the stack).
  $E739,$02 Jump to #R$E73F to process graphic layout data.

c $E73B Advance Graphic Layout Pointer By Two Bytes And Process
@ $E73B label=Advance_GraphicLayoutPointerByTwo
D $E73B Advance #REGix by two bytes and process the graphic layout data there.
E $E73B View the equivalent code in;
. #LIST
. { #FLUNKY$989A }
. LIST#
  $E73B,$02 Advance #REGix past the first graphic-layout operand byte.
N $E73D Skip one graphic-layout operand and resume decoding at #R$E73F.
@ $E73D label=Advance_GraphicLayoutPointerByOne
  $E73D,$02 Advance #REGix past one graphic-layout operand byte.

c $E73F Process Graphic Layout Data
@ $E73F label=Process_GraphicLayoutData
D $E73F Read the current graphic layout instruction at #REGix. Values below
. #N$EE are graphic tiles drawn into the display buffer; #N$EE–#N$FF
. dispatch via #R$E7BB.
R $E73F IX Current position in graphic layout data
R $E73F HL Drawing coordinates (#REGh = x, #REGl = y)
E $E73F View the equivalent code in;
. #LIST
. { #FLUNKY$98A3 }
. LIST#
N $E73F Ordinary tile: if it sits inside the #N$20×#N$14 window, plot it into
. the display buffer.
  $E73F,$03 Fetch the next graphic-layout byte (tile index / opcode) into #REGa.
  $E742,$05 Is #REGa less than #N$EE? If not, jump to #R$E7BB.
  $E747,$01 Copy #REGh into #REGa.
  $E748,$05 Is #REGa less than #N$20? If not, jump to #R$E7B1.
  $E74D,$01 Copy #REGl into #REGa.
  $E74E,$05 Is #REGa less than #N$14? If not, jump to #R$E7B1.
  $E753,$01 Stash #REGhl on the stack.
  $E754,$01 Copy #REGh into #REGa.
  $E755,$01 Double #REGa to form a word index into the table.
  $E756,$01 #REGa+=#REGh.
  $E757,$01 Keep the summed coordinate in #REGc.
  $E758,$01 Copy #REGl into #REGa.
  $E759,$01 Double #REGa to form a word index into the table.
  $E75A,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $E75B,$02 Clear #REGd (high byte of a pointer/offset).
  $E75D,$01 Copy #REGd into #REGb.
  $E75E,$03 Point #REGhl at Table: Display Buffer Row Offsets (#R$E967).
  $E761,$01 #REGhl+=#REGde.
  $E762,$03 Fetch the word at #REGhl into #REGde.
  $E765,$03 Load #REGhl with the current display-buffer pointer (#R$72F5).
  $E768,$01 #REGhl+=#REGde.
  $E769,$01 #REGhl+=#REGbc.
  $E76A,$01 Exchange #REGde and #REGhl.
N $E76B Write the current graphic-set index into the buffer cell and advance the
. layout cursor.
  $E76B,$03 Load #REGa with the current graphic-set index (#R$7306).
  $E76E,$01 Set the byte at #REGde.
  $E76F,$01 Advance the destination drawing coordinate by one.
  $E770,$03 Fetch the current entity's type into #REGa.
  $E773,$01 Set the byte at #REGde.
  $E774,$01 Advance the destination drawing coordinate by one.
  $E775,$03 Load #REGa with the current attribute (#R$7308).
  $E778,$03 Is the current attribute (#R$7308) zero? If not, jump to #R$E780.
  $E77B,$02 Advance #REGix past the graphic-layout operand byte.
  $E77D,$03 Fetch the current entity's type for the layout path.
N $E780 Compose the tile's attribute from #R$7308 / entity flags and write it
. into the display buffer.
@ $E780 label=ProcessLayout_DrawTile
  $E780,$01 Copy #REGa into #REGl.
  $E781,$02,b$01 #REGa&=#N$C0.
  $E783,$01 Keep a copy of #REGa in #REGb.
  $E784,$01 Copy #REGl into #REGa.
  $E785,$02,b$01 #REGa&=#N$3F.
  $E787,$01 Keep the masked attribute bits in #REGc.
  $E788,$02,b$01 #REGa&=#N$38.
  $E78A,$02 Jump to #R$E79C to continue if the comparison did not match.
  $E78C,$06 Is bit #N$07 of the layout step byte at #REGix+#N$01 set? If so,
. jump to #R$E79C.
  $E792,$01 Load #REGa from the byte at #REGde.
  $E793,$04 Is bit #N$06 of #REGa set? If not, jump to #R$E79A.
  $E797,$03 Multiply #REGa by #N$08.
N $E79A Mask the ink/paper bits of the composed attribute before merging.
@ $E79A label=Process_GraphicLayoutDataContinue
  $E79A,$02 #REGa&=#N$38.
N $E79C Merge the masked attribute halves and store the tile triple in the
. display buffer.
@ $E79C label=Process_GraphicLayoutDataContinueB
  $E79C,$01 Set in #REGa every bit that is set in #REGb.
  $E79D,$01 Set in #REGa every bit that is set in #REGc.
  $E79E,$01 Set the byte at #REGde.
  $E79F,$01 Restore #REGhl from the stack.
N $E7A0 Apply the layout delta/flags byte to step the drawing coordinates for
. the next tile.
@ $E7A0 label=Process_GraphicLayoutDataContinueB2
  $E7A0,$03 Fetch the layout delta/flags byte at #REGix+#N$01 into #REGa.
  $E7A3,$02,b$01 #REGa&=#N$7F.
  $E7A5,$02 #REGa-=#N$20.
  $E7A7,$02 Jump to #R$E7AB to continue if the comparison matched.
  $E7A9,$02 Jump to #R$E7AC if the result did not underflow.
N $E7AB Step the drawing Y down one character when the signed delta underflows.
@ $E7AB label=Process_GraphicLayoutDataContinueB3
  $E7AB,$01 Advance the low drawing coordinate by one.
N $E7AC Add the signed X delta into #REGh and continue via #R$E73B.
@ $E7AC label=Process_GraphicLayoutDataContinueB4
  $E7AC,$01 #REGa+=#REGh.
  $E7AD,$01 Copy #REGa into #REGh.
  $E7AE,$03 Jump to #R$E73B to advance the graphic layout pointer and continue.
N $E7B1 Skip drawing an off-screen tile, but still consume its layout operand
. and delta.
@ $E7B1 label=Process_GraphicLayoutDataContinueB5
  $E7B1,$03 Load #REGa with the current attribute (#R$7308).
  $E7B4,$03 Is the current attribute (#R$7308) zero? If not, jump to #R$E7A0.
  $E7B7,$02 Advance #REGix past the graphic-layout operand byte.
  $E7B9,$02 Jump to #R$E7A0 to continue this routine.

c $E7BB Jump Graphic Layout Routine
@ $E7BB label=Jump_GraphicLayoutRoutine
D $E7BB Dispatch graphic layout opcode #N$EE–#N$FF via #R$E7D5. The target
. address is patched into the #HTML(<code>JP</code>) at #R$E7D2.
R $E7BB A Graphic layout opcode
R $E7BB IX Address of the opcode byte
E $E7BB View the equivalent code in;
. #LIST
. { #FLUNKY$9945 }
. LIST#
  $E7BB,$02 Advance #REGix past the graphic-layout operand byte.
  $E7BD,$02 #REGa-=#N$EE.
  $E7BF,$01 Double #REGa to form a word index into the table.
  $E7C0,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $E7C1,$02 Clear #REGd (high byte of a pointer/offset).
  $E7C3,$01 Stash #REGhl on the stack.
  $E7C4,$03 Point #REGhl at Table of Addresses of Graphic Layout Handling
. Routines (#R$E7D5).
  $E7C7,$01 #REGhl+=#REGde.
  $E7C8,$01 Fetch the next script byte.
  $E7C9,$03 Set #R$E7BB(#N$E7D3).
  $E7CC,$01 Advance the graphic-layout pointer in #REGhl by one byte.
  $E7CD,$01 Fetch the next script byte.
  $E7CE,$03 Set #R$E7BB(#N$E7D4).
  $E7D1,$01 Restore #REGhl from the stack.
  $E7D2,$03 Jump to #N($0000,$04,$04).

w $E7D5 Table of Addresses of Graphic Layout Handling Routines
@ $E7D5 label=TableGraphicLayoutHandlers
D $E7D5 One word per graphic layout opcode from #N$EE to #N$FF.
. #TABLE(default,centre,centre)
. { =h Opcode | =h Handler }
. #FOR$00,$11(n,{ #N($EE+n) |
. #LET(addr=$E7D5+n*$02)#R(#PEEK({addr})+#PEEK({addr}+$01)*$0100) }).
. TABLE#
  $E7D5,$02 Address of the handler for graphic-layout opcode
. #N(#EVAL($EE+(#PC-$E7D5)/$02)).
L $E7D5,$02,$12

c $E7F9 Graphic Layout Routine: (#N$EE) Start Loop
@ $E7F9 label=GraphicLayoutRoutine_StartLoop
D $E7F9 Begin a counted graphic-layout loop using the operand at #REGix.
E $E7F9 View the equivalent code in;
. #LIST
. { #FLUNKY$9BA5 }
. LIST#
  $E7F9,$03 Fetch the loop-count parameter from the layout byte at #REGix.
  $E7FC,$03 Store it as the graphic-layout loop counter (#R$7302).
  $E7FF,$02 Advance #REGix past the graphic-layout operand byte.
  $E801,$04 Store #REGix in #R$72FF as the graphic-layout loop restart address.
  $E805,$03 Jump to #R$E73F to process graphic layout data.

c $E808 Graphic Layout Routine: (#N$EF) End Loop
@ $E808 label=GraphicLayoutRoutine_EndLoop
D $E808 Close the current graphic-layout loop and resume after it.
E $E808 View the equivalent code in;
. #LIST
. { #FLUNKY$9BB6 }
. LIST#
  $E808,$03 Load #REGa with the graphic-layout loop counter (#R$7302).
  $E80B,$01 Decrease #REGa by one.
  $E80C,$03 Set the graphic-layout loop counter (#R$7302).
  $E80F,$03 Jump to #R$E73F to process graphic layout data if the comparison
. matched.
  $E812,$04 Load #REGix with the graphic-layout loop-start pointer (#R$72FF).
  $E816,$03 Jump to #R$E73F to process graphic layout data.

c $E819 Graphic Layout: Random Address Jump
@ $E819 label=GraphicLayoutRoutine_JumpRandomFromList
D $E819 Choose one of the following graphic-layout addresses at random and
. continue drawing from it.
E $E819 View the equivalent code in;
. #LIST
. { #FLUNKY$9B8F }
. LIST#
  $E819,$03 Fetch the random-maximum parameter from the layout byte at #REGix.
  $E81C,$02 Advance #REGix past the graphic-layout operand byte.
  $E81E,$04 Call #R$EAE5 to pick a pseudo-random value and keep it in #REGc.
  $E822,$01 Double #REGa, then with the next add form a ×#N$03 index.
  $E823,$01 #REGa+=#REGc.
  $E824,$01 Keep #REGa in #REGc for the next calculation.
  $E825,$02 Load #REGb with #N$00.
  $E827,$02 #REGix+=#REGbc.
  $E829,$03 Jump to #R$E73F to process graphic layout data.

c $E82C Graphic Layout Routine: (#N$F0) Set New Pending Sound
@ $E82C label=GraphicLayoutRoutine_SetPendingSound
D $E82C Queue a new pending sound from the layout operand for later playback.
E $E82C View the equivalent code in;
. #LIST
. { #FLUNKY$9A6A }
. LIST#
  $E82C,$03 Fetch the sound-index parameter from the layout byte at #REGix.
  $E82F,$03 Call #R$F8F9 to queue a sound effect.
  $E832,$03 Jump to #R$E73D to advance Graphic Layout Pointer By One.

c $E835 Graphic Layout Routine: (#N$F2) Set Current Attribute
@ $E835 label=GraphicLayoutRoutine_SetCurrentAttribute
D $E835 Set the current drawing attribute from the layout operand.
E $E835 View the equivalent code in;
. #LIST
. { #FLUNKY$9A75 }
. LIST#
  $E835,$03 Fetch the attribute parameter from the layout byte at #REGix.
  $E838,$03 Set the current attribute (#R$7308).
  $E83B,$03 Jump to #R$E73D to advance Graphic Layout Pointer By One.

c $E83E Graphic Layout Routine: (#N$F4) Set Current Graphic Set Index
@ $E83E label=GraphicLayoutRoutine_SetGraphicSetIndex
D $E83E Switch the current graphic set to the layout operand's index.
E $E83E View the equivalent code in;
. #LIST
. { #FLUNKY$9A80 }
. LIST#
  $E83E,$03 Fetch the graphic-set parameter from the layout byte at #REGix.
  $E841,$03 Set the current graphic-set index (#R$7306).
  $E844,$03 Jump to #R$E73D to advance Graphic Layout Pointer By One.

c $E847 Graphic Layout Routine: (#N$F5) Set Next Graphic Index From Random List
@ $E847 label=GraphicLayoutRoutine_SetGraphicFromRandomList
D $E847 Pick the next graphic-set index from the layout's random list.
E $E847 View the equivalent code in;
. #LIST
. { #FLUNKY$9A8B }
. LIST#
  $E847,$02 Stash #REGix on the stack.
  $E849,$03 Fetch the current entity's type into #REGa.
  $E84C,$03 Call #R$EAE5 to pick a pseudo-random value.
  $E84F,$01 Step the random-list index on by one.
  $E850,$02 Load #REGb with #N$00.
  $E852,$01 Keep the table index in #REGc.
  $E853,$02 #REGix+=#REGbc.
  $E855,$03 Fetch the current entity's type into #REGa.
  $E858,$02 Restore #REGix from the stack.
  $E85A,$03 Load #REGc with the current entity's entity type.
  $E85D,$01 Advance the saved count in #REGc by one.
  $E85E,$02 #REGix+=#REGbc.
  $E860,$03 Set the current entity's entity type.
  $E863,$03 Jump to #R$E73F to process graphic layout data.

c $E866 Graphic Layout Routine: (#N$FF) Load Stored Coordinates And Return
@ $E866 label=GraphicLayoutRoutine_LoadStoredCoordsReturn
D $E866 Reload the stored drawing coordinates and return from this layout
. fragment.
E $E866 View the equivalent code in;
. #LIST
. { #FLUNKY$9AF0 }
. LIST#
  $E866,$01 Clear #REGa to #N$00.
  $E867,$03 Set the current attribute (#R$7308).
  $E86A,$03 Load #REGhl with the stored drawing coordinates (#R$72F7).
  $E86D,$01 Return.

c $E86E Graphic Layout Routine: (#N$FA) Adjust Coordinates Without Storing
@ $E86E label=GraphicLayoutRoutine_AdjustCoordsNoStore
D $E86E Nudge the drawing coordinates without writing them back to storage.
E $E86E View the equivalent code in;
. #LIST
. { #FLUNKY$9AF9 }
. LIST#
  $E86E,$03 Fetch the current entity's type into #REGa.
  $E871,$01 #REGa+=#REGl.
  $E872,$01 Copy #REGa into #REGl.
  $E873,$03 Load #REGa with the current entity's flags byte 1.
  $E876,$01 #REGa+=#REGh.
  $E877,$01 Copy #REGa into #REGh.
  $E878,$03 Jump to #R$E73B to advance the graphic layout pointer and continue.

c $E87B Graphic Layout Routine: (#N$FE) Adjust Coordinates And Store
@ $E87B label=GraphicLayoutRoutine_AdjustCoordsAndStore
D $E87B Nudge the drawing coordinates and store the result for later layout
. steps.
E $E87B View the equivalent code in;
. #LIST
. { #FLUNKY$9B08 }
. LIST#
  $E87B,$03 Fetch the current entity's type into #REGa.
  $E87E,$01 #REGa+=#REGl.
  $E87F,$01 Copy #REGa into #REGl.
  $E880,$03 Load #REGa with the current entity's flags byte 1.
  $E883,$01 #REGa+=#REGh.
  $E884,$01 Copy #REGa into #REGh.
  $E885,$03 Store #REGhl in the stored drawing coordinates (#R$72F7).
  $E888,$03 Jump to #R$E73B to advance the graphic layout pointer and continue.

c $E88B Graphic Layout Routine: (#N$FB) Process Nested Graphic Layout Data
@ $E88B label=GraphicLayoutRoutine_ProcessNestedLayout
D $E88B Recurse into a nested graphic-layout fragment, then return here.
E $E88B View the equivalent code in;
. #LIST
. { #FLUNKY$9B1A }
. LIST#
  $E88B,$03 Load #REGc with the current entity's entity type.
  $E88E,$03 Load #REGb with the current entity's flags byte 1.
  $E891,$02 Stash #REGix on the stack.
  $E893,$03 Copy #REGbc into #REGix (using the stack).
  $E896,$03 Call #R$E73F to process graphic layout data.
  $E899,$02 Restore #REGix from the stack.
  $E89B,$03 Jump to #R$E73B to advance the graphic layout pointer and continue.

c $E89E Graphic Layout Routine: (#N$F8) Jump To Graphic Layout Address
@ $E89E label=GraphicLayoutRoutine_JumpGraphicAddress
D $E89E Jump to the absolute graphic-layout address that follows this opcode.
E $E89E View the equivalent code in;
. #LIST
. { #FLUNKY$9B2F }
. LIST#
  $E89E,$03 Load #REGc with the current entity's entity type.
  $E8A1,$03 Load #REGb with the current entity's flags byte 1.
  $E8A4,$03 Copy #REGbc into #REGix (using the stack).
  $E8A7,$03 Jump to #R$E73F to process graphic layout data.

c $E8AA Graphic Layout Routine: (#N$F9) Jump To Time-Weighted Random Address
@ $E8AA label=GraphicLayoutRoutine_JumpTimeWeightedRandom
D $E8AA Jump to one of several graphic-layout addresses using a time-weighted
. random pick.
E $E8AA View the equivalent code in;
. #LIST
. { #FLUNKY$9B3D }
. LIST#
  $E8AA,$02 Stash #REGix on the stack.
  $E8AC,$03 Load #REGa with the current entity's flags byte 1.
  $E8AF,$02 Multiply #REGa by #N$04 to index the four-byte table entries.
  $E8B1,$02 #REGa+=#N$02.
  $E8B3,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $E8B4,$02 Clear #REGd (high byte of a pointer/offset).
  $E8B6,$02 #REGix+=#REGde.
  $E8B8,$03 Decrease the current entity's entity type.
  $E8BB,$02 Jump to #R$E8DB to continue if the comparison did not match.
  $E8BD,$02 Restore #REGix from the stack.
  $E8BF,$03 Fetch the current entity's type into #REGa.
  $E8C2,$03 Call #R$EAE5 to pick a pseudo-random value.
  $E8C5,$03 Set the current entity's flags byte 1.
  $E8C8,$02 Multiply #REGa by #N$04 to index the four-byte table entries.
  $E8CA,$02 #REGa+=#N$02.
  $E8CC,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $E8CD,$02 #REGix+=#REGde.
  $E8CF,$03 Load #REGa with the current entity's flags byte 1.
  $E8D2,$03 Call #R$EAE5 to pick a pseudo-random value.
  $E8D5,$01 Step the graphic-set / attribute index on by one.
  $E8D6,$03 Set the current entity's entity type.
  $E8D9,$02 Jump to #R$E8DC to continue this routine.
N $E8DB Timer still counting: restore #REGix and jump to the current
. time-weighted layout address.
@ $E8DB label=Layout_LoopEnd
  $E8DB,$01 Restore #REGde from the stack.
N $E8DC Load the chosen #N$F9 table entry's layout address into #REGix and
. process it at #R$E73F.
@ $E8DC label=GraphicLayoutRoutine_F9Continue
  $E8DC,$06 Fetch this table entry's graphic-layout address into #REGde.
  $E8E2,$03 Copy #REGde into #REGix (using the stack).
  $E8E5,$03 Jump to #R$E73F to process graphic layout data.

c $E8E8 Graphic Layout Routine: (#N$F3) Increment Index And Jump To N-th Address
@ $E8E8 label=GraphicLayoutRoutine_IncIndexJumpNth
D $E8E8 Advance the graphic index and jump to the N-th address in the following
. table.
E $E8E8 View the equivalent code in;
. #LIST
. { #FLUNKY$9B7D }
. LIST#
  $E8E8,$03 Fetch the current entity's type into #REGa.
  $E8EB,$01 Step the graphic-set / attribute index on by one.
  $E8EC,$05 Is #REGa less than this entity's flags byte 1? If so, jump to
. #R$E8F2.
  $E8F1,$01 Clear #REGa to #N$00.
N $E8F2 Write the wrapped #N$F3 index, index the address list, and jump to that
. layout.
@ $E8F2 label=GraphicLayoutRoutine_F3Continue
  $E8F2,$03 Set the current entity's entity type.
  $E8F5,$01 Double #REGa to form a word index into the table.
  $E8F6,$02 #REGa+=#N$02.
  $E8F8,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $E8F9,$02 Clear #REGd (high byte of a pointer/offset).
  $E8FB,$02 #REGix+=#REGde.
  $E8FD,$06 Fetch the next graphic-layout address into #REGde.
  $E903,$03 Copy #REGde into #REGix (using the stack).
  $E906,$03 Jump to #R$E73F to process graphic layout data.

c $E909 Graphic Layout Routine: (#N$F7) Timer-Based Random Graphic Index
@ $E909 label=GraphicLayoutRoutine_TimerRandomGraphicIndex
D $E909 Choose a graphic-set index from a timer-based random table.
E $E909 View the equivalent code in;
. #LIST
. { #FLUNKY$9AA9 }
. LIST#
  $E909,$02 Load #REGb with #N$00.
  $E90B,$03 Fetch the current entity's type into #REGa.
  $E90E,$01 Step the nested-layout counter on by one.
  $E90F,$03 Set the current entity's entity type.
  $E912,$03 Compare #REGa with this entity's flags byte 1.
  $E915,$04 Advance #REGix past the two-byte graphic-layout operand.
  $E919,$03 Fetch the current entity's type into #REGa.
  $E91C,$02 Jump to #R$E925 to continue if the comparison matched.
  $E91E,$01 Step the nested-layout counter on by one.
  $E91F,$01 Keep the updated index in #REGc.
  $E920,$02 #REGix+=#REGbc.
  $E922,$03 Jump to #R$E73F to process graphic layout data.
N $E925 Reset the #N$F7 timer byte, pick a random graphic index, and continue
. layout at #R$E73F.
@ $E925 label=GraphicLayoutRoutine_F7Continue
  $E925,$04 Write #N$00 to *(#REGix-#N$02).
  $E929,$02 Stash #REGix on the stack.
  $E92B,$03 Call #R$EAE5 to pick a pseudo-random value.
  $E92E,$01 Step the nested-layout counter on by one.
  $E92F,$01 Keep the updated index in #REGc.
  $E930,$02 #REGix+=#REGbc.
  $E932,$03 Fetch the current entity's type into #REGa.
  $E935,$02 Restore #REGix from the stack.
  $E937,$03 Load #REGc with the current entity's entity type.
  $E93A,$01 Advance the saved count in #REGc by one.
  $E93B,$02 #REGix+=#REGbc.
  $E93D,$03 Set the current entity's entity type.
  $E940,$03 Jump to #R$E73F to process graphic layout data.

c $E943 Graphic Layout Routine: (#N$F6) Jump To Randomly Selected Address
@ $E943 label=GraphicLayoutRoutine_JumpRandomAddress
D $E943 Jump to one of the following graphic-layout addresses chosen uniformly
. at random.
E $E943 View the equivalent code in;
. #LIST
. { #FLUNKY$9B8F }
. LIST#
  $E943,$03 Fetch the random-maximum parameter from the layout byte at #REGix.
  $E946,$02 Advance #REGix past the graphic-layout operand byte.
  $E948,$03 Call #R$EAE5 to pick a pseudo-random value.
N $E94B Index the random-address list by #REGa×#N$02 and jump via the #N$F8
. handler at #R$E89E.
@ $E94B label=GraphicLayout_ContinueAfterTile
  $E94B,$01 Double #REGa to form a word index into the table.
  $E94C,$01 Keep the index in #REGc.
  $E94D,$02 Load #REGb with #N$00.
  $E94F,$02 #REGix+=#REGbc.
  $E951,$03 Jump to #R$E89E to graphic Layout Routine: (#N$F8) Jump To Graphic
. Layout Address.

c $E954 Graphic Layout Routine: (#N$FD) Jump Using Carried-Entity Width
@ $E954 label=GraphicLayoutRoutine_JumpUsingCarriedWidth
D $E954 Branch in the layout using the width of the entity Berk is carrying.
E $E954 View the equivalent code in;
. #LIST
. { #FLUNKY$9BA0 }
. LIST#
  $E954,$03 Load #REGa with the camera Y coordinate (#R$72ED).
  $E957,$02 Jump to #R$E94B to continue this routine.

c $E959 Graphic Layout Routine: (#N$FC) Conditional Jump Or Skip
@ $E959 label=GraphicLayoutRoutine_ConditionalJumpOrSkip
D $E959 Conditionally jump in the layout, or skip the following address when the
. test fails.
  $E959,$03 Point #REGbc at the camera-follow entity (#R$909B).
  $E95C,$02 Advance #REGbc past the first two bytes of the camera-follow entity.
  $E95E,$01 Load #REGa from the byte at #REGbc.
  $E95F,$05 Is bit #N$04 of #REGa set? If so, jump to #R$E89E.
  $E964,$03 Jump to #R$E73B to advance the graphic layout pointer and continue.

b $E967 Table: Display Buffer Row Offsets
@ $E967 label=Table_DisplayBufferRowOffsets
D $E967 Word offsets into the #N$0780-byte display buffer for each character
. row. Used by #R$E73F.
  $E967,$2A,$02

c $E991 Blit Display Buffer To Screen
@ $E991 label=Blit_DisplayBuffer
D $E991 Compare the primary and secondary display buffers and blit changed tiles
. to the Spectrum screen. Tiles with attribute bit #N$07 set are horizontally
. mirrored via #R$7319 (see #R$EA23).
N $E991 Choose which display buffer is "live" versus "previous" from #R$72EA.
  $E991,$04 Point #REGix at the attribute file (#N$5800 (attribute buffer)).
  $E995,$03 Point #REGhl at Primary Display Buffer (#R$63A0).
  $E998,$03 Point #REGde at Secondary Display Buffer (#R$6B20).
  $E99B,$03 Load #REGa with the display-buffer select flag (#R$72EA).
  $E99E,$03 Is the display-buffer select flag (#R$72EA) zero? If so, jump to
. #R$E9A2.
  $E9A1,$01 Exchange #REGde and #REGhl.
N $E9A2 After selecting primary/secondary, walk #N$14 rows × #N$20 columns for
. dirty tiles.
@ $E9A2 label=Blit_DisplayBuffer_AfterSelect
  $E9A2,$03 Copy #REGde into #REGiy (using the stack).
  $E9A5,$02 Load #REGb with #N$14.
N $E9A7 Begin one display-buffer row of #N$20 tile comparisons.
@ $E9A7 label=Blit_DisplayBufferLoop
  $E9A7,$01 Stash #REGbc on the stack.
  $E9A8,$02 Load #REGb with loop count #N$20.
N $E9AA Compare one tile's graphic-set / type / attribute triple against the
. secondary buffer.
@ $E9AA label=Blit_DisplayBufferLoopB
  $E9AA,$01 Stash #REGbc on the stack.
  $E9AB,$01 Fetch the next primary-buffer graphic-set byte.
  $E9AC,$01 Advance the display-buffer pointer in #REGhl by one byte.
  $E9AD,$04 Is #REGa zero? If so, jump to #R$E9E6.
  $E9B1,$01 Keep the remaining count in #REGc.
  $E9B2,$02 Load #REGe with #N$00.
  $E9B4,$05 Does #REGa match the referenced entity's type? If not, jump to
. #R$E9BA.
  $E9B9,$01 Advance the low byte of the pointer/offset in #REGde.
N $E9BA Match the tile's entity-type byte; count matches in #REGe.
@ $E9BA label=Blit_DisplayBufferLoopB2
  $E9BA,$01 Fetch the next script byte.
  $E9BB,$03 Is the next script byte zero? If so, jump to #R$E9E6.
  $E9BE,$01 Keep a copy of #REGa in #REGb.
  $E9BF,$05 Does #REGa match the referenced entity's flags byte 1? If not, jump
. to #R$E9C5.
  $E9C4,$01 Advance the low byte of the pointer/offset in #REGde.
N $E9C5 Match the tile's attribute byte; blit via #R$E9EF unless both prior
. bytes already matched.
@ $E9C5 label=Blit_DisplayBufferLoopB3
  $E9C5,$01 Advance the display-buffer pointer in #REGhl by one byte.
  $E9C6,$01 Fetch the next script byte.
  $E9C7,$05 Does #REGa match the referenced entity's flags byte 2? If not, jump
. to #R$E9D0.
  $E9CC,$04 Is bit #N$01 of #REGe set? If so, jump to #R$E9D5.
N $E9D0 Blit this changed tile to the Spectrum screen through #R$E9EF.
@ $E9D0 label=Blit_DisplayBufferLoopB4
  $E9D0,$01 Stash #REGhl on the stack.
  $E9D1,$03 Call #R$E9EF to blit Display Buffer Row.
  $E9D4,$01 Restore #REGhl from the stack.
N $E9D5 Advance past this tile's triple and move to the next attribute column.
@ $E9D5 label=Blit_DisplayBufferLoopB5
  $E9D5,$01 Advance the display-buffer pointer in #REGhl by one byte.
  $E9D6,$02 Advance #REGix to the next attribute-file column.
  $E9D8,$03 Load #REGde with #N($0003,$04,$04).
  $E9DB,$02 #REGiy+=#REGde.
  $E9DD,$01 Restore #REGbc from the stack.
  $E9DE,$02 Decrease the loop counter in #REGb and jump to #R$E9AA if more
. iterations remain.
  $E9E0,$01 Restore #REGbc from the stack.
  $E9E1,$01 Decrease #REGb by one.
  $E9E2,$03 Jump to #R$E9A7 to continue if the comparison did not match.
  $E9E5,$01 Return.
N $E9E6 Treat a zero graphic-set as "blank": force bit #N$06 and skip the blit.
@ $E9E6 label=Blit_DisplayBufferLoopB6
  $E9E6,$01 Advance the display-buffer pointer in #REGhl by one byte.
  $E9E7,$01 Fetch the next script byte.
  $E9E8,$02 Set bit #N$06 of #REGa.
  $E9EA,$03 Set the current entity's entity type.
  $E9ED,$02 Jump to #R$E9D5 to continue the loop.

c $E9EF Blit Display Buffer Row
@ $E9EF label=Blit_DisplayBufferRow
D $E9EF Blit one display-buffer tile to the screen. The graphic-set index
. selects a base from #R$730B; the tile index × #N$08 is added to that base
. Attribute bit #N$07 selects the mirrored blit at #R$EA23 (via #R$7319).
N $E9EF Write the attribute and resolve the graphic-set tile address.
  $E9EF,$05 Force bright on the attribute in #REGa and write it through #REGix.
  $E9F4,$04 Keep the tile index in #REGhl (high byte cleared).
  $E9F8,$04 Double the graphic-set index into #REGbc as a word offset.
  $E9FC,$07 Point #REGhl at #R$730B, add the set offset, and fetch the set base
. into #REGbc.
  $EA03,$05 Restore the tile index, multiply it by #N($08), and add the set base
. to get the bitmap address.
  $EA08,$01 Keep the bitmap address in #REGde.
N $EA09 Convert the attribute address into a screen-bitmap address and blit.
  $EA09,$02 Copy #REGix to #REGhl (using the stack).
  $EA0C,$04 Multiply the attribute high byte by #N($08).
  $EA10,$02,b$01 Keep only the screen-bitmap high bits (mask #N$5B).
  $EA12,$02 Write the result to #REGh and move the address into #REGde.
  $EA14,$06 Is the mirror bit (bit #N$07) set on the attribute? If so, blit the
. mirrored tile at #R$EA23.
  $EA1A,$02 There are #N$08 pixel rows in a tile.
N $EA1C Copy #N$08 pixel rows of an unmirrored tile into the screen bitmap.
@ $EA1C label=Blit_DisplayBufferRow_CopyRows
  $EA1C,$06 Copy one bitmap row to the screen and step to the next pixel row.
  $EA22,$01 Return.
N $EA23 Blit the tile with horizontal mirroring via #R$7319.
@ $EA23 label=Blit_DisplayBufferRowLoop
  $EA23,$04 Clear the mirror bit on the attribute at #REGix.
  $EA27,$02 There are #N$08 pixel rows in a tile.
N $EA29 Copy #N$08 pixel rows with horizontal mirroring via #R$7319.
@ $EA29 label=Blit_DisplayBufferRowLoopB
  $EA29,$12 Fetch a bitmap byte, reverse it through #R$7319, write it to the
. screen, and step to the next pixel row.
  $EA3B,$01 Return.

c $EA3C Clear Both Display Buffers
@ $EA3C label=Clear_BothDisplayBuffers
D $EA3C Zero-fill #N$0F00 bytes from Primary Display Buffer (#R$63A0), covering
. both the primary and secondary buffers.
  $EA3C,$03 Point #REGhl at Primary Display Buffer (#R$63A0).
  $EA3F,$03 Load #REGbc with #N$0F00.
  $EA42,$02 Jump to #R$EA4A to fill with #N$00.

c $EA44 Clear Display Buffer
@ $EA44 label=Clear_DisplayBuffer
D $EA44 Clear the current display buffer.
  $EA44,$03 Load #REGhl with the current display-buffer pointer (#R$72F5).
  $EA47,$03 Load #REGbc with #N$077F.
N $EA4A Shared zero-fill used to clear one or both display buffers.
@ $EA4A label=Fill_MemoryWithZero
  $EA4A,$01 Clear #REGa to #N$00.
  $EA4B,$01 Set the byte at #REGhl.
  $EA4C,$01 Copy #REGhl to #REGde.
  $EA4D,$01 Copy #REGhl to #REGde.
  $EA4E,$01 Advance the clear-attributes destination by one.
  $EA4F,$02 Copy bytes from *#REGhl to *#REGde until #REGbc is zero.
  $EA51,$01 Return.

c $EA52 Clear Attribute File
@ $EA52 label=Clear_AttributeFile
D $EA52 Clear the attribute file.
R $EA52 A Attribute fill value
  $EA52,$01 Switch to the shadow registers.
  $EA53,$03 Load #REGhl with #N$5800 (attribute buffer).
  $EA56,$01 Copy #REGhl to #REGde.
  $EA57,$01 Copy #REGhl to #REGde.
  $EA58,$01 Advance the clear-attributes destination by one.
  $EA59,$01 Write the fill value to the first attribute cell.
  $EA5A,$05 Copy #N$027F attribute bytes from *#REGhl to *#REGde.
  $EA5F,$03 Call #R$EA3C to clear both display buffers.
N $EA62 #HTML(#AUDIO0(clear-attributes.wav)(#INCLUDE(ClearAttributes)))
  $EA62,$02 Load #REGa with sound index #N$89.
  $EA64,$03 Call #R$F8F9 to queue a sound effect.
  $EA67,$03 Call #R$F9AF to play the queued sound.
  $EA6A,$01 Switch to the shadow registers.
  $EA6B,$01 Return.

g $EA6C Border / Speaker State
@ $EA6C label=BorderSpeakerState
D $EA6C Current border colour and EAR bit. Written by #R$EA6D; read by #R$F9AF
. before each speaker toggle.
B $EA6C,$01

c $EA6D Set Border And Speaker State
@ $EA6D label=Set_BorderSpeakerState
D $EA6D Output #REGa to port #N$FE and remember it at #R$EA6C.
  $EA6D,$02 Send #REGa to the speaker (port #N$FE).
  $EA6F,$03 Store it at #R$EA6C.
  $EA72,$01 Return.

c $EA73 Reposition Camera-Follow Entity After Interaction
@ $EA73 label=Reposition_CameraFollowEntity
D $EA73 Clear the attribute file via #R$EA52, then randomly reposition the
. camera-follow entity (#R$909B) and store a Berk script pointer at #R$72B1.
  $EA73,$02 Load #REGa with #N$04.
  $EA75,$03 Set the camera-follow delay (#R$730A).
  $EA78,$02 Load #REGa with #N$7F.
  $EA7A,$03 Call #R$EA52 to clear the attribute file (and play sound).
  $EA7D,$01 Switch to the shadow registers.
  $EA7E,$02 Stash #REGix on the stack.
  $EA80,$04 Point #REGix at the camera-follow entity (#R$909B).
  $EA84,$03 Load #REGa with the current entity's x-coordinate.
  $EA87,$02 Load #REGb with #N$05.
N $EA89 Divide the follow entity's X by #N$20 to pick a room-band seed.
@ $EA89 label=Reposition_CameraFollow_ShiftX
  $EA89,$02 Shift #REGa right logical.
  $EA8B,$02 Decrease the loop counter in #REGb and jump to #R$EA89 if more
. iterations remain.
  $EA8D,$01 Keep the fill attribute in #REGc.
N $EA8E Pick a random X band that differs from the previous one.
@ $EA8E label=Reposition_CameraFollow_WriteX
  $EA8E,$02 Load #REGa with #N$05.
  $EA90,$03 Call #R$EAE5 to pick a pseudo-random value.
  $EA93,$01 Step the fill-row counter on by one.
  $EA94,$03 Does #REGa match #REGc? If so, jump to #R$EA8E.
  $EA97,$01 Stash #REGaf on the stack.
  $EA98,$02 Load #REGb with #N$05.
N $EA9A Scale the band into a world X and add a random offset for the follow
. entity.
@ $EA9A label=Reposition_CameraFollow_RandomY
  $EA9A,$01 Double #REGa to form a word index into the table.
  $EA9B,$02 Decrease the loop counter in #REGb and jump to #R$EA9A if more
. iterations remain.
  $EA9D,$01 Keep a copy of #REGa in #REGb.
  $EA9E,$02 Load #REGa with #N$14.
  $EAA0,$03 Call #R$EAE5 to pick a pseudo-random value.
  $EAA3,$02 #REGa+=#N$02.
  $EAA5,$01 #REGa+=#REGb.
  $EAA6,$03 Set the current entity's x-coordinate.
  $EAA9,$02 #REGa+=#N$05.
  $EAAB,$03 Set the current entity's x-extent.
  $EAAE,$01 Restore #REGaf from the stack.
  $EAAF,$04 Is #REGa equal to #N$03? If so, jump to #R$EAB9.
  $EAB3,$02 Load #REGa with #N$03.
  $EAB5,$03 Call #R$EAE5 to pick a pseudo-random value.
  $EAB8,$02 Step the fill-row counter on by two.
N $EAB9 Write the follow entity's room, Y, extents, and facing after the random
. place.
@ $EAB9 label=Reposition_CameraFollow_WriteScript
  $EABA,$03 Set the current entity's room index.
  $EABD,$02 #REGa+=#N$1D.
  $EABF,$03 Set the current entity's y-coordinate.
  $EAC2,$02 #REGa+=#N$06.
  $EAC4,$03 Set the current entity's y-extent.
  $EAC7,$04 Write #N$00 to the current entity's direction / state.
  $EACB,$04 Set bit #N$00 of the current entity's flags byte 3.
  $EACF,$03 Load #REGbc with #R$B9A5(#N$BBBD).
  $EAD2,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$EADA.
  $EAD8,$02 Advance the script address in #REGbc by two bytes.
N $EADA Store the chosen Berk script pointer at #R$72B1 and return.
@ $EADA label=Reposition_CameraFollow_PickScript
  $EADA,$04 Store #REGbc in Pointer: Berk Script Position (#R$72B1).
  $EADE,$02 Restore #REGix from the stack.
  $EAE0,$01 Switch to the shadow registers.
  $EAE1,$01 Return.

g $EAE2 Random Seed Scratch
@ $EAE2 label=RandomSeedScratch
D $EAE2 Three-byte scratch written by game start and read by the pseudo-random
. routine.
B $EAE2,$02 Seed word updated by #R$EAE5.
@ $EAE4 label=RandomRangeMaximum
B $EAE4,$01 Random-range maximum for the current #R$EAE5 call.

c $EAE5 Generate Pseudo-Random Number
@ $EAE5 label=PseudoRandom
D $EAE5 Return a pseudo-random number between #N$01 and max(#N($02), #REGa).
R $EAE5 A Maximum value
R $EAE5 O:A Random number
E $EAE5 View the equivalent code in;
. #LIST
. { #FLUNKY$955A }
. LIST#
  $EAE5,$04 Is #REGa less than #N$02? If not, jump to #R$EAEB.
  $EAE9,$02 Load #REGa with #N$02.
N $EAEB Clamp the range to at least #N($02), mix the seed at #R$EAE2, and reduce
. into #N$01…max.
@ $EAEB label=PseudoRandom_Mix
  $EAEB,$03 Store #REGa as the random-range maximum at #R$EAE4.
  $EAEE,$03 Stash #REGhl, #REGde and #REGbc on the stack.
  $EAF1,$04 Load #REGde from #R$EAE2.
  $EAF5,$01 Copy #REGe into #REGh.
  $EAF6,$02 Load #REGl with #N$FD.
  $EAF8,$01 Copy #REGd into #REGa for later use.
  $EAF9,$01 Is #REGa zero?.
  $EAFA,$02 Subtract #REGde from #REGhl, including the previous success marker.
  $EAFC,$02 Subtract the previous success marker from #REGa.
  $EAFE,$02 Subtract #REGde from #REGhl, including the previous success marker.
  $EB00,$02 Subtract the previous success marker from #REGa.
  $EB02,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $EB03,$02 Clear #REGd (high byte of a pointer/offset).
  $EB05,$02 Subtract #REGde from #REGhl, including the previous success marker.
  $EB07,$02 Jump to #R$EB0A if the result did not underflow.
  $EB09,$01 Advance the data pointer in #REGhl by one byte.
N $EB0A Write the mixed seed back to #R$EAE2 and accumulate it against the
. range.
@ $EB0A label=PseudoRandomContinue
  $EB0A,$03 Store #REGhl in #R$EAE2.
  $EB0D,$02 Copy #REGhl into #REGde (using the stack).
  $EB0F,$03 Load #REGa with the random-range maximum at #R$EAE4.
  $EB12,$01 Decrease #REGa by one.
  $EB13,$01 Keep a copy of #REGa in #REGb.
  $EB14,$01 Clear #REGa to #N$00.
N $EB15 Fold the seed word into the result by repeated addition.
@ $EB15 label=PseudoRandomContinueB
  $EB15,$01 #REGhl+=#REGde.
  $EB16,$02 Jump to #R$EB19 if the result did not underflow.
  $EB18,$01 Step the print-position / counter on by one.
N $EB19 Finish the accumulate loop and restore the caller's registers.
@ $EB19 label=PseudoRandomContinueB2
  $EB19,$02 Decrease the loop counter in #REGb and jump to #R$EB15 if more
. iterations remain.
  $EB1B,$03 Restore #REGbc, #REGde and #REGhl from the stack.
  $EB1E,$01 Return.

b $EB1F Score Leading-Zero Suppress Flag
@ $EB1F label=Flag_ScoreLeadingZeroSuppress
D $EB1F Leading-zero suppress flag for #R$EB20 / #R$EB41. Cleared while
. leading zeros are blanked, then set when a non-zero digit is printed.
  $EB1F,$01

c $EB20 Print Score Digits
@ $EB20 label=Print_ScoreDigits
D $EB20 Print the score in #REGhl as four digits via #R$EB41, suppressing
. leading zeros until a non-zero digit (or the units) using #R$EB1F.
  $EB20,$01 Clear #REGa to #N$00.
  $EB21,$02 Jump to #R$EB25 to continue the loop.
  $EB23,$02 Load #REGa with #N$01.
N $EB25 Remember the leading-zero suppress flag at #R$EB1F, then print
. thousands/hundreds/tens/units.
@ $EB25 label=Print_ScoreDigits_StoreSuppressFlag
  $EB25,$03 Set #R$EB1F.
  $EB28,$03 Load #REGde with #N($03E8,$04,$04).
  $EB2B,$03 Call #R$EB41 to print Digit.
  $EB2E,$03 Load #REGde with #N($0064,$04,$04).
  $EB31,$03 Call #R$EB41 to print Digit.
  $EB34,$03 Load #REGde with #N($000A,$04,$04).
  $EB37,$03 Call #R$EB41 to print Digit.
  $EB3A,$01 Step the print-position / counter on by one.
  $EB3B,$03 Set #R$EB1F.
  $EB3E,$01 Copy #REGl into #REGa.
  $EB3F,$02 Jump to #R$EB4B to blit Next Row.

c $EB41 Print Digit
@ $EB41 label=Print_Digit
D $EB41 Divide #REGhl by #REGde, print the quotient digit through #REGix, and
. leave the remainder in #REGhl. Uses #R$EB1F to suppress leading zeros.
  $EB41,$01 Is #REGa zero?.
  $EB42,$02 Load #REGb with #N$FF.
N $EB44 Count how many times #REGde fits into #REGhl (digit quotient).
@ $EB44 label=Print_Digit_DivideLoop
  $EB44,$01 Step the outer print loop counter on by one.
  $EB45,$02 Subtract #REGde from #REGhl, including the previous success marker.
  $EB47,$02 Jump to #R$EB44 if the result did not underflow.
  $EB49,$01 #REGhl+=#REGde.
  $EB4A,$01 Copy the loop counter from #REGb into #REGa.
N $EB4B Choose a digit glyph, a leading space, or a leading zero using #R$EB1F.
@ $EB4B label=Print_Digit_SelectGlyph
  $EB4B,$03 Is #REGa zero? If not, jump to #R$EB5C.
  $EB4E,$03 Load #REGa from #R$EB1F.
  $EB51,$03 Is #REGa zero? If not, jump to #R$EB58.
  $EB54,$02 Load #REGa with #N$20.
  $EB56,$02 Jump to #R$EB61 to continue the loop.
N $EB58 Print a leading zero (#CHR$30) while suppression is still armed.
@ $EB58 label=Print_Digit_LeadingZero
  $EB58,$02 Load #REGa with #N$30.
  $EB5A,$02 Jump to #R$EB61 to continue the loop.
N $EB5C Convert a non-zero quotient to ASCII and clear the leading-zero suppress
. flag.
@ $EB5C label=Print_DigitLoopB
  $EB5C,$02 #REGa+=#N$30.
  $EB5E,$03 Set #R$EB1F.
N $EB61 Write the chosen character through #REGix and advance one column.
@ $EB61 label=Print_DigitLoopB2
  $EB61,$03 Write the character code through #REGix.
  $EB64,$02 Advance #REGix to the next character column.
  $EB66,$01 Return.

c $EB67 Print Character
@ $EB67 label=Print_Character
D $EB67 Print the character code in #REGde at attribute address #REGhl using the
. character set at #R$72F9 and attribute #R$7307.
  $EB67,$03 Stash #REGde, #REGhl and #REGbc on the stack.
  $EB6A,$03 Load #REGa with the current text attribute (#R$7307).
  $EB6D,$01 Set the byte at #REGhl.
  $EB6E,$01 Copy #REGh into #REGa.
  $EB6F,$03 Multiply #REGa by #N$08 to form the screen-bitmap high byte.
  $EB72,$02,b$01 #REGa&=#N$5B.
  $EB74,$01 Copy #REGa into #REGh.
  $EB75,$01 Stash #REGhl on the stack.
  $EB76,$01 Exchange #REGde and #REGhl.
  $EB77,$03 Multiply #REGhl by #N$08 to index the character glyph.
  $EB7A,$04 Load #REGde with the current character-set pointer (#R$72F9).
  $EB7E,$01 #REGhl+=#REGde.
  $EB7F,$01 Restore #REGde from the stack.
  $EB80,$02 Load #REGb with loop count #N$08.
N $EB82 Blit #N$08 pixel rows of the character glyph into the screen bitmap.
@ $EB82 label=Print_CharacterLoop
  $EB82,$01 Fetch the next script byte.
  $EB83,$01 Set the byte at #REGde.
  $EB84,$01 Advance the high byte of the screen address by one.
  $EB85,$01 Advance the data pointer in #REGhl by one byte.
  $EB86,$02 Decrease the loop counter in #REGb and jump to #R$EB82 if more
. iterations remain.
  $EB88,$03 Restore #REGbc, #REGhl and #REGde from the stack.
  $EB8B,$01 Return.

w $EB8C Table of Addresses of Script Handling Routines
@ $EB8C label=TableScriptHandlers
D $EB8C One word per script opcode from #N$00 to #N$50. Used by #R$EC2E.
. #TABLE(default,centre,centre,centre)
. { =h Opcode | =h Handler | =h Meaning }
. { #N$00 | Unused | Unused }
. { #N$01 | #R$EF82 | Load script address }
. { #N$02 | #R$EF8C | Move left one character }
. { #N$03 | #R$EFB1 | Move right one character }
. { #N$04 | #R$F014 | Move up one character }
. { #N$05 | #R$F069 | Move down one character }
. { #N$06 | #R$F0C7 | Move left two characters }
. { #N$07 | #R$F0CE | Move right two characters }
. { #N$08 | #R$F0DC | Move up two characters }
. { #N$09 | #R$F0D5 | Move down two characters }
. { #N$0A | #R$EF54 | Reset direction flags }
. { #N$0B | #R$EF5B | Face right }
. { #N$0C | #R$EF62 | Face left }
. { #N$0D | #R$EF69 | Face up }
. { #N$0E | #R$EF70 | Face down }
. { #N$0F | #R$F0E3 | Put down carried entity }
. { #N$10 | #R$F166 | Face left after put-down }
. { #N$11 | #R$F173 | Face right after put-down }
. { #N$12 | #R$F1A1 | Position put-down entity left }
. { #N$13 | #R$F1B7 | Position put-down entity right }
. { #N$14 | #R$F13E | Pick up / restore held entity }
. { #N$15 | #R$EF77 | Jump if carrying }
. { #N$16 | #R$F1DF | Start Drutt script }
. { #N$17 | #R$EF12 | Load script parameter into A }
. { #N$18 | #R$EF32 | Start loop }
. { #N$19 | #R$F24F | Continue to next instruction }
. { #N$1A | #R$EDD5 | Open trap door }
. { #N$1B | #R$AFDC | Animate trap door }
. { #N$1C | #R$EDCF | Close trap door }
. { #N$1D | #R$EF28 | Set event flags after interaction }
. { #N$1E | #R$EC72 | Berk interact with door ahead }
. { #N$1F | #R$ECDB | Berk interact with door behind }
. { #N$20 | #R$ECB0 | Berk open door ahead }
. { #N$21 | #R$EC53 | Start counted script loop }
. { #N$22 | #R$EC61 | End script loop }
. { #N$23 | Unused | Unused }
. { #N$24 | #R$BF8F | Task-two entity action }
. { #N$25 | #R$BFEA | Task-two entity action }
. { #N$26 | #R$C000 | Task-two entity action }
. { #N$27 | #R$C027 | Task-two entity action }
. { #N$28 | #R$BF77 | Task-two entity action }
. { #N$29 | #R$BFBF | Task-two entity action }
. { #N$2A | #R$C602 | Cauldron / heater action }
. { #N$2B | #R$C3DF | Task-three entity action }
. { #N$2C | #R$C5F6 | Slimy-creature action }
. { #N$2D | #R$C443 | Task-three entity action }
. { #N$2E | #R$C582 | Task-three entity action }
. { #N$2F | #R$C568 | Task-three entity action }
. { #N$30 | #R$C3D7 | Task-three entity action }
. { #N$31 | #R$BC36 | Type-#N$22 action }
. { #N$32 | #R$BC45 | Type-#N$22 action }
. { #N$33 | #R$BC64 | Type-#N$22 action }
. { #N$34 | #R$BC81 | Type-#N$22 action }
. { #N$35 | #R$BC54 | Type-#N$22 action }
. { #N$36 | #R$D59E | Collectible action }
. { #N$37 | #R$D56A | Collectible action }
. { #N$38 | #R$D601 | Collectible action }
. { #N$39 | #R$D61D | Collectible action }
. { #N$3A | #R$D639 | Collectible action }
. { #N$3B | #R$D65B | Collectible action }
. { #N$3C | #R$D5F4 | Collectible action }
. { #N$3D | #R$D5ED | Collectible action }
. { #N$3E | #R$D074 | Vat action }
. { #N$3F | #R$D1BD | Vat action }
. { #N$40 | #R$D1AC | Vat action }
. { #N$41 | #R$D1E6 | Vat action }
. { #N$42 | #R$D1D5 | Vat action }
. { #N$43 | #R$D153 | Vat action }
. { #N$44 | #R$D1F5 | Vat action }
. { #N$45 | #R$D1CC | Vat action }
. { #N$46 | #R$D1FE | Vat action }
. { #N$47 | #R$D06C | Vat action }
. { #N$48 | #R$CAFE | Task-four entity action }
. { #N$49 | #R$CC53 | Task-four entity action }
. { #N$4A | #R$CC78 | Task-four entity action }
. { #N$4B | #R$CB44 | Task-four entity action }
. { #N$4C | #R$CC8B | Task-four entity action }
. { #N$4D | #R$CBCE | Task-four entity action }
. { #N$4E | #R$CBC3 | Task-four entity action }
. { #N$4F | #R$CB1E | Task-four entity action }
. { #N$50 | #R$CAF0 | Task-four entity action }
. TABLE#
E $EB8C View the equivalent code in;
. #LIST
. { #FLUNKY$9C2C }
. LIST#
  $EB8C,$02 Address of the handler for script opcode #N((#PC-$EB8C)/$02).
L $EB8C,$02,$51


c $EC2E Advance #REGhl To Next Script Instruction And Execute
@ $EC2E label=AdvanceScriptInstruction
D $EC2E Advance the script pointer by two bytes and execute the instruction at
. #REGhl. A zero high byte means a script opcode (dispatched via #R$EB8C);
. otherwise the word is a graphic layout address stored into the entity at
. #REGix.
R $EC2E IX Address of complex state data for an entity
R $EC2E O:HL Current position in script data
E $EC2E View the equivalent code in;
. #LIST
. { #R$EC2E: #FLUNKY$9CCE }
. { #R$EC30: #FLUNKY$9CD0 }
. { #R$EC43: #FLUNKY$9CE3 }
. LIST#
  $EC2E,$02 Advance #REGhl to the next script instruction.
N $EC30 If the high byte of the word at #REGhl is non-zero, store that word as
. the entity's graphic layout pointer and return. Otherwise jump to #R$EC43 to
. dispatch a script opcode.
@ $EC30 label=ScriptInstruction
  $EC30,$01 Advance #REGhl to the next script byte.
  $EC31,$01 Load #REGa from *#REGhl.
  $EC32,$01 Step #REGhl back one byte in the current data stream.
  $EC33,$03 Is #REGa zero? If so, jump to #R$EC43 to dispatch the script opcode.
  $EC36,$03 Store #REGhl in the active script cursor (#R$72CF).
  $EC39,$01 Load #REGa from *#REGhl.
  $EC3A,$03 Set the current entity's graphic layout address (low).
  $EC3D,$01 Advance #REGhl to the next script byte.
  $EC3E,$01 Load #REGa from *#REGhl.
  $EC3F,$03 Set the current entity's graphic layout address (high).
  $EC42,$01 Return.
N $EC43 Dispatch the script opcode in the low byte at #REGhl via #R$EB8C.
@ $EC43 label=ExecuteScript
  $EC43,$01 Load #REGa from *#REGhl.
  $EC44,$01 Stash #REGhl on the stack.
  $EC45,$03 Point #REGhl at the script handler table (#R$EB8C).
  $EC48,$01 Double #REGa to form a word index into the script/handler table.
  $EC49,$01 Keep the index in #REGc.
  $EC4A,$02 Load #REGb with #N$00.
  $EC4C,$01 #REGhl+=#REGbc.
  $EC4D,$03 Fetch the word at #REGhl into #REGbc.
  $EC50,$01 Restore #REGhl from the stack.
  $EC51,$01 Stash #REGbc on the stack.
  $EC52,$01 Return.


c $EC53 Script Routine: (#N$21) Start script loop with count
@ $EC53 label=ScriptRoutine_StartScriptLoop
D $EC53 Start a counted script loop for the current entity.
  $EC53,$02 Advance #REGhl past the current script instruction.
  $EC55,$01 Fetch the next script byte.
  $EC56,$03 Set the script loop counter (#R$7301).
  $EC59,$02 Advance #REGhl past the loop-count operand onto the loop body.
  $EC5B,$03 Store #REGhl in the script loop restart pointer (#R$72FD).
  $EC5E,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $EC61 Script Routine: (#N$22) End script loop
@ $EC61 label=ScriptRoutine_EndScriptLoop
D $EC61 End the current script loop and resume after it.
  $EC61,$03 Load #REGa with the script loop counter (#R$7301).
  $EC64,$01 Decrease #REGa by one.
  $EC65,$03 Set the script loop counter (#R$7301).
  $EC68,$04 Is #REGa zero? If so, jump to #R$EC2E to run the next script
. instruction.
  $EC6C,$03 Load #REGhl with the script loop restart pointer (#R$72FD).
  $EC6F,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $EC72 Script Routine: (#N$1E) Have Berk interact with a door in front of him
@ $EC72 label=ScriptRoutine_BerkDoorInFront
D $EC72 Let Berk interact with the door directly in front of him.
  $EC72,$04 Load #REGbc with the current-entity pointer (#R$72AC).
  $EC76,$01 Load #REGa from the byte at #REGbc.
  $EC77,$04 Is #REGa equal to #N$05? If so, jump to #R$EC92.
  $EC7B,$04 Is #REGa equal to #N$08? If so, jump to #R$EC9C.
  $EC7F,$04 Is #REGa equal to #N$10? If so, jump to #R$ECA6.
  $EC83,$05 Is #REGa equal to #N$03? If not, jump to #R$EC2E.
  $EC88,$03 Point #REGbc at basket rim layout #R$9D2D.
N $EC8B Install basket rim layout #R$9D2D into slot #R$8EF3(#N$9051) (type
. #N$03 basket ahead).
@ $EC8B label=Script_DoorInteract_Scan
  $EC8B,$04 Store #REGbc in #R$8EF3(#N$9051).
  $EC8F,$03 Jump to #R$EC2E to run the next script instruction.
N $EC92 Select yellow cup rim layout #R$9D7E for the type-#N$05 entity ahead.
@ $EC92 label=Script_DoorAhead_Hit
  $EC92,$03 Point #REGbc at yellow cup rim layout #R$9D7E.
N $EC95 Install the chosen yellow cup layout into slot #R$8EF3(#N$9043).
@ $EC95 label=Script_DoorInteract_StoreDoorSlot
  $EC95,$04 Store #REGbc in #R$8EF3(#N$9043).
  $EC99,$03 Jump to #R$EC2E to run the next script instruction.
N $EC9C Select yellow cup rim layout #R$9D7E for the type-#N$08 entity ahead.
@ $EC9C label=Script_DoorAhead_YellowCupRim
  $EC9C,$03 Point #REGbc at yellow cup rim layout #R$9D7E.
N $EC9F Install the chosen layout into slot #R$8EF3(#N$9035).
@ $EC9F label=Script_DoorInteract_Found
  $EC9F,$04 Store #REGbc in #R$8EF3(#N$9035).
  $ECA3,$03 Jump to #R$EC2E to run the next script instruction.
N $ECA6 Select layout #R$A14E for the type-#N$10 seed box ahead.
@ $ECA6 label=Script_DoorAhead_TaskProp
  $ECA6,$03 Load #REGbc with #R$A14E.
N $ECA9 Install the chosen seed-box layout into slot #R$8EF3(#N$9027).
@ $ECA9 label=Script_DoorInteract_StoreAltDoorSlot
  $ECA9,$04 Store #REGbc in #R$8EF3(#N$9027).
  $ECAD,$03 Jump to #R$EC2E to run the next script instruction.

c $ECB0 Script Routine: (#N$20) Have Berk open a door in front of him
@ $ECB0 label=ScriptRoutine_BerkOpenDoorInFront
D $ECB0 Let Berk open the door directly in front of him.
  $ECB0,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $ECB4,$04 Write #N$02 to the referenced entity's flags byte 2.
  $ECB8,$03 Load #REGa with the referenced entity's entity type.
  $ECBB,$04 Is #REGa equal to #N$05? If so, jump to #R$ECCC.
  $ECBF,$04 Is #REGa equal to #N$03? If so, jump to #R$ECD1.
  $ECC3,$04 Is #REGa equal to #N$10? If so, jump to #R$ECD6.
  $ECC7,$03 Point #REGbc at entity-type-#N$08 layout #R$9DA2.
  $ECCA,$02 Jump to #R$EC9F to script Door Interact Found.
N $ECCC Open the type-#N$05 yellow cup using layout #R$9D69, then store via
. #R$EC95.
@ $ECCC label=Script_OpenDoor_Hit
  $ECCC,$03 Point #REGbc at yellow cup layout #R$9D69.
  $ECCF,$02 Jump to #R$EC95 to script Door Interact Next.
N $ECD1 Open the type-#N$03 basket using layout #R$9D0F, then store via
. #R$EC8B.
@ $ECD1 label=Script_OpenDoor_Basket
  $ECD1,$03 Point #REGbc at basket layout #R$9D0F.
  $ECD4,$02 Jump to #R$EC8B to continue scanning.
N $ECD6 Open the type-#N$10 prop using layout #R$A13F, then store via #R$ECA9.
@ $ECD6 label=Script_OpenDoor_TaskProp
  $ECD6,$03 Point #REGbc at task-prop layout #R$A13F.
  $ECD9,$02 Jump to #R$ECA9 to finish this handler.

c $ECDB Script Routine: (#N$1F) Have Berk interact with a door behind him
@ $ECDB label=ScriptRoutine_BerkDoorBehind
D $ECDB Let Berk interact with the door directly behind him.
R $ECDB IX Address of complex state data for an entity
  $ECDB,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $ECDF,$03 Load #REGa with the referenced entity's entity type.
  $ECE2,$04 Is #REGa equal to #N$05? If so, jump to #R$ECFC.
  $ECE6,$04 Is #REGa equal to #N$08? If so, jump to #R$ED05.
  $ECEA,$04 Is #REGa equal to #N$10? If so, jump to #R$ED0E.
  $ECEE,$05 Is #REGa equal to #N$03? If not, jump to #R$EC2E.
  $ECF3,$03 Point #REGbc at basket upside-down layout #R$9D4B.
  $ECF6,$04 Store #REGbc in #R$8EF3(#N$9051).
  $ECFA,$02 Jump to #R$ED15 to continue this routine.
N $ECFC Install yellow cup upside-down layout #R$9D8D into slot
. #R$8EF3(#N$9043) (type #N$05).
@ $ECFC label=Script_DoorBehind_Scan
  $ECFC,$03 Point #REGbc at yellow cup upside-down layout #R$9D8D.
  $ECFF,$04 Store #REGbc in #R$8EF3(#N$9043).
  $ED03,$02 Jump to #R$ED15 to continue this routine.
N $ED05 Install worm-can layout #R$9DA2 into slot #R$8EF3(#N$9035) (type
. #N$08).
@ $ED05 label=Script_DoorBehind_Type08
  $ED05,$03 Point #REGbc at the worm-can layout (#R$9DA2).
  $ED08,$04 Store #REGbc in #R$8EF3(#N$9035).
  $ED0C,$02 Jump to #R$ED15 to continue this routine.
N $ED0E Install seed-box layout #R$A15B into slot #R$8EF3(#N$9027)
. (type #N$10).
@ $ED0E label=Script_DoorBehind_TaskProp
  $ED0E,$03 Load #REGbc with #R$A15B.
  $ED11,$04 Store #REGbc in #R$8EF3(#N$9027).
N $ED15 Mark the interactable entity facing-behind (#N$40) and honour the
. interaction delay in #R$72EC.
@ $ED15 label=Script_DoorBehind_FaceAndDelay
  $ED15,$04 Write #N$40 to the referenced entity's flags byte 2.
  $ED19,$03 Load #REGa with the door interaction delay (#R$72EC).
  $ED1C,$03 Is the door interaction delay (#R$72EC) zero? If so, jump to
. #R$ED26.
  $ED1F,$01 Decrease #REGa by one.
  $ED20,$03 Set the door interaction delay (#R$72EC).
  $ED23,$03 Jump to #R$EDBD to continue this routine.
N $ED26 Snapshot Berk's position/room and scan complex entities for a matching
. type-#N$32 hitch.
@ $ED26 label=Script_DoorBehind_SnapshotScan
  $ED26,$03 Stash #REGhl and #REGix on the stack.
  $ED29,$04 Load #REGix with the current-entity pointer (#R$72AC).
  $ED2D,$03 Load #REGc with the current entity's x-coordinate.
  $ED30,$03 Load #REGb with the current entity's y-coordinate.
  $ED33,$03 Load #REGa with the current entity's room index.
  $ED36,$03 Set saved room index (#R$72E8).
  $ED39,$03 Load #REGhl with the current-entity pointer (#R$72AC).
  $ED3C,$04 Point #REGiy at Boney's complex entity state (#R$8EE9).
  $ED40,$03 Load #REGde with #N($000E,$04,$04).
N $ED43 Walk complex entities looking for type #N$32; abort the behind-door move
. if found.
@ $ED43 label=Script_DoorBehind_WalkEntities
  $ED43,$03 Load #REGa with the referenced entity's entity type.
  $ED46,$04 Is #REGa equal to #N$32? If not, jump to #R$ED50.
  $ED4A,$03 Restore #REGix and #REGhl from the stack.
  $ED4D,$03 Jump to #R$EC2E to run the next script instruction.
N $ED50 Skip inactive (bit #N$07) entities while matching Berk's saved
. coordinates.
@ $ED50 label=Script_DoorBehind_SkipInactive
  $ED50,$04 Is bit #N$07 of #REGa set? If so, jump to #R$ED58.
N $ED54 Advance to the next complex entity and keep scanning.
@ $ED54 label=Script_DoorBehind_NextEntity
  $ED54,$02 #REGiy+=#REGde.
  $ED56,$02 Jump to #R$ED43 to continue this routine.
N $ED58 On a coordinate match, reactivate the hitch, copy Berk's position, and
. reseed #R$72EC.
@ $ED58 label=Script_DoorBehind_HitchMatch
  $ED58,$01 Copy #REGl into #REGa.
  $ED59,$05 Does #REGa match the referenced entity's extra state? If not, jump
. to #R$ED54.
  $ED5E,$01 Copy #REGh into #REGa.
  $ED5F,$05 Does #REGa match the referenced entity's extra state? If not, jump
. to #R$ED54.
  $ED64,$04 Reset bit #N$07 of the referenced entity's entity type.
  $ED68,$04 Reset bit #N$05 of the referenced entity's flags byte 1.
  $ED6C,$04 Set bit #N$07 of the referenced entity's flags byte 1.
  $ED70,$03 Load #REGa with the referenced entity's x-extent.
  $ED73,$03 Subtract the referenced entity's x-coordinate from #REGa.
  $ED76,$03 Store #REGc in the referenced entity's x-coordinate.
  $ED79,$01 #REGa+=#REGc.
  $ED7A,$03 Set the referenced entity's x-extent.
  $ED7D,$03 Load #REGa with the referenced entity's y-extent.
  $ED80,$03 Subtract the referenced entity's y-coordinate from #REGa.
  $ED83,$03 Store #REGb in the referenced entity's y-coordinate.
  $ED86,$01 #REGa+=#REGb.
  $ED87,$03 Set the referenced entity's y-extent.
  $ED8A,$03 Load #REGa with the current entity's room index.
  $ED8D,$04 Is #REGa equal to #N$01? If not, jump to #R$ED92.
  $ED91,$01 Step the door's room index on by one.
N $ED92 Write the hitch's new room, arm bit #N$00 of #R$72B3, and clear the
. type-#N$0B/#N$08 special case.
@ $ED92 label=Script_DoorBehind_WriteHitchRoom
  $ED92,$03 Set the referenced entity's room index.
  $ED95,$02 Load #REGa with #N$02.
  $ED97,$03 Call #R$EAE5 to pick a pseudo-random value.
  $ED9A,$01 Turn the random roll into a #N$01–#N$02 door delay.
  $ED9B,$03 Set the door interaction delay (#R$72EC).
  $ED9E,$03 Point #REGhl at the game event flags (#R$72B3).
  $EDA1,$02 Set bit #N$00 of the byte at #REGhl.
  $EDA3,$03 Load #REGa with the referenced entity's entity type.
  $EDA6,$04 Is #REGa equal to #N$0B? If not, jump to #R$EDBA.
  $EDAA,$03 Fetch the current entity's type for the type test.
  $EDAD,$04 Is #REGa equal to #N$08? If not, jump to #R$EDBA.
  $EDB1,$03 Point #REGhl at the collision scratch byte (#R$72BD).
  $EDB4,$01 Decrease the byte at #REGhl by one.
  $EDB5,$03 Point #REGhl at task-one / collision flags (#R$72B8).
  $EDB8,$02 Clear bit #N$06 of the byte at #REGhl.
N $EDBA Finish the behind-door hitch update and fall through to resume
. scripting.
@ $EDBA label=Script_DoorBehind_Finish
  $EDBA,$03 Restore #REGix and #REGhl from the stack.
N $EDBD Resume scripting at #R$B9A5(#N$BBA9) via #R$EC30.
@ $EDBD label=Script_DoorBehind_ResumeScript
  $EDBD,$03 Load #REGhl with #R$B9A5(#N$BBA9).
  $EDC0,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

b $EDC3 Data: Entity Type Bytes
@ $EDC3 label=Data_TrapDoorOpenTypes
D $EDC3 Bytes written by #R$EDDB / #R$EDF8 when opening or closing the trap
. door.
  $EDC3,$06 Open-trap type bytes applied to the six scenery slots.
@ $EDC9 label=Data_TrapDoorClosedTypes
  $EDC9,$06 Closed-trap type bytes applied to the six scenery slots.

c $EDCF Script Routine: (#N$1C) Close Trap Door
@ $EDCF label=ScriptRoutine_CloseTrapDoor
D $EDCF Call #R$EDDB (close the trap door) then advance to the next script
. instruction.
  $EDCF,$03 Call #R$EDDB to close the trap door.
  $EDD2,$03 Jump to #R$EC2E to run the next script instruction.


c $EDD5 Script Routine: (#N$1A) Open Trap Door
@ $EDD5 label=ScriptRoutine_OpenTrapDoor
D $EDD5 Call #R$EDF8 (open the trap door) then advance to the next script
. instruction.
  $EDD5,$03 Call #R$EDF8 to open the trap door.
  $EDD8,$03 Jump to #R$EC2E to run the next script instruction.

c $EDDB Close Trap Door
@ $EDDB label=Close_TrapDoor
D $EDDB Close the trap door: queue a sound, switch the lever graphic layout to
. closed facing right, and update the related scenery entity types.
  $EDDB,$04 Stash #REGix, #REGhl and #REGde on the stack.
  $EDDF,$03 Point #REGhl at the game event flags (#R$72B3).
  $EDE2,$04 Is "task-two / upstairs event latch" (bit #N$04 of #R$72B3) set? If
. so, jump to #R$EE2B.
  $EDE6,$02 Clear "trap door is open / trap door event armed" (bit #N$01 of
. #R$72B3).
N $EDE8 #HTML(#AUDIO0(trap-door-close.wav)(#INCLUDE(TrapDoorClose)))
  $EDE8,$02 Load #REGa with sound index #N$06.
  $EDEA,$03 Call #R$F8F9 to queue sound.
  $EDED,$03 Point #REGhl at the lever closed, facing right (#R$A809).
  $EDF0,$03 Store #REGhl in the lever layout pointer (#R$9177).
  $EDF3,$03 Point #REGhl at the closed-trap type list (#R$EDC9).
  $EDF6,$02 Jump to #R$EE19 to handle the trap door.

c $EDF8 Open Trap Door
@ $EDF8 label=Open_TrapDoor
D $EDF8 Open the trap door: queue a sound, switch the lever graphic layout to
. open facing right, and update the related scenery entity types.
  $EDF8,$04 Stash #REGix, #REGhl and #REGde on the stack.
  $EDFC,$03 Call #R$EE30 to check whether entities require the trap door to
. open.
  $EDFF,$03 Jump to #R$EE2B to continue if no open is required.
  $EE02,$03 Point #REGhl at the game event flags (#R$72B3).
  $EE05,$04 Is "task-two / upstairs event latch" (bit #N$04 of #R$72B3) set? If
. so, jump to #R$EE2B.
  $EE09,$02 Set "trap door is open / trap door event armed" (bit #N$01 of
. #R$72B3).
N $EE0B #HTML(#AUDIO0(trap-door-open.wav)(#INCLUDE(TrapDoorOpen)))
  $EE0B,$02 Load #REGa with sound index #N$05.
  $EE0D,$03 Call #R$F8F9 to queue sound.
  $EE10,$03 Point #REGhl at the lever open, facing right (#R$A7FA).
  $EE13,$03 Store #REGhl in the lever layout pointer (#R$9177).
  $EE16,$03 Point #REGhl at the open-trap type list (#R$EDC3).
N $EE19 Rewrite #N$06 scenery entity types from the open/close type list
. starting at #R$8E87.
@ $EE19 label=UpdateTrapDoorEntityTypes
  $EE19,$04 Point #REGix at the simple-entity slot at #R$8E87.
  $EE1D,$03 Load #REGde with #N($000E,$04,$04).
  $EE20,$02 Load #REGb with loop count #N$06.
N $EE22 Write one type byte into the current trap door scenery slot and advance.
@ $EE22 label=UpdateTrapDoorEntityTypes_WriteType
  $EE22,$01 Load #REGa with the next type byte.
  $EE23,$03 Write it to the entity.
  $EE26,$01 Advance the trap door script pointer.
  $EE27,$02 Advance #REGix to the next entity.
  $EE29,$02 Decrease the loop counter in #REGb and jump to #R$EE22 if more
. iterations remain.
N $EE2B Exit open/close trap door after updating scenery types (or early abort).
@ $EE2B label=TrapDoor_RestoreAndReturn
  $EE2B,$04 Restore #REGde, #REGhl and #REGix from the stack.
  $EE2F,$01 Return.


c $EE30 Check Entities Near Trap Door
@ $EE30 label=Check_EntitiesNearTrapDoor
D $EE30 Scan complex entity state starting at #R$8EE9. Returns with the carry
. flag set when the trap door should open (an entity of type #N$32 is present
. and nearby entities have been adjusted). Called by #R$EDF8.
R $EE30 O:F Success marker set if the trap door should open
N $EE3A Scan complex entities for ones standing in the trap door X band of rooms
. #N$02–#N$04.
@ $EE3A label=CheckNearTrapDoor_Scan
  $EE30,$04 Point #REGix at Boney's complex entity state (#R$8EE9).
  $EE34,$03 Load #REGde with #N($000E,$04,$04).
  $EE37,$03 Point #REGhl at the game event flags (#R$72B3).
  $EE3A,$03 Fetch the current entity's type for the type test.
  $EE3D,$05 Is #REGa equal to #N$32? If so, jump to #R$EEBF.
  $EE42,$03 Is #REGa zero? If so, jump to #R$EE8E.
  $EE45,$04 Is #REGa less than #N$21? If not, jump to #R$EE8E.
  $EE49,$03 Load #REGa with the current entity's room index.
  $EE4C,$04 Is #REGa equal to #N$05? If so, jump to #R$EE8E.
  $EE50,$04 Is #REGa less than #N$02? If so, jump to #R$EE8E.
  $EE54,$06 Is bit #N$07 of the current entity's flags byte 1 set? If so, jump
. to #R$EE8E.
  $EE5A,$03 Load #REGa with the current entity's x-extent.
  $EE5D,$04 Is #REGa less than #N$6C? If so, jump to #R$EE8E.
  $EE61,$03 Load #REGa with the current entity's x-coordinate.
  $EE64,$04 Is #REGa less than #N$74? If not, jump to #R$EE8E.
  $EE68,$04 Is #REGa less than #N$72? If so, jump to #R$EE7A.
  $EE6C,$02 Jump to #R$EE74 to continue if the comparison did not match.
  $EE6E,$04 Set bit #N$06 of the current entity's flags byte 3.
  $EE72,$02 Jump to #R$EE8A to handle the trap door.
N $EE74 Flag this near-trap entity with bit #N$07 (right-of-band side).
@ $EE74 label=CheckNearTrapDoor_SetBit7
  $EE74,$04 Set bit #N$07 of the current entity's flags byte 3.
  $EE78,$02 Jump to #R$EE8A to handle the trap door.
N $EE7A For X in the inner band: poke Bad Tempered Thing state for Berk, else
. just mark the entity.
@ $EE7A label=CheckNearTrapDoor_CheckEntityType
  $EE7A,$03 Fetch the current entity's type for the type test.
  $EE7D,$04 Is #REGa less than #N$14? If not, jump to #R$EE92.
  $EE81,$04 Is #REGa equal to #N$01? If not, jump to #R$EE8A.
  $EE85,$02 Load #REGa with #N$07.
  $EE87,$03 Set the Bad Tempered Thing state (#R$72C7).
N $EE8A Set bit #N$00 on the near-trap entity, then advance.
@ $EE8A label=CheckNearTrapDoor_MarkEntity
  $EE8A,$04 Set bit #N$00 of the current entity's flags byte 2.
N $EE8E Advance to the next complex entity in the near-trap scan.
@ $EE8E label=CheckNearTrapDoor_NextEntity
  $EE8E,$02 #REGix+=#REGde.
  $EE90,$02 Jump to #R$EE3A to handle the trap door.
N $EE92 Restart from #R$8EE9 to clear near-trap marks when no type-#N$32 was
. found.
@ $EE92 label=CheckNearTrapDoor_ClearPass
  $EE92,$04 Point #REGix at Boney's complex entity state (#R$8EE9).
N $EE96 Clear pass: wipe bit #N$00/#N$06/#N$07 marks until type #N($32), then
. refuse the open.
@ $EE96 label=CheckNearTrapDoor_ClearScan
  $EE96,$03 Fetch the current entity's type for the type test.
  $EE99,$04 Is #REGa equal to #N$32? If so, jump to #R$EEBC.
  $EE9D,$06 Is bit #N$00 of the current entity's flags byte 2 set? If not,
. jump to #R$EEB8.
  $EEA3,$04 Reset bit #N$00 of the current entity's flags byte 2.
  $EEA7,$04 Reset bit #N$06 of the current entity's flags byte 3.
  $EEAB,$04 Reset bit #N$07 of the current entity's flags byte 3.
  $EEAF,$04 Is #REGa equal to #N$01? If not, jump to #R$EEB8.
  $EEB3,$02 Load #REGa with sound index #N$05.
  $EEB5,$03 Set the Bad Tempered Thing state (#R$72C7).
N $EEB8 Advance during the clear pass.
@ $EEB8 label=CheckNearTrapDoor_ClearNext
  $EEB8,$02 #REGix+=#REGde.
  $EEBA,$02 Jump to #R$EE96 to handle the trap door.
N $EEBC No open: clear the falling-entity latch (bit #N$02 of #R$72B3) and
. return carry clear.
@ $EEBC label=CheckNearTrapDoor_NoOpen
  $EEBC,$02 Clear the falling-entity latch (bit #N$02 of #R$72B3).
  $EEBE,$01 Return.
N $EEBF Type #N$32 found: restart from #R$8EE9 to nudge marked entities before
. opening.
@ $EEBF label=CheckNearTrapDoor_FoundSceneryBlock
  $EEBF,$04 Point #REGix at Boney's complex entity state (#R$8EE9).
N $EEC3 Adjust pass: shrink or bump entities that were marked near the trap
. door.
@ $EEC3 label=CheckNearTrapDoor_AdjustScan
  $EEC3,$03 Fetch the current entity's type for the type test.
  $EEC6,$04 Is #REGa equal to #N$32? If so, jump to #R$EF0E.
  $EECA,$06 Is bit #N$00 of the current entity's flags byte 2 set? If not,
. jump to #R$EF0A.
  $EED0,$03 Load #REGa with the current entity's flags byte 3.
  $EED3,$01 Keep the flags byte in #REGc.
  $EED4,$02,b$01 #REGa&=#N$3F.
  $EED6,$03 Set the current entity's flags byte 3.
  $EED9,$01 Copy the saved count/flag from #REGc into #REGa.
  $EEDA,$02,b$01 #REGa&=#N$C0.
  $EEDC,$02 Jump to #R$EEF4 to continue if the comparison matched.
  $EEDE,$04 Reset bit #N$00 of the current entity's flags byte 2.
  $EEE2,$04 Is bit #N$06 of #REGa set? If not, jump to #R$EEEC.
  $EEE6,$06 Move this entity one character right.
N $EEEC Bump a marked entity one character right away from the trap door band.
@ $EEEC label=CheckNearTrapDoor_BumpCoordinates
  $EEEC,$06 Bump this entity one character right.
  $EEF2,$02 Jump to #R$EF0A to handle the trap door.
N $EEF4 Randomly shrink a marked entity's Y/Y-extent by #N$04–#N$07 characters.
@ $EEF4 label=CheckNearTrapDoor_ShrinkBounds
  $EEF4,$02 Load #REGa with #N$04.
  $EEF6,$03 Call #R$EAE5 to pick a pseudo-random value.
  $EEF9,$02 #REGa+=#N$04.
  $EEFB,$01 Keep #REGa in #REGc for the next calculation.
  $EEFC,$03 Load #REGa with the current entity's y-coordinate.
  $EEFF,$01 #REGa-=#REGc.
  $EF00,$03 Set the current entity's y-coordinate.
  $EF03,$03 Load #REGa with the current entity's y-extent.
  $EF06,$01 #REGa-=#REGc.
  $EF07,$03 Set the current entity's y-extent.
N $EF0A Advance to the next entity in the adjust pass.
@ $EF0A label=CheckNearTrapDoor_AdjustNext
  $EF0A,$02 #REGix+=#REGde.
  $EF0C,$02 Jump to #R$EEC3 to handle the trap door.
N $EF0E Signal that the trap door should open (set bit #N$02 of #R$72B3, carry
. set).
@ $EF0E label=CheckNearTrapDoor_ShouldOpen
  $EF0E,$02 Set the falling-entity latch (bit #N$02 of #R$72B3).
  $EF10,$01 Signal success.
  $EF11,$01 Return.

c $EF12 Script Routine: (#N$17) Move held entity up one room row
@ $EF12 label=ScriptRoutine_MoveHeldUpOneRoom
D $EF12 Via #R$72AC: decrease the held entity's y and y-extent by #N($02), then
. increment its room index, and continue at #R$EC2E.
  $EF12,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $EF16,$0C Move the referenced entity two characters up.
  $EF22,$03 Increment the referenced entity's room index.
  $EF25,$03 Jump to #R$EC2E to run the next script instruction.

c $EF28 Script: Set Entity Latch
@ $EF28 label=ScriptRoutine_SetLatchRaiseEvent
D $EF28 Set bit #N$05 of flags byte 2 (#REGix+#N$02). If bit #N$04 of
. flags byte 3 (#REGix+#N$03) is clear, continue at #R$EF49 to set bit #N$00
. of #R$72B3.
R $EF28 IX Address of complex state data for an entity
  $EF28,$04 Set bit #N$05 of the current entity's flags byte 2.
  $EF2C,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EF49.

c $EF32 Script Routine: (#N$18) Start loop
@ $EF32 label=ScriptRoutine_StartLoop
D $EF32 Start a simple script loop for the current entity.
R $EF32 IX Address of complex state data for an entity
  $EF32,$04 Reset bit #N$04 of the current entity's flags byte 3.
  $EF36,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $EF3A,$04 Reset bit #N$05 of the referenced entity's flags byte 1.
  $EF3E,$03 Load #REGa with the referenced entity's entity type.
  $EF41,$04 Is the referenced entity's entity type zero? If so, jump to #R$EC2E
. to run the next script instruction.
  $EF45,$04 Set bit #N$07 of the referenced entity's flags byte 1.
N $EF49 Raise bit #N$00 of the game event flags at #R$72B3, then continue the
. script.
@ $EF49 label=Script_Shared_SetEventBit
  $EF49,$03 Load #REGa with the game event flags (#R$72B3).
  $EF4C,$02 Set bit #N$00 of #REGa.
  $EF4E,$03 Set the game event flags (#R$72B3).
  $EF51,$03 Jump to #R$EC2E to run the next script instruction.

c $EF54 Script Routine: (#N$0A) Reset entity direction flags
@ $EF54 label=ScriptRoutine_ResetDirectionFlags
D $EF54 Clear the entity's facing / direction flags.
R $EF54 IX Address of complex state data for an entity
  $EF54,$04 Write #N$00 to the current entity's direction / state.
  $EF58,$03 Jump to #R$EC2E to run the next script instruction.

c $EF5B Script Routine: (#N$0B) Set entity facing right
@ $EF5B label=ScriptRoutine_FaceRight
D $EF5B Face the entity right for the next script beats.
R $EF5B IX Address of complex state data for an entity
  $EF5B,$04 Write #N$02 to the current entity's direction / state.
  $EF5F,$03 Jump to #R$EC2E to run the next script instruction.

c $EF62 Script Routine: (#N$0C) Set entity facing left
@ $EF62 label=ScriptRoutine_FaceLeft
D $EF62 Face the entity left for the next script beats.
R $EF62 IX Address of complex state data for an entity
  $EF62,$04 Write #N$01 to the current entity's direction / state.
  $EF66,$03 Jump to #R$EC2E to run the next script instruction.

c $EF69 Script Routine: (#N$0D) Set entity facing up
@ $EF69 label=ScriptRoutine_FaceUp
D $EF69 Face the entity up for the next script beats.
R $EF69 IX Address of complex state data for an entity
  $EF69,$04 Write #N$08 to the current entity's direction / state.
  $EF6D,$03 Jump to #R$EC2E to run the next script instruction.

c $EF70 Script Routine: (#N$0E) Set entity facing down
@ $EF70 label=ScriptRoutine_FaceDown
D $EF70 Face the entity down for the next script beats.
R $EF70 IX Address of complex state data for an entity
  $EF70,$04 Write #N$04 to the current entity's direction / state.
  $EF74,$03 Jump to #R$EC2E to run the next script instruction.

c $EF77 Script: Jump If Carrying
@ $EF77 label=ScriptRoutine_JumpIfCarrying
D $EF77 If bit #N$04 of flags byte 3 is set, jump to the script address that
. follows; otherwise skip it.
R $EF77 IX Address of complex state data for an entity
  $EF77,$02 Advance #REGhl past the current script instruction.
  $EF79,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If so, jump to
. #R$EF84.
  $EF7F,$03 Jump to #R$EC2E to run the next script instruction.

c $EF82 Script: Load Script Pointer
@ $EF82 label=ScriptRoutine_JumpToAddress
D $EF82 Replace the entity's script cursor with the absolute address that
. follows, so it continues from that fragment.
E $EF82 View the equivalent code in;
. #LIST
. { #FLUNKY$9E51 }
. LIST#
  $EF82,$02 Advance #REGhl past the current script instruction.
N $EF84 Redirect the script pointer to the operand address and execute it at
. #R$EC30.
@ $EF84 label=ScriptRoutine_JumpToAddress_FetchAddress
  $EF84,$01 Fetch the low byte of the new script address.
  $EF85,$01 Advance the script pointer by one byte.
  $EF86,$01 Fetch the high byte of the new script address.
  $EF87,$02 Load #REGhl with the new script address (using the stack).
  $EF89,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.

c $EF8C Script Routine: (#N$02) Move entity left one character
@ $EF8C label=ScriptRoutine_MoveLeft
D $EF8C Shift the current entity one character left.
R $EF8C IX Address of complex state data for an entity
E $EF8C View the equivalent code in;
. #LIST
. { #FLUNKY$9EB8 }
. LIST#
  $EF8C,$06 Move this entity one character left.
  $EF92,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EFA5.
  $EF98,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $EF9C,$06 Move the referenced entity one character left.
  $EFA2,$03 Jump to #R$EC2E to run the next script instruction.
N $EFA5 If the entity is locked to a linked partner (bit #N$03), scan collisions
. with code #N$82.
@ $EFA5 label=Script_MoveLeft_TestBit3
  $EFA5,$07 Is bit #N$03 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $EFAC,$02 Load #REGa with #N$82.
  $EFAE,$02 Jump to #R$EFD3 to continue this routine.
  $EFB0,$01 No operation.

b $EFB0 Script Push Direction Flag
@ $EFB0 label=Flag_ScriptPushDirection
D $EFB0 Direction / state scratch byte for script push helpers. Written by
. #R$EFD3 and read by #R$EFED.
  $EFB0,$01

c $EFB1 Script Routine: (#N$03) Move entity right one character
@ $EFB1 label=ScriptRoutine_MoveRight
D $EFB1 Shift the current entity one character right.
R $EFB1 IX Address of complex state data for an entity
E $EFB1 View the equivalent code in;
. #LIST
. { #FLUNKY$9ED2 }
. LIST#
  $EFB1,$06 Move this entity one character right.
  $EFB7,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EFCA.
  $EFBD,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $EFC1,$06 Move the referenced entity one character right.
  $EFC7,$03 Jump to #R$EC2E to run the next script instruction.
N $EFCA If the entity is locked to a linked partner (bit #N$03), scan collisions
. with code #N$81.
@ $EFCA label=Script_MoveRight_TestBit3
  $EFCA,$07 Is bit #N$03 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $EFD1,$02 Load #REGa with #N$81.
N $EFD3 Remember the push direction in #R$EFB0 and walk complex entities for a
. type-#N$32 hitch.
@ $EFD3 label=Script_MoveHorizontal_ScanCollisions
  $EFD3,$03 Set #R$EFB0.
  $EFD6,$03 Stash #REGix and #REGde on the stack.
  $EFD9,$03 Load #REGde with #N($000E,$04,$04).
  $EFDC,$04 Point #REGix at Boney's complex entity state (#R$8EE9).
N $EFE0 Scan complex entities; stop when type #N$32 is reached.
@ $EFE0 label=Script_PushHitch_ScanSceneryBlock
  $EFE0,$03 Fetch the current entity's type for the type test.
  $EFE3,$04 Is #REGa equal to #N$32? If not, jump to #R$EFED.
  $EFE7,$03 Restore #REGde and #REGix from the stack.
  $EFEA,$03 Jump to #R$EC2E to run the next script instruction.
N $EFED On a matching push-direction hitch, shove it left or right and play the
. movement click.
@ $EFED label=Script_PushHitch_Shove
  $EFED,$03 Load #REGa from #R$EFB0.
  $EFF0,$05 Does #REGa match this entity's direction/state? If not, jump to
. #R$F010.
  $EFF5,$04 Write #N$00 to the current entity's direction / state.
  $EFF9,$04 Is #REGa equal to #N$82? If so, jump to #R$F005.
  $EFFD,$06 Move this entity one character right.
  $F003,$02 Jump to #R$F00B to continue this routine.
N $F005 Shove the hitch one character left (push-left path).
@ $F005 label=Script_PushHitch_ShoveLeft
  $F005,$06 Move this entity one character left.
N $F00B #HTML(#AUDIO0(movement.wav)(#INCLUDE(Movement)))
@ $F00B label=Script_PushHitch_Click
  $F00B,$02 Load #REGa with #N$10.
  $F00D,$03 Call #R$F8F9 to queue a sound effect.
N $F010 Advance to the next complex entity in the horizontal-push scan.
@ $F010 label=Script_PushHitch_NextEntity
  $F010,$02 #REGix+=#REGde.
  $F012,$02 Jump to #R$EFE0 to continue this routine.

c $F014 Script Routine: (#N$04) Move entity up one character
@ $F014 label=ScriptRoutine_MoveUp
D $F014 Shift the current entity one character up.
R $F014 IX Address of complex state data for an entity
  $F014,$03 Load #REGa with the current entity's y-extent.
  $F017,$04 Is #REGa equal to #N$1B? If not, jump to #R$F021.
  $F01B,$03 Point #REGhl at Berk's left-facing idle script (#R$B9A5(#N$B9CD)).
  $F01E,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $F021 Past the ceiling band: optionally step back one room, then move up.
@ $F021 label=ScriptRoutine_MoveUp_AfterCeilingExit
  $F021,$03 Load #REGa with the current entity's room index.
  $F024,$04 Is #REGa equal to #N$00? If so, jump to #R$F02B.
  $F028,$03 Move this entity back one room.
N $F02B Move the entity (and any carried partner) one character up.
@ $F02B label=ScriptRoutine_MoveUp_DecY
  $F02B,$06 Move this entity one character up.
  $F031,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$F04B.
  $F037,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F03B,$04 Is #REGa equal to #N$00? If so, jump to #R$F042.
  $F03F,$03 Decrease the referenced entity's room index.
N $F042 Move the carried entity one character up to match Berk.
@ $F042 label=ScriptRoutine_MoveUp_DecHeldY
  $F042,$06 Move the referenced entity one character up.
  $F048,$03 Jump to #R$EC2E to run the next script instruction.
N $F04B If a linked camera-follow partner is locked (bit #N$03), clear the lock
. and lift it too.
@ $F04B label=ScriptRoutine_MoveUp_CheckHoldingLock
  $F04B,$07 Is bit #N$03 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $F052,$04 Reset bit #N$03 of the current entity's flags byte 3.
  $F056,$04 Load #REGiy from the camera-follow entity's extra-state pointer
. (#R$8EF3(#N$90A7) = #R$909B+#N$0C).
  $F05A,$04 Is #REGa equal to #N$00? If so, jump to #R$F061.
  $F05E,$03 Decrease the referenced entity's room index.
N $F061 Move the linked partner one character up, then clear its pointer and
. thud.
@ $F061 label=ScriptRoutine_MoveUp_DecLinkedY
  $F061,$06 Move the referenced entity one character up.
  $F067,$02 Jump to #R$F0B8 to continue this routine.

c $F069 Script Routine: (#N$05) Move entity down one character
@ $F069 label=ScriptRoutine_MoveDown
D $F069 Shift the current entity one character down.
R $F069 IX Address of complex state data for an entity
  $F069,$03 Load #REGa with the current entity's room index.
  $F06C,$04 Is #REGa equal to #N$04? If not, jump to #R$F076.
  $F070,$03 Point #REGhl at Berk's right-facing idle script (#R$B9AD).
  $F073,$03 Jump to #R$EC30 to execute the script instruction at #REGhl.
N $F076 Past the floor band: optionally advance one room, then move down.
@ $F076 label=ScriptRoutine_MoveDown_AfterFloorExit
  $F076,$03 Load #REGa with the current entity's y-extent.
  $F079,$04 Is #REGa less than #N$23? If so, jump to #R$F080.
  $F07D,$03 Advance this entity into the next room.
N $F080 Move the entity (and any carried partner) one character down.
@ $F080 label=ScriptRoutine_MoveDown_IncY
  $F080,$06 Move this entity one character down.
  $F086,$06 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$F0A0.
  $F08C,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F090,$04 Is #REGa less than #N$23? If so, jump to #R$F097.
  $F094,$03 Increment the referenced entity's room index.
N $F097 Move the carried entity one character down to match Berk.
@ $F097 label=ScriptRoutine_MoveDown_IncHeldY
  $F097,$06 Move the referenced entity one character down.
  $F09D,$03 Jump to #R$EC2E to run the next script instruction.
N $F0A0 If a linked camera-follow partner is locked (bit #N$03), clear the lock
. and drop it too.
@ $F0A0 label=ScriptRoutine_MoveDown_CheckHoldingLock
  $F0A0,$07 Is bit #N$03 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $F0A7,$04 Reset bit #N$03 of the current entity's flags byte 3.
  $F0AB,$04 Load #REGiy from the camera-follow entity's extra-state pointer
. (#R$8EF3(#N$90A7) = #R$909B+#N$0C).
  $F0AF,$06 Move the referenced entity one character down.
  $F0B5,$03 Increment the referenced entity's room index.
N $F0B8 Clear the linked-entity pointer at #R$8EF3(#N$90A7) and queue movement
. sound #N$10.
@ $F0B8 label=ScriptRoutine_Move_ClearLinkedAndThud
  $F0B8,$03 Clear #REGbc ready to wipe the linked-entity pointer.
  $F0BB,$04 Clear the camera-follow entity's extra-state pointer at
. #R$8EF3(#N$90A7).
N $F0BF #HTML(#AUDIO0(movement.wav)(#INCLUDE(Movement)))
  $F0BF,$02 Load #REGa with #N$10.
  $F0C1,$03 Call #R$F8F9 to queue a sound effect.
  $F0C4,$03 Jump to #R$EC2E to run the next script instruction.

c $F0C7 Script Routine: (#N$06) Move entity left two characters
@ $F0C7 label=ScriptRoutine_MoveLeftTwo
D $F0C7 Shift the current entity two characters left.
R $F0C7 IX Address of complex state data for an entity
  $F0C7,$04 Set bit #N$01 of the current entity's flags byte 3.
  $F0CB,$03 Jump to #R$EC2E to run the next script instruction.

c $F0CE Script Routine: (#N$07) Move entity right two characters
@ $F0CE label=ScriptRoutine_MoveRightTwo
D $F0CE Shift the current entity two characters right.
R $F0CE IX Address of complex state data for an entity
  $F0CE,$04 Reset bit #N$01 of the current entity's flags byte 3.
  $F0D2,$03 Jump to #R$EC2E to run the next script instruction.

c $F0D5 Script Routine: (#N$09) Move entity down two characters
@ $F0D5 label=ScriptRoutine_MoveDownTwo
D $F0D5 Shift the current entity two characters down.
R $F0D5 IX Address of complex state data for an entity
  $F0D5,$04 Reset bit #N$00 of the current entity's flags byte 3.
  $F0D9,$03 Jump to #R$EC2E to run the next script instruction.

c $F0DC Script Routine: (#N$08) Move entity up two characters
@ $F0DC label=ScriptRoutine_MoveUpTwo
D $F0DC Shift the current entity two characters up.
R $F0DC IX Address of complex state data for an entity
  $F0DC,$04 Set bit #N$00 of the current entity's flags byte 3.
  $F0E0,$03 Jump to #R$EC2E to run the next script instruction.

c $F0E3 Script Routine: (#N$0F) Have entity put down carried entity
@ $F0E3 label=ScriptRoutine_PutDownCarried
D $F0E3 Make the entity put down whatever it is carrying.
R $F0E3 IX Address of complex state data for an entity
  $F0E3,$03 Call #R$F0F2 to script Put Down Set Carrying Flag.
  $F0E6,$03 Jump to #R$EC2E to run the next script instruction.
N $F0E9 Place the held entity using Berk's Y as the put-down baseline.
@ $F0E9 label=ScriptRoutine_PutDownCarried_PlaceHeldFromBerk
  $F0E9,$03 Load #REGc with the current entity's y-coordinate.
  $F0EC,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F0F0,$02 Jump to #R$F11C to continue this routine.
N $F0F2 Set bit #N$04 of flags byte 3 and prepare the held entity for
. put-down.
@ $F0F2 label=Script_PutDown_SetCarryingFlag
  $F0F2,$04 Set bit #N$04 of the current entity's flags byte 3.
  $F0F6,$03 Load #REGc with the current entity's y-coordinate.
  $F0F9,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F0FD,$03 Load #REGa with the referenced entity's entity type.
  $F100,$04 Is #REGa equal to #N$01? If not, jump to #R$F108.
  $F104,$01 Clear #REGa to #N$00.
  $F105,$03 Set the Bad Tempered Thing state (#R$72C7).
N $F108 Reactivate the held entity; if it is type #N($09), set Slimies in
. #R$72B6.
@ $F108 label=Script_PutDown_Apply
  $F108,$04 Reset bit #N$07 of the referenced entity's entity type.
  $F10C,$04 Is #REGa equal to #N$09? If not, jump to #R$F118.
  $F110,$03 Load #REGa with the task-three flags (#R$72B6).
  $F113,$02 Set Slimies (bit #N$01 of #REGa. put-down of type #N$09).
  $F115,$03 Set the task-three flags (#R$72B6).
N $F118 Set bit #N$05 on the held entity before writing its grounded Y.
@ $F118 label=ScriptRoutine_PutDownCarried_SetHeldBit5
  $F118,$04 Set bit #N$05 of the referenced entity's flags byte 1.
N $F11C Save held width/height into #R$72ED/#R$72EE and park the entity at the
. put-down Y.
@ $F11C label=ScriptRoutine_PutDownCarried_SaveSizeAndPlaceY
  $F11C,$03 Load #REGa with the referenced entity's x-extent.
  $F11F,$03 Subtract the referenced entity's x-coordinate from #REGa.
  $F122,$03 Store the held entity's width (x-extent − x) in #R$72ED.
  $F125,$03 Load #REGa with the referenced entity's y-extent.
  $F128,$03 Subtract the referenced entity's y-coordinate from #REGa.
  $F12B,$03 Store the held entity's height (y-extent − y) in #R$72EE.
  $F12E,$01 Keep a copy of #REGa in #REGb.
  $F12F,$02 Shift #REGa right logical.
  $F131,$02 Negate #REGa (flip a delta/direction).
  $F133,$01 #REGa+=#REGc.
  $F134,$02 #REGa+=#N$02.
  $F136,$03 Set the referenced entity's y-coordinate.
  $F139,$01 #REGa+=#REGb.
  $F13A,$03 Set the referenced entity's y-extent.
  $F13D,$01 Return.

c $F13E Script Routine: (#N$14) Have entity pick up / restore held entity state
@ $F13E label=ScriptRoutine_PickUpHeld
D $F13E Make the entity pick up / restore the held-entity state.
R $F13E IX Address of complex state data for an entity
  $F13E,$04 Reset bit #N$04 of the current entity's flags byte 3.
  $F142,$03 Load #REGa with the saved held-entity height from #R$72EE.
  $F145,$01 Keep the camera origin X in #REGc.
  $F146,$03 Load #REGa with the held-entity y-extent (#R$72E9).
  $F149,$03 Is the held-entity y-extent (#R$72E9) zero? If not, jump to #R$F150.
  $F14C,$03 Load #REGa with the current entity's y-extent.
  $F14F,$01 Decrease #REGa by one.
N $F150 Snap the held entity back under Berk using height #R$72EE and clear bit
. #N$05.
@ $F150 label=ScriptRoutine_PickUpHeld_ApplyHeldY
  $F150,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F154,$04 Reset bit #N$05 of the referenced entity's flags byte 1.
  $F158,$03 Set the referenced entity's y-extent.
  $F15B,$01 Subtract #REGc from #REGa.
  $F15C,$03 Set the referenced entity's y-coordinate.
  $F15F,$01 Clear #REGa to #N$00.
  $F160,$03 Set the held-entity y-extent (#R$72E9).
  $F163,$03 Jump to #R$EC2E to run the next script instruction.

c $F166 Script Routine: (#N$10) Have entity face left after putting down
@ $F166 label=ScriptRoutine_FaceLeftAfterPutDown
D $F166 After a put-down, face the entity left.
R $F166 IX Address of complex state data for an entity
  $F166,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $F16D,$03 Call #R$F183 to script Face After Put Down Apply.
  $F170,$01 Step the facing / put-down index on by one.
  $F171,$02 Jump to #R$F17D to script Routine 10 Apply Facing.

c $F173 Script Routine: (#N$11) Have entity face right after putting down
@ $F173 label=ScriptRoutine_FaceRightAfterPutDown
D $F173 After a put-down, face the entity right.
R $F173 IX Address of complex state data for an entity
  $F173,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $F17A,$03 Call #R$F183 to script Face After Put Down Apply.
N $F17D Write the held entity's room after facing, then continue the script.
@ $F17D label=ScriptRoutine_FaceLeftAfterPutDown_ApplyFacing
  $F17D,$03 Set the referenced entity's room index.
  $F180,$03 Jump to #R$EC2E to run the next script instruction.
N $F183 Aim the held entity's X at Berk's #R$7303 using the saved width in
. #R$72ED.
@ $F183 label=Script_FaceAfterPutDown_Apply
  $F183,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F187,$03 Load #REGa with the saved held-entity width from #R$72ED.
  $F18A,$02 Load #REGe with #N$01.
  $F18C,$01 Copy #REGa into #REGd as a saved coordinate / value.
  $F18D,$02 Shift #REGa right logical.
  $F18F,$02 Jump to #R$F192 to continue if the comparison did not match.
  $F191,$01 Advance the low byte of the pointer/offset in #REGde.
N $F192 Write the held entity's X and X-extent beside Berk after put-down
. facing.
@ $F192 label=ScriptRoutine_FaceRightAfterPutDown_WriteHeldX
  $F192,$03 Load #REGa with Berk's X-coordinate copy (#R$7303).
  $F195,$01 Add #REGe to #REGa.
  $F196,$03 Set the referenced entity's x-coordinate.
  $F199,$01 Add #REGd into #REGa while building a 16-bit entity/screen address.
  $F19A,$03 Set the referenced entity's x-extent.
  $F19D,$03 Load #REGa with the current entity's room index.
  $F1A0,$01 Return.

c $F1A1 Script Routine: (#N$12) Position put-down entity to the left
@ $F1A1 label=ScriptRoutine_PlacePutDownLeft
D $F1A1 Place the put-down entity to the carrier's left.
R $F1A1 IX Address of complex state data for an entity
  $F1A1,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $F1A8,$03 Load #REGa with the saved held-entity width from #R$72ED.
  $F1AB,$01 Copy #REGa into #REGd as a saved coordinate / value.
  $F1AC,$01 Step the put-down placement index on by one.
  $F1AD,$02 Shift #REGa right logical.
  $F1AF,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $F1B0,$01 Clear #REGa to #N$00.
  $F1B1,$01 Subtract #REGe from #REGa.
  $F1B2,$03 Add the entity byte at offset #N$07 to #REGa.
  $F1B5,$02 Jump to #R$F1CB to script Routine 12 Write Put Down.

c $F1B7 Script Routine: (#N$13) Position put-down entity to the right
@ $F1B7 label=ScriptRoutine_PlacePutDownRight
D $F1B7 Place the put-down entity to the carrier's right.
R $F1B7 IX Address of complex state data for an entity
  $F1B7,$07 Is bit #N$04 of flags byte 3 (#REGix+#N$03) set? If not, jump to
. #R$EC2E.
  $F1BE,$03 Load #REGa with the saved held-entity width from #R$72ED.
  $F1C1,$01 Copy #REGa into #REGd as a saved coordinate / value.
  $F1C2,$02 Shift #REGa right logical.
  $F1C4,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $F1C5,$02 Load #REGa with #N$04.
  $F1C7,$01 Subtract #REGe from #REGa.
  $F1C8,$03 Add the entity byte at offset #N$07 to #REGa.
N $F1CB Write the put-down entity's X, X-extent and room, then continue the
. script.
@ $F1CB label=ScriptRoutine_PlacePutDownLeft_WritePutDown
  $F1CB,$04 Load #REGiy with the current-entity pointer (#R$72AC).
  $F1CF,$03 Set the referenced entity's x-coordinate.
  $F1D2,$01 Add #REGd into #REGa while building a 16-bit entity/screen address.
  $F1D3,$03 Set the referenced entity's x-extent.
  $F1D6,$03 Load #REGa with the current entity's room index.
  $F1D9,$03 Set the referenced entity's room index.
  $F1DC,$03 Jump to #R$EC2E to run the next script instruction.

c $F1DF Script Routine: (#N$16) Start Drutt script
@ $F1DF label=ScriptRoutine_StartDruttScript
D $F1DF Hand control to Drutt's script for the trap door sequence.
  $F1DF,$04 Point #REGiy at the lever scenery entity (#R$8D8B).
  $F1E3,$08 Point the referenced entity's graphic layout at #R$A818.
  $F1EB,$05 Set the timed event latch.
  $F1F0,$03 Jump to #R$EC2E to run the next script instruction.

c $F1F3 Update Camera Follow
@ $F1F3 label=Update_CameraFollow
D $F1F3 Adjust the camera window at #R$72FB to follow the target entity.
N $F1F3 If the camera-follow delay is non-zero, tick it down; otherwise scroll
. the window toward the target.
  $F1F3,$03 Load #REGa with the camera-follow delay (#R$730A).
  $F1F6,$03 Is the camera-follow delay (#R$730A) zero? If so, jump to #R$F1FE.
  $F1F9,$01 Decrease #REGa by one.
  $F1FA,$03 Set the camera-follow delay (#R$730A).
  $F1FD,$01 Return.
N $F1FE Camera delay expired: point at the follow entity (#R$909B) and track it
. against #R$72FB.
@ $F1FE label=Update_CameraFollow_Active
  $F1FE,$04 Point #REGix at the camera-follow entity (#R$909B).
  $F202,$04 Load #REGde with the camera room-origin pointer (#R$72FB).
  $F206,$02 Load #REGb with loop count #N$20.
N $F208 Probe whether the follow entity sits inside the camera X window.
@ $F208 label=Update_CameraFollow_ProbeX
  $F208,$03 Load #REGa with the current entity's x-coordinate.
  $F20B,$02 #REGa+=#N$02.
  $F20D,$03 Is #REGa less than #REGe? If so, jump to #R$F230.
  $F210,$01 Keep #REGa in #REGc for the next calculation.
  $F211,$01 Copy #REGd into #REGa for later use.
  $F212,$03 Is #REGa less than #REGc? If so, jump to #R$F216.
  $F215,$01 Return.
N $F216 Scroll the camera origin right by #N$20 until the follow entity is
. centred.
@ $F216 label=Update_CameraFollow_ScrollRight
  $F216,$01 Copy the saved low byte from #REGe into #REGa.
  $F217,$04 Is #REGa equal to #N$A0? If so, jump to #R$F226.
  $F21B,$01 #REGa+=#REGb.
  $F21C,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $F21D,$01 Copy #REGa into #REGd as a saved coordinate / value.
  $F21E,$01 #REGa+=#REGb.
  $F21F,$01 Copy #REGa into #REGd as a saved coordinate / value.
  $F220,$04 Store #REGde in Pointer: Camera Room Origin (#R$72FB).
  $F224,$02 Jump to #R$F208 to continue the loop.
N $F226 Wrap the follow entity left by #N$A0 when the camera hits the right
. edge.
@ $F226 label=Update_CameraFollow_WrapLeft
  $F226,$03 Load #REGa with the current entity's x-coordinate.
  $F229,$02 #REGa-=#N$A0.
  $F22B,$03 Set the current entity's x-coordinate.
  $F22E,$02 Jump to #R$F248 to refresh the follow entity's x-extent.
N $F230 Scroll the camera origin left by #N$20 until the follow entity is
. centred.
@ $F230 label=Update_CameraFollow_ScrollLeft
  $F230,$01 Copy the saved low byte from #REGe into #REGa.
  $F231,$04 Is #REGa equal to #N$20? If so, jump to #R$F240.
  $F235,$01 Subtract #REGb from #REGa.
  $F236,$01 Copy #REGa into #REGe as a saved coordinate / value.
  $F237,$01 Copy #REGd into #REGa for later use.
  $F238,$01 Subtract #REGb from #REGa.
  $F239,$01 Copy #REGa into #REGd as a saved coordinate / value.
  $F23A,$04 Store #REGde in Pointer: Camera Room Origin (#R$72FB).
  $F23E,$02 Jump to #R$F208 to continue the loop.
N $F240 Wrap the follow entity right by #N$A0 when the camera hits the left
. edge.
@ $F240 label=Update_CameraFollow_WrapRight
  $F240,$03 Load #REGa with the current entity's x-coordinate.
  $F243,$02 #REGa+=#N$A0.
  $F245,$03 Set the current entity's x-coordinate.
N $F248 Refresh the follow entity's X-extent after a wrap and keep probing.
@ $F248 label=Update_CameraFollow_AdjustXExtent
  $F248,$02 #REGa+=#N$05.
  $F24A,$03 Set the current entity's x-extent.
  $F24D,$02 Jump to #R$F208 to continue the loop.

c $F24F Script Routine: (#N$19) Continue To Next Instruction
@ $F24F label=ScriptRoutine_ContinueToNextInstruction
D $F24F No-op handler: advance the script pointer and execute the next
. instruction.
  $F24F,$03 Jump to #R$EC2E to run the next script instruction.


c $F252 Clamp Camera Position
@ $F252 label=Clamp_CameraPosition
D $F252 Clamp the camera position.
  $F252,$02 Load #REGc with #N$00.
  $F254,$02 Stash #REGhl and #REGde on the stack.
  $F256,$03 Point #REGhl at the task-three helper entity (#R$90A9).
  $F259,$02 Jump to #R$F266 to continue scanning.

c $F25B Adjust Camera X
@ $F25B label=Adjust_CameraX
D $F25B Adjust the camera x-coordinate.
  $F25B,$02 Load #REGc with #N$01.
  $F25D,$02 Jump to #R$F261 to adjust Camera Common.

c $F25F Adjust Camera Y
@ $F25F label=Adjust_CameraY
D $F25F Adjust the camera y-coordinate.
  $F25F,$02 Load #REGc with #N$00.
N $F261 Shared camera adjust: scan entities backward from the weight-chain
. slot.
@ $F261 label=Adjust_Camera_Common
  $F261,$02 Stash #REGhl and #REGde on the stack.
  $F263,$03 Point #REGhl at the weight-chain entity (#R$908D).
N $F266 Walk entity records with stride $FFF2 looking for a camera blocker.
@ $F266 label=Adjust_Camera_ScanEntities
  $F266,$03 Load #REGde with $FFF2.
N $F269 Stop with carry set when the entity-table terminator (#N$FF) is reached.
@ $F269 label=Adjust_Camera_ScanLoop
  $F269,$01 Fetch this entity's type.
  $F26A,$04 Is #REGa equal to #N$FF? If not, jump to #R$F272.
  $F26E,$02 Restore #REGde and #REGhl from the stack.
  $F270,$01 Signal success.
  $F271,$01 Return.
N $F272 Test whether this solid, same-room entity overlaps the camera subject.
@ $F272 label=Adjust_Camera_CheckEntity
  $F272,$01 Re-fetch this entity's type.
  $F273,$03 Is the next script byte zero? If so, jump to #R$F2BA.
  $F276,$04 Is bit #N$07 of #REGa set? If so, jump to #R$F2BA.
  $F27A,$05 Does #REGa match this entity's type? If so, jump to #R$F2BA.
  $F27F,$01 Stash #REGhl on the stack.
  $F280,$01 Advance the camera-table pointer in #REGhl by one byte.
  $F281,$01 Fetch this entity's flags byte.
  $F282,$02,b$01 Keep only bit #N$01 of those flags.
  $F284,$02 If it was clear, skip this entity at #R$F2B9.
  $F286,$04 Is bit #N$05 of the byte at #REGhl set? If so, jump to #R$F2B9.
  $F28A,$03 Advance #REGhl past three entity fields onto the room byte.
  $F28D,$01 Fetch this entity's room.
  $F28E,$01 #REGa+=#REGc.
  $F28F,$05 Does #REGa match this entity's room? If not, jump to #R$F2B9.
  $F294,$01 Advance the camera-table pointer in #REGhl by one byte.
  $F295,$03 Load #REGa with the current entity's y-extent.
  $F298,$03 Is #REGa less than the byte at #REGhl? If so, jump to #R$F2B9.
  $F29B,$01 Advance the camera-table pointer in #REGhl by one byte.
  $F29C,$01 Fetch the next script byte.
  $F29D,$05 Is #REGa less than this entity's y-coordinate? If so, jump to
. #R$F2B9.
  $F2A2,$01 Advance the camera-table pointer in #REGhl by one byte.
  $F2A3,$03 Load #REGa with the current entity's x-extent.
  $F2A6,$03 Is #REGa less than the byte at #REGhl? If so, jump to #R$F2B9.
  $F2A9,$01 Advance the camera-table pointer in #REGhl by one byte.
  $F2AA,$01 Fetch the next script byte.
  $F2AB,$05 Is #REGa less than this entity's x-coordinate? If so, jump to
. #R$F2B9.
  $F2B0,$01 Restore #REGhl from the stack.
  $F2B1,$01 Clear #REGa to #N$00.
  $F2B2,$03 Store #REGhl in the last-collided entity pointer (#R$72AA).
  $F2B5,$01 Fetch the next script byte.
  $F2B6,$02 Restore #REGde and #REGhl from the stack.
  $F2B8,$01 Return.
N $F2B9 Skip a non-blocking camera entity and keep scanning.
@ $F2B9 label=Adjust_Camera_SkipEntity
  $F2B9,$01 Restore #REGhl from the stack.
N $F2BA Step to the previous entity record and continue the camera scan.
@ $F2BA label=Adjust_Camera_NextEntity
  $F2BA,$01 #REGhl+=#REGde.
  $F2BB,$02 Jump to #R$F269 to continue the loop.

c $F2BD Test Entity Overlap (Allow Special)
@ $F2BD label=Test_EntityOverlap_AllowSpecial
D $F2BD Find a simple entity at #R$8B69 whose bounds overlap #REGix, allowing
. entities with bit #N$05 set. On a hit, clear the miss marker, store the
. entity pointer at #R$72AA and return its type in #REGa; on a miss, set carry.
R $F2BD IX Address of complex state data for the subject entity
  $F2BD,$03 Load #REGbc with #N($0100,$04,$04) (allow bit #N($05), then same
. room).
  $F2C0,$02 Jump to #R$F2CA to scan with the allow-special mask.

c $F2C2 Test Entity Overlap
@ $F2C2 label=Test_EntityOverlap
D $F2C2 Find a simple entity at #R$8B69 whose bounds overlap #REGix, ignoring
. entities with bit #N$05 set. Used for trap offers, put-downs and falls. On a
. hit, clear carry and store the entity at #R$72AA; on a miss, set carry.
R $F2C2 IX Address of complex state data for the subject entity
  $F2C2,$03 Load #REGbc with #N($0000,$04,$04) (reject bit #N($05), then same
. room).
  $F2C5,$02 Jump to #R$F2CA to scan with the standard mask.

c $F2C7 Test Entity Overlap At Depth
@ $F2C7 label=Test_EntityOverlap_AtDepth
D $F2C7 As #R$F2C2, but match entities whose room is one deeper than #REGix
. (room−#N$01). Used when Berk moves forward into the next depth band.
R $F2C7 IX Address of complex state data for the subject entity
  $F2C7,$03 Load #REGbc with #N($0001,$04,$04) (reject bit #N($05), then
. room−#N$01).
N $F2CA Walk the simple-entity table for a collidable overlap with #REGix.
@ $F2CA label=Test_EntityOverlap_Scan
  $F2CA,$02 Stash #REGhl and #REGde on the stack.
  $F2CC,$03 Each entity record is #N($000E,$04,$04) bytes, then load that into
. #REGde.
  $F2CF,$03 Point #REGhl at the simple entity table (#R$8B69).
N $F2D2 Next simple-entity slot for the overlap test (or miss on #N$FF).
@ $F2D2 label=Test_EntityOverlap_ScanSlot
  $F2D2,$05 Fetch this entity's type. Is it the table terminator (#N$FF)? If
. not, test the slot at #R$F2DB.
N $F2D7 Simple-entity scan miss: restore registers and return carry set.
  $F2D7,$02 Restore #REGde and #REGhl from the stack.
  $F2D9,$01 Signal a miss.
  $F2DA,$01 Return.
N $F2DB Reject empty/inactive/same-type slots; require collidable bit #N$00 (and
. optional bit #N$05).
@ $F2DB label=Test_EntityOverlap_CheckSlot
  $F2DB,$04 Re-fetch the type. Is the slot empty (type #N$00)? If so, skip to
. #R$F327.
  $F2DF,$04 Is the high bit set (inactive)? If so, skip to #R$F327.
  $F2E3,$05 Is it the same type as the subject? If so, skip to #R$F327.
  $F2E8,$01 Stash #REGhl on the stack.
  $F2E9,$01 Advance onto flags byte 1.
  $F2EA,$01 Fetch flags byte 1.
  $F2EB,$02,b$01 Keep only the collidable bit (bit #N$00).
  $F2ED,$02 If it was clear, reject at #R$F326.
  $F2EF,$04 Has the caller allowed bit-#N$05 entities (#REGb bit #N$00)? If so,
. skip the bit-#N$05 reject at #R$F2F7.
  $F2F3,$04 Is bit #N$05 set on this entity? If so, reject at #R$F326.
N $F2F7 Require matching room (minus #REGc) and overlapping y/x extents with
. #REGix.
@ $F2F7 label=Test_EntityOverlap_CheckBounds
  $F2F7,$03 Advance #REGhl past the unused entity fields onto the room byte.
  $F2FA,$01 Fetch the entity's room.
  $F2FB,$01 Subtract the caller's room bias in #REGc.
  $F2FC,$05 Does it match the subject's room (#REGix+#N$04)? If not, jump to
. #R$F326.
  $F301,$01 Advance onto the entity's y-coordinate.
  $F302,$06 Does the subject's y-extent (#REGix+#N$06) reach this candidate y?
. If not, reject at #R$F326.
  $F308,$01 Advance onto the entity's y-extent.
  $F309,$06 Does this candidate y-extent reach the subject's y (#REGix+#N$05)?
. If not, reject at #R$F326.
  $F30F,$01 Advance onto the entity's x-coordinate.
  $F310,$06 Does the subject's x-extent (#REGix+#N$08) reach this candidate x?
. If not, reject at #R$F326.
  $F316,$01 Advance onto the entity's x-extent.
  $F317,$06 Does this candidate x-extent reach the subject's x (#REGix+#N$07)?
. If not, reject at #R$F326.
N $F31D Hit: remember the entity and return its type with carry clear.
  $F31D,$01 Restore #REGhl from the stack.
  $F31E,$01 Clear #REGa / carry.
  $F31F,$03 Store the entity pointer at #R$72AA.
  $F322,$01 Fetch the entity's type into #REGa.
  $F323,$02 Restore #REGde and #REGhl from the stack.
  $F325,$01 Return.
N $F326 Reject this overlap candidate and continue the simple-entity walk.
@ $F326 label=Test_EntityOverlap_Reject
  $F326,$01 Restore #REGhl from the stack.
N $F327 Advance to the next simple-entity record in the overlap scan.
@ $F327 label=Test_EntityOverlap_AdvanceSlot
  $F327,$01 Advance #REGhl by one entity record.
  $F328,$02 Jump to #R$F2D2 to test the next simple entity.

c $F32A Test Entity On Left
@ $F32A label=Test_EntityOnLeft
D $F32A Find a solid simple entity immediately to the left of #REGix (for a
. leftward step). On a hit, store it at #R$72AA and clear carry; on a miss, set
. carry.
R $F32A IX Address of complex state data for the subject entity
  $F32A,$02 Load #REGc with #N$00 (same-room / left bias).
  $F32C,$02 Jump to #R$F330 to scan for a solid entity on the left.

c $F32E Test Entity On Right
@ $F32E label=Test_EntityOnRight
D $F32E Find a solid simple entity immediately to the right of #REGix (for a
. rightward step). On a hit, store it at #R$72AA and clear carry; on a miss, set
. carry.
R $F32E IX Address of complex state data for the subject entity
  $F32E,$02 Load #REGc with #N$01 (room−#N$01 / right bias).
N $F330 Walk #R$8B69 for a solid (bit #N$02) entity abutting #REGix
. horizontally.
@ $F330 label=Test_EntityHorizontal_Scan
  $F330,$02 Stash #REGhl and #REGde on the stack.
  $F332,$03 Each entity record is #N($000E,$04,$04) bytes, then load that into
. #REGde.
  $F335,$03 Point #REGhl at the simple entity table (#R$8B69).
N $F338 Next simple-entity slot for the horizontal abut test (or miss on #N$FF).
@ $F338 label=Test_EntityHorizontal_ScanSlot
  $F338,$05 Fetch this entity's type. Is it the table terminator (#N$FF)? If
. not, test the slot at #R$F341.
  $F33D,$02 Restore #REGde and #REGhl from the stack.
  $F33F,$01 Signal a miss.
  $F340,$01 Return.
N $F341 Require a solid (bit #N$02) neighbour; skip room check for type #N$33.
@ $F341 label=Test_EntityHorizontal_CheckSlot
  $F341,$04 Re-fetch the type. Is the slot empty? If so, skip to #R$F38A.
  $F345,$04 Is the high bit set (inactive)? If so, skip to #R$F38A.
  $F349,$05 Is it the same type as the subject? If so, skip to #R$F38A.
  $F34E,$01 Keep the type in #REGb.
  $F34F,$01 Stash #REGhl on the stack.
  $F350,$01 Advance onto flags byte 1.
  $F351,$01 Fetch the flags.
  $F352,$02,b$01 Keep only the solid/platform bit (bit #N$02).
  $F354,$02 If it was clear, reject at #R$F389.
  $F356,$04 Is bit #N$05 set? If so, reject at #R$F389.
  $F35A,$03 Advance past the room/y/y-extent fields onto the room-check byte.
  $F35D,$03 Keep the candidate type in #REGa. Is it type #N$33 (skip room
. check)?.
  $F360,$02 If so, take the bounds check at #R$F369.
  $F362,$07 Fetch the entity's room. Subtract the caller's room bias in #REGc.
. Does it match the subject's room? If not, reject at #R$F389.
N $F369 Confirm vertical overlap and X-extent abutment with the subject.
@ $F369 label=Test_EntityHorizontal_CheckBounds
  $F369,$01 Advance onto the entity's y-coordinate.
  $F36A,$06 Does the subject's y-extent (#REGix+#N$06) reach this candidate y?
. If not, reject at #R$F389.
  $F370,$01 Advance onto the entity's y-extent.
  $F371,$06 Does this candidate y-extent reach the subject's y (#REGix+#N$05)?
. If not, reject at #R$F389.
  $F377,$02 Advance #REGhl past the x-coordinate onto the entity's x-extent.
  $F379,$03 Fetch the subject's x (#REGix+#N$07).
  $F37C,$01 Step it left by one.
  $F37D,$03 Does it equal this entity's x-extent (abutting on the left/right)?
. If not, jump to #R$F389.
N $F380 Horizontal neighbour hits: store the entity at #R$72AA and return its
. type.
  $F380,$01 Restore #REGhl from the stack.
  $F381,$03 Store it at #R$72AA.
  $F384,$01 Clear carry.
  $F385,$01 Fetch the entity's type into #REGa.
  $F386,$02 Restore #REGde and #REGhl from the stack.
  $F388,$01 Return.
N $F389 Reject this horizontal neighbour and continue the simple-entity walk.
@ $F389 label=Test_EntityHorizontal_Reject
  $F389,$01 Restore #REGhl from the stack.
N $F38A Advance to the next simple-entity record in the horizontal scan.
@ $F38A label=Test_EntityHorizontal_AdvanceSlot
  $F38A,$01 Advance #REGhl by one entity record.
  $F38B,$02 Jump to #R$F338 to test the next horizontal neighbour.

c $F38D Test Entity Above
@ $F38D label=Test_EntityAbove
D $F38D Find a solid simple entity immediately above #REGix (for an upward
. step). On a hit, store it at #R$72AA and clear carry; on a miss, set carry.
R $F38D IX Address of complex state data for the subject entity
  $F38D,$02 Load #REGc with #N$00 (same-room / up bias).
  $F38F,$02 Jump to #R$F393 to scan for a solid entity above.

c $F391 Test Entity Below
@ $F391 label=Test_EntityBelow
D $F391 Find a solid simple entity immediately below #REGix (for a downward
. step). On a hit, store it at #R$72AA and clear carry; on a miss, set carry.
R $F391 IX Address of complex state data for the subject entity
  $F391,$02 Load #REGc with #N$01 (room−#N$01 / down bias).
N $F393 Walk #R$8B69 for a solid entity abutting #REGix vertically.
@ $F393 label=Test_EntityVertical_Scan
  $F393,$02 Stash #REGhl and #REGde on the stack.
  $F395,$03 Each entity record is #N($000E,$04,$04) bytes, then load that into
. #REGde.
  $F398,$03 Point #REGhl at the simple entity table (#R$8B69).
N $F39B Next simple-entity slot for the vertical abut test (or miss on #N$FF).
@ $F39B label=Test_EntityVertical_ScanSlot
  $F39B,$05 Fetch this entity's type. Is it the table terminator (#N$FF)? If
. not, test the slot at #R$F3A4.
  $F3A0,$02 Restore #REGde and #REGhl from the stack.
  $F3A2,$01 Signal a miss.
  $F3A3,$01 Return.
N $F3A4 Require a solid (bit #N$02) neighbour; skip room check for type #N$33.
@ $F3A4 label=Test_EntityVertical_CheckSlot
  $F3A4,$04 Re-fetch the type. Is the slot empty? If so, skip to #R$F3EC.
  $F3A8,$04 Is the high bit set (inactive)? If so, skip to #R$F3EC.
  $F3AC,$05 Is it the same type as the subject? If so, skip to #R$F3EC.
  $F3B1,$01 Keep the type in #REGb.
  $F3B2,$01 Stash #REGhl on the stack.
  $F3B3,$01 Advance onto flags byte 1.
  $F3B4,$01 Fetch the flags.
  $F3B5,$02,b$01 Keep only the solid/platform bit (bit #N$02).
  $F3B7,$02 If it was clear, reject at #R$F3EB.
  $F3B9,$04 Is bit #N$05 set? If so, reject at #R$F3EB.
  $F3BD,$03 Advance past the room/y/y-extent fields onto the room-check byte.
  $F3C0,$03 Keep the candidate type in #REGa. Is it type #N$33 (skip room
. check)?.
  $F3C3,$02 If so, take the bounds check at #R$F3CC.
  $F3C5,$07 Fetch the entity's room. Subtract the caller's room bias in #REGc.
. Does it match the subject's room? If not, reject at #R$F3EB.
N $F3CC Confirm horizontal overlap and Y abutment with the subject.
@ $F3CC label=Test_EntityVertical_CheckBounds
  $F3CC,$01 Advance onto the entity's y-coordinate.
  $F3CD,$06 Does the subject's y-extent (#REGix+#N$06) reach this candidate y?
. If not, reject at #R$F3EB.
  $F3D3,$01 Advance onto the entity's y-extent.
  $F3D4,$06 Does this candidate y-extent reach the subject's y (#REGix+#N$05)?
. If not, reject at #R$F3EB.
  $F3DA,$01 Advance onto the entity's x-coordinate.
  $F3DB,$07 Fetch the subject's x-extent (#REGix+#N$08). Step it right by one.
. Does it equal this entity's x (abutting above/below)? If not, reject at
. #R$F3EB.
N $F3E2 Vertical neighbour hits: store the entity at #R$72AA and return its
. type.
  $F3E2,$01 Restore #REGhl from the stack.
  $F3E3,$03 Store it at #R$72AA.
  $F3E6,$01 Clear carry.
  $F3E7,$01 Fetch the entity's type into #REGa.
  $F3E8,$02 Restore #REGde and #REGhl from the stack.
  $F3EA,$01 Return.
N $F3EB Reject this vertical neighbour and continue the simple-entity walk.
@ $F3EB label=Test_EntityVertical_Reject
  $F3EB,$01 Restore #REGhl from the stack.
N $F3EC Advance to the next simple-entity record in the vertical scan.
@ $F3EC label=Test_EntityVertical_AdvanceSlot
  $F3EC,$01 Advance #REGhl by one entity record.
  $F3ED,$02 Jump to #R$F39B to test the next vertical neighbour.

c $F3EF Display And Handle Main Menu
@ $F3EF label=MainMenu
D $F3EF Draw the title logo, print the controls/score stream via #R$F46B (which
. resumes at #R$F51D). When CONTINUE returns, clear again, colour-cycle the
. logo, print #R$F407 ("CHOOSE to be / LEARNER BERK / SUPER BERK"), then
. continue on to #R$F43D.
E $F3EF Continue on to #R$F43D.
N $F3EF #PUSHS #POKES$4000,$00,$1B00 #SIM(start=$F454,stop=$F46A)
. #SIM(start=$F6D6,stop=$F73F) #SIM(start=$F46B,stop=$F51D)
. #UDGTABLE { #SCR$02,$00,$00,$20,$18(main-menu) } UDGTABLE# #POPS
N $F3EF First pass: logo + controls menu (returns via #R$F51D / CONTINUE).
  $F3EF,$03 Call #R$F454 to clear the menu attribute block.
  $F3F2,$03 Call #R$F6D6 to draw the main-menu logo.
  $F3F5,$03 Call #R$F46B to print the controls/score stream and handle options.
N $F3F8 Second pass (after CONTINUE): refresh, colour-cycle, print the
. Learner/Super chooser.
@ $F3F8 label=MainMenu_ChoosePass
  $F3F8,$03 Call #R$F454 to clear the menu attribute block again.
  $F3FB,$03 Call #R$F70A to colour-cycle the logo.
  $F3FE,$06 Point #REGhl at #SKOOLKID$3D00(CHARSET)-#N$0100, then store it as
. the current character set.
  $F404,$03 Call #R$AD6F to print the inline chooser stream at #R$F407.

t $F407 Messaging: Main Menu
@ $F407 label=Messaging_MainMenu
D $F407 Menu printer stream for #R$AD6F. Fragment headers are three bytes
. (address low/high, attribute); #CHR$26 starts a new positioned fragment, and
. #CHR$5D terminates the stream. Renders as "CHOOSE to be / LEARNER BERK / SUPER
. BERK".
B $F407,$01 Attribute-file address low byte (#N$AA).
B $F408,$01 Attribute-file address high byte (#N$58).
B $F409,$01 Text attribute (#N$47).
  $F40A,$0C "#STR(#PC,$04,$0C)".
B $F416,$01 Join marker (#CHR$26).
B $F417,$01 Attribute-file address low byte (#N$4A).
B $F418,$01 Attribute-file address high byte (#N$59).
B $F419,$01 Text attribute (#N$7A).
  $F41A,$01 "#STR(#PC,$04,$01)".
B $F41B,$01 Join marker (#CHR$26).
B $F41C,$01 Attribute-file address low byte (#N$4B).
B $F41D,$01 Attribute-file address high byte (#N$59).
B $F41E,$01 Text attribute (#N$47).
  $F41F,$0B "#STR(#PC,$04,$0B)".
B $F42A,$01 Join marker (#CHR$26).
B $F42B,$01 Attribute-file address low byte (#N$AB).
B $F42C,$01 Attribute-file address high byte (#N$59).
B $F42D,$01 Text attribute (#N$78).
  $F42E,$01 "#STR(#PC,$04,$01)".
B $F42F,$01 Join marker (#CHR$26).
B $F430,$01 Attribute-file address low byte (#N$AC).
B $F431,$01 Attribute-file address high byte (#N$59).
B $F432,$01 Text attribute (#N$47).
  $F433,$09 "#STR(#PC,$04,$09)".
B $F43C,$01 Terminator (#CHR$5D).

; =============================================================================
; Controls + score printer streams for #R$AD6F ($F474–$F51C).
; #CHR$26 before SCORE is at $F4F8 (not $F4F9).
; =============================================================================

c $F43D Main Menu: Choose Learner Or Super Berk
@ $F43D label=MainMenu_ChooseLearnerOrSuper
D $F43D Wait for #CHR$53 (Super Berk, flag #N$00) or #CHR$4C (Learner Berk,
. flag #N$01) and store the choice at #R$72A9.
N $F43D Default to Super Berk (flag clear), then sample the keyboard.
  $F43D,$01 Clear #REGa ready to select Super Berk.
  $F43E,$03 Write #N$00 to the Learner Berk mode flag.
N $F441 Wait for S (Super Berk) or L (Learner Berk) and store the choice in
. #R$72A9.
@ $F441 label=MainMenu_ChooseLearnerOrSuper_KeyWait
  $F441,$03 Call #R$FC78 for one menu-music wait tick.
  $F444,$03 Call #R$F640 to read a key code.
  $F447,$03 Was #CHR$53 pressed? If so, keep Super Berk (flag #N$00) and return.
  $F44A,$04 Was #CHR$4C pressed? If not, keep waiting at #R$F441.
  $F44E,$02 Load #N$01 for Learner Berk.
  $F450,$03 Write it to the Learner Berk mode flag.
  $F453,$01 Return.

c $F454 Draw Menu Background
@ $F454 label=Draw_MenuBackground
D $F454 Black out the whole attribute file, then clear a #N$0E×#N$18 character
. window starting at #N$5809 (attribute buffer) for the main-menu / controls
. layout.
N $F454 Fill the attribute file, then clear the menu window.
  $F454,$04 Clear #REGa (black ink/paper), then call #R$EA6D to fill the
. attribute file.
  $F458,$03 Point #REGhl at the menu window top-left
. (#N$5809 (attribute buffer)).
  $F45B,$03 Load #REGde with the per-row skip (#N($0012,$04,$04) bytes).
  $F45E,$02 Load #REGc with #N$18 row counter.
N $F460 Clear one attribute row of the #N$0E×#N$18 menu window.
@ $F460 label=Draw_MenuBackground_RowLoop
  $F460,$02 Load #REGb with #N$0E column counter.
N $F462 Black out one attribute cell inside the menu window.
@ $F462 label=Draw_MenuBackground_ColLoop
  $F462,$04 Write black at #REGhl. Advance one character. Loop across the row.
  $F466,$01 Step #REGhl by the row skip in #REGde.
  $F467,$01 Decrease the row counter.
  $F468,$02 Jump to #R$F460 if more rows remain.
  $F46A,$01 Return.

c $F46B Print Controls Menu
@ $F46B label=Print_ControlsMenu
D $F46B Point the character set at #SKOOLKID$3D00(CHARSET)-#N$0100 and call
. #R$AD6F. The controls + score printer stream is inline at
. #R$F474–#R$F51C (ends with #CHR$5D) #R$AD6F resumes at #R$F51D.
  $F46B,$06 Point #REGhl at #SKOOLKID$3D00(CHARSET)-#N$0100, then store it as
. the current character set.
  $F471,$03 Call #R$AD6F to print the inline stream at #R$F474 (returns to
. #R$F51D).

t $F474 Messaging: Controls Menu
@ $F474 label=Messaging_ControlsMenu
D $F474 Controls / redefine-keys printer stream for #R$AD6F. Fragment headers
. are three bytes (attribute-file address low/high, then attribute); #CHR$26
. starts the next fragment. Options: KEYS, JOYSTICK, REDEFINE, CONTINUE;
. directions RIGHT / LEFT / DOWN / UP; actions DROP / TIP / HOLD. Score stream
. continues at #R$F4F8.
B $F474,$01 Attribute-file address low byte (#N$0B).
B $F475,$01 Attribute-file address high byte (#N$58).
B $F476,$01 Text attribute (#N$70).
  $F477,$0A "#STR(#PC,$04,$0A)".
B $F481,$01 Join marker (#CHR$26).
B $F482,$01 Attribute-file address low byte (#N$4B).
B $F483,$01 Attribute-file address high byte (#N$58).
B $F484,$01 Text attribute (#N$70).
  $F485,$0A "#STR(#PC,$04,$0A)".
B $F48F,$01 Join marker (#CHR$26).
B $F490,$01 Attribute-file address low byte (#N$8B).
B $F491,$01 Attribute-file address high byte (#N$58).
B $F492,$01 Text attribute (#N$70).
  $F493,$0A "#STR(#PC,$04,$0A)".
B $F49D,$01 Join marker (#CHR$26).
B $F49E,$01 Attribute-file address low byte (#N$CB).
B $F49F,$01 Attribute-file address high byte (#N$58).
B $F4A0,$01 Text attribute (#N$70).
  $F4A1,$0A "#STR(#PC,$04,$0A)".
B $F4AB,$01 Join marker (#CHR$26).
B $F4AC,$01 Attribute-file address low byte (#N$0D).
B $F4AD,$01 Attribute-file address high byte (#N$59).
B $F4AE,$01 Text attribute (#N$70).
  $F4AF,$07 "#STR(#PC,$04,$07)".
B $F4B6,$01 Join marker (#CHR$26).
B $F4B7,$01 Attribute-file address low byte (#N$4D).
B $F4B8,$01 Attribute-file address high byte (#N$59).
B $F4B9,$01 Text attribute (#N$70).
  $F4BA,$07 "#STR(#PC,$04,$07)".
B $F4C1,$01 Join marker (#CHR$26).
B $F4C2,$01 Attribute-file address low byte (#N$8D).
B $F4C3,$01 Attribute-file address high byte (#N$59).
B $F4C4,$01 Text attribute (#N$70).
  $F4C5,$07 "#STR(#PC,$04,$07)".
B $F4CC,$01 Join marker (#CHR$26).
B $F4CD,$01 Attribute-file address low byte (#N$CD).
B $F4CE,$01 Attribute-file address high byte (#N$59).
B $F4CF,$01 Text attribute (#N$70).
  $F4D0,$07 "#STR(#PC,$04,$07)".
B $F4D7,$01 Join marker (#CHR$26).
B $F4D8,$01 Attribute-file address low byte (#N$0D).
B $F4D9,$01 Attribute-file address high byte (#N$5A).
B $F4DA,$01 Text attribute (#N$70).
  $F4DB,$07 "#STR(#PC,$04,$07)".
B $F4E2,$01 Join marker (#CHR$26).
B $F4E3,$01 Attribute-file address low byte (#N$4D).
B $F4E4,$01 Attribute-file address high byte (#N$5A).
B $F4E5,$01 Text attribute (#N$70).
  $F4E6,$07 "#STR(#PC,$04,$07)".
B $F4ED,$01 Join marker (#CHR$26).
B $F4EE,$01 Attribute-file address low byte (#N$8D).
B $F4EF,$01 Attribute-file address high byte (#N$5A).
B $F4F0,$01 Text attribute (#N$70).
  $F4F1,$07 "#STR(#PC,$04,$07)".

t $F4F8 Messaging: Score / HiScore
@ $F4F8 label=Messaging_ScoreHiScore
D $F4F8 Score / Hi-score printer stream. Opens with #CHR$26 joining from the
. controls stream (at #R$F4F8), then SCORE / HiSCORE fragments; ends with
. #CHR$5D.
B $F4F8,$01 Join marker (#CHR$26).
B $F4F9,$01 Attribute-file address low byte (#N$C9).
B $F4FA,$01 Attribute-file address high byte (#N$5A).
B $F4FB,$01 Text attribute (#N$47).
  $F4FC,$0E "#STR(#PC,$04,$0E)".
B $F50A,$01 Join marker (#CHR$26).
B $F50B,$01 Attribute-file address low byte (#N$E9).
B $F50C,$01 Attribute-file address high byte (#N$5A).
B $F50D,$01 Text attribute (#N$47).
  $F50E,$0E "#STR(#PC,$04,$0E)".
B $F51C,$01 Terminator (#CHR$5D).

c $F51D Main Menu Select Options
@ $F51D label=MainMenu_SelectOptions
D $F51D Handle KEYS / JOYSTICK / REDEFINE / CONTINUE on the controls menu.
. Returns to the caller of #R$F46B (the Learner/Super pass at #R$F3F8) when
. CONTINUE (#CHR$43) is chosen.
N $F51D If keyboard mode is selected, highlight the KEYS option first.
  $F51D,$06 If Kempston is already selected (#R$F602), skip the KEYS highlight
. at #R$F52B.
  $F523,$08 Highlight the KEYS option (#N$68) and pulse the menu timing.
N $F52B Poll the controls menu for KEYS, JOYSTICK, REDEFINE or CONTINUE.
@ $F52B label=MainMenu_SelectOptions_KeyLoop
  $F52B,$03 Call #R$FC78 for one menu-music wait tick.
  $F52E,$03 Call #R$F640 to read a key code.
  $F531,$04 Was #CHR$4B (KEYS) pressed? If so, select keyboard at #R$F542.
  $F535,$04 Was #CHR$4A (JOYSTICK) pressed? If so, select Kempston at #R$F548.
  $F539,$04 Was #CHR$52 (REDEFINE) pressed? If so, redefine keys at #R$F553.
  $F53D,$03 Was #CHR$43 (CONTINUE) pressed? If so, return to #R$F3F8.
  $F540,$02 Jump to #R$F52B to keep waiting.
N $F542 Select keyboard controls and refresh the highlights.
@ $F542 label=MainMenu_SelectOptions_Keys
  $F542,$06 Select keyboard controls (clear #R$F602) and refresh the menu
. highlights at #R$F5B5.
N $F548 Select Kempston and click the menu.
@ $F548 label=MainMenu_SelectOptions_Joystick
  $F548,$0B Select Kempston (#N$01 at #R$F602) and clear the KEYS column labels.
N $F553 Clear the key table to #CHR$3F, prompt for seven new keys, and print
. each choice.
@ $F553 label=MainMenu_SelectOptions_Redefine
  $F553,$04 Select keyboard mode (clear #R$F602) before redefine.
  $F557,$07 Fill all seven control-key slots at #R$F5FB with #CHR$3F
. placeholders.
N $F55E Fill the seven control-key slots at #R$F5FB with #CHR$3F placeholders.
@ $F55E label=MainMenu_SelectOptions_ClearKeys
  $F55E,$04 Write the placeholder into this slot and step #REGhl onto the next
. key slot until all seven are cleared.
  $F562,$08 Print the redefine placeholders in attribute #N$C7 and pulse the
. menu timing.
  $F56A,$05 Set the text attribute to #N$4F for newly typed key labels.
  $F56F,$04 Point #REGix at #R$F5FB.
  $F573,$06 Point #REGhl at the first key's attribute cell
. (#N$590C (attribute buffer)), then remember it in #R$F5F9.
  $F579,$02 Load #REGb with #N$07 keys to redefine.
N $F57B Prompt for the next of seven redefine-key presses.
@ $F57B label=MainMenu_SelectOptions_RedefineLoop
  $F57B,$03 Stash #REGbc and #REGix on the stack.
N $F57C Wait until a fresh key is pressed during redefine.
@ $F57C label=MainMenu_SelectOptions_WaitUniqueKey
  $F57E,$03 Call #R$FC78 for one menu-music wait tick.
  $F581,$02 Restore #REGix from the stack.
  $F583,$03 Call #R$F640 to read a key code.
  $F586,$03 Was a key pressed? If not, keep waiting at #R$F57C.
  $F589,$03 Point #REGhl at #R$F5FB.
  $F58C,$02 Load #REGb with #N$07 to scan for duplicates.
N $F58E Reject the key if it already appears in #R$F5FB; otherwise store and
. print it.
@ $F58E label=MainMenu_SelectOptions_CheckDuplicate
  $F58E,$03 Does this code already appear in the table? If so, reject it and
. wait again at #R$F57C.
  $F591,$01 Advance to the next slot.
  $F592,$02 Loop until all slots are checked.
  $F594,$03 Store the new key code at #REGix.
  $F597,$02 Advance #REGix onto the next slot.
  $F599,$03 Stash #REGix and #REGaf on the stack.
  $F59C,$03 Call #R$F70A to colour-cycle the logo (menu acknowledge).
  $F59F,$03 Restore #REGaf and #REGix from the stack.
  $F5A2,$09 Fetch the current label attribute address (#R$F5F9). Keep the key
. code in #REGe. Clear #REGd. Call #R$EB67 to print that character.
  $F5AB,$07 Advance the key-label attribute address by one menu row
. (#N($0040,$04,$04)) and store it in #R$F5F9.
  $F5B2,$01 Restore #REGbc from the stack.
  $F5B3,$02 Loop until all seven keys are redefined.
N $F5B5 Refresh both highlight attributes and return to the key loop.
@ $F5B5 label=MainMenu_SelectOptions_Refresh
  $F5B5,$05 Reprint all seven key labels in attribute #N$C7.
  $F5BA,$05 Reprint the KEYS column highlight in attribute #N$68.
  $F5BF,$03 Call #R$F5EA to pulse the menu timing.
  $F5C2,$03 Jump to #R$F52B to wait for the next KEYS / JOYSTICK / REDEFINE /
. CONTINUE choice.

c $F5C5 Print Control Key Labels (Short)
@ $F5C5 label=Print_ControlKeyLabels_Short
D $F5C5 Entry that reprints the first #N$05 control-key labels using attribute
. #REGa (used when JOYSTICK is chosen to clear the KEYS column). Jumps into
. #R$F5CA at #R$F5CC with a five-label count.
  $F5C5,$02 Load #REGb with #N$05 label count.
  $F5C7,$01 Clear #REGa (blank / black attribute).
  $F5C8,$02 Jump to #R$F5CC to print with a blank attribute and five labels.

c $F5CA Print Control Key Labels
@ $F5CA label=Print_ControlKeyLabels
D $F5CA Print the control-key characters from #R$F5FB into the menu column at
. #N$590C (attribute buffer) using attribute #REGa. #REGb holds how many slots
. to print (#N$07 for a full refresh, #N$05 via #R$F5C5).
R $F5CA A Attribute value for the labels
  $F5CA,$02 Load #REGb with #N$07 label count.
N $F5CC Walk #R$F5FB and print each defined key code.
@ $F5CC label=Print_ControlKeyLabels_WalkTable
  $F5CC,$03 Store #REGa as the current text attribute.
  $F5CF,$03 Point #REGhl at the first key's attribute cell
. (#N$590C (attribute buffer)).
  $F5D2,$04 Point #REGix at #R$F5FB.
N $F5D6 Print one control-key label and step down one menu row.
@ $F5D6 label=Print_ControlKeyLabels_NextKey
  $F5D6,$08 Fetch this slot's key code into #REGe. Clear #REGd. Call #R$EB67 to
. print that character.
  $F5DE,$02 Advance #REGix onto the next slot.
  $F5E0,$04 Step #REGhl down one menu key-label row (#N($0040,$04,$04)).
  $F5E4,$02 Loop until #REGb labels are printed.
  $F5E6,$03 Call #R$F70A to colour-cycle the logo (menu acknowledge).
  $F5E9,$01 Return.

c $F5EA Pulse Menu Timing
@ $F5EA label=Pulse_MenuTiming
D $F5EA Pulse the menu by briefly inverting the key-scan wait at #R$FC80
. The normal opcode there is #HTML(<code>JR Z</code>) (#N$28), which loops
. at #R$FC79 while #SKOOLKID$028E(KEY_SCAN) reports no key; writing
. #HTML(<code>JR NZ</code>) (#N$20) inverts that sense for one #R$FC78 tick so
. the highlight flashes, then #N$28 is restored.
N $F5EA Patch #R$FC80 to #HTML(<code>JR NZ</code>), wait one tick, then restore
. #HTML(<code>JR Z</code>).
  $F5EA,$05 Write #N$20 (#HTML(<code>JR NZ</code>)) over the opcode at #R$FC80.
  $F5EF,$03 Call #R$FC78 for one inverted wait tick.
  $F5F2,$05 Write #N$28 (#HTML(<code>JR Z</code>)) back to #R$FC80.
  $F5F7,$01 Return.

g $F5F8 Control Input Bitmap
@ $F5F8 label=ControlInputBitmap
D $F5F8 Player control bits, written by #R$F603.
. #TABLE(default,centre,centre)
. { =h Bit | =h Meaning }
. { #N$00 | Right }
. { #N$01 | Left }
. { #N$02 | Down (forward) }
. { #N$03 | Up (back) }
. { #N$04 | Fire (pick up / put down / interact) }
. { #N$05 | Secondary fire / alternate action (keyboard #CHR$54 by default) }
. { #N$06 | Pause (keyboard #CHR$48 by default; special-cased in #R$F603) }
. { #N$07 | Unused }
. TABLE#
B $F5F8,$01

g $F5F9 Pointer: Control Key Definition Cursor
@ $F5F9 label=Pointer_ControlKeyDefinitionCursor
D $F5F9 Pointer into #R$F5FB used while redefine-keys walks the control table.
W $F5F9,$02

b $F5FB Table: Control Key Codes
@ $F5FB label=Table_ControlKeyCodes
D $F5FB Default key codes for bits #N$00–#N$06 of #R$F5F8
. (#CHR$58, #CHR$5A, #CHR$41, #CHR$51, #CHR$43, #CHR$54, #CHR$48).
  $F5FB,$07

g $F602 Flag: Kempston Joystick Enabled
@ $F602 label=Flag_KempstonJoystickEnabled
D $F602 Non-zero to read Kempston (#N$1F) in #R$F603; zero to use the keyboard
. table at #R$F5FB.
B $F602,$01

c $F603 Read Player Controls
@ $F603 label=Read_PlayerControls
D $F603 Sample Kempston (#N$1F) or the keyboard table at #R$F5FB into the
. control input bitmap. Pause (#CHR$48 / bit #N$06) waits for the key
. to be released and pressed again before returning.
N $F603 Clear the bitmap, then try Kempston if enabled.
  $F603,$04 Clear #REGa, then clear the control input bitmap.
  $F607,$06 Fetch the Kempston-enabled flag. Is Kempston selected? If not, read
. the keyboard at #R$F613.
  $F60D,$02 Read Kempston port #N$1F.
  $F60F,$02,b$01 Keep bits #N$00–#N$04.
  $F611,$02 If any direction/fire is pressed, store it at #R$F62F.
N $F613 Match the pressed key against #R$F5FB and set the corresponding bit.
@ $F613 label=Read_PlayerControls_Keyboard
  $F613,$03 Call #R$F640 to read a key code.
  $F616,$02 Was a key pressed? If not, return with the bitmap clear.
  $F618,$02 Start the bit mask at #N$01 (bit #N$00 = Right).
  $F61A,$02 Load #REGb with #N$07 table entries.
  $F61C,$03 Point #REGhl at #R$F5FB.
N $F61F Scan #R$F5FB for the pressed key and build the matching bit of #R$F5F8.
@ $F61F label=Read_PlayerControls_ScanTable
  $F61F,$03 Does this table slot match the pressed key? If so, handle it at
. #R$F62A.
  $F622,$01 Advance to the next slot.
  $F623,$02 Shift the bit mask left by one.
  $F625,$02 Loop until the table is exhausted.
  $F627,$03 Clear #REGa (unrecognised key), then store a clear bitmap at
. #R$F62F.
N $F62A Matched a control key: handle pause specially, otherwise write the
. bitmap.
@ $F62A label=Read_PlayerControls_Matched
  $F62A,$01 Keep the matched bit mask in #REGa.
  $F62B,$04 Is it the pause key (bit #N$06)? If so, debounce pause at #R$F633.
N $F62F Store the assembled control bits into #R$F5F8.
@ $F62F label=Read_PlayerControls_WriteBitmap
  $F62F,$03 Write the control input bitmap to #R$F5F8.
  $F632,$01 Return.
N $F633 Wait for pause to be released, then for any key to resume.
@ $F633 label=Read_PlayerControls_PauseRelease
  $F633,$06 Call #R$F640. Is a key still held? If so, keep waiting at #R$F633.
N $F639 After pause release, wait for any key before resuming play.
@ $F639 label=Read_PlayerControls_PauseResume
  $F639,$06 Call #R$F640. Has a key been pressed to resume? If not, keep waiting
. at #R$F639.
  $F63F,$01 Return.

c $F640 Read Keyboard Controls
@ $F640 label=Read_KeyboardControls
D $F640 Scan the keyboard half-rows via #R$F67E and return the matching ASCII
. key code in #REGa, or #N$00 if nothing is pressed.
N $F640 Probe port #N$FEFE first (caps/shift row with bit #N$00 forced).
  $F640,$03 Load #REGbc with keyboard port #N$FEFE.
  $F643,$03 Point #REGhl at #R$F67E.
  $F646,$02 Read the half-row.
  $F648,$02 Force bit #N$00 set (ignore caps-shift alone).
  $F64A,$02,b$01 Keep the five key bits.
  $F64C,$02,b$01 Invert so pressed keys are set.
  $F64E,$02 If any are pressed, decode at #R$F675.
  $F650,$04 Load #REGde with #N($0005,$04,$04), then advance #REGhl onto the
. next half-row's key codes.
  $F654,$02 Load #REGe with #N$06 remaining half-rows.
N $F656 Scan the remaining keyboard half-rows for a pressed key.
@ $F656 label=Read_KeyboardControls_HalfRowLoop
  $F656,$02 Rotate the port select in #REGb left (next half-row).
  $F658,$02 Read that half-row.
  $F65A,$02,b$01 Keep the five key bits.
  $F65C,$02,b$01 Invert so pressed keys are set.
  $F65E,$02 If any are pressed, decode at #R$F675.
  $F660,$05 Advance #REGhl onto the next half-row's key codes.
  $F665,$01 Decrease the half-row counter.
  $F666,$02 Loop at #R$F656 if more half-rows remain.
N $F668 Final half-row: force bit #N$01 set before testing.
  $F668,$02 Rotate onto the last half-row port.
  $F66A,$02 Read it.
  $F66C,$02 Force bit #N$01 set.
  $F66E,$02,b$01 Keep / invert the key bits.
  $F670,$02,b$01 Invert so pressed keys are set.
  $F672,$02 If any are pressed, decode at #R$F675.
  $F674,$01 Return with #REGa = #N$00 (no key).
N $F675 Shift through the pressed-bit positions to pick the ASCII code at
. #REGhl.
@ $F675 label=Read_KeyboardControls_Decode
  $F675,$04 Shift the pressed-bit mask right, then if that key is pressed, take
. its code at #R$F67C.
  $F679,$01 Advance #REGhl onto the next key's code.
  $F67A,$02 Jump to #R$F675 to keep decoding.
N $F67C Return the ASCII code for the pressed bit position from the port map.
@ $F67C label=Read_KeyboardControls_Found
  $F67C,$01 Fetch the ASCII key code at #REGhl.
  $F67D,$01 Return.

b $F67E Table: Keyboard Port Map
@ $F67E label=Table_KeyboardPortMap
  $F67E,$28
c $F6A6 Update High Score Display
@ $F6A6 label=Update_HighScoreDisplay
D $F6A6 Print the current score into the menu score stream at #R$F4F8(#N$F504),
. and if it beats the high score at #R$72F3 update that too (printed at
. #R$F4F8(#N$F516)).
N $F6A6 Print score; promote it to high score when larger.
  $F6A6,$04 Point #REGix at #R$F4F8(#N$F504).
  $F6AA,$03 Fetch the current score.
N $F6AD Keep the current score while the high-score digits are printed.
  $F6AD,$01 Stash #REGhl on the stack.
  $F6AE,$03 Call #R$EB20 to print the score digits.
  $F6B1,$01 Restore #REGhl from the stack.
  $F6B2,$08 Fetch the high score. Clear the success marker. Is the
. current score below the high score? If so, return.
  $F6BA,$01 Restore the current score (add back the high score).
  $F6BB,$03 Store it as the new high score.
  $F6BE,$04 Point #REGix at #R$F4F8(#N$F516).
  $F6C2,$03 Call #R$EB20 to print the high-score digits.
  $F6C5,$01 Return.

w $F6C6 Table: Main Menu Logo Attribute Addresses
@ $F6C6 label=Table_MainMenuLogoAttributes
D $F6C6 Eight attribute-file addresses for the main-menu logo cells drawn by
. #R$F6D6 / colour-cycled by #R$F70A.
W $F6C6,$02
L $F6C6,$02,$08

c $F6D6 Draw Main Menu Logo
@ $F6D6 label=Draw_MainMenuLogo
D $F6D6 Draw the eight-cell main-menu logo using the UDG font at #R$F740 and the
. attribute-address table at #R$F6C6 #PUSHS #POKES$4000,$00,$1B00
. #SIM(start=$F6D6,stop=$F73F)
. #UDGTABLE { #SCR$02,$00,$00,$20,$18(main-menu-logo) } UDGTABLE# #POPS
E $F6D6 Continue on to #R$F70A.
N $F6D6 Point the character set at the logo font and walk eight attribute cells.
  $F6D6,$06 Point #REGhl at the logo font + #N$01 (#R$F740 + #N$01), then store
. it as the current character set.
  $F6DC,$04 Clear the current text attribute.
  $F6E0,$01 Clear #REGd.
  $F6E1,$04 Point #REGix at #R$F6C6.
  $F6E5,$02 There are #N$08 logo cells to draw.
N $F6E7 Draw one of the eight main-menu logo cells from the UDG font at #R$F740.
@ $F6E7 label=Draw_MainMenuLogo_CellLoop
  $F6E7,$01 Stash #REGbc on the stack.
  $F6E8,$06 Fetch this cell's attribute address into #REGhl.
  $F6EE,$02 Start the glyph index at #N$01.
  $F6F0,$02 There are #N$06 rows in each logo cell.
N $F6F2 Draw one #N$09-character row inside the current logo cell.
@ $F6F2 label=Draw_MainMenuLogo_RowLoop
  $F6F2,$02 There are #N$09 characters in each logo row.
N $F6F4 Print one logo glyph via #R$EB67 and advance along the row.
@ $F6F4 label=Draw_MainMenuLogo_CharLoop
  $F6F4,$03 Call #R$EB67 to print glyph #REGe at #REGhl.
  $F6F7,$01 Move to the next character cell on screen.
  $F6F8,$01 Move on to the next logo glyph.
  $F6F9,$02 Decrease the column counter and jump to #R$F6F4 while columns
. remain.
  $F6FB,$01 Stash #REGde on the stack.
  $F6FC,$02 Load #REGe with #N$17 (bytes from row end to the next logo row).
  $F6FE,$01 Step #REGhl onto the next logo row.
  $F6FF,$01 Restore #REGde from the stack.
  $F700,$01 Decrease the row counter.
  $F701,$02 Jump to #R$F6F2 while rows remain.
  $F703,$04 Move #REGix to the next attribute address in the table.
  $F707,$01 Restore #REGbc from the stack.
  $F708,$02 Decrease the cell counter and jump to #R$F6E7 while cells remain.

c $F70A Colour-Cycle Main Menu Logo
@ $F70A label=ColourCycle_MainMenuLogo
D $F70A Cycle attributes across the eight logo cells at #R$F6C6. Picks a
. fresh paper value via #R$EAE5 (avoiding a repeat of the scratch byte at
. #R$F740), then paints a #N$06×#N$09 attribute block at each cell. Used
. after #R$F6D6 and as a menu acknowledge flash from #R$F51D.
N $F70A #PUSHS #POKES$4000,$00,$1B00 #SIM(start=$F6D6,stop=$F70A)
. #POKES$EAE2,$13 #POKES$EAE3,$2B #POKES$F740,$FF #SIM(start=$F70A,stop=$F73F)
. #SCR$02,$00,$00,$20,$18(*lcc1) #POKES$EAE2,$26
. #POKES$EAE3,$56 #POKES$F740,$FF #SIM(start=$F70A,stop=$F73F)
. #SCR$02,$00,$00,$20,$18(*lcc2) #POKES$EAE2,$39
. #POKES$EAE3,$81 #POKES$F740,$FF #SIM(start=$F70A,stop=$F73F)
. #SCR$02,$00,$00,$20,$18(*lcc3) #POKES$EAE2,$4C
. #POKES$EAE3,$AC #POKES$F740,$FF #SIM(start=$F70A,stop=$F73F)
. #SCR$02,$00,$00,$20,$18(*lcc4) #POKES$EAE2,$5F
. #POKES$EAE3,$D7 #POKES$F740,$FF #SIM(start=$F70A,stop=$F73F)
. #SCR$02,$00,$00,$20,$18(*lcc5)
. #UDGTABLE { #FRAMES(lcc1,12;lcc2;lcc3;lcc4;lcc5)(logo-cycle) } UDGTABLE# #POPS
N $F70A Walk all eight logo cells with a new random attribute.
  $F70A,$04 Point #REGix at #R$F6C6.
  $F70E,$02 Clear #REGd (row-step high byte stays #N$00).
  $F710,$02 There are #N$08 logo cells to recolour.
N $F712 Recolour one of the eight logo cells with a fresh random paper
. attribute.
@ $F712 label=ColourCycle_MainMenuLogo_CellLoop
  $F712,$01 Stash #REGbc on the stack.
  $F713,$03 Point #REGhl at the logo-font scratch byte.
  $F716,$02 Load #REGa with #N$05 (random range for the attribute pick).
N $F718 Pick a paper value that differs from the previous pick at #R$F740.
@ $F718 label=ColourCycle_MainMenuLogo_PickAttr
  $F718,$03 Call #R$EAE5 to pick a pseudo-random value.
  $F71B,$03 Does it match the previous pick at #R$F740? If so, jump to #R$F718
. to pick again.
  $F71E,$01 Store the new pick at #R$F740.
  $F71F,$02 #REGa+=#N$02.
  $F721,$03 Multiply by #N$08 to form a paper attribute.
  $F724,$06 Fetch this cell's attribute address into #REGhl.
  $F72A,$02 There are #N$06 attribute rows to paint.
N $F72C Paint one attribute row of the #N$06×#N$09 logo cell.
@ $F72C label=ColourCycle_MainMenuLogo_RowLoop
  $F72C,$02 There are #N$09 attribute cells in a logo row.
N $F72E Write one attribute cell of the colour-cycled logo row.
@ $F72E label=ColourCycle_MainMenuLogo_ColLoop
  $F72E,$01 Write the attribute at #REGhl.
  $F72F,$01 Advance along the attribute row.
  $F730,$02 Decrease the column counter and jump to #R$F72E while columns
. remain.
  $F732,$02 Load #REGe with #N$17 (bytes from row end to the next logo row).
  $F734,$01 Step #REGhl onto the next attribute row.
  $F735,$01 Decrease the row counter.
  $F736,$02 Jump to #R$F72C while rows remain.
  $F738,$04 Move #REGix to the next attribute address in the table.
  $F73C,$01 Restore #REGbc from the stack.
  $F73D,$02 Decrease the cell counter and jump to #R$F712 while cells remain.
  $F73F,$01 Return.

b $F740 Font: Main Menu Logo
@ $F740 label=Font_MainMenuLogo
D $F740 UDG font for the main-menu logo drawn by #R$F6D6. #R$F6D6 points the
. character set at #R$F740+#N$01; glyph #N$00 (the first #N($0008,$04,$04)
. bytes) is also reused by #R$F70A as the "last attribute" scratch byte.
. There are #N($0037,$04,$04) glyphs of #N($0008,$04,$04) bytes each.
  $F740,$08 Glyph #N((#PC-$F740)/$08):
. #UDGTABLE { #UDG(#PC) } UDGTABLE#
L $F740,$08,$37
  $F8F8,$01

c $F8F9 Queue Sound
@ $F8F9 label=Queue_Sound
D $F8F9 Queue a sound index in #R$7309 for #R$F9AF. If bit #N$07 of #REGa is
. set, force the queue (replace any pending sound). Otherwise keep the existing
. pending sound when one is already waiting #R$F9AF forms the parameter pointer
. as base #R$F8F9(#N$F907) plus index×#N$08. That base address
. #R$F8F9(#N$F907) is the operand byte of the busy-check #R$F906(JR NZ), and it
. is never read as a sound parameter because indexes start at #N$01 (so the
. first block is at #R$F90F).
R $F8F9 A Sound index (#N$01–#N$14), optionally with bit #N$07 set to force
  $F8F9,$04 Is bit #N$07 set (force-queue)? If not, jump to #R$F901 to queue
. only when idle.
  $F8FD,$03 Write the sound index to #R$7309.
  $F900,$01 Return.
N $F901 Queue the sound index into #R$7309 only when the queue is idle.
@ $F901 label=Queue_Sound_UnlessBusy
  $F901,$01 Stash #REGaf on the stack.
  $F902,$03 Fetch the pending sound index from #R$7309.
  $F905,$03 Is a sound already waiting? If so, jump to #R$F90D.
N $F908 Finish #R$F8F9: write the new index when the queue was idle, or discard
. it when busy.
@ $F908 label=Queue_Sound_CommitOrDiscard
  $F908,$01 Restore the new index from the stack.
  $F909,$03 Write it to #R$7309.
  $F90C,$01 Return.
N $F90D Leave the pending sound in #R$7309 unchanged when the queue is busy.
@ $F90D label=Queue_Sound_Busy
  $F90D,$01 Restore #REGaf from the stack (discard the new index).
  $F90E,$01 Return.

b $F90F Table: Sound Parameters
@ $F90F label=Table_SoundParameters
D $F90F Eight-byte parameter blocks for sounds #N$01–#N$14. #R$F9AF forms
. #REGix=#R$F8F9(#N$F907)+(index×#N$08). The base #R$F8F9(#N$F907) is the
. operand byte of #R$F906(JR NZ) in #R$F8F9; it is never read as a parameter
. because indexes start at #N($01), so sound #N$01 begins here. Layout:
. #TABLE(default,centre,centre)
. { =h Offset | =h Meaning }
. { #N$00 | Outer repeat count (#REGc) }
. { #N$01 | Pulse count (#REGb) }
. { #N$02 | Speaker-off delay (#REGe) }
. { #N$03 | Speaker-on delay (#REGd) }
. { #N$04 | Per-pulse delta added to the on-delay }
. { #N$05 | Per-pulse delta added to the off-delay }
. { #N$06 | Flags / waveform high byte (bit #N$07 set = square wave only) }
. { #N$07 | Waveform low byte when bit #N$07 of #N$06 is clear }
. TABLE#
  $F90F,$08 Sound #N$01: score / room-init fanfare (#R$AEF7).
  $F917,$08 Sound #N$02: Berk-action fanfare (#R$AED6).
  $F91F,$08 Sound #N$03.
  $F927,$08 Sound #N$04: entity-slot store (forced as #N$84 at #R$B3B7).
  $F92F,$08 Sound #N$05: trap door opening (#R$EE0B).
  $F937,$08 Sound #N$06: trap door closing (#R$EDE8).
  $F93F,$08 Sound #N$07: entity-slot wait (forced as #N$87 at #R$B409).
  $F947,$08 Sound #N$08: random game-event sting (forced as #N$88 at #R$BDAD).
  $F94F,$08 Sound #N$09: clear-attributes sting (forced as #N$89 at #R$EA62).
  $F957,$08 Sound #N$0A: message-flash click (#R$E294).
  $F95F,$08 Sound #N$0B: task fanfare / stinger (#R$AC6D).
  $F967,$08 Sound #N$0C: timed-event / Drutt script (#R$ADF6 / #R$AFE3).
  $F96F,$08 Sound #N$0D.
  $F977,$08 Sound #N$0E: trap door / catch thump (also forced as #N$8E at
. #R$B062 / #R$B130).
  $F97F,$08 Sound #N$0F: ghost update (#R$CEB8).
  $F987,$08 Sound #N$10: scripted movement (#R$F00B / #R$F0BF).
  $F98F,$08 Sound #N$11: vat / script action (#R$D06C / #R$D229).
  $F997,$08 Sound #N$12: heater (#R$C635).
  $F99F,$08 Sound #N$13.
  $F9A7,$08 Sound #N$14: task-three script action (#R$C3D7).

c $F9AF Play Queued Sound
@ $F9AF label=Play_QueuedSound
D $F9AF Play the sound queued at #R$7309 using the parameter block selected
. from base #R$F8F9(#N$F907) (sound #N$01 starts at #R$F90F), then clear the
. queue. The base #R$F8F9(#N$F907) is the operand byte of #R$F906(JR NZ) in
. #R$F8F9; it is never read as a parameter because indexes start at #N$01.
N $F9AF Fetch the pending sound and return if the queue is empty.
  $F9AF,$03 Fetch the pending sound index from #R$7309.
  $F9B2,$02,b$01 Keep only bits #N$00–#N$06 (mask #N$7F).
  $F9B4,$01 Return if the queue was empty.
  $F9B5,$02 Stash #REGix on the stack.
N $F9B7 Point #REGix at this sound's parameter block and clear the queue.
  $F9B7,$03 Multiply the index by #N$08.
  $F9BA,$01 Keep the table offset in #REGc.
  $F9BB,$04 Clear #R$7309.
  $F9BF,$01 Clear #REGb (high byte of the offset).
  $F9C0,$06 Point #REGix at #R$F8F9(#N$F907) (operand of #R$F906) plus the
. offset.
N $F9C6 Load the tone parameters and play.
  $F9C6,$03 Load the outer repeat count from #REGix+#N$00 into #REGc.
N $F9C9 Outer repeat: reload pulse count and on/off delays from the parameter
. block.
@ $F9C9 label=Play_QueuedSound_RepeatLoop
  $F9C9,$03 Load the pulse count from #REGix+#N$01 into #REGb.
  $F9CC,$03 Load the speaker-off delay from #REGix+#N$02 into #REGe.
  $F9CF,$03 Load the speaker-on delay from #REGix+#N$03 into #REGd.
  $F9D2,$03 Load the flags / waveform high byte from #REGix+#N$06 into #REGh.
N $F9D5 One speaker pulse: turn EAR on, delay, optional waveform, then EAR off.
@ $F9D5 label=Play_QueuedSound_PulseLoop
  $F9D5,$01 Stash #REGbc on the stack.
  $F9D6,$03 Fetch the border / speaker state from #R$EA6C.
  $F9D9,$02 Set bit #N$04 (speaker on).
  $F9DB,$02 Send it to the speaker (port #N$FE).
  $F9DD,$01 Keep the on-delay in #REGb.
N $F9DE Hold the speaker on for the on-delay in #REGd.
@ $F9DE label=Play_QueuedSound_OnDelay
  $F9DE,$03 Hold for the on-delay. jump to #R$F9DE while it remains.
  $F9E1,$04 Is the square-wave-only flag set? If so, jump to #R$F9F3.
  $F9E5,$01 Fetch the next waveform delay into #REGb.
  $F9E6,$01 Advance the waveform pointer in #REGhl.
N $F9E7 Pad the non-square waveform delay from the stream at #REGhl.
@ $F9E7 label=Play_QueuedSound_WaveDelay
  $F9E7,$0A Timing pad for the waveform delay.
  $F9F1,$02 Decrease the waveform delay and jump to #R$F9E7 while it remains.
N $F9F3 Turn the speaker off and hold for the off-delay in #REGe.
@ $F9F3 label=Play_QueuedSound_SpeakerOff
  $F9F3,$02 Clear bit #N$04 (speaker off).
  $F9F5,$02 Send it to the speaker (port #N$FE).
  $F9F7,$01 Keep the off-delay in #REGb.
N $F9F8 Hold the speaker off for the off-delay, then apply the per-pulse deltas.
@ $F9F8 label=Play_QueuedSound_OffDelay
  $F9F8,$03 Hold for the off-delay. jump to #R$F9F8 while it remains.
  $F9FB,$05 Add the on-delay delta from #REGix+#N$04 to #REGd.
  $FA00,$05 Add the off-delay delta from #REGix+#N$05 to #REGe.
  $FA05,$01 Restore #REGbc from the stack.
  $FA06,$02 Decrease the pulse counter and jump to #R$F9D5 while pulses remain.
  $FA08,$01 Decrease the repeat counter.
  $FA09,$02 Jump to #R$F9C9 while repeats remain.
N $FA0B Housekeeping; restore the registers stashed at the start of the routine.
  $FA0B,$02 Restore #REGix from the stack.
  $FA0D,$01 Return.

b $FA0E Buffer: Entity State Backup
@ $FA0E label=Buffer_EntityStateBackup
D $FA0E Backup copy of complex entity state data, written by #R$AFA9.
  $FA0E,$01CE

u $FBDC
  $FBDC,$90

c $FC6C Seed Menu Music And Wait For Key
@ $FC6C label=Seed_MenuMusicAndWaitForKey
@ $FC6C org=$FC6C
D $FC6C Live copy of the menu-music and key-wait code, relocated from
. #R$6F04 by #R$AAB3 (length #N($0393,$04,$04)). On game start this
. entry seeds the two music-stream cursors, then continues into #R$FC78.
. Menu code also enters at #R$FC78 for a single wait tick. #R$F5EA briefly
. patches #R$FC80 while pulsing the menu highlight.
E $FC6C Continue on to #R$FC78.
  $FC6C,$06 Point #REGhl at #R$FE3B and seed the cursor word at #R$FC87.
  $FC72,$06 Point #REGhl at #R$FF19 and seed the cursor word at #R$FC8B.

c $FC78 Wait For Key With Menu Music
@ $FC78 label=Wait_KeyWithMenuMusic
D $FC78 Disable interrupts and wait until #SKOOLKID$028E(KEY_SCAN) reports a
. key, playing one #R$FCB3 music tick per loop. Game start falls through from
. #R$FC6C; the menu calls this entry for a single wait tick.
  $FC78,$01 Disable interrupts.
N $FC79 Key-scan wait loop with menu music.
@ $FC79 label=Wait_KeyWithMenuMusic_Loop
  $FC79,$03 Call #R$FCB3 to play one menu-music tick.
  $FC7C,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $FC7F,$01 Increment #REGe by one (#SKOOLKID$028E(KEY_SCAN) returns #N$FF in
. #REGe when no key).
  $FC80,$02 Jump to #R$FC79 if #REGe wrapped to #N$00 (no key yet).
  $FC82,$01 No operation.
  $FC83,$01 Return.

b $FC84 Menu Music Workspace
@ $FC84 label=MenuMusic_Workspace
D $FC84 Working bytes for the two-channel menu tune. #R$FC84 and #R$FC85 hold
. the latest stream bytes; #R$FC86 holds the border and speaker output value
. written to port #N$FE; #R$FC87/#R$FC89 are stream one's cursor and reload
. address; #R$FC8B/#R$FC8D are stream two's; #R$FC8F holds the shared delay
. phase.
  $FC84,$01 Latest byte from music stream one.
  $FC85,$01 Latest byte from music stream two.
  $FC86,$01 Border and speaker bits for port #N$FE.
W $FC87,$02 Stream one cursor.
W $FC89,$02 Stream one reload address.
W $FC8B,$02 Stream two cursor.
W $FC8D,$02 Stream two reload address.
  $FC8F,$01 Shared delay phase for both channels.

c $FC90 Read Music Stream Byte
@ $FC90 label=Read_MusicStreamByte
D $FC90 Advance a word cursor at #REGhl, fetch the next stream byte, and treat
. #N$40 as an end marker (then jump to #R$FCAB to reload the cursor from the
. following word).
  $FC90,$01 Fetch the low byte of the cursor word into #REGe.
  $FC91,$01 Advance #REGhl onto the high byte.
  $FC92,$01 Fetch the high byte of the cursor word into #REGd.
  $FC93,$01 Advance the cursor value in #REGde by one.
N $FC94 Fetch the byte at the stream cursor.
@ $FC94 label=Read_MusicStreamByte_Fetch
  $FC94,$01 Fetch the byte at the cursor.
  $FC95,$02 Is it the end marker #N$40?
  $FC97,$02 If so, jump to #R$FCAB to reload the cursor from the next word.
  $FC99,$01 Write the updated high byte back.
  $FC9A,$01 Step #REGhl back to the low byte.
  $FC9B,$01 Write the updated low byte back.
  $FC9C,$01 Return.

c $FC9D Decode Music Delay
@ $FC9D label=Decode_MusicDelay
D $FC9D Map a raw stream byte through the delay table at #R$FD40 into a tone and
. duration pair returned in #REGhl. The #R$FCAB entry reloads a cursor word and
. continues at #R$FC94.
  $FC9D,$01 Load the raw stream byte from #REGhl.
  $FC9E,$02 Bias it by #N$0C for the table index.
  $FCA0,$01 Copy the index into #REGe.
  $FCA1,$02 Clear #REGd so #REGde holds the table offset.
  $FCA3,$03 Point #REGhl at #R$FD40.
  $FCA6,$01 Index into the table.
  $FCA7,$01 Fetch the delay high byte into #REGh.
  $FCA8,$02 Load the delay low byte with #N$01.
  $FCAA,$01 Return.

c $FCAB Reload Music Stream Cursor
@ $FCAB label=Reload_MusicStreamCursor
D $FCAB Reload the stream cursor from the word after an end marker, then
. continue fetching at #R$FC94.
  $FCAB,$01 Advance #REGhl onto the reload word.
  $FCAC,$01 Fetch its low byte into #REGe.
  $FCAD,$01 Advance onto the high byte.
  $FCAE,$01 Fetch its high byte into #REGd.
  $FCAF,$02 Step #REGhl back onto the cursor word.
  $FCB1,$02 Jump to #R$FC94 to fetch from the reloaded cursor.

c $FCB3 Play Menu Music Tick
@ $FCB3 label=Play_MenuMusicTick
D $FCB3 One tick of the two-channel menu tune while the key-scan waits.
. Reads both stream cursors, looks each byte up in #R$FD40, then either
. bit-bangs the speaker on port #N$FE (toggling bit #N$04 via #N$10) or
. takes the #R$FD76 continue path. Called every pass of #R$FC79.
  $FCB3,$03 Point #REGhl at music cursor one (#R$FC87).
  $FCB6,$03 Call #R$FC90 to read the next stream-one byte.
  $FCB9,$03 Store it at #R$FC84.
  $FCBC,$03 Point #REGhl at music cursor two (#R$FC8B).
  $FCBF,$03 Call #R$FC90 to read the next stream-two byte.
  $FCC2,$03 Store it at #R$FC85.
  $FCC5,$03 Point #REGhl at stream-one's stored byte (#R$FC84).
  $FCC8,$03 Call #R$FC9D to decode its delay pair.
  $FCCB,$02 Rotate #REGe left through carry to test the channel flag.
  $FCCD,$03 If carry is set, jump to #R$FD76 for the continue path.
  $FCD0,$01 Stash the decoded delay on the stack.
  $FCD1,$03 Point #REGhl at stream-two's stored byte (#R$FC85).
  $FCD4,$03 Call #R$FC9D to decode its delay pair.
  $FCD7,$01 Restore stream-one's delay into #REGde.
  $FCD8,$04 If stream-one's duration is not #N($01), jump to #R$FCE0.
  $FCDC,$04 If stream-two's duration is #N($01), jump to #R$FD22.
N $FCE0 Prepare the speaker output value and enter the tone pulse loop.
@ $FCE0 label=Play_MenuMusic_PreparePulse
  $FCE0,$06 Load the delay phase from #R$FC8F into #REGc and clear #REGb.
  $FCE6,$03 Load the border and speaker bits from #R$FC86.
  $FCE9,$01 Switch to the alternate accumulator.
  $FCEA,$03 Reload the border and speaker bits from #R$FC86.
  $FCED,$02 Keep the inner delay count in #REGixh.
  $FCEF,$02 Load #REGd with #N$10 (speaker bit mask).
N $FCF1 Inner tone loop: burn delay, write port #N($FE), and toggle the speaker
. bit.
@ $FCF1 label=Play_MenuMusic_PulseLoop
  $FCF1,$02 Timing pad before the port write.
N $FCF3 Write the speaker level and advance the dual delay counters.
@ $FCF3 label=Play_MenuMusic_PulseWrite
  $FCF3,$01 Switch back to the primary accumulator.
  $FCF4,$01 Decrease the fine delay in #REGe.
  $FCF5,$02 Write the border and speaker bits to port #N$FE.
  $FCF7,$02 If the fine delay remains, jump to #R$FD10.
  $FCF9,$02 Reload the fine delay from #REGixh.
  $FCFB,$01 Toggle the speaker bit (#N$10) in #REGa via #REGd.
  $FCFC,$01 Switch to the alternate accumulator.
  $FCFD,$01 Decrease the coarse delay in #REGl.
  $FCFE,$03 If the coarse delay remains, jump to #R$FD17.
N $FD01 Reload the coarse delay from #REGh and keep pulsing.
@ $FD01 label=Play_MenuMusic_ReloadCoarse
  $FD01,$02 Write the speaker level to port #N$FE.
  $FD03,$01 Copy #REGh into #REGl to reload the coarse delay.
  $FD04,$01 Toggle the speaker bit (#N$10) in #REGa via #REGd.
  $FD05,$02 Decrease #REGb and loop to #R$FCF1 while the outer count remains.
  $FD07,$01 Advance the phase counter in #REGc.
  $FD08,$03 If the phase remains, jump to #R$FCF3.
  $FD0B,$01 Return.

b $FD0C Data: Embedded "adam" Pad
@ $FD0C label=Data_EmbeddedAdamPad
D $FD0C Four unreachable ASCII bytes ("adam") sitting after the #R$FD0B
. return. Never executed; the pulse loop re-enters at #R$FD10.
  $FD0C,$04 "#STR(#PC,$04,$04)".

c $FD10 Play Menu Music Pulse Tail
@ $FD10 label=Play_MenuMusic_PulseTail
D $FD10 Continuation of the #R$FCF1 tone loop when the fine delay is still
. non-zero. The opening #HTML(<code>JR Z</code>) is a never-taken timing
. pad (entry always has the zero flag clear).
  $FD10,$02 Never-taken timing pad (#HTML(<code>JR Z</code>)). Fall through with
. the zero flag clear.
N $FD12 Finish the fine-delay tail and return to the main pulse loop.
@ $FD12 label=Play_MenuMusic_PulseTailBody
  $FD12,$01 Switch to the alternate accumulator.
  $FD13,$01 Decrease the coarse delay in #REGl.
  $FD14,$03 If the coarse delay expired, jump to #R$FD01.
N $FD17 Port write used when the coarse delay is still running.
@ $FD17 label=Play_MenuMusic_PulseTailWrite
  $FD17,$02 Write the speaker level to port #N$FE.
  $FD19,$02 Timing pad before the outer count test.
  $FD1B,$02 Decrease #REGb and loop to #R$FCF1 while the outer count remains.
  $FD1D,$01 Advance the phase counter in #REGc.
  $FD1E,$03 If the phase remains, jump to #R$FCF3.
  $FD21,$01 Return.

c $FD22 Hold Menu Music Silence
@ $FD22 label=Hold_MenuMusicSilence
D $FD22 Hold silence while both channel durations are zero, or when #R$FD76
. takes the clear-carry path into #R$FD27. Burns a delay derived from #R$FC8F,
. then returns.
  $FD22,$03 Load the delay phase from #R$FC8F.
  $FD25,$02 Complement it into #REGc as a hold count.
N $FD27 Timed silent hold used by #R$FD76 and the expired-duration path.
@ $FD27 label=Hold_MenuMusicSilence_Loop
  $FD27,$02 Stash #REGbc and #REGaf on the stack.
  $FD29,$02 Clear #REGb for the inner burn count.
N $FD2B Burn cycles for one silent-hold iteration.
@ $FD2B label=Hold_MenuMusicSilence_Burn
  $FD2B,$01 Stash #REGhl on the stack.
  $FD2C,$03 Point #REGhl at #N($0000,$04,$04).
  $FD2F,$06 Burn cycles with three #HTML(<code>SRA (HL)</code>) pads.
  $FD35,$01 Timing pad.
  $FD36,$01 Restore #REGhl from the stack.
  $FD37,$02 Decrease #REGb and loop to #R$FD2B while the burn count remains.
  $FD39,$01 Decrease the hold count in #REGc.
  $FD3A,$03 If the hold count remains, jump to #R$FD2B.
  $FD3D,$02 Restore #REGaf and #REGbc from the stack.
  $FD3F,$01 Return.

b $FD40 Menu Music Delay Table
@ $FD40 label=Table_MenuMusicDelay
D $FD40 Delay lookup used by #R$FC9D to turn each stream byte into a tone
. duration.
  $FD40,$36

c $FD76 Continue Menu Music Tick
@ $FD76 label=Continue_MenuMusicTick
D $FD76 Continue a music tick when #R$FCB3 takes the carry path: build a delay
. via #R$FD99, then either pulse the speaker, play the table-driven coda, or
. return.
  $FD76,$05 Stash #REGaf, load stream-two's byte from #R$FC85 into #REGd, then
. restore #REGaf.
  $FD7C,$03 Call #R$FD99 to build the delay count.
  $FD7F,$04 Jump to #R$FDAE if #REGa is #N$FF (pulse the speaker).
  $FD83,$05 Jump to #R$FDEB if #REGa is #N$C0 (play the coda).
  $FD88,$02 Load #REGb with #N$04 step bits.
  $FD8A,$01 Copy the delay into #REGc.
  $FD8B,$04 Rotate #REGa left through carry four times to walk the step mask.
N $FD8F Apply the current step bit: pulse, hold, then loop.
@ $FD8F label=Continue_MenuMusicTick_StepBit
  $FD8F,$01 Rotate #REGa left through carry once more for this step.
  $FD90,$03 If carry is set, call #R$FDAE to pulse the speaker.
  $FD93,$03 If carry is clear, call #R$FD27 for a silent hold.
  $FD96,$02 Decrease #REGb and loop to #R$FD8F while steps remain.
  $FD98,$01 Return.

c $FD99 Build Music Delay Count
@ $FD99 label=Build_MusicDelayCount
D $FD99 Build a delay count from the shared phase at #R$FC8F.
  $FD99,$01 Stash #REGaf on the stack.
  $FD9A,$05 Load #R$FC8F, complement it, and copy the result into #REGb and
. #REGc.
  $FDA0,$02 Add #N$01 so a zero phase still yields a positive count.
  $FDA2,$04 Divide #REGa by #N$04 with two arithmetic shifts right.
  $FDA6,$01 Copy the scaled count into #REGe.
  $FDA7,$04 If the scaled count is zero, force #REGe to #N$01.
N $FDAC Restore #REGaf and return the delay count.
@ $FDAC label=Build_MusicDelayCount_Return
  $FDAC,$02 Restore #REGaf from the stack and return.

c $FDAE Pulse Menu Music Speaker
@ $FDAE label=Pulse_MenuMusicSpeaker
D $FDAE Pulse the speaker bit on port #N$FE for the delay count built by
. #R$FD99. Walks the step mask in #REGd, writing high or low levels or burning
. timing for clear bits.
  $FDAE,$03 Stash #REGaf, #REGhl and #REGbc on the stack.
  $FDB1,$05 Load the border and speaker bits from #R$FC86 and clear #REGb.
  $FDB6,$03 Point #REGhl at the pulse period base (#N($03E8,$04,$04)).
N $FDB9 Walk the step mask in #REGd and either pulse or burn timing.
@ $FDB9 label=Pulse_MenuMusicSpeaker_Step
  $FDB9,$02 Rotate #REGd right through carry.
  $FDBB,$03 If carry is clear, jump to #R$FDDD for a timing burn.
  $FDBE,$01 Advance the period pointer.
  $FDBF,$05 If the selected step bit is clear, jump to #R$FDD9 to force the
. speaker low.
  $FDC4,$02 Force the speaker bit high in #REGa.
  $FDC6,$02,b$01 Toggle spare tone bits with #N$83.
  $FDC8,$02,b$01 Toggle spare tone bits with #N$83 again.
N $FDCA Write the speaker level and count down the pulse delay.
@ $FDCA label=Pulse_MenuMusicSpeaker_Write
  $FDCA,$02 Write the border and speaker bits to port #N$FE.
N $FDCC Inner delay between speaker writes.
@ $FDCC label=Pulse_MenuMusicSpeaker_Delay
  $FDCC,$01 Timing pad.
  $FDCD,$04 Decrease #REGb and loop to #R$FDB9 while the fine count remains.
  $FDD1,$04 Decrease #REGc and loop to #R$FDB9 while the coarse count remains.
  $FDD5,$03 Restore #REGbc, #REGhl and #REGaf from the stack.
  $FDD8,$01 Return.
N $FDD9 Force the speaker bit low, then write it.
@ $FDD9 label=Pulse_MenuMusicSpeaker_Low
  $FDD9,$02 Clear the speaker bit in #REGa.
  $FDDB,$02 Jump to #R$FDCA to write it.
N $FDDD Timing burn for a clear step-mask bit.
@ $FDDD label=Pulse_MenuMusicSpeaker_Burn
  $FDDD,$01 Set the carry flag.
  $FDDE,$03 Timing pad (#HTML(<code>JP NC</code>)).
  $FDE1,$03 Timing pad (#HTML(<code>JP NC</code>)).
  $FDE4,$05 No operations.
  $FDE9,$02 Jump to #R$FDCC to resume the delay count.

c $FDEB Play Menu Music Coda
@ $FDEB label=Play_MenuMusicCoda
D $FDEB Play coda notes from the table at #R$FE23 via the ROM beeper.
  $FDEB,$06 Point #REGde at offset #REGb and #REGhl at #R$FE23.
  $FDF1,$02 Add the offset into #REGhl.
  $FDF3,$02 Fetch the note length into #REGb.
  $FDF5,$03 Point #REGhl at the starting pitch (#N($0003,$04,$04)).
N $FDF8 Sound each coda step through #R$FE0A.
@ $FDF8 label=Play_MenuMusicCoda_Loop
  $FDF8,$01 Stash the remaining note count on the stack.
  $FDF9,$03 Load #REGde with pitch step #N($0001,$04,$04).
  $FDFC,$01 Stash the current pitch on the stack.
  $FDFD,$03 Call #R$FE0A to beep at this pitch.
  $FE00,$01 Restore the pitch into #REGhl.
  $FE01,$05 Raise the pitch by #N($00FF,$04,$04).
  $FE06,$01 Restore the remaining note count.
  $FE07,$02 Decrease #REGb and loop to #R$FDF8 while notes remain.
  $FE09,$01 Return.

c $FE0A Sound Coda Beep
@ $FE0A label=Sound_CodaBeep
D $FE0A Finalise one coda step: scale the pitch, index the ROM beeper
. helper, then return with interrupts disabled.
  $FE0A,$01 Copy the pitch low byte into #REGa.
  $FE0B,$04 Divide #REGl by #N$04 with two logical shifts right.
  $FE0F,$01 Complement #REGa.
  $FE10,$02,b$01 Keep only the bottom two bits of #REGa.
  $FE12,$03 Copy that index into #REGc and clear #REGb.
  $FE15,$06 Point #REGix at #SKOOLKID$03D1(BEEPER) and index it by #REGbc.
  $FE1B,$03 Load the border and speaker bits from #R$FC86.
  $FE1E,$03 Call #SKOOLKID$03D4(BEEPER).
  $FE21,$01 Disable interrupts.
  $FE22,$01 Return.

b $FE23 Menu Music Coda Note Table
@ $FE23 label=MenuMusic_CodaNoteTable
D $FE23 Note-length bytes indexed by #R$FDEB when playing the menu-music coda.
. Each entry feeds one #R$FE0A beep.
  $FE23,$18

b $FE3B Menu Music Stream One Base
@ $FE3B label=MenuMusic_StreamOneBase
@ $FE3B org=$FE3B
D $FE3B Base of music stream one. #R$FC6C seeds the stream-one cursor at
. #R$FC87 to this address, and the stream-two cursor at #R$FC8B to
. #R$FF19. The leftover filename bytes from #R$728E sit at #R$FFF6.
  $FE3B,$00DE
@ $FF19 label=MenuMusic_StreamTwoBase
  $FF19,$00DD
@ $FFF6 label=Leftover_MusicEn_Relocated
  $FFF6,$0A

readme - TSE-SGDMA Design


Overview:

This design is provided to show case the TSE-SGDMA design running on the Nios development boards and highlights many of the
advanced features of the Nios II processor, Triple Speed Ethernet and the Scatter Gather DMA.
In addition to the features of the full_featured design, this design includes:

 - Two SGDMA peripherals for high-speed data transfers 
 - A Triple Speed Ethernet


Contents of the System:

 - Nios II/f Core
 - JTAG Debug Module (Level 4)
 - Onchip Tightly Coupled Data Memory (8kB)
 - Onchip Tightly Coupled Instruction Memory (4kB)
 - DDR SDRAM Controller (32MB)
 - SSRAM Controller (2MB)
 - CFI Flash Memory Interface (16MB)
 - Descriptor memories (On Chip Memory)
 - DMA Controller
 - EPCS Controller (with bootloader)
 - JTAG UART
 - UART (RS-232)
 - Two Timers
 - Ethernet Interface
 - LED PIO
 - Seven Segment Display PIO
 - Push Button PIO
 - LCD Display Interface
 - Performance Counter
 - System ID Peripheral
 - Three PLLs 


Supported Software Examples:

 - Blank Project
 - Hello World
 - Board Diagnostic
 - Count Binary
 - Hello Free-Standing
 - Hello MicroC/OS II
 - Hello World Small
 - Memory Test
 - Simple Sockets Server
 - Web Server


Further Notes:

- The top level of this design is the HDL file generated around the SOPC Builder design. This wrapper performs the following functions:

  1.) Renaming the DDR-associated pins from SOPC Builder to match the timing assignments produced by the DDR megafunction.
  2.) Instantiate an auxillary module required by the DDR.
  3.) Adds a NOT gate to the LED_PIO output to change the sense to active-low.
  4.) If you modify and regenerate the SOPC Builder design, the port list of the SOPC Builder instance may change. 
      You must manually edit the HDL wrapper file to rectify any discrepancies.

- This Quartus II project contains assignments that match the port names produced by SOPC Builder. 
  If you add or modify SOPC Builder components, the pin assignments may no longer be valid. 
  To view the Assignment Editor in the Quartus II software, in the Assignments menu, click "Assignment Editor".


- This design contains the DDR memory and Triple Speed Ethernet components.  Any design containing these cores must be re-generated 
  in SOPC Builder before to re-compiling it in Quartus, if it the installation path to the Altera toolchain has changed since it was 
  last generated.  This is because these cores make use of RTL libraries that are referenced using absolute paths.  The re-generation 
  process will update these absolute paths.
  Attempting to recompile in Quartus II without regenerating will result in an error of the following form during Quartus II Analysis and 
  Synthesis:
  Error: Node instance "ddr_control" instantiates undefined entity "auk_ddr_controller"


- DDR memory is the main memory of the system, however SSRAM has a faster access speed (when using the same clock frequencies).  

- This design contains a PLL that produces a phase-shifted clock to feed the SSRAM.  The phase shift is board-dependent, and may be different
  if this design is retargeted to a different board.

- This design contains a PLL that produces a phase-shifted clock to feed the DDR SDRAM. The phase shift is board-dependent, and may be different
  if this design is retargeted to a different board. 
  Please see AN 398: Using DDR/DDR SDRAM With SOPC Builder. <http://www.altera.com/literature/an/an398.pdf>

- This design contains a PLL that produces 125Mhz clock to the Triple Speed Ethernet and PHY. This clock also can be supply by an external 
  cristal.

- The current version of the Nios II EDS hardware design example uses an HDL file as the top level of the design hierarchy.  
  If you would like to use a schematic-based top level instead (BDF), follow the steps listed below.  
  For more information and details, refer to the Nios II Embedded Design Suite Release Note.
  
  1.)  In the Quartus II software, open the top-level HDL file (.v or .vhd) for the design.
  2.)  Create a symbol for the HDL file by clicking "File -> Create/Update -> Create Symbol Files for Current File"
  3.)  Create a new BDF file by clicking "File -> New -> Block Diagram/Schematic File."
  4.)  Instantiate the symbol in the BDF by double-clicking in the empty space of the BDF file and selecting "Project -> <symbol filename>"
  5.)  Instantiate pins in the BDF by double-clicking empty space, then typing "input", "output", or "bidir".
  6.)  Rename the pins and connect them to the appropriate ports on the symbol.
  7.)  Save the BDF as a unique filename.
  8.)  Set the BDF as your top level entity by clicking, "Project -> Set as Top-Level Entity".
  9.)  Recompile the Quartus II project.

- This example design should be used with any of the Altera's Partner Development Board Daughter Cards
  (http://www.altera.com/products/devkits/kit-daughter_boards.jsp) listed below:
  
  1) 10/100 Ethernet PHY Daughter Card with National Semiconductor PHY (http://www.morethanip.com/boards_10_100_dp83848.htm)
  2) 10/100/1000 Ethernet PHY Daughter Board with Marvell PHY (http://www.morethanip.com/boards_10_100_1000_88E1111.htm)
  3) 10/100/1000 Ethernet PHY Daughter Card with National Semiconductor PHY (http://www.morethanip.com/boards_10_100_1000_dp83865.htm)

- The PHY daughter card should be installed on the PROTO 2 Santa Cruz connector located on the development board before running this 
  example design.

- Technical documentation for the PhyWorx Ethernet PHY Daughtercard is available from:
  http://www.morethanip.com/products_web/06_boards_hardware/02_10_100_1000_phy_88e1111/triple_phy_daughterboard_m_ref1.1.pdf 

- For more information, please refer to http://www.altera.com/support/examples/nios2/exm-nios2.html


# generated_app.mk
#
# Machine generated for a CPU named "cpu" as defined in:
# h:\Project\Ethernet\software\simple_socket_server_0_syslib\..\..\std_2s60.ptf
#
# Generated: 2009-12-07 21:07:08.296

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# assuming the Quartus project directory is the same as the PTF directory
QUARTUS_PROJECT_DIR = H:/Project/Ethernet

# the simulation directory is a subdirectory of the PTF directory
SIMDIR = $(QUARTUS_PROJECT_DIR)/std_2s60_sim

DBL_QUOTE := "


# macros defined by/for ext_flash
EXT_FLASH_FLASHTARGET_ALT_SIM_PREFIX = $(EXT_FLASH_FLASHTARGET_TMP1:0=)
EXT_FLASH_FLASHTARGET_TMP1 = $(ALT_SIM_OPTIMIZE:1=RUN_ON_HDL_SIMULATOR_ONLY_)
BOOT_COPIER = boot_loader_cfi.srec
CPU_CLASS = altera_nios2
CPU_RESET_ADDRESS = 0x3000000


all: delete_placeholder_warning flashfiles sim hex

delete_placeholder_warning: do_delete_placeholder_warning
.PHONY: delete_placeholder_warning

flashfiles: $(EXT_FLASH_FLASHTARGET_ALT_SIM_PREFIX)ext_flash.flash
.PHONY: flashfiles

sim: $(SIMDIR)/dummy_file
.PHONY: sim

hex: $(QUARTUS_PROJECT_DIR)/onchip_ram_64_kbytes.hex
.PHONY: hex

verifysysid: dummy_verifysysid_file
.PHONY: verifysysid

do_delete_placeholder_warning:
	rm -f $(SIMDIR)/contents_file_warning.txt
.PHONY: do_delete_placeholder_warning

$(EXT_FLASH_FLASHTARGET_ALT_SIM_PREFIX)ext_flash.flash: $(ELF)
	@echo Post-processing to create $(notdir $@)
	elf2flash --input=$(ELF) --flash= --boot=$(DBL_QUOTE)$(shell $(DBL_QUOTE)$(QUARTUS_ROOTDIR)/sopc_builder/bin/find_sopc_component_dir$(DBL_QUOTE) $(CPU_CLASS) $(QUARTUS_PROJECT_DIR))/$(BOOT_COPIER)$(DBL_QUOTE) --outfile=$(EXT_FLASH_FLASHTARGET_ALT_SIM_PREFIX)ext_flash.flash --sim_optimize=$(ALT_SIM_OPTIMIZE) --base=0x3000000 --end=0x3FFFFFF --reset=$(CPU_RESET_ADDRESS)

$(SIMDIR)/dummy_file: $(ELF)
	if [ ! -d $(SIMDIR) ]; then mkdir $(SIMDIR) ; fi
	@echo Hardware simulation is not enabled for the target SOPC Builder system. Skipping creation of hardware simulation model contents and simulation symbol files. \(Note: This does not affect the instruction set simulator.\)
	touch $(SIMDIR)/dummy_file

$(QUARTUS_PROJECT_DIR)/onchip_ram_64_kbytes.hex: $(ELF)
	@echo Post-processing to create $(notdir $@)
	elf2hex $(ELF) 0x02120000 0x212FFFF --width=32 $(QUARTUS_PROJECT_DIR)/onchip_ram_64_kbytes.hex --create-lanes=0

dummy_verifysysid_file:
	nios2-download $(JTAG_CABLE)                                --sidp=0x02131888 --id=991051294 --timestamp=1260225362
.PHONY: dummy_verifysysid_file


generated_app_clean:
	$(RM) $(EXT_FLASH_FLASHTARGET_ALT_SIM_PREFIX)ext_flash.flash
	$(RM) $(SIMDIR)/dummy_file
	$(RM) $(QUARTUS_PROJECT_DIR)/onchip_ram_64_kbytes.hex
.PHONY: generated_app_clean

# makefile for SOPC Builder example design

# Quartus files
QPF = $(shell echo *.qpf)
QP = $(notdir $(basename $(QPF)))
QSF = $(QP).qsf

# SOPC Builder files
PTF = $(shell echo *.ptf)
# system name
SYS = $(notdir $(basename $(PTF)))
# output of generated system
GEN = $(SYS)_log.txt

# handles problem in 4.2 b153 where dubbing results in MHz
# clock being stored in Hz field; need to multiply by 1E6
# to correct it.
define fix_ptf_clk
@x=`ptf_parse $(PTF) SYSTEM/WIZARD_SCRIPT_ARGUMENTS/CLOCKS/clk`;\
x=`echo $$x | perl -e 'my $$x=<>; if ($$x < 1000) { print $$x * 1000000; } else { print $$x; }'`; \
ptf_parse $(PTF) SYSTEM/WIZARD_SCRIPT_ARGUMENTS/CLOCKS/clk=$$x
endef

# SOF <- Quartus Project, SOPC Builder PTF
$(QP).sof : $(QPF) $(GEN) $(QSF)
	quartus_cmd $(QP) -c $(QSF)

# SOPC Builder dub & generate
$(GEN): $(PTF)
	sopc_builder $(PTF) \
		--playback_file=$(PTF) \
		--record_file=dubscript.ptf \
		--no_splash; \
		R=$$?; [ $$R = 4 ] || [ $$R = 2 ]
	-mv -f dubscript.ptf dubscript.txt
	$(fix_ptf_clk)
	sopc_builder $(PTF) \
		--generate --no_splash; \
		[ $$? = 4 ]

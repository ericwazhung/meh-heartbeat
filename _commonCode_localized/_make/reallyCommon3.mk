#/* mehPL:
# *    This is Open Source, but NOT GPL. I call it mehPL.
# *    I'm not too fond of long licenses at the top of the file.
# *    Please see the bottom.
# *    Enjoy!
# */
#
#
#
#
#
#
#reallyCommon3.mk -someNum...


# Changing over from reallyCommon2 to reallyCommon3:
# COMDIR in the makefile should now be CENTRAL_COMDIR, etc.

# Changing over from reallyCommon to reallyCommon2:
#  Add to makefile: (Uncomment indented commentted lines)
# (If using an AVR, definitely look into copying a code-block from there,
# as well, regarding PRINTF and STDIO and code-size)

#New a/o LCDdirectLVDSv128:
# If COMDIR/COMREL isn't defined, use CENTRAL_COMDIR/COMREL
# NOTE: COMDIR/COMREL should be replaced with CENTRAL_COMDIR/COMREL
# in makefiles... But this should still be backwards-compatible

#  This goes roughly after (CENTRAL_)COMDIR=...
# THIS CANNOT BE A MAKEFILE-SNIPPET IN COMDIR (duh) because COMDIR isn't
# yet set!


### THIS MUST BE IN YOUR MAKEFILE NEAR THE TOP 
# AFTER CENTRAL_COMDIR/COMREL definitions
# uncomment and unindent the indented lines:

################# SHOULD NOT CHANGE THIS BLOCK... FROM HERE ##############
#                                                                        #
# This stuff has to be done early-on (e.g. before other makefiles are    #
#   included..                                                           #
#                                                                        #
#                                                                        #
# LOCAL_COMDIR is the subdirectory of this project-directory where       #
#   _commonCode can be located for local usage.                          #
# (Unless you're me, this is most-likely where this project's            #
#  _commonCode is located)                                               #
 #LOCAL_COMDIR = _commonCode_localized
#                                                                        #
#                                                                        #
# If the file __use_Local_CommonCode.mk exists and contains "LOCAL=1"    #
# then code will be compiled from the LOCAL_COMDIR                       #
# This could be slightly more sophisticated, but I want it to be         #
#  recognizeable in the main directory...                                #
# ONLY ONE of these two files (or neither) will exist, unless fiddled with
# AND SHOULD contain 'LOCAL=0' and 'LOCAL=1', respectively.              #
 #SHARED_MK = __use_Shared_CommonCode.mk
 #LOCAL_MK = __use_Local_CommonCode.mk
#                                                                        #
 #-include $(SHARED_MK)
 #-include $(LOCAL_MK)
#                                                                        #
#                                                                        #
#                                                                        #
#COMREL/COMDIR: 
# The *actual* *used* _commonCode directory is in the variable "COMDIR"  #
# COMREL and COMDIR are automatically assigned the values from either    #
#  CENTRAL_COMREL/COMDIR or LOCAL_COMREL/COMDIR as appropriate.          #
# COMDIR will be used in all references to _commonCode, throughout this  #
#  makefile
# COMREL is used for compiling common-code into _BUILD...                #
 #ifeq ($(LOCAL), 1)
 #COMREL = ./
 #COMDIR = $(LOCAL_COMDIR)
 #else
 #COMREL = $(CENTRAL_COMREL)
 #COMDIR = $(CENTRAL_COMDIR)
 #endif
#                                                                        #
################# TO HERE ################################################


#For backwards compatibility with COMDIR rather than CENTRAL_COMDIR:
#NO! This won't work!
# COMDIR may be set to LOCAL_COMDIR long before we get here...
#ALSO: CENTRAL_COMDIR is used, if not-defined, to warn about upgrading to
# it... among other things?
#ifneq ($(LOCAL),1)
#ifndef CENTRAL_COMDIR
#CENTRAL_COMDIR = $(COMDIR)
#endif
#ifndef CENTRAL_COMREL
#CENTRAL_COMREL = $(COMREL)
#endif
#else




#
#
#  Attempting to copy _commonCode to local directory for building...
#  This could get hokey, as it'd also be nice to copy this file, etc.
#  Which then would require... accessing the actual file in _commonCode
#   when making clean, and accessing the copied file otherwise (?)
#   TODO: Figure that out...
#
#	Funny Note: I suppose this is getting closer to svn or cvs...
#   TODO: Might also be handy to make changes to local commonCode and
#         re"upload" them to the main "repository" hehehehe
#         (am thinkink I reinvent the wheel, and "the wheel keeps on
#          turning and turning and turning yeah... nothing can stop it,
#           the way it goes around")
#
# Haven't been keeping this list up to date...
# There're probably several changes between each noted version that aren't
# at all noted...

# No idea what version number...
#  adding PROJ_PREMAKE to target 'all'
#  a/o LCDdirectLVDS76, this is very specific, but PROJ_PREMAKE could
#  probably be used in many other ways...
#  Used for allowing conditional code in the project's makefile based on a 
#  configuration file (a header) which can be parsed into a makefile
#  snippet, which can then be included in the project makefile
#  (So probably requires two 'make' calls if the file changes)
# ACTUALLY THAT'S UNNECESSARY. But leaving PROJ_PREMAKE is OK...
#  (see 'info make' "3.5 How Makefiles Are Remade"
# 17ish... WHOOPS, broke "make" for non-avr (pc-based) apps
#          Fixed. Plus "make run"
#2++ - Looking into 'make openDir', an idea to open 
#          commonCode files/folders
#      Called As (e.g.) : 'make openDir file=bitHandling'
#... - Added 'make includes' to list all included-files...
#2-?+1 - Removing necessity for TWO verifications on make-clean
#2-? - Haven't been updating... fixed tarball so it's not COMREL specific
#      Added RSYCNABLE and copyCommon
#      Adding 'make local'
#      TODO: read notes in 'make tarball'!
#             ALSO: 'make tarball' may no longer be relevent since
#             backup.sh + copyCommon... 
#             BUT: if it's handled in here, then we can have something
#             to automatically set LOCAL=TRUE if wanted...
#2-0 - First version a/o avr/audioThing18
#      First Step, fix "make clean" to remove all compilation files
#      as opposed to just those in _BUILD
#      (at least, those that're misplaced, 
#               e.g. polled_uar/test/polled_uar.o)
#
#Original Explanation for reallyCommon.mk:
# common.mk is actually not-so-common, being specific to AVRs
#  This (reallyCommon.mk) is an attempt at a common makefile for
#   any sort of build... to be included by the program's makefile
#  Ideally, I suppose, common.mk would be renamed to, say, avrCommon.mk
#   and this would become common.mk
#   Not sure which'd be better, 
#     probably: test $(MCU) here, and include avrCommon.mk
#
# OLD NOTE:
# Sample makefile 
# original by Eric B. Weddington, et al. for WinAVR
# modified for _common "libraries" and other goodies by Eric Hungerford
#
# Maybe someday to be released to the Public Domain
# Please read the make user manual!
#
#
# On command line:
# make = Make software.
# make clean = Clean out built project files.
#
# To rebuild project do "make clean" then "make".
#





# THIS MUST BE BEFORE ANY ADDITIONAL INCLUDES!
# Include this and the MCU-specific makefile in the tarball...
# (This could probably just be done specifically in the tarball function)
# This isn't particularly sophisticated, listing them all here
# Maybe they should add themselves when included...?
# Not too wise to use thisFile since if it's used in other files it'd
# be rewritten... and who knows what it'll be when...
#thisFile := $(lastword $(MAKEFILE_LIST))

# See MAKEFILE_LIST in 'info make'
# Basically, lastword of MAKEFILE_LIST is whatever the most recently-
#  included file may be... (thus if an include were allowed to happen
#   /before/ this, it would *NOT* refer to *this File*)
# Doing this so we don't have to worry about it come reallyCommon3.mk
reallyCommonFile := $(lastword $(MAKEFILE_LIST))

# Can't put lastword in COM_MAKE += because it won't evaluate it until
# the end...
COM_MAKE += $(reallyCommonFile)
#		$(lastword $(MAKEFILE_LIST))
#      $(COMDIR)/_make/reallyCommon2.mk
#     $(COMDIR)/_make/common.mk

# OTHER MAKEFILES: Should include themselves in COM_MAKE...
# They don't include themselves... avrCommon.mk includes them.
#$(COMDIR)/_make/$(MCU).mk



# This needs to be done in the original (project) makefile
# Otherwise it'll use the actual comdir reallyCommon2.mk
#  rather than the local one...
#  which may not be too happy if the project folder's been moved
#  or extracted from a tarball...
#ifdef LOCAL
#COMDIR=$(LOCAL_COMDIR)
#COMREL=./
#endif


# If use_LocalCommonCode.mk exists and contains "LOCAL=1"
# then code will be compiled from the LOCAL_COMDIR
# This could be slightly more sophisticated, but I want it to be
#  recognizeable in the main directory...
# ONLY ONE of these two files (or neither) will exist, unless fiddled with	
#SHARED_MK = __use_Shared_CommonCode.mk
#LOCAL_MK = __use_Local_CommonCode.mk
#-include $(SHARED_MK)
#-include $(LOCAL_MK)







# RE: SPACES IN FILENAMES / PATHS:
# BAD IDEA
# but one example where I ran into it is after making a tarball and 
# trying to build from it...

# The following three lines are necessary for spaces in filenames
# The idea: convert spaces to '?' call notdir, then convert back to spaces
# Thanks to Ville Laurikan for this
# http://stackoverflow.com/questions/1189781/using-make-dir-or-notdir-on-a-path-with-spaces
s? = $(subst $(empty) ,?,$1)
?s = $(subst ?, ,$1)
notdirx = $(call ?s,$(notdir $(call s?,$1)))


# RE: SPACES IN FILENAMES / PATHS:
# BAD IDEA
# (Just wanted to reiterate)
# And also note that the above fix isn't implemented everywhere
# It's only for notdir, and I've also used dir, and whatnot elsewhere

# This is *ONLY* the project directory... no path, and no version
# e.g. audioThing (is that the case a/o here, or at the end...?)
PROJ_DIR = $(call notdirx,$(patsubst %/,%,$(dir $(PWD))))

# Extract the path relative to COMREL
# This is used in tarballing, and possibly later for local commonCode
# e.g. running make from: 
#     /Users/meh/_avrProjects/audioThing/18-buildComCodeFromLocalSources
#     COMREL=../../.. (/Users/meh/_commonCode/)
# -> _avrProjects/audioThing/18-buildComCodeFromLocalSources 
PROJ_DIR_REL = $(patsubst $(abspath $(PWD)/$(COMREL))/%,%,$(PWD))


# CAN this go in common.mk if it's located in the _common directory?
#Title of this version... 
# namely, the directory in which the main source exists
# In my typical scheme, this contains a version number 
#   and a note about the changes made
# This is kinda a hacked-use of notdir, since PWD does not show a "/"
#  at the end
# notdir thinks the last directory in PWD is actually a file name. (sweet)
VER_TITLE = $(call notdirx,$(PWD))

# Extract the version number from the project directory
# e.g. ~/projectTitle/ver-description -> VER_NUM = ver
# e.g.2 ~/threePinIDer/47i-speedupExperiments10 -> VER_NUM = 47i
VER_NUM = $(shell temp="$(VER_TITLE)";echo $${temp%%-*})


#COMMON_DIRS is used for making a tarball...
# THIS DOESN"T WORK WITH INLINE_ONLY STUFF!!!
# That's handled separately now...
COMMON_DIRS := $(dir $(SRC))

#COMMON_STUFF is dealt with later, due to includes...

#MY_SRC must be added to SRC after the above
SRC += $(MY_SRC)

#.o (and likely .lst, .d, and .s) files will be located in the BUILD_DIR
# directory under the main project directory
BUILD_DIR = _BUILD

# This should be in the project make-file
# AND IT SHOULD NEVER BE REFERENCED IF NOT DEFINED
# otherwise who knows where things'll be placed
#LOCAL_COMDIR = _commonCode_localized


# THE FOLLOWING SHOULD BE RENAMED!!!!
# They are imaginary source-files to be renamed with actual extensions
# later down the road and placed in the directory in their (initially)
# imaginary path...
# In most cases COMREL will be ../..
# Strip leading "../../" from the SRC's setup by common-libraries...
#  (it will be added again manually later) ???
# Replace "../../" with "$(BUILD_DIR)/"
# THIS IS NOT THE SAME as COM_LIB_SRC
# THIS includes all SRC including non common-libraries...
# So there's really no reason to call it this.
##ALLSRC = $(patsubst $(COMREL)/%,$(BUILD_DIR)/%,$(SRC))

# This is all the files that are NOT in the _common folder...
# Assuming I don't do anything crazy, they're either in or in a subdirectory
# of the project-dir...
##LOCALSRC = $(filter-out $(BUILD_DIR)/%,$(ALLSRC))
##COMLIBSRC = $(filter $(BUILD_DIR)/%,$(ALLSRC))
# This is where they should go under $(BUILD_DIR)
# (prepend BUILD_DIR to the file-path)
##BUILD_DIR_SRC = $(patsubst %,$(BUILD_DIR)/%,$(LOCALSRC))
# Now add the COMLIBs back...
##BUILD_DIR_SRC += $(COMLIBSRC)

# One-liner...
# Strip COMREL "../.." and you're left with either an untouched local file
#  or a library referenced from (and including) _commonCode/
# Append BUILD_DIR and all's well and good. DUH!
buldDirSrcPercent:=%
# patsubst FROM,TO,TEXT
# inner patsubst: looks in $(SRC) for '$(COMREL)/%'
#                                     essentially $(COMREL)/*
#                 replaces '$(COMREL)/%' with '%' 
#                                     (stripping '$(COMREL)/')
# outer patsubst: looks in the above for anything (% ~= *)
#                 replaces '%' with '$(BUILD_DIR)/%'
#                                     (prefixing with '$(BUILD_DIR)/')
#### ALSO apparently replaces .c with .d!
#### So doesn't work with clean_list, properly
#### The only reason it worked, I suppose, is because BUILD_DIR itself is
#### ultimately removed, except e.g. when building a commonCode test
#### where the .o file for the commonThing was stored in the project
#### directory, rather than _BUILD.
#### TODO: Ideally, the commonThing.o would be stored in _BUILD.
BUILD_DIR_DEPS = \
	$(patsubst %.c,%.d,\
	  $(patsubst %,$(BUILD_DIR)/%,\
	                              $(patsubst $(COMREL)/%,%,$(SRC))\
		)\
	 )
#BUILD_DIR_SRC=$(BUILD_DIR_SRC:.c=.d)

# RENAME THE ABOVE...

# This includes mostly special warnings that I'd rather be considered
# errors...
# This include could be removed if extra warnings aren't wanted...

#This is a hack... apple's gcc doesn't have support for these options	
ifdef MCU
include $(COMDIR)/_make/commonWarnings.mk
endif



# These haven't been used in a while... but probably still exist
# in some common code...
# Actually, appears to be more common still than I expected...
# I wonder what I could learn by setting these true...
ifndef TODO_WARN
TODO_WARN = FALSE
endif
ifndef ERR_WARN
ERR_WARN = FALSE
endif
ifndef UNKN_WARN
UNKN_WARN = FALSE
endif
ifndef OPTIM_WARN
OPTIM_WARN = FALSE
endif

CFLAGS += -D'__TODO_WARN__=$(TODO_WARN)' \
          -D'__ERR_WARN__=$(ERR_WARN)' \
          -D'__UNKN_WARN__=$(UNKN_WARN)' \
          -D'__OPTIM_WARN__=$(OPTIM_WARN)'


#The remaining are CFLAGS for -W... arguments
# Warnings that I would rather be considered errors...

CFLAGS += -Wall
CFLAGS += -Wstrict-prototypes





# TRUE and FALSE are not defined by default... if a C file doesn't include bithandling, then we're screwed...
# instead, define TRUE and FALSE using gcc -D...

CFLAGS += -D'TRUE=1' -D'FALSE=0' 

#TODO: (Not sure what this is...)
#include $(suffix $(LIBLIST), .mk)



## Main... target file-name is determined by PROJECT
## Target file name (without extension).
#TARGET = main
ORIGINALTARGET := $(TARGET)
TARGET := $(BUILD_DIR)/$(TARGET)



#OLD, probably shouldn't be here...
# List Assembler source files here.
# Make them always end in a capital .S.  Files ending in a lowercase .s
# will not be considered source files but generated files (assembler
# output from the compiler), and will be deleted upon "make clean"!
# Even though the DOS/Win* filesystem matches both .s and .S the same,
# it will preserve the spelling of the filenames, and gcc itself does
# care about how the name is spelled on its command-line.
#ASRC = 


# Apparently this has to be before the Targets that use it in avrCommon.mk
# Before this was moved here...
# Oddly: "$(TARGET).elf:$(OBJ) -> echo '$^'" would give nada
# Whereas:                        echo '$(OBJ)' would give the expected

OBJ = $(BUILD_DIR_DEPS:.d=.o) $(ASRC:.S=.o)


#Do this before OPT (below) so MCU's OPT=s will override this one's (2?)
# NOTE That reallyCommon2.mk's default-target is overridden by avrCommon's
ifdef MCU
include $(COMDIR)/_make/avrCommon.mk
endif


# Optimization level (can be 0, 1, 2, 3, s) 
# This should probably be 's' if MCU and 2 if computer...?
# (Note: 3 is not always the best optimization level. See avr-libc FAQ)
# This ifndef also allows for makefile's predefining it differently
# (as long as the same ifndef exists in avr.mk, etc.)
ifndef OPT
OPT = s
endif




# SOME OF THESE MAY NOT BE IDEAL for a computer...
# -g = include debugging info, -O = optimization level
# -f's define things which are usually system-dependent
#      e.g. "char" could be signed or unsigned depending on the system
CFLAGS += -g -O$(OPT) -funsigned-char -funsigned-bitfields -fpack-struct \
			 -fshort-enums 


# Pass on some assembler options. Specifically: create a listing file
# (.lst) (is this useful on a computer?)

# None of these -a[hlms] options are available in Mac's as
# The actual xFLAGS lines and description are in avr.mk
#CFLAGS += -Wa,-ahlms=$(patsubst %.c,%.lst,$(patsubst %,$(BUILD_DIR)/%,$(patsubst $(COMREL)/%,%,$<)))

# Optional assembler flags.
#ASFLAGS = -Wa,-ahlms=$(<:.S=.lst),-gstabs 

# -Map is not available in Mac's ld
# Optional linker flags.
#LDFLAGS += -Wl,-Map=$(TARGET).map,--cref





# Additional libraries
# -lm = math library
#LDFLAGS += -lm


# Handled above
#ifdef MCU
#include avr.mk
#endif

# Define programs and commands.
SHELL = sh

#These are defined in avr.mk, if included...
#This isn't possible with "CC" since it's defined by default...
#ifndef CC
ifeq ($(origin CC),default)
CC := gcc
endif

# There doesn't appear to be (installed) a regular objcopy or objdump
#OBJCOPY = avr-objcopy
#OBJDUMP = avr-objdump


#This is an attempt at trying to figure out whether to use myrm.sh or rm
#MYRMEXISTS = $(shell if [ -e /Users/meh/myexecs/myrm.sh ] ; then echo 1 ; else echo 0 ; fi )
#This doesn't work, apparently...
# It works (with ifeq 1, below) when myrm.sh *does* exist, 
# but not when it doesn't.
#MYRMEXISTS = $(shell which myrm.sh > /dev/null ; echo $? )
MYRMLOCATION = $(shell which myrm.sh)


#ifeq ($(MYRMEXISTS),0)
#ifeq ($(MYRMEXISTS),1)
ifeq ($(MYRMLOCATION),)
REMOVE = rm -r -f
else
#REMOVE = /Users/meh/myexecs/myrm.sh --dont-ls-subdirs -r -f
REMOVE = myrm.sh --dont-ls-subdirs -r -f
endif

COPY = cp

# Doesn't appear to exist nor to be called...
# (I've never seen a complaint about it not existing, so it mustn't be
#  called, despite its appearing to, below)
#ELFCOFF = objtool

INDENTEXISTS = $(shell if [ -e /Users/meh/myexecs/indent.sh ] ; then echo 1 ; else echo 0 ; fi )

#ifndef because avrCommon defines it as avr-size...
# which means that indent isn't used for avrs... ah well.
ifndef ELFSIZE

ifeq ($(INDENTEXISTS),0)
#ELFSIZE = size -m $(TARGET)
#see reallyCommon.mk (yeah, got there first, weird)
#size -m doesn't work...
ELFSIZE = echo " *** 'size -m' is broken... ***"
else
ELFSIZE = /Users/meh/myexecs/indent.sh -5 size -m $(TARGET)
endif

endif

FINISH = echo Errors: none
BEGIN_SEPARATOR = echo -------- begin --------
END_SEPARATOR = echo --------  end  --------



# Define all object files.
# This has been moved obove... 
#OBJ = $(COMLIBSRC:.c=.o) $(ASRC:.S=.o) 
#OBJ = $(BUILD_DIR_DEPS:.d=.o) $(ASRC:.S=.o) 

# Define all listing files.
LST = $(ASRC:.S=.lst) $(SRC:.c=.lst)

# Combine all necessary flags and optional flags. 
# Target processor is added to ALL_xFLAGS in avr.mk, so += here...
ALL_CFLAGS += -I. $(CFLAGS)
ALL_ASFLAGS += -I. -x assembler-with-cpp $(ASFLAGS)


#for AVR this is: $(TARGET).elf $(TARGET).hex $(TARGET).eep $(TARGET).lss
ifndef TARGETS
TARGETS = $(TARGET)
endif







# Moved *just before* the targets, due to the following:
####### NOGO ::: COM_MAKE IS MODIFIED AFTER THIS DUE TO INCLUDES
# NO INCLUDES SHOULD FOLLOW THIS
COMMON_STUFF := $(COMMON_DIRS) $(COM_HEADERS) $(COM_MAKE)

# Toward copying commonCode to source directory...
COMMON_STUFF_ABS := $(abspath $(COMMON_STUFF))

# e.g. ../../../_commonCode -> /Users/meh/_commonCode
COMDIR_ABS := $(abspath $(COMDIR))

# Insert /./ after _commonCode so rsync will know to keep the path 
# thereafter
# Looks like it returns without a trailing /
#  which is what I think we want for rsync anyhow, YAY!
RSYNCABLE_COMMON_STUFF := \
		$(patsubst $(COMDIR_ABS)/%,$(COMDIR_ABS)/./%,$(COMMON_STUFF_ABS))

# a/o reallyCommon3.mk:
# We now have rC3-scripts/
RSYNCABLE_COMMON_STUFF += \
		$(patsubst $(COMDIR_ABS)/%,$(COMDIR_ABS)/./%,$(COMDIR_ABS)/_make/rC3-scripts)




#BACKUP_DIR = "backup_$(MCU)_$(shell date '+%Y-%m-%d_%H.%M.%S')"




#Check if CENTRAL_COMDIR exists
# If not, there's no reason to bombard users with messages about which
# directory is being used...
ifneq ($(wildcard $(CENTRAL_COMDIR)),)

ifeq ($(LOCAL), 1)
endLocalizationMessage = endLocal
else
endLocalizationMessage = endCentral
endif

else
# CENTRAL_COMDIR doesn't exist, so don't bombard the user with messages
endLocalizationMessage = 
endif


###############################################
#####
#####  THIS IS THE DEFAULT TARGET ('all')
#####    when called as 'make'
#####
#####  Don't put any targets before this, or they'll be default!
################################################

ifdef PROJINFO_TARGET
# Default target.
.PHONY: all
all: $(PROJ_PREMAKE) projInfo begin sizebefore $(TARGETS) sizeafter finished end
else
.PHONY: all
all: begin sizebefore $(TARGETS) sizeafter finished end
endif
 

# This is a target-specific variable... 
# Personally, I think this is confusing, as it looks like a target



###############
# Added a/o LCDrevisited2012-27, in order to figure out who was calling
# stdio (and thus, why vfprintf was being compiled-in)
# Turns out stdio *wasn't* called, but there was an LDFLAG...
#   (see avrCommon.mk for more details)
#
#'make includes':
#	This is pretty hokily-implemented...
#  Best idea: 'make clean' first, then 'make includes'
#  this will create .o files in _BUILD, and its subdirs, that contain
#  a list of the #includes...
#
#  then you can e.g. 'grep -r stdio.h _BUILD/*'
#  or 'find ./_BUILD/ -name \*.o -exec cat {} \;'
#
#  Be sure to run 'make clean' after you're done.
#
#  Note that includesMessage never runs because the build fails when trying
#  to create the final output-file since the object-files are not actually 
#  compiled code. 
#  That's just how this is currently implemented
#
includes: ALL_CFLAGS += -M


.PHONY: includes
includes: $(TARGETS) includesMessage

.PHONY: includesMessage
includesMessage:
	@echo ""
	@echo "includes-lists have been placed in .o files under _BUILD"
#
###############

#Could be handy if modified for computer... (see avrCommon.mk)
#.PHONY: projInfo
#projInfo:
#	@echo -n ""
# ...Nothing to do here...

# Eye candy.
.PHONY: begin
begin:
	-@$(BEGIN_SEPARATOR)

.PHONY: finished
finished:
	-@$(FINISH)


.PHONY: endLocal
endLocal:
	@echo ""
	@echo "You're using the LOCALIZED _commonCode source in: "
	@echo "  '$(LOCAL_COMDIR)'"
	@echo "  ('$(abspath $(LOCAL_COMDIR))')"
	@echo "  Changes in the centralized directory:"
	@echo "  '$(CENTRAL_COMDIR)'"
	@echo "   ('$(abspath $(CENTRAL_COMDIR))')"
	@echo "  will not be reflected in this project!"
	@echo "  (To change this, run 'make delocalize')"
	@echo "  (To override temporarily, run 'make ... LOCAL=0')"
	@echo ""


.PHONY: endCentral
endCentral:
	@echo ""
	@echo "You're using the CENTRALIZED _commonCode source in:"
	@echo "  '$(CENTRAL_COMDIR)'"
	@echo "   ('$(abspath $(CENTRAL_COMDIR))')"
	@echo "  (To use code in '$(LOCAL_COMDIR)', run 'make localize')"
	@echo "  (To override temporarily, run 'make ... LOCAL=1')"
	@echo ""


.PHONY: endSeparator
endSeparator:
	-@$(END_SEPARATOR)

.PHONY: end
end: endSeparator endWarnings $(endLocalizationMessage)


.PHONY: endWarnings
endWarnings:
	@echo "$(END_WARNINGS)"

# Display size of file.
.PHONY: sizebefore
sizebefore:
	@if [ -f $(TARGET).elf ] || [ -f $(TARGET) ] ;\
	 then\
		 echo "Before:" ;\
		$(ELFSIZE);\
	 fi


.PHONY: sizeafter
sizeafter:
	@if [ -f $(TARGET).elf ] || [ -f $(TARGET) ] ;\
	 then\
	 	echo "After:";\
	  	$(ELFSIZE);\
	 fi



#This is hacked... 
# Link: create ELF output file from object files.
# Not exactly sure what .SECONDARY does, but it caused oddities on Mac:
#  sizeAfter (as well as end) would run before this completes
#  (so there would be no sizeafter information)
#  Oddly, only if made-clean first
#NOTE: If using an AVR: This is overridden by avrCommon.mk
# See there for other notes, as well.
#.SECONDARY : $(TARGET).elf
.PRECIOUS : $(OBJ)
$(TARGET): $(OBJ)
	@echo "### TARGET(.elf?):OBJ   Linking $@ from $^"
	@$(CC) $(ALL_CFLAGS) $(OBJ) --output $@ $(LDFLAGS)

#$(BUILD_DIR)/$(TARGET).elf:
#	@echo "### Linking $(BUILD_DIR)/$(TARGET).elf from $^"
#@$(CC) $(ALL_CFLAGS) $(OBJ) --output $@ $(LDFLAGS)

# Compile: create object files from C source files.
%.o: %.c
	@echo "### .o:.c   Compiling $@ from $^"
	@$(CC) -c $(ALL_CFLAGS) $< -o $@


$(BUILD_DIR)/%.o : %.c
	@mkdir -p $(dir $@)
	@echo "### comObjs: .o:.c Compiling $@ from $^:"
	@$(CC) -c $(ALL_CFLAGS) $< -o $@


$(BUILD_DIR)/%.o : $(COMREL)/%.c
	@mkdir -p $(dir $@)
	@echo "### comObjs: .o:.c Compiling $@ from $^:"
	@$(CC) -c $(ALL_CFLAGS) $< -o $@



# Compile: create assembler files from C source files.
%.s: %.c
	@echo "### .s:.c   Creating Assembler File $@ from $^"
	@$(CC) -S $(ALL_CFLAGS) $< -o $@


$(BUILD_DIR)/%.s : $(COMREL)/%.c
	@mkdir -p $(dir $@)
	@echo "### comObjs: .s:.c   Compiling $@ from $^:"
	@$(CC) -S $(ALL_CFLAGS) $< -o $@



# Assemble: create object files from assembler source files.
%.o: %.S
	@echo "### .o:.S   Compiling Assembler $@ from $^"
	@$(CC) -c $(ALL_ASFLAGS) $< -o $@

# Automatically generate C source code dependencies. 
# (Code originally taken from the GNU make user manual and modified (See README.txt Credits).)
# Note that this will work with sh (bash) and sed that is shipped with WinAVR (see the SHELL variable defined above).
# This may not work with other shells or other seds.
#NOTE: This particular one doesn't seem to be used (a/o LCDdirectLVDSv128)
%.d: %.c
	@echo "### .d:.c   generating dependencies $@ from $^"
	@set -e; $(CC) -MM $(ALL_CFLAGS) $< \
	| sed 's,\(.*\)\.o[ :]*,\1.o \1.d : ,g' > $@; \
	[ -s $@ ] || rm -f $@
#echo "### .d:.c  Creating Dependency Listing $@ from $^"

#When localized, main.c is handled by this one... (Weird?)
# Nah, COMREL is ./ in this case... so it makes sense...
$(BUILD_DIR)/%.d : $(COMREL)/%.c
	@echo "### BUILD_DIR/.d:COMREL/.c   generating dependencies $@ from $^"
	@mkdir -p $(dir $@)
	@set -e; $(CC) -MM $(ALL_CFLAGS) $< \
	| sed 's,\(.*\)\.o[ :]*,\1.o \1.d : ,g' > $@; \
	[ -s $@ ] || rm -f $@
#@echo "### comObjs: .d:.c Creating Dependency Listing $@ from $^:"

#When NOT localized, main.c is handled by this one...
$(BUILD_DIR)/%.d : %.c
	@echo "### BUILD_DIR/.d:.c   generating dependencies $@ from $^"
	@mkdir -p $(dir $@)
	@set -e; $(CC) -MM $(ALL_CFLAGS) $< \
	| sed 's,\(.*\)\.o[ :]*,\1.o \1.d : ,g' > $@; \
	[ -s $@ ] || rm -f $@
#@echo "### LocalObjs: .d:.c Creating Dependency Listing $@ from $^:"


ifneq ($(LOCAL), 1)
ifdef LOCAL_COMDIR


.PHONY: $(LOCAL_COMDIR)
$(LOCAL_COMDIR):
	@echo "Localizing CommonFiles:" ; \
	if [ ! -d "$(LOCAL_COMDIR)" ] ; then \
	 mkdir $(LOCAL_COMDIR) ; \
	 rsync -avR --exclude=_BUILD $(RSYNCABLE_COMMON_STUFF) \
	 										$(LOCAL_COMDIR) ; \
	else \
	 echo "" ; \
	 echo "#############################################################################" ;\
	 echo "# HEY!!! '$(LOCAL_COMDIR)/' already exists, not going to overwrite it." ; \
	 echo "# If you're sure you want to overwrite it with stuff from:" ;\
	 echo "   '$(CENTRAL_COMDIR)'" ;\
	 echo "    ('$(abspath $(CENTRAL_COMDIR))')" ;\
	 echo "# Then delete $(LOCAL_COMDIR) AND __use_Local_CommonCode.mk" ;\
	 echo "# And re-run 'make localize' " ;\
	 echo "#############################################################################" ;\
	 echo "" ; \
	fi

.PHONY: copyCommon
copyCommon:
	@$(REMOVE) $(LOCAL_COMDIR)
	@mkdir $(LOCAL_COMDIR)
	@rsync -avR --exclude=_BUILD $(RSYNCABLE_COMMON_STUFF) $(LOCAL_COMDIR)

ifdef LOCALIZABLE_OTHERS
ifdef OTHERS_DIR
.PHONY: localizeOthers
localizeOthers:
	@echo "Localizing other files:" ; \
	if [ ! -d "$(OTHERS_DIR)" ] ; then \
		mkdir ./"$(OTHERS_DIR)" ; \
		rsync -av $(LOCALIZABLE_OTHERS) ./$(OTHERS_DIR) ; \
	else \
		echo "" ; \
		echo " HEY!!! ./$(OTHERS_DIR) already exists, not going to overwrite it." ;\
		echo "" ; \
	fi

else
.PHONY: localizeOthers
localizeOthers:
	@echo "" ; \
	echo "HEY!!! OTHERS_DIR needs to be set to localize others!" ; \
	echo ""

endif
else
.PHONY: localizeOthers
localizeOthers:
	@echo "No Others to localize"

endif


endif


.PHONY: tarball
tarball:
	@echo "make tarball isn't as sophisticated as the rest of the makefile"
	@echo "It should be possible to use copyCommon then just create a tarball from the source directory alone"
	@echo "Further, this'll copy the real _commonCode AS WELL AS that in _local"
	@echo "BUT: were we to change it, should makefile somehow be modified to use LOCAL=TRUE by default?"
# THIS WILL NOT COPY HEADER-ONLY-LIBS! (e.g. bithandling)
# NOR WITH INLINE_ONLY STUFF!!!
# THIS ASSUMES TARGET is EQUAL to the directory it's stored in!
#	@echo "projDir='$(PROJ_DIR)'"
	@echo "Output File: ../$(PROJ_DIR)-$(VER_TITLE).tar.bz2"
	@echo "COMMON_DIRS: '$(COMMON_DIRS)'"
	@echo "COM_HEADERS: '$(COM_HEADERS)'"
	@echo "COM_MAKE: '$(COM_MAKE)'"
#	@echo "PROJ_DIR/VER_TITLE: '$(PROJ_DIR)/$(VER_TITLE)'"
#	@echo "PWD: '$(PWD)'"
#	@echo "PROJ_DIR_REL: '$(PROJ_DIR_REL)'"
	@tar -cjvf ../$(PROJ_DIR)-$(VER_TITLE).tar.bz2 $(COMMON_DIRS) \
	  	$(COM_HEADERS) $(COM_MAKE) -C $(COMREL) "$(PROJ_DIR_REL)"
	@echo "-------------------------------------------------"
	@echo "!!!"
	@echo "DO NOT FORGET to check this before distributing..."
	@echo "  common headers and inline-only stuff may be missing!"
	@echo "!!!"
#	@if [ "$(COMREL)" != "../.." ] ;\
#	 then\
#	 echo "DOESN'T PLAY NICE WITH COMREL != '../..' your COMREL='$(COMREL)'" ; \
# 	 fi
# WAS:
#@tar -cjvf ../$(PROJ_DIR)-$(VER_TITLE).tar.bz2 $(COMMON_DIRS) \
#   $(COM_HEADERS) $(COM_MAKE) -C ../../ "$(PROJ_DIR)/$(VER_TITLE)"

endif
	
.PHONY: list
list:
	@echo ""
	@echo "BEWARE: This isn't necessarily all-inclusive"
	@echo " Especially if a commonLib is _INLINE_ONLY"
	@echo ""
	@echo "SRC=" ;\
	stuff="$(subst ",\", $(SRC))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "COMMON_DIRS=" ;\
	stuff="$(subst ",\", $(COMMON_DIRS))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "ALL_CFLAGS=" ;\
	stuff="$(subst ",\",$(ALL_CFLAGS))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "LDFLAGS=" ; \
	stuff="$(subst ",\", $(LDFLAGS))" ; \
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "COM_MAKE=" ; \
	stuff="$(subst ",\", $(COM_MAKE))" ; \
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "COM_HEADERS=" ;\
	stuff="$(subst ",\", $(COM_HEADERS))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "MY_SRC=" ; \
	stuff="$(subst ",\", $(MY_SRC))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo RSYNCABLE_COMMON_STUFF= ; \
	stuff="$(subst ",\", $(RSYNCABLE_COMMON_STUFF))" ; \
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "TARGETS=" ; \
	stuff="$(subst ",\", $(TARGETS))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "ORIGINALTARGET=$(ORIGINALTARGET)"
	@echo "OBJ=" ;\
	stuff="$(subst ",\", $(OBJ))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "BUILD_DIR_DEPS=" ;\
	stuff="$(subst ",\", $(BUILD_DIR_DEPS))" ;\
	for thing in $${stuff} ; \
	do \
		echo " $${thing}" ; \
	done
	@echo ""
	@echo "COMREL=$(COMREL)"
	

#@echo $(RSYNCABLE_COMMON_STUFF)

#@echo "MAKEFILE_LIST="
#@echo $(MAKEFILE_LIST)
#@echo ""

.PHONY: openDir
openDir: openDirBegin end


.PHONY: openDirBegin
openDir:
	@if [ "`which openDirFromList.sh`" != "" ] ; \
	then \
		openDirFromList.sh $(file) $(RSYNCABLE_COMMON_STUFF) ; \
	else \
		echo "Sorry buddy, you need 'openDirFromList.sh' in your path to run this" ; \
	fi




ifdef LOCAL_COMDIR
#Just because I'm localizing, doesn't mean I want to use the current
# stuff from _commonCode, hopefully this will be smart enough to recognize
# that $(LOCAL_COMDIR) already exists, in that case
#  and doesnt try to update it...
#  NOPE... 
.PHONY: localize
ifneq ($(LOCAL), 1)
localize: begin $(LOCAL_COMDIR) localizeOthers setUseLocalFile finished endSeparator endLocal
else
localize:
	@echo ""
	@echo "You are already running localized"
	@echo ""
endif


#Should only be called from make localize
# mrm doesnt pay attention to -f
# so instead of $(REMOVE) we use /bin/rm
.PHONY: setUseLocalFile
setUseLocalFile: 
	@/bin/rm -f $(SHARED_MK)
	@echo "### BEST NOT MODIFY THIS FILE, use 'make (de)localize' instead" \
		> $(LOCAL_MK)
	@echo "# When this is 1, we'll use the files in " \
		>> $(LOCAL_MK)
	@echo "# $(LOCAL_COMDIR)" >> $(LOCAL_MK)
	@echo "# instead of the main _commonCode directory" \
		>> $(LOCAL_MK)
	@echo "# Its value can be overriden by e.g. 'make ... LOCAL=0'" \
		>> $(LOCAL_MK)
	@echo "LOCAL=1" >> $(LOCAL_MK)


ifeq ($(LOCAL),1)
.PHONY: delocalize
delocalize: begin centralizeFiles finished endSeparator delocalizeEndWarnings endCentral
else
delocalize:
	@echo ""
	@echo "You are already running centralized (delocalized)"
	@echo ""
endif


.PHONY: delocalizeEndWarnings
delocalizeEndWarnings:
ifdef DELOCALIZE_END_WARNINGS
	@echo "############################"
	@echo "## DELOCALIZATION NOTICE: ##"
	@echo "##                        ##"
	@echo "## $(DELOCALIZE_END_WARNINGS)"
else
	@echo -n ""
endif

.PHONY: centralizeFiles
centralizeFiles:
ifdef CENTRAL_COMDIR
	@$(COMDIR)/_make/rC3-scripts/delocalize.sh "$(CENTRAL_COMDIR)" "$(LOCAL_COMDIR)" "$(abspath $(CENTRAL_COMDIR))"
else
	@echo "Unable to check whether local commonCode differs from central commonCode"
	@echo "Consider changing COMDIR/REL to CENTRAL_COMDIR/REL in your makefile"
	@echo "AND copy over the new bits in the block from reallyCommon2.mk"
endif
	@/bin/rm -f $(LOCAL_MK) && \
	echo "### BEST NOT MODIFY THIS FILE, use 'make (de)localize' instead" \
		> $(SHARED_MK)	&& \
	echo "# When this is 1, we'll use the files in " \
		>> $(SHARED_MK) && \
	echo "# $(LOCAL_COMDIR)" >> $(SHARED_MK) && \
	echo "# instead of the main _commonCode directory" \
		   >> $(SHARED_MK) && \
	echo "# Its value can be overriden by e.g. 'make ... LOCAL=0'" \
		   >> $(SHARED_MK) && \
	echo "LOCAL=0" >> $(SHARED_MK)
endif


# Target: clean project.
.PHONY: clean
clean: begin clean_list finished end

ifdef LOCAL_COMDIR
.PHONY: cleanCommonLocal
cleanCommonLocal:
	@$(REMOVE) $(LOCAL_COMDIR) $(SHARED_MK) $(LOCAL_MK)


.PHONY: cleaner
cleaner: clean cleanCommonLocal
endif

# DO NOT change this to $(TARGET).* as it's likely there'll be a 
#  $(TARGET).c!!!
#### This note is old, BUILD_DIR_DEPS *is* .d, not .c, so it didn't do what
#### it was supposed to. .o files were left. Ironic this references
#### polled_uar, because that, again, is where I've run into this problem
#### a/o polled_uar 0.40-18/19
# $(BUILD_DIR_DEPS:.c=.d/.o) should also remove any commonCode .o/.d files
# 	that're non-standardly located... e.g. polled_uar/test/polled_uar.o
#  due to test's makefile referencing ../polled_uar as the _LIB path...
#  e.g. POLLED_UAR_LIB = ../polled_uar instead of = 
#    $(COMDIR)/.../$(VER_...)/...
# This addition makes "make clean" a little ugly when listing files to be
# removed...
# Trying to clean that up a bit... adding /* removes contents, but leaves
#  the BUILD_DIR, thus _BUILD/../polled_uar.o can be deleted in the next
#  round, without showing the huge list of all files...
#  @$(REMOVE) to suppress display of the command listing all files
#   requested...
ifdef PROJINFO_TARGET
.PHONY: clean_list
clean_list:
	$(REMOVE) projInfo.h \
				 $(BUILD_DIR_DEPS) \
				 $(BUILD_DIR_DEPS:.d=.o) \
				 $(BUILD_DIR)
else
.PHONY: clean_list
clean_list:
	$(REMOVE) $(BUILD_DIR_DEPS) \
				 $(BUILD_DIR_DEPS:.d=.o) \
				 $(BUILD_DIR)
endif
#	$(REMOVE) $(BUILD_DIR_DEPS:.c=.d) \
#				 $(BUILD_DIR_DEPS:.c=.o) \
#				 $(BUILD_DIR)
#	$(REMOVE) $(TARGET).hex $(TARGET).lss $(TARGET).eep $(TARGET).elf $(TARGET).map *.s *.d *.lst *.o $(BUILD_DIR)


# Remove the '-' if you want to see the dependency files generated.
#### This will rebuild *.d files during every single friggin' operation, including "clean"!
#-include $(COMLIBSRC:.c=.d)
# This from: 
#http://stackoverflow.com/questions/2773202/skip-makefile-dependency-generation-for-certain-targets-e-g-clean
ifneq ($(MAKECMDGOALS),clean)
-include $(BUILD_DIR_DEPS)
endif
#-include main.d

#Moved Above
#ifndef MCU
#.PHONY: run
#run: $(TARGET)
#	$(TARGET)
#endif


##############
# a/o audioThing40:
#
# 'make run' 
#    On a PC-application: would ideally run the program (with no arguments)
#    On an AVR project: is the equivalent of the old 'make flash'
#                       with a bit of new-handling for eeprom
#
# This probably should NOT be .PHONY, but I'm too tired to think of how to
# do it the 'right' way.
ifdef MCU
.PHONY: run
run: loadChip
else
run: $(TARGET)
	@echo	"################################################################################"
	@echo "#### make: RUNNING $(TARGET)"
	@echo	"################################################################################"
	$(TARGET)	
endif

#/* mehPL:
# *    I would love to believe in a world where licensing shouldn't be
# *    necessary; where people would respect others' work and wishes, 
# *    and give credit where it's due. 
# *    A world where those who find people's work useful would at least 
# *    send positive vibes--if not an email.
# *    A world where we wouldn't have to think about the potential
# *    legal-loopholes that others may take advantage of.
# *
# *    Until that world exists:
# *
# *    This software and associated hardware design is free to use,
# *    modify, and even redistribute, etc. with only a few exceptions
# *    I've thought-up as-yet (this list may be appended-to, hopefully it
# *    doesn't have to be):
# * 
# *    1) Please do not change/remove this licensing info.
# *    2) Please do not change/remove others' credit/licensing/copyright 
# *         info, where noted. 
# *    3) If you find yourself profiting from my work, please send me a
# *         beer, a trinket, or cash is always handy as well.
# *         (Please be considerate. E.G. if you've reposted my work on a
# *          revenue-making (ad-based) website, please think of the
# *          years and years of hard work that went into this!)
# *    4) If you *intend* to profit from my work, you must get my
# *         permission, first. 
# *    5) No permission is given for my work to be used in Military, NSA,
# *         or other creepy-ass purposes. No exceptions. And if there's 
# *         any question in your mind as to whether your project qualifies
# *         under this category, you must get my explicit permission.
# *
# *    The open-sourced project this originated from is ~98% the work of
# *    the original author, except where otherwise noted.
# *    That includes the "commonCode" and makefiles.
# *    Thanks, of course, should be given to those who worked on the tools
# *    I've used: avr-dude, avr-gcc, gnu-make, vim, usb-tiny, and 
# *    I'm certain many others. 
# *    And, as well, to the countless coders who've taken time to post
# *    solutions to issues I couldn't solve, all over the internets.
# *
# *
# *    I'd love to hear of how this is being used, suggestions for
# *    improvements, etc!
# *         
# *    The creator of the original code and original hardware can be
# *    contacted at:
# *
# *        EricWazHung At Gmail Dotcom
# *
# *    This code's origin (and latest versions) can be found at:
# *
# *        https://code.google.com/u/ericwazhung/
# *
# *    The site associated with the original open-sourced project is at:
# *
# *        https://sites.google.com/site/geekattempts/
# *
# *    If any of that ever changes, I will be sure to note it here, 
# *    and add a link at the pages above.
# *
# * This license added to the original file located at:
# * /home/meh/_commonCode/heartbeat/2.00-gitHubbing_+revisions/testMega328P+button+DMS/_commonCode_localized/_make/reallyCommon3.mk
# *
# *    (Wow, that's a lot longer than I'd hoped).
# *
# *    Enjoy!
# */

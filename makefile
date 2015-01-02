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


# Having trouble working with inline assembly experiments;
# the assembler is failing with pretty vague errors, and since I'm using
# macros both in cpp-form and asm-form it's hard to determine what exactly
# is responsible for the syntax errors.
# This is supposed to stop after compilation, prior to assembly
#CFLAGS += -S


# This gets modified for compilation to _BUILD/
# if needed after reallyCommon3.mk is included, Reference ORIGINALTARGET...
TARGET = heartbeatTest



### BECAUSE this is a commonThing test program, these should be defined:
THIS_COMMONTHING = HEARTBEAT
THIS_commonThing = heartbeat
#(They are used in commonThingEasyVersion.mk, which is included later)


MCU = atmega328p

FCPU = 8000000UL

MY_SRC = main.c

#Other source-code, e.g. that in _commonCode[_localized]/, will be included
#elsewhere



#SKIP THIS BLOCK...
#   'till "### TO HERE ###"


#CENTRAL_COMREL/COMDIR:
# THE FOLLOWING DEFINITIONS, THIS EXPLANATION, AND THE "###" BLOCK BELOW
# CAN BE IGNORED (But must be here)
#
# So here's an explanation:
#CENTRAL_COMREL/COMDIR:
#Location of the centralized _commonCode directory, relative to here...
# The contents of the _commonCode_localized directory, here, can be moved 
# to a centralized location 
# (e.g. CENTRAL_COMREL /home/you/_commonCode).
# Then each of your projects can use that same _commonCode directory...
# E.G. Bug-fixes to _commonCode will then trickle-down to all your 
# projects.
#
# To do this, run 'make delocalize'
#
# Then, to later copy *from* the centralized _commonCode directory
#  back to _commonCode_localized
#
# run 'make localize'
#
# CENTRAL_COMREL/CENTRAL_COMDIR should NOT be an absolute path... (nor '~')
#  Keep them in this format.
# ALSO: CENTRAL_COMREL should *not* end with '/'
#  ...COMREL is used for compiling common-code locally (into _BUILD).
#
# UNTIL you plan to use a centralized _commonCode directory, you can
# just ignore this and the following "####" block.
CENTRAL_COMREL = ../../../..
CENTRAL_COMDIR = $(CENTRAL_COMREL)/_commonCode

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
LOCAL_COMDIR = _commonCode_localized
#                                                                        #
#                                                                        #
# If the file __use_Local_CommonCode.mk exists and contains "LOCAL=1"    #
# then code will be compiled from the LOCAL_COMDIR                       #
# This could be slightly more sophisticated, but I want it to be         #
#  recognizeable in the main directory...                                #
# ONLY ONE of these two files (or neither) will exist, unless fiddled with
# AND SHOULD contain 'LOCAL=0' and 'LOCAL=1', respectively.              #
SHARED_MK = __use_Shared_CommonCode.mk
LOCAL_MK = __use_Local_CommonCode.mk
#                                                                        #
-include $(SHARED_MK)
-include $(LOCAL_MK)
#                                                                        #
#                                                                        #
#                                                                        #
#COMREL/COMDIR: 
# The *actual* *used* _commonCode directory is in the variable "COMDIR"  #
# COMREL and COMDIR are automatically assigned the values from either    #
#  CENTRAL_COMREL/COMDIR or LOCAL_COMREL/COMDIR as appropriate.          #
# COMDIR will be used in all references to _commonCode, throughout this 
#  makefile
# COMREL is used for compiling common-code into _BUILD...                #
ifeq ($(LOCAL), 1)
COMREL = ./
COMDIR = $(LOCAL_COMDIR)
else
COMREL = $(CENTRAL_COMREL)
COMDIR = $(CENTRAL_COMDIR)
endif
#                                                                        #
################# TO HERE ################################################







# Common "Libraries" to be included
#  haven't yet figured out how to make this less-ugly...


# There're lots of options like this for code-size
# Also INLINE_ONLY's see the specific commonCode...
#CFLAGS += -D'TIMER_INIT_UNUSED=TRUE'


######## DMS TIMER SPECIFIC STUFF #############

# Heartbeat uses the dmsTimer for precision timing in this project

# This version of heartbeat (1.30) uses dmsTimer 1.13 by default, 
# but the pwm161 requires dmsTimer 1.15

# BECAUSE This overrides the value set by heartbeat.mk, this must be set
# *before* heartbeat.mk is included
# (Otherwise, there's some weirdness with using 1.13 then changing the
# value to 1.15, which is a weird result of make's multi-pass technique?)
VER_DMSTIMER = 1.15
DMSTIMER_LIB = $(COMDIR)/dmsTimer/$(VER_DMSTIMER)/dmsTimer
include $(DMSTIMER_LIB).mk

#This doesn't make an ounce of sense to me... I don't see where 1.21 could
# possibly be referenced from. dmsTimer1.14 references 1.22...
#VER_TIMERCOMMON = 1.22

# dmsTimer (used by Heartbeat) typically uses Timer0
# The AT90PWM161 doesn't have a Timer0
# There are a couple options for not using and/or sharing Timer0
# Here we'll tell it to use Timer1
# Further, unlike most timers, this device's Timer1 doesn't have an 
# "Output Compare Register." Instead, it uses the Input Capture Register
# to clear the timer at a compare-match
#a/o dmsTimer1.15: These defaults now handled in dmsTimer.h
#CFLAGS += -D'DMS_AVRTIMER_SIG=TIMER1_CAPT_vect'
#CFLAGS += -D'DMS_AVRTIMER_NUM=1'
#CFLAGS += -D'DMS_AVRTIMER_OCR=ICR1'
#CFLAGS += -D'DMS_AVRTIMER_TCNT=TCNT1'

# The PWM161's Timer only has CLKDIV1...
#CFLAGS += -D'_DMS_CLKDIV_=CLKDIV1'
# But it is 16-bit...
#CFLAGS += -D'DMS_AVRTIMER_MAX=0xffff'

##### TODO: Handle errors earlier, so e.g. heartblink could work before dms
#####       timer is running...


######## TO HERE #########



######## HEARTBEAT SPECIFIC STUFF #########

# Probably best not to enable the WDT while testing/debugging!
WDT_DISABLE = TRUE

# HEART_DMS uses the deci-millisecond (dms) timer to cause the
# fading/blinking rates of the heartbeat to be consistent regardless of CPU
# load. If the FCPU is correct, it should take 8 seconds to cycle when
# fading, and each blink should be 1 second when heartBlink is set.
HEART_DMS = TRUE
# This is probably best, otherwise the pin is a variable, making it slower
# and bigger.
CFLAGS += -D'HEARTPIN_HARDCODED=TRUE'
# Heartbeat is on MISO 
#  since AVR's can drive up to 40mA it shouldn't affect programming
# a/o the writing of this (atmega328p), these are now handled by default:
# Placing the heartbeat on the programming-header's MISO pin
# If you need to override that, enter the proper values here:
#CFLAGS += -D'HEART_PINNUM=PB6'
#CFLAGS += -D'HEART_PINPORT=PORTB'
# The heartbeat LED is connected: PB6 >----|<|---/\/\/\---> V+
# This should be the case 99% of the time, as it also allows the heart-pin
# to be used for a momentary-pushbutton input.
# a/o atmega328p, this is now default unless overridden
#CFLAGS += -D'HEART_LEDCONNECTION=LED_TIED_HIGH'

#For the heartbeat pin being shared with a momentary pushbutton:
# This value is a number of loops to delay in order to wait for the pull-up
# resistors to overcome various capacitances.
# Its maximum value is 255, (which is the default, if not entered here)
# 255 should be *way* higher than necessary, and should pretty much be
# guaranteed to work.
# If you feel so inclined to optimize things, just keep in mind that
# decreasing this value too low will cause heartPinInputPoll() to return 0
# even if the pushbutton isn't activated.
# Further, keep in mind that the value is sensitive to CPU speed, as well
# as external circuitry (e.g. what's the capacitance of that LED?)
CFLAGS += -D'HEART_PULLUP_DELAY=255'



#This should be set to a specific value for your project.
# Verify the version here matches the folder:
#   _commonCode_localized/heartbeat/<version>
# And uncomment the following line.
#VER_HEARTBEAT = 2.00-gitHubbing

# For this particular case, we can extract the version-number from the
# current working directory, so that this makefile (and indeed most--if not
# all--heartbeat test-code) needn't be modified with each version of
# heartbeat... 
# (When you set VER_HEARTBEAT, above, commonTestEasyVersion.mk 
#  will be automatically disabled. BUT:)

# This line should be removed in a custom-project, 
#   And VER_<commonThings> should be explicitly-defined, as above.
include $(COMDIR)/_make/commonTestEasyVersion.mk




HEARTBEAT_LIB = $(COMDIR)/heartbeat/$(VER_HEARTBEAT)/heartbeat


include $(HEARTBEAT_LIB).mk

######## TO HERE ##########








# HEADERS... these are LIBRARY HEADERS which do NOT HAVE SOURCE CODE
# These are added to COM_HEADERS after...
# These are necessary only for make tarball... 
#   would be nice to remove this...
# NOTE: These CAN BE MULTIPLY-DEFINED! Because newer headers almost always 
#    include older headers' definitions, as well as new ones
#   i.e. bithandling...
#  the only way to track all this, for sure, is to hunt 'em all down
#  (or try make tarball and see what's missing after the compilation)
VER_BITHANDLING = 0.95
BITHANDLING_HDR = $(COMDIR)/bithandling/$(VER_BITHANDLING)/
COM_HEADERS += $(BITHANDLING_HDR)
# This is so #include _BITHANDLING_HEADER_ can be used in .c and .h files.
CFLAGS += -D'_BITHANDLING_HEADER_="$(BITHANDLING_HDR)/bithandling.h"'

VER_ERRORHANDLING = 0.99
ERRORHANDLING_HDR = $(COMDIR)/errorHandling/$(VER_ERRORHANDLING)/
COM_HEADERS += $(ERRORHANDLING_HDR)
CFLAGS += -D'_ERRORHANDLING_HEADER_="$(ERRORHANDLING_HDR)/errorHandling.h"'



include $(COMDIR)/_make/reallyCommon3.mk


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
# * /home/meh/_commonCode/heartbeat/2.00-gitHubbing_+revisions/testMega328P+button+DMS/makefile
# *
# *    (Wow, that's a lot longer than I'd hoped).
# *
# *    Enjoy!
# */

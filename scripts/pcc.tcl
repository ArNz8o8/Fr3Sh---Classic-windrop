# pubchancomm.tcl - a modified version of public.tcl v1.00
# PubChanComm v1.82 - 7 Jun 04
# this is modification of existing code by joaquin
# modified by glide (glide@uo.sk)
###########################################
#
#  INSTALLATION (script tested on DiVERSE, VoiD, Eggdrop)
#    1. Place the file into scripts directory
#    2. Add the following line into bots config file
#	 source scripts/pcc.tcl 
#    3. Find the following line in pubchancomm.tcl
#	 set znak "!" and define your own character or use ! as default
#	(this line is located in the script 2 times: first line of code, and HELP section)
#    4. Edit flags in Commands section or use defaults
#	(+o needed for opping +Q for other commands)
#    5. Rehash the bot
#    6. should work now ;)
#
###########################################
#
#Original header follows:

#########################################
#author - joaquin@centrum.sk (joaquin)  #
#editor - joaquin@centrum.sk (joaquin)  #
#########################################

#code:


set znak "!"

############
# Commands #
############

bind pub o|o ${znak}op op
bind pub Q|Q ${znak}deop deop

bind pub Q|Q ${znak}voice voice
bind pub Q|Q ${znak}devoice devoice

bind pub Q|Q ${znak}kick ckick
bind pub Q|Q ${znak}ban ban
bind pub Q|Q ${znak}unban unban
bind pub Q|Q ${znak}kban kban

bind pub Q|Q ${znak}topic topic
bind pub Q|Q ${znak}mode mode
bind pub Q|Q ${znak}help help
bind pub Q|Q ${znak}about about


####################################################################
# Don't change anything below this line except: set znak ""        #
# in the Help section !!! unless you know what you're doing        #
# (if changing anything, pls keep the entire header with script)   #
#__________________________________________________________________#

proc op {nick host hand chan text} {
set target [lindex $text 0]
set target1 [lindex $text 1]
set target2 [lindex $text 2]
if {$target == ""} {
 putserv "MODE $chan +o $nick"
 } else {
 putserv "MODE $chan +ooo $target $target1 $target2"
 }
}

proc deop {nick host hand chan text} {
global botnick
set target [lindex $text 0]
set target1 [lindex $text 1]
set target2 [lindex $text 2]
if {$target == ""} {
 putserv "MODE $chan -o $nick"
 } elseif {[matchattr $nick n|-] == "1"} {
putserv "MODE $chan -ooo $target $target1 $target2"
  } elseif {$target != $botnick} {
if {[matchattr $target n|-] == "0"} {
 if {[matchattr $nick -|o $chan] == 1} {
  putserv "MODE $chan -ooo $target $target1 $target2"
   } elseif {[matchattr $target -|o $chan] == 0} {
  putserv "MODE $chan -ooo $target $target1 $target2"
   } else {
  putserv "NOTICE $nick : You don`t have permission to deop the Op $target"
 }
} elseif {[matchattr $target n|-] == 1} {
    putserv "NOTICE $nick : You don`t have permission to deop the Op $target"
}
} else {
 putquick "NOTICE $nick : Fuck you"
}
}

proc voice {nick host hand chan text} {
set target [lindex $text 0]
set target1 [lindex $text 1]
set target2 [lindex $text 2]
if {$target == ""} {
 putserv "MODE $chan +v $nick"
 } else {
 putserv "MODE $chan +vvv $target $target1 $target2"
 }
}

proc devoice {nick host hand chan text} {
set target [lindex $text 0]
set target1 [lindex $text 1]
set target2 [lindex $text 2]
if {$target == ""} {
 putserv "MODE $chan -v $nick"
 } else {
 putserv "MODE $chan -vvv $target $target1 $target2"
 }
}

proc ckick {nick host hand chan text} {
global botnick
set target [lindex $text 0]
set reason [lrange $text 1 end]
if {[matchattr $nick n|-] == "1"} {
  putserv "KICK $chan $target :$reason"
  } elseif {$target != $botnick} {
if {[matchattr $target n|-] == "0"} {
 if {[matchattr $nick -|o $chan] == "1"} {
  putserv "KICK $chan $target :$reason"
   } elseif {[matchattr $target -|o $chan] == "0"} {
  putserv "KICK $chan $target :$reason"
   } else {
  putserv "NOTICE $nick : You don`t have permission to kick the Op $target"
 }
} elseif {[matchattr $target n|-] == 1} {
    putserv "NOTICE $nick : You don`t have permission to kick the Op $target"
}
} else {
 putquick "NOTICE $nick : Fuck you"
}
}

proc ban {nick host hand chan text} {
global botnick
set target [lindex $text 0]
set bhost [getchanhost $target $chan]
set banmask "*!*[string trimleft [string range $bhost [string first "!" $bhost] end] ?^~-_+?]"
if {[matchattr $nick n|-] == "1"} {
putserv "MODE $chan +b $banmask"
  } elseif {$target != $botnick} {
if {[matchattr $target n|-] == "0"} {
 if {[matchattr $nick -|o $chan] == 1} {
  putserv "MODE $chan +b $banmask"
   } elseif {[matchattr $target -|o $chan] == 0} {
  putserv "MODE $chan +b $banmask"
   } else {
  putserv "NOTICE $nick : You don`t have permission to ban the Op $target"
 }
} elseif {[matchattr $target n|-] == 1} {
    putserv "NOTICE $nick : You don`t have permission to ban the Op $target"
}
} else {
 putquick "NOTICE $nick : Fuck you"
}
}

proc unban {nick host hand chan text} {
set target [lindex $text 0]
putserv "MODE $chan -b $target"
}

proc kban {nick host hand chan text} {
global botnick
set target [lindex $text 0]
set reason [lrange $text 0 end]
set bhost [getchanhost $target $chan]
set banmask "*!*[string trimleft [string range $bhost [string first "!" $bhost] end] ?^~-_+?]"
if {[matchattr $nick n|-] == "1"} {
  putserv "MODE $chan +b $banmask"
  putserv "KICK $chan $target :$reason"
  } elseif {$target != $botnick} {
if {[matchattr $target n|-] == "0"} {
 if {[matchattr $nick -|o $chan] == 1} {
  putserv "MODE $chan +b $banmask"
  putserv "KICK $chan $target :$reason"
   } elseif {[matchattr $target -|o $chan] == 0} {
  putserv "MODE $chan +b $banmask"
  putserv "KICK $chan $target :$reason"
  } else {
  putserv "NOTICE $nick : You don`t have permission to kick the Op $target"
 }
} elseif {[matchattr $target n|-] == 1} {
    putserv "NOTICE $nick : You don`t have permission to kick the Op $target"
}
} else {
 putquick "NOTICE $nick : Fuck you"
}
}
 
proc topic {nick host hand chan text} {
putserv "TOPIC $chan :$text"
}

proc mode {nick host hand chan text} {
set mode [lrange $text 0 6]
putserv "MODE $chan :$mode"
}

################
# HELP SECTION #
################

proc help {nick host hand chan text} {
set znak "!"
putserv "NOTICE $nick :Public commands script -- HELP"
putserv "NOTICE $nick :* means that if u don't specify the nick, action will be performed on you"
putserv "NOTICE $nick :${znak}op <nick> -- Ops the nick you specify, *"
putserv "NOTICE $nick :${znak}deop <nick> -- Deops the nick you specify, *"
putserv "NOTICE $nick :${znak}kick <nick> <reason> -- Kicks a user, The reason is optional"
putserv "NOTICE $nick :${znak}voice <nick> -- Voices a user you specify, *"
putserv "NOTICE $nick :${znak}devoice <nick> -- Devoices the nick you specify, *"
putserv "NOTICE $nick :${znak}ban <nick> --  Bans a user"
putserv "NOTICE $nick :${znak}kban <nick> --  Kick/Bans a user"
putserv "NOTICE $nick :${znak}unban <host> -- Unban the host you specify"
putserv "NOTICE $nick :${znak}topic <text> -- Changes the topic of the channel"
putserv "NOTICE $nick :${znak}mode <+/-modes> -- Changes the modes of the channel"
putserv "NOTICE $nick :${znak}help -- Shows this list of commands :)"
putserv "NOTICE $nick :${znak}about -- Shows info about script"   
} 

proc about {nick host hand chan text} {
set ver "1.82"
putserv "PRIVMSG $nick :Script: Public Channel Commands, v${ver}"
putserv "PRIVMSG $nick :Author: joaquin, glide"
putserv "PRIVMSG $nick :joaquin (joaquin@centrum.sk) - written the original code -> true author"
putserv "PRIVMSG $nick :glide (glide@uo.sk) - improved banning, added - multiple target support, topic, mode, help, about"
putserv "PRIVMSG $nick ---------------------------------------------------------------------------------------------------"
putserv "PRIVMSG $nick :E-Mail: glide@uo.sk"
putserv "PRIVMSG $nick :For any bug reports, suggestions, or comments use supported email address"
putserv "PRIVMSG $nick --------------------------------------------------------------------------"
putserv "PRIVMSG $nick :Special thanx to: Logosys (tcl help), _ViPeR_ (testing)"
putserv "PRIVMSG $nick "
putserv "PRIVMSG $nick :I know that !mode command doesn't work on 100%, I will make it in the next update"
} 

set ver "1.82" 
putlog "Public Channel Commands ${ver} Created by joaquin, edited by glide"
putlog "For help type: !help on the channel"

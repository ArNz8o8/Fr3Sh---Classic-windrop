#################################
# Public notes by Sergio100 1.01 #
#################################

#You should make a directory named publicnotes where the eggdrop lives :)
#It's messy, i know... But i wrote it without help and without knowing TCL :)
#TO DO: Check users by host, not by nick.
#1.01: I was using string wordend for nicks, but it doesnt work with some characters.
#      So i now use lindex and lrange. It's quite faster too :D

bind join - * onjoin_notes
bind msg - .erasenotes erase_notes
bind msg - .leavenote leave_notes
bind msg - .getnotes get_notes
bind msg - .noteshelp help_notes

#This is the per user limit on notes received at one time (not sent! :).
set limitnotes 2

proc help_notes { nick uhost hand text } {
  global botnick
  puthelp "PRIVMSG $nick :Use /msg $botnick .leavenote <nick> <text> to send a note. Use /msg $botnick .getnotes to read your notes or /msg $botnick .erasenotes to delete them."
  puthelp "PRIVMSG $nick :The script will let you know if you have notes when you join the channel. Please delete your notes after reading them. Otherwise you wont be able to get more (limit is 2)."
  return 1
}

proc onjoin_notes { nick uhost hand chan } {
  global botnick
  set n [dosearchnote $nick]
    if ($n>0) { 
      putserv "NOTICE $nick :You have $n notes waiting to be read. Use /msg $botnick .getnotes to read them."
      return 1
    }
  return 0
}

proc erase_notes { nick uhost hand text } {
  set lowercasenick [string tolower $nick]
  set a [dosearchnote $nick]
  if ($a>0) {
  putserv "NOTICE $nick :All your notes have been deleted"
  eval "exec rm ./publicnotes/public$lowercasenick.txt"
  return 1
  } else {
    putserv "NOTICE $nick :You didnt have any notes :P"
    return 0
  }
}

proc dosearchnote {getnick} {
  set lowercasenick [string tolower $getnick]
  set notesf [file exists "./publicnotes/public$lowercasenick.txt"]
  if ($notesf==0) {
     return 0
  }
  set notesfile [open "./publicnotes/public$lowercasenick.txt" "r+"]
  set numbernotes 0
  while {[eof $notesfile] == 0} {
    set line [gets $notesfile]
    set nickline [lindex $line 0]
    if {[string compare [string tolower $nickline] [string tolower $getnick]] == 0} {
      set numbernotes [incr numbernotes]
    }
  }
  close $notesfile
  return $numbernotes
}

proc leave_notes { nick uhost hand text } {
  global limitnotes
  set getnick [lindex $text 0]
  set msg [lrange $text 1 end]
  set numbernotes [dosearchnote $getnick]
  set cmp [expr $numbernotes >= $limitnotes]
  if ($cmp>0) {
    putserv "NOTICE $nick :The user already has $limitnotes notes. No more notes can be added to prevent spam."
  } else {
    set lowercasenick [string tolower $getnick]
    set thereis [file exists "./publicnotes/public$lowercasenick.txt"]
    set cmp [expr $thereis == 1]
    if ($cmp) {
      set notesfile [open "./publicnotes/public$lowercasenick.txt" "a"]
    } else {
      set notesfile [open "./publicnotes/public$lowercasenick.txt" "w+"]
    }
    puts $notesfile "$getnick $nick $msg"
    putserv "NOTICE $nick :Note to $getnick has been stored."
    close $notesfile
  }
  return 1
}

proc get_notes { nick uhost hand text } {
  set lowercasenick [string tolower $nick]
  set thereis [file exists "./publicnotes/public$lowercasenick.txt"]
  if ($thereis==0) {
    putserv "NOTICE $nick :You didnt have any notes."
    return 1
  }
  set notesfile [open "./publicnotes/public$lowercasenick.txt" "r+"]
  if {[eof $notesfile]} {
    putserv "NOTICE $nick :You dont have any notes."
    close $notesfile
  } else {
    set yes 0
    set b [dosearchnote $nick]
    set cmp [expr $b > 0]
    if ($cmp<=0) {
      putserv "NOTICE $nick :You dont have any notes."
      close $notesfile
      return 1
    }
      while {[eof $notesfile] == 0} {
      set line [gets $notesfile]
      set thisnick [lindex $line 0]
      set cmpstr [string compare [string tolower $thisnick] [string tolower $nick]]
      if ($cmpstr==0) {
        set sendnick [lindex $line 1]
        set msg [lrange $line 2 end]
        putserv "NOTICE $nick :You have a note from $sendnick -> $msg"
        set yes 1
      }
    }
    if { $yes==0 } {
      putserv "NOTICE $nick :You dont have any notes. Stop bugging me."
    }
    close $notesfile
  }
  return 1
}

##############################
# Show load statement        #
##############################
putlog "Public Notes 1.0 by Sergio100 (EFNet)"
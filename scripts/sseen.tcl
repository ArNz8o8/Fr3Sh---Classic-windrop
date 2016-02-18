#  ---------------------------------------------------------- 
 # 
 #   Sseend v 1.2 (6-4-11-3) 
 #   by: <lee8oiAtgmail><lee8oiOnfreenode> (thanks thommey) 
 # 
 #   Original Sseend v1.0 based on: 
 #   Sseen v 0.2.22 by samu (IRC: samu@pirc.pl) 
 # 
 #  ---------------------------------------------------------- 
 # 
 #  This is Simple Seen 'Duke' (pronounced 'Seend' by lee8oi). 
 #  Sseend is a seen script forked from Sseen that will tell you how 
 #  long ago the bot last seen the specified nick, what channel they 
 #  were on, and what their last message was to that channel. Sseend 
 #  also allows users to .seen themselves! (demanded feature believe it or not). 
 # 
 #  Initial channel setup: 
 #  (starts logging and enables .seen command) 
 #    .chanset #channel +sseen 
 # 
 #  Public command syntax: 
 #    .seen <username> 
 #  or 
 #    .seen me 
 # 
 #  Example Usage: 
 #    <lee8oi> .seen lee8oi 
 #    <dukelovett> I last saw you 1 hour 3 minutes 39 seconds ago on 
 #    #dukelovett saying: Sseen script was awsome. My version improves on 
 #    it. 
 # 
 #  Note: 
 #    Restarting the bot will clear all stored seen data. But Rehashing 
 #    normally does not clear the data. 
 #  
 #  Updates log: 
 #    v1.0: 
 #    1. Users can .seen themselves (Strange but popular). 
 #    2. .seen command lines are now ignored. This allows users "seening" 
 #       themselves to get results besides the command they just ran. 
 #    3. Sseend now keeps track of the users last message. 
 #    4. Lastseen time now shown as a duration instead of a time to 
 #       better serve users accross multiple timezones. 
 #    5. Bot can now cleverly respond to requests for it to 'seen' 
 #       itself. 
 #    6. Users can now do '.seen me' to seen themselves. 
 # 
 #    v1.1 
 #    1. Bot now replies correctly if users seen themselves before 
 #       any seen data is saved. 
 #    2. Added code changes suggested by nml375 including using isbotnick 
 #       instead of comparing to global var botnick. 
 # 
 #    v1.2 
 #    1. Removed _showcurtime procedure because the new duration 
 #       system doesn't require it. 
 # 
 #  TODO: 
 #  <> Add a system for backing up and restoring seen data. 
 # 
 #  ---------------------------------------------------------- 

 bind pubm - * public_msg_save 
 bind sign - * public_msg_save 
 bind pub - .seen pub_show_seen 

 set ver "1.2" 


 setudef flag sseen 

 proc public_msg_save {nick userhost handle channel text} { 
    global lastseen 
    global lastchan 
    global lastmsg 
    if {[channel get $channel sseen]} { 
       if {![string match .seen* $text]} { 
          set lastseen($nick) [clock seconds] 
          set lastchan($nick) $channel 
          set lastmsg($nick) $text 
       } 
    } 
 } 

 proc pub_show_seen {nick userhost handle channel text} { 
    global lastseen 
    global lastchan 
    global lastmsg 
    if {[channel get $channel sseen]} { 
       set text [lindex [split $text] 0] 
       if {$text == $nick || [string tolower $text] == "me"} { 
          if {[info exists lastseen($nick)]} { 
             putserv "PRIVMSG $channel :I last saw you [duration [expr {[clock seconds] - $lastseen($nick)}]] ago on $lastchan($nick) saying: $lastmsg($nick)" 
          } else { 
             putserv "PRIVMSG $channel :I haven't seen you yet $nick. Say something to put yourself in my database." 
          } 
       } elseif {[isbotnick $text]} { 
          putserv "PRIVMSG $channel :I last saw myself just now. Right here." 
       } else { 
          if {[info exists lastseen($text)]} { 
             putserv "PRIVMSG $channel :I last saw $text [duration [expr {[clock seconds] - $lastseen($text)}]] ago on $lastchan($text) saying: $lastmsg($text)" 
          } else { 
             putserv "PRIVMSG $channel :I haven't seen $text. They might not have said anything yet." 
          } 
       } 
    } 
 } 

 putlog "Sseend $ver by <lee8oiAtgmail> loaded!" 
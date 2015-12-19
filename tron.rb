#!/usr/bin/env ruby

require "ncurses"

class Game

  def self.init
    Ncurses.initscr
    Ncurses.cbreak           # provide unbuffered input
    Ncurses.noecho           # turn off input echoing
    Ncurses.nonl             # turn off newline translation
    Ncurses.stdscr.intrflush(false) # turn off flush-on-interrupt
    Ncurses.stdscr.keypad(true)     # turn on keypad mode
  end

  def self.end
    Ncurses.echo
    Ncurses.nocbreak
    Ncurses.nl
    Ncurses.endwin
  end

end

begin
  Game.init

  Ncurses.stdscr.addstr("Press a key to continue") # output string
  Ncurses.stdscr.getch                             # get a charachter
ensure
  Game.end
end

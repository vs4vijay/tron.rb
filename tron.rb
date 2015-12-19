#!/usr/bin/env ruby

require "ncurses"

class GameManager

  def start
    Ncurses.initscr
    Ncurses.cbreak                  # provide unbuffered input
    Ncurses.noecho                  # turn off input echoing
    Ncurses.nonl                    # turn off newline translation
    Ncurses.stdscr.intrflush(false) # turn off flush-on-interrupt
    Ncurses.stdscr.keypad(true)     # turn on keypad mode
  end

  def end
    Ncurses.echo
    Ncurses.nocbreak
    Ncurses.nl
    Ncurses.endwin
  end

  def make_borders

    screen = Ncurses::WINDOW.new(0, Ncurses.COLS, 0, 0)
    screen.border(*([0]*8))

    screen.noutrefresh() # copy window to virtual screen, don't update real screen
    Ncurses.doupdate()

    show_message("Tron - Light Cycle", screen)
    screen.getch
  end

  def show_message (message, screen = Ncurses.stdscr)
    screen.addstr(message)
  end

end

begin
  game_manager = GameManager.new
  game_manager.start
  game_manager.make_borders                       # get a charachter
ensure
  game_manager.end
end

#!/usr/bin/env ruby

require "ncurses"

include Ncurses

class GameManager

  def initialize(name = "Tron")
    start
    @cols = Ncurses.COLS
    make_playground
  end

  def start
    @playground = Ncurses.initscr
    @playground.intrflush(false)    # turn off flush-on-interrupt
    @playground.keypad(true)        # turn on keypad mode

    Ncurses.cbreak                  # provide unbuffered input
    Ncurses.noecho                  # turn off input echoing
    Ncurses.nonl                    # turn off newline translation
    # make_playground
  end

  def end
    Ncurses.echo
    Ncurses.nocbreak
    Ncurses.nl
    Ncurses.endwin
  end

  def make_playground
    # @window = Ncurses::WINDOW.new(0, @cols, 0, 0)
    @playground.border(*([0]*8))

    Ncurses.start_color();
    Ncurses.init_pair(1, COLOR_RED, COLOR_BLACK);
    Ncurses.init_pair(2, COLOR_GREEN, COLOR_BLACK);
    Ncurses.init_pair(3, COLOR_BLUE, COLOR_BLACK);
    Ncurses.init_pair(4, COLOR_BLACK, COLOR_WHITE);

    @playground.bkgd(Ncurses.COLOR_PAIR(2));

    show_message("Tron - Light Cycle", @playground)

    Ncurses.refresh
    # @playground.getch
  end

  def play
    # Ncurses.endwin

    while ((ch = @playground.getch) != KEY_F1)
      p 'aaa'
    end

    # Ncurses.endwin
  end

  def show_message (message, screen = Ncurses.stdscr, posx = 0, posy = (@cols - message.size)/2)
    # screen.addstr(message)
    screen.mvaddstr(posx, posy, message);
    # Ncurses.mvaddstr(4, 19, "Hello, world!");
  end

  def fun
    sleep 2
    # screen.noutrefresh() # copy window to virtual screen, don't update real screen
    # Ncurses.doupdate()

    # screen.move(0, Ncurses.COLS/2 - 10)
    Ncurses.endwin
  end

end

begin
  game_manager = GameManager.new
  # game_manager.start
  # game_manager.make_playground                      # get a charachter
  game_manager.play


ensure
  game_manager.end
end

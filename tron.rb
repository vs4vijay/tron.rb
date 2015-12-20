#!/usr/bin/env ruby

require "ncurses"

include Ncurses

class GameManager

  $GAME_HEADING = "Tron - Light Cycle"
  SLEEP_INTERVAL = 0.2

  def initialize(name = "Tron")
    start
    @cols = Ncurses.COLS
    @lines = Ncurses.LINES
    p @cols, @lines
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
    Ncurses.init_pair(1, COLOR_RED, COLOR_BLACK)
    Ncurses.init_pair(2, COLOR_GREEN, COLOR_BLACK)
    Ncurses.init_pair(3, COLOR_BLUE, COLOR_BLACK)
    Ncurses.init_pair(4, COLOR_BLACK, COLOR_WHITE)

    @playground.bkgd(Ncurses.COLOR_PAIR(2))

    show_message($GAME_HEADING, @playground)

    Ncurses.refresh
    # @playground.getch
  end

  def update_score
    headline = "#{$GAME_HEADING} | Score: #{@p1.name}(#{@p1.score})"
    show_message(headline, @playground)
    @p1.score
  end

  def key_handler
    while ((ch = @playground.getch) != KEY_F1)
      case ch
      when KEY_UP
        @p1.direction = [0, -1]
      when KEY_DOWN
        @p1.direction = [0, 1]
      when KEY_LEFT
        @p1.direction = [-1, 0]
      when KEY_RIGHT
        @p1.direction = [1, 0]
      when KEY_RESIZE
        p 'Handle resize'
      when KEY_MOUSE
        p 'mouse handler'
      end
    end
    Ncurses.endwin
  end

  def game_loop
    count = 0
    while true
      count += 1
      update_score
      # @playground.bkgd(Ncurses.COLOR_PAIR(count/50)) if count > 50
      # @playground.refresh
      show_message(".", @playground, count, count)

      @p1.move
      show_message(@p1.mark, @playground, @p1.x, @p1.y)
      current_char = @playground.winch
      if current_char != 544
        game_over
      end

      sleep SLEEP_INTERVAL
    end
  end

  def play
    Ncurses.beep
    Ncurses.curs_set(1)
    # Ncurses.attron(A_REVERSE | A_BLINK)
    # Ncurses.attron(A_PROTECT)
    @p1 = Player.new("Viz", "#")

    @t1 = Thread.new { game_loop }
    @t2 = Thread.new { key_handler }

    @t1.join
    @t2.join
  end

  def game_over
    @playground.bkgd(Ncurses.COLOR_PAIR(1))
    show_message("GAME OVER")
    # @t1.stop
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
    # @playground.attrset(Ncurses::COLOR_PAIR(0));
    Ncurses.curs_set(2)

    # screen.move(0, Ncurses.COLS/2 - 10)
    Ncurses.endwin
  end

end

class Player
  attr_accessor :name, :mark, :x, :y,
                :score, :direction

  def initialize(name, mark, x = 3, y = 3)
    @name, @mark, @x, @y = name, mark, x, y
    @score = 0
    @direction = [0, 0]
  end

  def move(offsetX = nil, offsetY = nil)
    @score += 1
    offsetX, offsetY = @direction.reverse if offsetX.nil? && offsetY.nil?
    @x += offsetX
    @y += offsetY
    [@x, @y]
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

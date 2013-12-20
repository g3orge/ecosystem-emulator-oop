#
# File implementing the required organisms classes
#

#
# Metadata
#
$orgs = %w(Phytoplankton Zooplankton Squid Milittus Octopus
          Shrimp Crab Sprattus Shark Dolphin)

#
# Function to generate a random organism for the world.
# Optional arguments are the positions on the map
# This probably needs to favor Planktons, but it doesn't.
#
def gen_random_org(x=nil, y=nil)
  x ||= rand(0..$world.dim_x)
  y ||= rand(0..$world.dim_y)
  eval "#{$orgs.sample}.new(x,y)"
end

#
# Basic object
# It assumes that is run in a World object with a $world global var.
#
class Organism
  attr_reader :id
  attr_reader :size
  attr_reader :orgs_eaten
  attr_reader :food_needed
  attr_reader :steps_alive

  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x
    @y = y
    @steps_alive = 0
  end

  #
  # One unit of time
  #
  def tick
    move_random
    # TODO: check health orgs_eaten etc etc...
  end

  #
  # Interacting with a fellow cell
  #
  def eat_or_interact(x, y)
    if $world.map[x][y] > @size
      # I just got eaten
      $world.map[x][y].orgs_eaten += 1
      die
    else
      # I am bigger
      @orgs_eaten += 1
      # update positions
      @x = x
      @y = y
      $world.map[x][y] = self
      $world.map[@x][@y] = nil
    end
  end

  #
  # moving to the a neighbor cell and interacting with what is there
  #
  def move_random
    coords = get_coords(get_random_possible($world.dim_x, $world.dim_y))
    eat_or_interact(coords[0], coords[1])
  end

  #
  # Letting the Garbage Collector do the job, afterwards
  #
  def die
    $world.map[@x][@y] = nil
  end

  #
  # calculate the required coordinates for a cell
  # check the table in the comments for 'get_random_possible' method
  #
  def get_coords(cell)
    a = Array.new(2)
    if (1..3).include? cell
      a[0] = case cell
             when 1 then @x-1
             when 2 then @x
             when 3 then @x+1
             end
      a[1] = @y-1
    elsif (4..6).include? cell
      a[0] = case cell
             when 4 then @x-1
             when 5 then @x
             when 6 then @x+1
             end
      a[1] = @y
    elsif (7..9).include? cell
      a[0] = case cell
             when 7 then @x-1
             when 8 then @x
             when 9 then @x+1
             end
      a[1] = @y+1
    else
      fail "get_coords argument is not in range"
    end
    return a
  end

  #
  # trying to find where to move into the board (only to possible cells)
  # +-----------+
  # | 1 | 2 | 3 |
  # | 4 | 5 | 6 |
  # | 7 | 8 | 9 |
  # +-----------+
  #
  def get_random_possible(max_x, max_y)
    if @x == 0
      if @y == 0
        [5,6,8,9].sample
      elsif @y == max_y
        [2,3,5,6].sample
      else
        [2,3,5,6,8,9].sample
      end
    elsif @y == 0
      # we don't cover same situations
      if @x == max_x
        [4,5,7,8].sample
      else
        [4,5,6,7,8,9].sample
      end
    elsif @x == max_x
      if @y == max_y
        [1,2,4,5].sample
      else
        [1,2,4,5,7,8].sample
      end
    elsif @y == max_y
      [1,2,3,4,5,6].sample
    else
      [1,2,3,4,5,6,7,8,9].sample
    end
  end
end

#
# Plankton classes
# TODO: use metaprogramming throughout the program !!
#

class Phytoplankton < Organism
  def initialize
    super
    @id   = 'PP'
    @size = 1
  end
end

class Zooplankton < Organism
  def initialize
    super
    @id   = 'ZP'
    @size = 1
  end
end

#
# Basic classes under the generic Organism.
# There should be another subclass (Invertebrate and Vertebrate),
# before these, but we removed it for beatiful code's sake.
#

class Mollusca < Organism
  def initialize
    super
    # maybe move the sizes here
  end
end

class Arthropoda < Organism
  def initialize
    super
  end
end

class Chordata < Organism
  def initialize
    super
  end
end

#
# Actual Animals from Mollusca phylum
#

class Squid < Mollusca
  def initialize
    super
    @id   = 'Sq'
    @size = 2
  end
end

class Milittus < Mollusca
  def initialize
    super
    @id   = 'Mi'
    @size = 2
  end
end

class Octopus < Mollusca
  def initialize
    super
    @id   = 'Oc'
    @size = 3
  end
end

#
# Actual Animals from Arthropoda phylum
#

class Shrimp < Arthropoda
  def initialize
    super
    @id   = 'Sh'
    @size = 2
  end
end

class Crab < Arthropoda
  def initialize
    super
    @id   = 'Cr'
    @size = 3
  end
end

#
# Actual Animals from Chordata phylum (Vertebrate subphylum)
#

class Sprattus < Chordata
  def initialize
    super
    @id   = 'Sp'
    @size = 3
  end
end

class Shark < Chordata
  def initialize
    super
    @id   = 'Sk'
    @size = 4
  end
end

class Dolphin < Chordata
  def initialize
    super
    @id   = 'Do'
    @size = 4
  end
end

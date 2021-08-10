##########################################################
# Bomber class: It executes vertical and horizontal fires
# Input: Scuare Matrix with x and zero chars
# output: Scuare Matrix with zero valid chars
# by: Hermes Galvis Mejía
# Date: 2021-08-09
##########################################################

class Bomber
  attr_accessor :map

  def initialize(map, goal_position)
    @map           = map
    @goal_position = goal_position
    @map_size      = map.size
  end

  def fire(pointer_axis, fire_direction)
    initialize_pointers
    execute_multiple_fire(select_fire_validator(fire_direction),
                          send("pointer_#{pointer_axis}"),
                          fire_direction)
  end

  private

  attr_accessor :goal_position,
                :map_size,
                :pointer_x,
                :pointer_y


  def initialize_pointers
    @pointer_y, @pointer_x = goal_position
  end

  def select_fire_validator(fire_direction)
    if %i[right down].include?(fire_direction)
      :valid_positive_direction?
    else
      :valid_negative_direction?
    end
  end

  def execute_multiple_fire(fire_condition, pointer, fire_direction)
    while send(fire_condition, pointer) do
      map[pointer_y][pointer_x] = 'x' if map[pointer_y][pointer_x] == 0

      break if invalid_fire_position?(fire_direction)

      move_sight_direction(fire_direction)
    end
  end

  def valid_positive_direction?(pointer)
    pointer <= map_size - 1
  end

  def valid_negative_direction?(pointer)
    pointer >= 0
  end

  def invalid_fire_position?(fire_direction)
    pointer_positions = select_pointers_positions(fire_direction)
    [nil, 'x'].include?(map.dig(pointer_positions[0], pointer_positions[1]))
  end

  def select_pointers_positions(fire_direction)
    case fire_direction
    when :down then [pointer_y + 1, pointer_x]
    when :up then [pointer_y - 1, pointer_x]
    when :right then [pointer_y , pointer_x + 1]
    else [pointer_y , pointer_x - 1] # left
    end
  end

  def move_sight_direction(fire_direction)
    case fire_direction
    when :down then @pointer_y += 1
    when :up then @pointer_y -= 1
    when :right then @pointer_x += 1
    else @pointer_x -= 1
    end
  end
end


##########################################################
# BomberGame class: It uses Bomber class and execute the play,
# firing in horizontan and vertical directions.
# Input: Scuare Matrix with x and zero chars
# output: Scuare Matrix with zero valid chars
# by: Hermes Galvis Mejía
# Date: 2021-08-09
##########################################################


class BomberGame
  def initialize(map, goal_position)
    @map           = map
    @goal_position = goal_position
  end

  def play
    bomber = Bomber.new(map, goal_position)

    %i[down up left right].each do |fire_direction|
      process_fire(bomber, fire_direction)
    end

    bomber.map
  end

  private

  attr_reader :goal_position,
              :map

  def process_fire(bomber, fire_direction)
    pointer_axis = %i[down up].include?(fire_direction) ? 'y' : 'x'
    bomber.fire(pointer_axis, fire_direction)
  end
end


################################################################
#               ##### PLAY THE GAME #####
#               #####               #####
###############################################################
map = [
  ['x', 0 , 0 , 0 , 0 ],
  ['x', 0 ,'x', 'x', 'x'],
  ['x', 0 , 0 , 0 , 0 ],
  ['x', 0 , 0 , 0 , 0 ],
  ['x', 0 , 0 , 0 , 0 ]
]

position = [0, 0]

bomber_game = BomberGame.new(map, position)
bomber_game.play


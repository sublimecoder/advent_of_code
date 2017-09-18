class Path
  CARDINAL_DIRECTIONS = %w[N E S W]
  STARTING_CARDINAL_DIRECTION = "N"
  STARTING_COORDINATES = [0,0]

  attr_accessor :instructions
  attr_accessor :current_direction
  attr_accessor :current_coordinates
  attr_accessor :coordinates_history

  def initialize instructions
    self.instructions = process_instructions(instructions)
    self.current_direction = STARTING_CARDINAL_DIRECTION
    self.current_coordinates = STARTING_COORDINATES
    self.coordinates_history = []

    traverse
  end

  def shortest_distance
    distance_traversed_for current_coordinates
  end

  def first_revisited_location
    coordinates_history.detect { |coordinates| coordinates_history.count(coordinates) > 1 }
  end

  def distance_traversed_for coordinates
    coordinates.map(&:abs).sum
  end

  private

  def process_instructions instructions
    instructions.map do |instruction|
      { direction: instruction[0], distance: instruction[1..-1].to_i }
    end
  end

  def traverse
    instructions.each do |instruction|
      change_direction instruction[:direction]
      move instruction[:distance]
    end
  end

  def move distance
    distance.times do
      case current_direction
      when "N"
        increment_latitude
      when "E"
        increment_longitude
      when "S"
        decrement_latitude
      when "W"
        decrement_longitude
      end
      save_current_position
    end
  end

  def save_current_position
    self.coordinates_history << current_coordinates
  end

  def change_direction new_direction
    if new_direction == "L"
      next_cardinal_direction = CARDINAL_DIRECTIONS[index_of_current_direction - 1]
    else
      next_cardinal_direction = CARDINAL_DIRECTIONS[index_of_current_direction + 1] || "N"
    end

    self.current_direction = next_cardinal_direction
  end

  def index_of_current_direction
    CARDINAL_DIRECTIONS.index current_direction
  end

  def increment_longitude
    self.current_coordinates = [current_coordinates[0], current_coordinates[1] + 1]
  end

  def decrement_longitude
    self.current_coordinates = [current_coordinates[0], current_coordinates[1] - 1]
  end

  def increment_latitude
    self.current_coordinates = [current_coordinates[0] + 1, current_coordinates[1]]
  end

  def decrement_latitude
    self.current_coordinates = [current_coordinates[0] - 1, current_coordinates[1]]
  end
end

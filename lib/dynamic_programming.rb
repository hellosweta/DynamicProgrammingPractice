# Dynamic Programming practice
# NB: you can, if you want, define helper functions to create the necessary caches as instance variables in the constructor.
# You may find it helpful to delegate the dynamic programming work itself to a helper method so that you can
# then clean out the caches you use.  You can also change the inputs to include a cache that you pass from call to call.

class DPProblems
  def initialize
    # Use this to create any instance variables you may need
    @fib_cache = {
      1 => 1,
      2 => 1
    }
  end

  # Takes in a positive integer n and returns the nth Fibonacci number
  # Should run in O(n) time
  def fibonacci(n)
    return @fib_cache[n] if @fib_cache[n]
    @fib_cache[n-1] ||= fibonacci(n-1)
    @fib_cache[n-2] ||= fibonacci(n-2)
    @fib_cache[n] = @fib_cache[n-1] + @fib_cache[n-2]

  end

  # Make Change: write a function that takes in an amount and a set of coins.  Return the minimum number of coins
  # needed to make change for the given amount.  You may assume you have an unlimited supply of each type of coin.
  # If it's not possible to make change for a given amount, return nil.  You may assume that the coin array is sorted
  # and in ascending order.
  def make_change(amt, coins, coin_cache = { 0 => 0} )

    return coin_cache[amt] if coin_cache[amt]
    return Float::INFINITY if amt < coins[0]

    best_change = amt
    possible = false
    i = 0
     while i < coins.length && coins[i] <= amt
       num_change = 1 + make_change(amt - coins[i], coins, coin_cache)
       if num_change.is_a?(Integer)
         possible = true
         best_change = num_change if num_change < best_change
       end
       i += 1
     end

     if possible
       coin_cache[amt] = best_change
     else
       coin_cache[amt] = 0.0/0.0
     end

  end

  # Knapsack Problem: write a function that takes in an array of weights, an array of values, and a weight capacity
  # and returns the maximum value possible given the weight constraint.  For example: if weights = [1, 2, 3],
  # values = [10, 4, 8], and capacity = 3, your function should return 10 + 4 = 14, as the best possible set of items
  # to include are items 0 and 1, whose values are 10 and 4 respectively.  Duplicates are not allowed -- that is, you
  # can only include a particular item once.
  def knapsack(weights, values, capacity)
    return 0 if capacity == 0 || weights.length == 0
    table = make_table(weights, values, capacity)
    table[capacity][weights.length - 1]
  end

  def make_table(weights, values, capacity)
    table = []
    (0..capacity).each do |i|
      table[i] = []
      (0..weights.length - 1).each do |j|
        if i == 0
          table[i][j] = 0
        elsif j == 0
          if weights[0] > i
            table[i][j] = 0
          else
            table[i][j] = values[0]
          end
        else
          first = table[i][j - 1]
          if i < weights[j]
            second = 0
          else
            second = table[i - weights[j]][j - 1] + values[j]
          end
          best = [first, second].max
          table[i][j] = best
        end
      end
    end
    table
  end

  # Stair Climber: a frog climbs a set of stairs.  It can jump 1 step, 2 steps, or 3 steps at a time.
  # Write a function that returns all the possible ways the frog can get from the bottom step to step n.
  # For example, with 3 steps, your function should return [[1, 1, 1], [1, 2], [2, 1], [3]].
  # NB: this is similar to, but not the same as, make_change.  Try implementing this using the opposite
  # DP technique that you used in make_change -- bottom up if you used top down and vice versa.
  def stair_climb(n)
    steps_cache = [[[]], [[1]], [[1, 1], [2]]]
    return steps_cache[n] if n < 3
    (3..n).each do |num|
      next_step = []
      (1..3).each do |first_step|
        steps_cache[num - first_step].each do |potential_step|
          new_route = [first_step]
          potential_step.each do |step|
            new_route << step
          end
          next_step << new_route
        end
      end
      steps_cache << next_step
    end

    steps_cache.last
  end

  # String Distance: given two strings, str1 and str2, calculate the minimum number of operations to change str1 into
  # str2.  Allowed operations are deleting a character ("abc" -> "ac", e.g.), inserting a character ("abc" -> "abac", e.g.),
  # and changing a single character into another ("abc" -> "abz", e.g.).
  def str_distance(str1, str2)
    string_distance_helper(str1, str2)
  end

  def string_distance_helper(string1, string2)

    dist_cache = Hash.new { |hash, key| hash[key] = {} }

    return dist_cache[string1][string2] if dist_cache[string1][string2]

    if string1 == string2
      dist_cache[string1][string2] = 0
      return 0
    end

    if string1.nil?
      return string2.length
    elsif string2.nil?
      return string1.length
    end

    len1 = string1.length
    len2 = string2.length

    if string1[0] == string2[0]
      distance = string_distance_helper(string1[1..len1], string2[1..len2])
      dist_cache[string1][string2] = distance
      return distance
    else
      one = 1 + string_distance_helper(string1[1..len1], string2[1..len2])
      two = 1 + string_distance_helper(string1, string2[1..len2])
      three = 1 + string_distance_helper(string1[1..len1], string2)
      p one, two, three
      distance = [one, two, three].min
      dist_cache[string1][string2] = distance
      distance
    end
  end
  # Maze Traversal: write a function that takes in a maze (represented as a 2D matrix) and a starting
  # position (represented as a 2-dimensional array) and returns the minimum number of steps needed to reach the edge of the maze (including the start).
  # Empty spots in the maze are represented with ' ', walls with 'x'. For example, if the maze input is:
  #            [['x', 'x', 'x', 'x'],
  #             ['x', ' ', ' ', 'x'],
  #             ['x', 'x', ' ', 'x']]
  # and the start is [1, 1], then the shortest escape route is [[1, 1], [1, 2], [2, 2]] and thus your function should return 3.
  def maze_escape(maze, start)
  end
end

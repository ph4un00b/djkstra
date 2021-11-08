# frozen_string_literal: true

# https://leetcode.com/problems/path-with-maximum-probability/

require 'set'

OPTIMAL_COST = 1.0

# djsktra with heap time: O(n + e) * O(log n)
# todo: implement heap
class DjsktraHeap
  def initialize(num_vertices, edges, succ_prob)
    @distances = [Float::INFINITY] * num_vertices
    heap_distances = []
    (0...num_vertices).to_a.each { |node| heap_distances << [Float::INFINITY, node] }
    @heap = MinHeap.new(heap_distances)
    @adjacent_list = adjacent_edges(succ_prob, edges, num_vertices)
  end

  def execute(start, finito)
    @distances[start] = OPTIMAL_COST
    @heap.update!(OPTIMAL_COST, start)

    until @heap.empty?
      current_cost, current_node = @heap.remove!
      break if current_cost == Float::INFINITY

      relax_distances!(@adjacent_list[current_node], current_cost)
    end

    inverse @distances[finito]
  end

  private

  def inverse(number)
    1.0 / number
  end

  def relax_distances!(edges, current_cost)
    edges.each do |(edge_cost, edge_destiny)|
      new_cost = edge_cost * current_cost
      next unless new_cost < @distances[edge_destiny]

      @distances[edge_destiny] = new_cost
      @heap.update!(edge_destiny, new_cost)
    end
  end

  def adjacent_edges(weights, edges, num_nodes)
    result = Array.new(num_nodes, [])
    edges.each_with_index do |(a, b), index|
      result[a] = [*result[a], [inverse(weights[index]), b]]
      result[b] = [*result[b], [inverse(weights[index]), a]]
    end
    result
  end
end

# djsktra with queue time: O(n*e)
class DjsktraQ
  def initialize(num_vertices, edges, succ_prob)
    @distances = [Float::INFINITY] * num_vertices
    @queue = []
    @adjacent_list = adjacent_edges(succ_prob, edges, num_vertices)
  end

  def execute(start, finito)
    @distances[start] = OPTIMAL_COST
    @queue.push([OPTIMAL_COST, start])

    until @queue.empty?
      current_cost, current_node = @queue.shift
      relax_distances!(@adjacent_list[current_node], current_cost)
    end

    inverse @distances[finito]
  end

  private

  def inverse(number)
    1.0 / number
  end

  def relax_distances!(edges, current_cost)
    edges.each do |(edge_cost, edge_destiny)|
      new_cost = current_cost * edge_cost
      if new_cost < @distances[edge_destiny]
        @queue.push [new_cost, edge_destiny]
        @distances[edge_destiny] = [new_cost, @distances[edge_destiny]].min
      end
    end
  end

  def adjacent_edges(weights, edges, num_nodes)
    result = Array.new(num_nodes, [])
    edges.each_with_index do |(a, b), index|
      result[a] = [*result[a], [inverse(weights[index]), b]]
      result[b] = [*result[b], [inverse(weights[index]), a]]
    end
    result
  end
end

# el dijsktra, time: O(n^2 * e)
class Djsktra
  def initialize(num_nodes, edges_list, costs)
    @distances = [Float::INFINITY] * num_nodes
    @path = Set.new
    @adjacent_list = adjacent_edges(costs, edges_list, num_nodes)
  end

  def execute(start, finito)
    @distances[start] = 1.0

    until @path.size == @distances.size
      closest_distance, closest_node = closest_branch
      break if closest_node.nil?

      @path.add closest_node
      relax_distances!(@adjacent_list[closest_node], closest_distance)
    end

    inverse @distances[finito]
  end

  private

  def inverse(number)
    1.0 / number
  end

  def relax_distances!(edges, closest_distance)
    edges.each do |(edge_cost, edge_destiny)|
      unless @path.include? edge_destiny
        new_distance = edge_cost * closest_distance
        @distances[edge_destiny] = [new_distance, @distances[edge_destiny]].min
      end
    end
  end

  def closest_branch
    @distances.each_with_index.inject([Float::INFINITY, nil]) do |(optimal_distance, optimal_node), (distance, node)|
      if distance < optimal_distance && !@path.include?(node)
        [distance, node]
      else
        [optimal_distance, optimal_node]
      end
    end
  end

  def adjacent_edges(weights, edges, num_nodes)
    result = Array.new(num_nodes, [])
    edges.each_with_index do |(a, b), index|
      result[a] = [*result[a], [inverse(weights[index]), b]]
      result[b] = [*result[b], [inverse(weights[index]), a]]
    end
    result
  end
end

# edges = [[0, 1], [1, 2], [0, 2]]
# weights = [0.5, 0.5, 0.2]
# num_vertices = 3
# start = 0
# finito = 2

num_vertices = 5
edges = [[2, 3], [1, 2], [3, 4], [1, 3], [1, 4], [0, 1], [2, 4], [0, 4], [0, 2]]
weights = [0.06, 0.26, 0.49, 0.25, 0.2, 0.64, 0.23, 0.21, 0.77]
start = 0
finito = 3

p Djsktra.new(num_vertices, edges, weights).execute(start, finito)
p DjsktraQ.new(num_vertices, edges, weights).execute(start, finito)
# p max_probability_with_heap(num_vertices, edges, weights, start, finito)

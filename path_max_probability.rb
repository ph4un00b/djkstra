# frozen_string_literal: true

# https://leetcode.com/problems/path-with-maximum-probability/

# @param {Integer} n
# @param {Integer[][]} edges
# @param {Float[]} succ_prob
# @param {Integer} start
# @param {Integer} end
# @return {Float}

require 'set'

OPTIMAL_COST = 1.0
def max_probability_with_queues(n, edges, succ_prob, start, finito)
  distances = [Float::INFINITY] * n
  distances[start] = OPTIMAL_COST
  queue = []
  queue.push([OPTIMAL_COST, start])
  adjacent_list = get_adjacent_list(succ_prob, edges, n)

  until queue.empty?
    current_cost, current_node = queue.shift
    relax_distances_q!(distances, queue, adjacent_list[current_node], current_cost)
  end

  1.0 / distances[finito]
end

def relax_distances_q!(distances, queue, edges, current_cost)
  edges.each do |(edge_cost, edge_destiny)|
    new_cost = current_cost * edge_cost
    if new_cost < distances[edge_destiny]
      queue.push [new_cost, edge_destiny]
      distances[edge_destiny] = [new_cost, distances[edge_destiny]].min
    end
  end
end

def max_probability(n, edges, succ_prob, start, finito)
  distances = [Float::INFINITY] * n
  distances[start] = 1.0
  path = Set.new
  adjacent_list = get_adjacent_list(succ_prob, edges, n)

  until path.size == n
    closest_distance, closest_node = closest_branch(distances, path)
    break if closest_node.nil?

    path.add closest_node
    relax_distances!(adjacent_list[closest_node], path, distances, closest_distance)
  end

  1.0 / distances[finito]
end

def relax_distances!(edges, path, distances, closest_distance)
  edges.each do |(edge_cost, edge_destiny)|
    unless path.include? edge_destiny
      new_distance = edge_cost * closest_distance
      distances[edge_destiny] = [new_distance, distances[edge_destiny]].min
    end
  end
end

def closest_branch(distances, path)
  distances.each_with_index.inject([Float::INFINITY, nil]) do |(optimal_distance, optimal_node), (distance, node)|
    if distance < optimal_distance && !path.include?(node)
      [distance, node]
    else
      [optimal_distance, optimal_node]
    end
  end
end

def get_adjacent_list(weights, edges, num_nodes)
  result = Array.new(num_nodes, [])
  edges.each_with_index do |(a, b), index|
    result[a] = [*result[a], [1.0 / weights[index], b]]
    result[b] = [*result[b], [1.0 / weights[index], a]]
  end
  result
end

edges = [[0, 1], [1, 2], [0, 2]]
weights = [0.5, 0.5, 0.2]
n = 3
start = 0
finito = 2

p max_probability(n, edges, weights, start, finito)

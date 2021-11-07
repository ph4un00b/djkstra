# frozen_string_literal: true

# https://leetcode.com/problems/path-with-maximum-probability/

# @param {Integer} n
# @param {Integer[][]} edges
# @param {Float[]} succ_prob
# @param {Integer} start
# @param {Integer} end
# @return {Float}

require 'set'

def max_probability(n, edges, succ_prob, start, finito)
  distances = [Float::INFINITY] * n
  distances[start] = 1.0
  path = Set.new
  adjacent_list = get_adjacent_list(succ_prob, edges, n)

  until path.size == n
    closest_distance, closest_node = get_closest_node(distances, path)
    break if closest_node.nil?

    path.add closest_node
    updates_adjacent_distances(adjacent_list[closest_node], path, distances, closest_distance)
  end

  1.0 / distances[finito]
end

def updates_adjacent_distances(adjancent_nodes, path, distances, closest_distance)
  adjancent_nodes.each do |(current_distance, current_node)|
    unless path.include? current_node
      new_distance = current_distance * closest_distance
      distances[current_node] = [new_distance, distances[current_node]].min
    end
  end
end

def get_closest_node(distances, path)
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
    result[a] = [*result[a], [1 / weights[index], b]]
    result[b] = [*result[b], [1 / weights[index], a]]
  end
  result
end

edges = [[0, 1], [1, 2], [0, 2]]
weights = [0.5, 0.5, 0.2]
n = 3
start = 0
finito = 2

p max_probability(n, edges, weights, start, finito)

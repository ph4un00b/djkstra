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
  distances[start] = 1.0 # not 0 since we use multiplation
  unvisited = (0...n).to_a
  path = Set.new
  adjacent_list = get_adjacent_list(succ_prob, edges, n)

  until unvisited.empty?
    closest_distance, closest_node = get_closest_node(distances, path)
    break if closest_node.nil?

    updates_distances_list(adjacent_list[closest_node], path, distances, closest_node, closest_distance)
    unvisited.reject! { |node| node == closest_node }
    path.add closest_node
  end

  1.0 / distances[finito]
end

def updates_distances_list(adjancent_nodes, path, distances, closest_node, closest_distance)
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

  edges.each_with_index do |edge, index|
    a, b = edge

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

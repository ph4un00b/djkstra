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
    # closest_node, closest_distance = get_closest_node(distances, path)
    closest_distance, closest_node = distances.each_with_index.inject([Float::INFINITY, nil]) do
      |(optimal_distance, optimal_node), (distance, node)|
      if distance < optimal_distance && !path.include?(node)
        [distance, node]
      else
        [optimal_distance, optimal_node]
      end
    end

    break if closest_node.nil?

    adjacent_list[closest_node].each do |edge|
      current_distance, current_node = edge

      update_distances(current_node, current_distance * closest_distance, distances) unless path.include? current_node
    end

    unvisited.reject! { |node| node == closest_node }
    path.add closest_node
  end

  1.0 / distances[finito]
end

def update_distances(node, new_distance, distances)
  distances[node] = [new_distance, distances[node]].min
end

def get_closest_node(distances, path)
  optimal_distance = Float::INFINITY
  optimal_node = nil

  distances.each_with_index do |distance, node|
    if path.include? node
      # noop
    elsif distance < optimal_distance
      optimal_distance = distance
      optimal_node = node
    end
  end

  [optimal_node, optimal_distance]
end

def get_adjacent_list(weights, edges, num_nodes)
  result = Array.new(num_nodes, [])

  edges.each_with_index do |edge, index|
    a, b = edge

    result[a] = [*result[a], [1 / weights[index], b]]
    result[b] = [*result[b], [1 / weights[index], a]]
  end

  # for i in 0..edges.size-1 do
  # 	x = edges[i][0]
  # 	y = edges[i][1]

  # 	# result[x] << [1/weights[i], y]
  # 	result[x] = [*result[x], [1/weights[i], y]]
  # 	# result[y] << [1/weights[i], x]
  # 	result[y] = [*result[y], [1/weights[i], x]]
  # end

  result
end

edges = [[1, 2], [0, 2], [0, 1]]
weights = [0.5, 0.5, 0.2]
n = 1000
start = 112
finito = 493

p max_probability(n, edges, weights, start, finito)

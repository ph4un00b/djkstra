# frozen_string_literal: true

# https://leetcode.com/problems/path-with-maximum-probability/

require 'set'

# binary tree is 'complete'
class MinHeap
  TOP_HEAP = 0
  # array can be unsorted
  def initialize(array)
    @nodes = array.each_with_index.each_with_object({}) do |(_value, index), memo|
      memo[index] = index
    end

    @heap = build_heap(array)
  end

  # time O(n)
  def build_heap(array)
    last_index = array.size - 1
    first_parent_index = ((last_index - 1) / 2).floor
    (0..first_parent_index).reverse.each do |index|
      sift_down(index, array.size, array)
    end

    array
  end

  def empty?
    @heap.empty?
  end

  # time O(log n)
  def update!(node, cost)
    @heap[@nodes[node]] = [cost, node]
    sift_up(@nodes[node], @heap)
  end

  # time O(log n)
  def insert!(value)
    @heap.push value
    last_index = @heap.size - 1
    sift_up(last_index, @heap)
  end

  # time O(log n)
  def remove!
    last_index = @heap.size - 1
    swap(TOP_HEAP, last_index, @heap)
    cost, value_to_remove = @heap.pop
    @nodes.delete value_to_remove
    sift_down(TOP_HEAP, last_index, @heap)

    [cost, value_to_remove]
  end

  def peek
    @heap.first
  end

  private

  # time O(log n)
  def sift_down(current_index, last_index, heap)
    child_left_index = current_index * 2 + 1
    while child_left_index <= last_index
      child_right_index = current_index * 2 + 2 <= last_index ? current_index * 2 + 2 : -1

      cost_a = heap[child_left_index].first
      cost_b = heap[child_right_index].first
      index_to_swap = child_right_index != -1 && cost_b < cost_a ? child_right_index : child_left_index

      cost_to_swap = heap[index_to_swap].first
      cost_current = heap[current_index].first
      if cost_to_swap < cost_current
        swap(index_to_swap, current_index, heap)
        current_index = index_to_swap
        child_left_index = current_index * 2 + 1
      else
        break # since it is in the correct position
      end
    end
  end

  # time O(log n)
  def sift_up(current_index, heap)
    parent_index = ((current_index - 1) / 2).floor

    cost_current = heap[current_index].first
    cost_parent = heap[parent_index].first
    while current_index > TOP_HEAP && cost_current < cost_parent
      swap(current_index, parent_index, heap)
      current_index = parent_index
      parent_index = ((current_index - 1) / 2).floor
    end
  end

  def swap(a, b, heap)
    tmp = heap[a]
    heap[a] = heap[b]
    heap[b] = tmp
  end
end

OPTIMAL_COST = 1.0

def max_probability_with_heap(n, edges, succ_prob, start, finito)
  distances = [Float::INFINITY] * n
  distances[start] = OPTIMAL_COST
  heap = MinHeap.new([Float::INFINITY] * n)
  heap.update(start, OPTIMAL_COST)
  adjacent_list = adjacent_edges(succ_prob, edges, n)

  # time O(v)
  until heap.empty?
    # time log(v)
    current_cost, current_node = heap.remove!
    break if current_cost == Float::INFINITY

    # time O(edges)
    relax_distances_h!(adjacent_list[current_node], heap, distances, current_cost)
  end

  1.0 / distances[finito]
end

def relax_distances_h!(edges, heap, distances, current_cost)
  edges.each do |(edge_cost, edge_destiny)|
    new_cost = edge_cost * current_cost
    next unless new_cost < distances[edge_destiny]

    distances[edge_destiny] = new_cost
    # time log(v)
    heap.update edge_destiny, new_cost
  end
end

def max_probability_with_queues(n, edges, succ_prob, start, finito)
  distances = [Float::INFINITY] * n
  distances[start] = OPTIMAL_COST
  queue = []
  queue.push([OPTIMAL_COST, start])
  adjacent_list = adjacent_edges(succ_prob, edges, n)

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
  adjacent_list = adjacent_edges(succ_prob, edges, n)

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

def adjacent_edges(weights, edges, num_nodes)
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

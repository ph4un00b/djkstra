# frozen_string_literal: true

# binary tree is 'complete'
class MinHeap
  TOP_HEAP = 0
  # array can be unsorted
  def initialize(array)
    @nodes = array.each_with_index.each_with_object({}) do |(_, index), memo|
      memo[index] = index
      memo
    end

    @heap = build_heap(array)
  end

  # time O(n)
  def build_heap(array)
    last_index = array.size - 1
    first_parent_index = ((last_index - 1) / 2).floor
    (0..first_parent_index).to_a.reverse.each do |index|
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
    return if empty?

    last_index = @heap.size - 1
    swap(TOP_HEAP, last_index, @heap)
    cost, value_to_remove = @heap.pop
    @nodes.delete value_to_remove
    last_index = @heap.size - 1
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
      child_right_index = if current_index * 2 + 2 <= last_index
                            current_index * 2 + 2
                          else
                            -1
                          end
      index_to_swap = if child_right_index != -1 && heap[child_right_index][0] < heap[child_left_index][0]
                        child_right_index
                      else
                        child_left_index
                      end

      cost_to_swap = heap[index_to_swap].first
      cost_current = heap[current_index].first

      if cost_to_swap < cost_current
        swap(index_to_swap, current_index, heap)
        current_index = index_to_swap
        child_left_index = current_index * 2 + 1
      else
        break
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

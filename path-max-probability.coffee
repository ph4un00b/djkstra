#

solution = (source_node, edges) ->
	# space O(v)
	distances = new Array(edges.length).fill Infinity
	distances[source_node] = 0

	# space O(v)
	unvisited = [0...edges.length]

	# space O(v)
	path = new Map()

	# time O(v)
	while unvisited.length isnt 0
		# time O(v)
		[closest_node, closest_distance] = get_closest_node({path, distances})

		# time O(e)
		for [current_distance, current_node] from edges[closest_node]
			spec = {
				current_node
				new_distance: closest_distance + current_distance
				distances
			}

			update_distances(spec) unless path.has current_node

		# time O(v)
		unvisited = unvisited.filter((u) => u isnt closest_node)
		path.set(closest_node, true)
		console.log 'add to path', path.entries()

	distances

update_distances = ({current_node, new_distance, distances}) ->
	distances[current_node] = Math.min(new_distance, distances[current_node])

get_closest_node = ({path, distances: current_distances}) ->
	optimal_distance = Infinity
	optimal_node = null
	
	# time O(v)
	for [node, distance] from current_distances.entries()
		if path.has node
			# noop
		else
			if distance < optimal_distance
				optimal_distance = distance
				optimal_node = node

	[optimal_node, optimal_distance]

start = 0
edges = [
	[0,1],
	[1,2],
	[0,2]
]

probabilities = [0.5, 0.5, 0.2]

list = new Array(edges.length).fill([])

console.log list

for [index, node] from edges.entries()
	console.log {index, node}
	[a,b] = node
	list[index].push([probabilities[index], a])
	list[index].push([probabilities[index], b])

console.log list

# console.log(solution(start, edges))

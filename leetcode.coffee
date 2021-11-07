
solution = (source_node, edges) ->
	distances = new Array(edges.length).fill(Infinity)
	distances[source_node] = 0
	unvisited = [0...edges.length]
	path = new Map()

	while unvisited.length isnt 0
		[closest_node, closest_distance] = get_closest_node({path, distances})

		for [current_distance, current_node] from edges[closest_node]
			spec = {
				current_node
				new_distance: closest_distance + current_distance
				distances
			}

			update_distances(spec) unless path.has current_node

		console.log distances
		unvisited = unvisited.filter((u) => u isnt closest_node)
		path.set(closest_node, true)
		console.log 'add to path', path.entries()

	distances

update_distances = ({current_node, new_distance, distances: current_distances}) ->
	console.log 'adjacent', {current_node, new_distance}
	if new_distance < current_distances[current_node]
		current_distances[current_node] = new_distance

get_closest_node = ({path, distances: current_distances}) ->
	optimal_distance = Infinity
	optimal_node = null

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
    [[15, 1], [10, 2]],
    [[2, 2], [10, 3]],
    [[5, 3], [1, 4]],
    [],
    [[3, 3]]
]

console.log(solution(start, edges))

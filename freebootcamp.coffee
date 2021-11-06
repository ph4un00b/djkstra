# https://www.freecodecamp.org/news/dijkstras-shortest-path-algorithm-visual-introduction

solution = (source_node, edges) ->
	distances = new Array(edges.length).fill(Infinity)
	distances[source_node] = 0
	unvisited = [0...edges.length]
	path = new Map()

	while unvisited.length isnt 0
		[closest_node, closest_distance] = get_closest_node({path, distances})
		console.log 'select, closest node to the source node', {closest_node, distance: closest_distance}

		for [current_distance, current_node] from edges[closest_node]
			spec = {
				current_node
				new_distance: closest_distance + current_distance
				distances
			}

			update_distances(spec) unless path.has current_node
			console.log 'visited node, skip for', {current_node, from: closest_node} if path.has current_node

		console.log distances
		console.log 'mark as visited', closest_node
		unvisited = unvisited.filter((u) => u isnt closest_node)
		path.set(closest_node, true)
		console.log 'add to path', path.entries()

	distances

update_distances = ({current_node, new_distance, distances: current_distances}) ->
	console.log 'adjacent', {current_node, new_distance}
	if new_distance < current_distances[current_node]
		console.log 'better path', {current_distance: current_distances[current_node], new: new_distance}
		current_distances[current_node] = new_distance

get_closest_node = ({path, distances: current_distances}) ->
	optimal_distance = Infinity
	optimal_node = null

	for [node, distance] from current_distances.entries()
		if path.has node
			# noop
		else
			console.log 'checking node', node
			if distance < optimal_distance
				optimal_distance = distance
				optimal_node = node

	[optimal_node, optimal_distance]

start = 0
edges = [
	[[2, 1], [6, 2]],
	[[2, 0], [5, 3]],
	[[6,0], [8, 3]],
	[[5,1], [8,2], [15, 5], [10, 4]],
	[[10, 3], [6,5], [2, 6]],
	[[6,4], [6,6], [15,3]]
	[[6,5], [2,4]],
]

console.log(solution(start, edges))

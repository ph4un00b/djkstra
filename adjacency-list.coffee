
n = 3

edges = [
	[0,1],
	[1,2],
	[0,2]
]

weights = [0.5, 0.5, 0.2]

list = new Array(n).fill([])

for [a,b],i in edges
	branches = list[b]
	new_branch = [weights[i], a]
	list[b] = [branches..., new_branch]

	branches = list[a]
	new_branch = [weights[i], b]
	list[a] = [branches..., new_branch]

console.log list

n = 3

edges = [
	[0,1],
	[1,2],
	[0,2]
]

weights = [0.5, 0.5, 0.3]

list = new Array(n).fill([])

for [a,b],i in edges
	branches = list[b]
	new_branch = [weights[i], a]
	list[b] = [branches..., new_branch]

	branches = list[a]
	new_branch = [weights[i], b]
	list[a] = [branches..., new_branch]

console.log list

n = 3

edges = [
	[0,1],
]

weights = [0.5]

list = new Array(n).fill([])

for [a,b],i in edges
	branches = list[b]
	new_branch = [weights[i], a]
	list[b] = [branches..., new_branch]

	branches = list[a]
	new_branch = [weights[i], b]
	list[a] = [branches..., new_branch]

console.log list

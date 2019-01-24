$db = {
	lucky: {
		desc: 'bashful',
		gender: :male,
		age: :kid,
		negative: []
	},
	buddy: {
		desc: 'dumb',
		gender: :male,
		age: :kid,
		negative: []
	},
	bluey: {
		desc: 'energetic',
		gender: :female,
		age: :kid,
		negative: [:family_bluey]
	},
	bandit: {
		desc: 'dedicated',
		gender: :female,
		age: :adult,
		negative: [:family_bluey]
	}
}

predicates = [
	'interesting ship...',
	'slash ship I see?',
	'creative ship.'
]

def calculate(a_name, b_name)
	a = $db[a_name]
	b = $db[b_name]

	if (a[:gender] != b[:gender])
		puts 'Interesting ship...'
	end

	if (a[:age] != b[:age])
	    puts 'take a seat'
	end
end

calculate(:lucky, :bandit)
calculate(:bluey, :bandit)

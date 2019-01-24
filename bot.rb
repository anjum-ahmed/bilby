$db = {
	/bluey/i => {
		name: 'Bluey',
		gender: :female,
		age: :kid,
		negative: [:family_bluey]
	},
	/bingo/i => {
		name: 'Bingo',
		gender: :male,
		age: :kid,
		negative: []
	},
	/bandit/i => {
		name: 'Bandit',
		gender: :male,
		age: :adult,
		negative: [:family_bluey, :bluey_parents]
	},
	/chil?li/i => {
		name: 'Mrs Chilli',
		gender: :female,
		age: :adult,
		negative: [:family_bluey, :bluey_parents]
	},
	/lucky/i => {
		name: 'Lucky',
		gender: :male,
		age: :kid,
		negative: []
	},
	/indy/i => {
		name: 'Indy',
		gender: :female,
		age: :kid,
		negative: []
	},
	/coco/i => {
		name: 'CoCo',
		gender: :female,
		age: :kid,
		negative: []
	},
	/snickers/i => {
		name: 'Snickers',
		gender: :male,
		age: :kid,
		negative: []
	},
	/honey/i => {
		name: 'Honey',
		gender: :female,
		age: :kid,
		negative: []
	},
	/mac(kenzie)?/i => {
		name: 'Honey',
		gender: :female,
		age: :kid,
		negative: []
	},
	/chloe/i => {
		name: 'Chloe',
		gender: :female,
		age: :kid,
		negative: []
	},
	/judo/i => {
		name: 'Judo',
		gender: :female,
		age: :kid,
		negative: []
	},
	/rusty?/i => {
		name: 'Rusty',
		gender: :male,
		age: :kid,
		negative: []
	},
	/muffin/i => {
		name: 'Muffin',
		gender: :female,
		age: :kid,
		negative: []
	},
	/socks/i => {
		name: 'Socks',
		gender: :female,
		age: :kid,
		negative: []
	},
	/pretzel/i => {
		name: 'Pretzel',
		gender: :male,
		age: :kid,
		negative: []
	},
	/bentley/i => {
		name: 'Bentley',
		gender: :female,
		age: :kid,
		negative: []
	},
	/missy/i => {
		name: 'Missy',
		gender: :female,
		age: :kid,
		negative: []
	},
	/rupert/i => {
		name: 'Rupert',
		gender: :male,
		age: :kid,
		negative: []
	},
	/juniper/i => {
		name: 'Juniper',
		gender: :female,
		age: :kid,
		negative: []
	},
	/buddy/i => {
		name: 'Buddy',
		gender: :male,
		age: :kid,
		negative: []
	},
	/(uncle )?strip/i => {
		name: 'Uncle Strip',
		gender: :male,
		age: :adult,
		negative: [:family_bluey, :cousin_parents]
	},
	/(aunt )?trix(ie)?/i => {
		name: 'Aunt Trixie',
		gender: :female,
		age: :adult,
		negative: [:family_bluey, :cousin_parents]
	},
	/buddy/i => {
		name: 'Buddy',
		gender: :male,
		age: :kid,
		negative: []
	},
}


def f(name)
	return if name.nil?
	$db.select{|r| !(r =~ name).nil? }
end

def speculate(a, b)
	return "#{a} and #{b}?"
end

def ra(ary)
	ary.shuffle.first
end

def calculate(a_h, b_h)

	a = a_h.values.first
	b = b_h.values.first

	a_name = a[:name]
	b_name = b[:name]

	ary = []

	ary << speculate(a_name, b_name)

	if (a_name == b_name)
		ary << 'What do you think?'
		return ary.join(' ')
	end

	if ((a[:negative] & b[:negative]).include?(:cousin_parents))
	    ary << ra([
	    	"They're already together!"])
	return ary.join(' ')
	end

	if ((a[:negative] & b[:negative]).include?(:bluey_parents))
	    ary << ra([
	    	"They're already together!"])
	return ary.join(' ')
	end


	if (a[:gender] == b[:gender])
	    	ary << ra([
	'Interesting ship...',
	'A taste for slash I see?',
	'Creative ship.'
		])
	end

	no = false

	if (a[:age] != b[:age])
		ary << ra([
	'Take a seat over there.',
   	'Cannot permit that!',
	'Ew, no.',
	'Bit far a part in age?'
		])
		no = true
	end

	if ((a[:negative] & b[:negative]).include?(:family_bluey))
	    ary << ra([
		    "That's certainly a unique ship.",
		    'So you think incest is wincest?',
		    "It's forbidden love."])
	end

	unless no
		ary << case ([a_name, b_name].sort.hash % 2)
		when 1 then ra(["What can I say, it's sheer destiny for them.",
		    "They'd be perfect together <3.",
		"I agree, that would work."])
		when 0 then ra(["No way.",
		    "Can't recommend it really.",
		"Don't think they were made for each other really."])
	end
	end


	return ary.join(' ')
end

def parse(phrase)
	p = phrase.match(/ship (.*) (and|\++|x+) (.*)/i)
	p_tree = {
		pair1: f(p[1]),
		pair2: f(p[3]),
	}
	return p_tree, p_tree.values.any?(&:empty?)
rescue StandardError
	return nil, nil
end

def deter(phrs)

	tree, err = parse(phrs)

	if tree.nil?
		return ra(["Didn't understand that, sorry",
		"Sorry mate, didn't quite get that"])
	end

	if err
		who = ""
		possible = tree.values.reject(&:empty?).first
		if possible
			who = who + possible.values.first[:name]
		end
		return who + " and who? could not figure that out"
	end
	a =  tree[:pair1].values.first[:name]
	b = tree[:pair2].values.first[:name]
	return calculate(tree[:pair1], tree[:pair2])

end

puts deter("bilby ship bandit and bluey")
puts deter("ship bandit and bluey")

require 'discordrb'

bot = Discordrb::Bot.new token: File.read('token').strip

bot.message(content: /bilby.* ship.*/i, in: 'bob-bilby') do |event|
	event.respond(deter(event.content))
end

bot.run

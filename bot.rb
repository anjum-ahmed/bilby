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
		name: 'Mackenzie',
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

FORTUNE = [
'Reply hazy, try again',
'Excellent Luck',
'Good Luck',
'Average Luck',
'Bad Luck',
'Good news will come to you by mail',
'（　´_ゝ`）ﾌｰﾝ',
'ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━ !!!!',
'You will meet a dark handsome stranger',
'Better not tell you now',
'Outlook good',
'Very Bad Luck',
'Godly Luck']

EIGHTBALL = [
'It is certain.',
'It is decidedly so.',
'Without a doubt.',
'Yes - definitely.',
'You may rely on it',
'As I see it, yes',
'Most likely.',
'Outlook good.',
'Yes.',
'Signs point to yes.',
'Reply hazy, try again later',
'Ask again later.',
'Better not tell you now.',
'Cannot predict now.',
'Concentrate and ask again.',
'Don\'t count on it',
'My reply is no.',
'My sources say no.',
'Outlook not so good',
'Very doubtful'
]


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
		ary << case ([a_name, b_name].join.length % 2)
		when 0 then ra(["What can I say, it's sheer destiny for them.",
		    "They'd be perfect together <3.",
		"I agree, that would work."])
		when 1 then ra(["No way.",
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

def fortune
	"Your fortune: #{ra(FORTUNE)}"
end

def eightball
	ra(EIGHTBALL)
	system ("convert -alpha set -background none -rotate #{(rand(400).to_f-200)/10.0} eightball/#{rand(20)+1}.png eightball/answer.png")
	"eightball/answer.png"
end

puts deter("ship lucky and bluey")
puts fortune
puts File.open(eightball)

exit unless ENV['PRODUCTION']

require 'discordrb'

bot = Discordrb::Bot.new token: File.read('token').strip

bot.message(content: /bilby,? ship.*/i, in: 'bob-bilby') do |event|
	event.respond(deter(event.content))
end

bot.message(content: /bilby,? #fortune/i, in: 'bob-bilby') do |event|
	event.respond(fortune)
end

bot.message(content: /bilby,? ask 8-?ball.*/i, in: 'bob-bilby') do |event|
	event.send_file(File.open(eightball))
end

bot.run

require 'date'
require 'sqlite3'
require './chars.rb'
require 'chronic'

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

def f(name)
	return if name.nil?
	$idb.select{|r| !(r =~ name).nil? }
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

def fortune(phrs)
	p = phrs.match(/#fortune for (.+)/i)
	
	unless (p.nil? ? nil : p[1])
		"Your fortune: #{ra(FORTUNE)}"
	else
		"#{p[1]}'s fortune: #{ra(FORTUNE)}"
	end
end

def eightball
	system ("convert -alpha set -background none -rotate #{(rand(90)-45)} eightball/#{rand(20)+1}.png eightball/answer.png")
	"eightball/answer.png"
end

def episodes(query)
	p = (query || 'latest episodes from today').match(/latest episodes from (.*)/i)
	period = Chronic.parse(p[1])
	return "Couldn't understand that..." unless period
	rs = $db.execute("select name, aired from episodes where date(aired) <= date(?) order by aired desc limit 5", period.iso8601)
	return "No episodes before #{p[1]}!" if rs.length == 0
	report = rs.collect{|r| "#{r.first} (aired #{r.last})"}.join("\n")
	puts period
	report
end

def help
	%Q(* Ship characters, ask "bilby, ship [character] and [character]
* Check your or someone's #fortune, ask "bilby, #fortune" or "bilby, fortune for @[person]"
* Shake the magic 8-ball, ask "bilby, ask 8-ball [question]")
end

begin
	$db = SQLite3::Database.open 'episodes.db'
rescue SQLite3::Exception => e
	puts e
	$db.close if $db
end

puts episodes(nil)
puts episodes("bilby, list the latest episodes from october 24 2018")
puts episodes("bilby, list the latest episodes from sdfjoisdjfoisj")
puts deter("bilby, ship bluey and lucky")

require 'discordrb'

begin
  bot = Discordrb::Bot.new token: File.read('token').strip
rescue
  exit
end

bot.message(content: /bilby, help/i) do |event|
	event.respond(help)
end

bot.message(content: /bilby,? ship.*/i, in: 'bob-bilby') do |event|
	event.respond(deter(event.content))
end

bot.message(content: /bilby,? #fortune( for)? .*/i, in: 'bob-bilby') do |event|
	event.respond(fortune(event.content))
end

bot.message(content: /bilby,? #fortune/i, in: 'bob-bilby') do |event|
	event.respond(fortune(event.content))
end

bot.message(content: /bilby,? ask 8-?ball.*/i, in: 'bob-bilby') do |event|
	event.send_file(File.open(eightball))
end

bot.message(content: /bilby,? list the latest episodes/i, in: 'bob-bilby') do |event|
	event.respond(episodes(nil))
end

bot.message(content: /bilby,? list the latest episodes from .*/i, in: 'bob-bilby') do |event|
	event.respond(episodes(event.content))
end

bot.run
$db.close if $db

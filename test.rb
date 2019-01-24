require 'discordrb'

bot = Discordrb::Bot.new token: File.read('token')

bot.message(content: 'Ping!') do |event|
	event.respond "Helllo!!! It's Bob Bilby!!"
end

bot.run

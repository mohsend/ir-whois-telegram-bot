require 'telegram/bot'
require 'net/http'
require 'uri'

unavailabes = Hash.new

file = File.new("token.txt", "r")
token = file.gets.strip

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    else
      domain = message.text.strip
      if domain =~ /.*\.ir/i
        uri = URI.parse("http://whois.nic.ir/?name=#{domain}")
        response = Net::HTTP.get_response(uri)
        if response.body.include? "ERROR:101: no entries found" 
          bot.api.send_message(chat_id: message.chat.id, text: "#{domain} is AVAILABLE! :)")
        else
          bot.api.send_message(chat_id: message.chat.id, text: "#{domain} is NOT available! :(\n\rBUT we'll inform you when it goes WILD!")
        end
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Gimme valid .ir domain name.")
      end
    end
  end
end

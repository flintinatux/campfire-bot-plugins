class Echo < CampfireBot::Plugin
  on_command 'echo', :say
  on_command 'say', :say
  on_command 'tell', :tell
  on_message %r[Ruby, do you]i, :do_you
  on_message %r[(I'm |hea(d|ded|ding|din') )out]i, :goodbye
  on_message %r[Ruby, what do you think]i, :what_i_think

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::Echo"]
  end

  def do_you
    m.speak ['Yes.', 'No.', 'I guess so...', 'Perhaps.', 'Why are you asking me?'].sample
  end
  
  def say(m)
    m.speak(m[:message])
  end

  def tell(m)
    message = m[:message]
    message.sub! /^([^\s]+)/, '\1:'
    m.speak message
  end

  def goodbye(m)
    name = m[:person].split.first
    farewells = [
                  "Peace.",
                  "Cya later, #{name}.",
                  "See you tomorrow, #{name}!",
                  "Goodbye, #{name}.",
                  "Don't worry, #{name}. I'll be here when you get back!",
                  "Drive fast and turn hard."
                ]
    m.speak farewells.sample
  end

  def what_i_think(m)
    name = m[:person].split.first
    responses = [
                  "Of course, #{name}!",
                  "I agree with #{name}.",
                  "What he said.",
                  "Absolutely."
                ]
    m.speak responses.sample
  end
end
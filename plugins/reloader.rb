class Reloader < CampfireBot::Plugin
  on_command 'reload', :reload

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::Reloader"]
  end

  def reload(m)
    # Cheat for now and just exit! to reload everything
    m.speak 'Reloading...'
    exit!
  end
end
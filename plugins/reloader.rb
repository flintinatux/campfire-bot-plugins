class Reloader < CampfireBot::Plugin
  on_command 'reload', :reload

  def reload
    what = m[:message]
    things_to_reload = ['plugins' => :load_plugins]
    CampfireBot::Bot.instance.send things_to_reload[what]
  end
end
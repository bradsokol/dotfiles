if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'w', 'whereami'
end

default_command_set = Pry::CommandSet.new do
  command 'sql', 'Send SQL using Active Record' do |query|
    if ENV['RAILS_ENV'] || defined?(Rails)
      pp ActiveRecord::Base.connection.select_all(query)
    else
      pp 'No Rails environment defined'
    end
  end
end

Pry.config.commands.import default_command_set

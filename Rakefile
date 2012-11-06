
desc "Add binw to user %PATH%."
task :binw do
  # Find absolute path of binw.
  binw = File.absolute_path('binw')
  # Add to user path with setx command.
  system("setx path \"#{binw};%PATH%\"")
end

desc "Setup Vim configuration for corrent user account."
task :vim do
  require 'vim/Rakefile'
  # Run the default task from that file?
end

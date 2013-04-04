
desc "Add binw to user %PATH%."
task :binw do
  # Find absolute path of binw.
  binw = File.absolute_path('binw')
  binw.gsub!(?/, ?\\)

  # Get user path and parse into array.
  user_path = `REG QUERY HKCU\\Environment /v Path`.sub(
    '    Path    REG_SZ    ', '').split($/)[2].split(?;)
          
  # Check if binw already exists in the user path.
  if user_path.include? binw
    puts "binw already in user path."
  else
    # Add to user path with setx command.
    system("setx path \"#{binw};%PATH%\"")
    puts "binw added to user path."
  end
end

desc "Setup Vim configuration for current user account."
task :vim do
  require 'vim/Rakefile'
  # Run the default task from that file?
end

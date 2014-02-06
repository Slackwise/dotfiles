BIN   = "C:\\bin"
BINW  = File.absolute_path('binw').gsub(?/, ?\\)

def dir_in_path?(dir)
  `REG QUERY HKCU\\Environment /v Path`.sub(
    '    Path    REG_SZ    ', '').split($/)[2].split(?;).include? dir
end


desc "Add #{BIN} to user %PATH%."
task :bin do
  # Check if binw already exists in the user path.
  if dir_in_path? BIN
    puts "#{BIN} already in user path."
  else
    # Add to user path with setx command.
    system("setx path \"#{BIN};%PATH%\"")
    puts "#{BIN} added to user path."
  end
end

desc "Add binw to user %PATH%."
task :binw do
  # Check if binw already exists in the user path.
  if dir_in_path? BINW
    puts "binw already in user path."
  else
    # Add to user path with setx command.
    system("setx path \"#{BINW};%PATH%\"")
    puts "binw added to user path."
  end
end

desc "Setup %PATH% for Windows."
task :setup_path => [:bin, :binw]

desc "Setup Vim configuration for current user account."
task :vim do
  require 'vim/Rakefile'
  # Run the default task from that file?
end

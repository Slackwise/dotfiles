#!/usr/bin/env ruby

# This script is supposed to bootstrap my Vim config on a new machine. It
# should ideally only be run once, with only needing Git pulls to maintain.

HOME = ENV['HOME']
VIMRC = HOME + "/src/dotfiles/vim/vimrc"

WIN_VIMRC = <<WIN_VIMRC_END
let $MYVIMRC="~/src/dotfiles/vim/vimrc"
source $MYVIMRC
WIN_VIMRC_END

CURL = <<CURLEND
@rem Do not use "echo off" to not affect any child calls.
@setlocal

@rem Get the abolute path to the parent directory, which is assumed to be the
@rem Git installation root.
@for /F "delims=" %%I in ("%~dp0..") do @set git_install_root=%%~fI
@set PATH=%git_install_root%\\bin;%git_install_root%\\mingw\\bin;%PATH%

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@curl.exe %*
CURLEND

def windows_setup
  # Install a redirecting vimrc file in $HOME.
  begin
    File.open(HOME + "/_vimrc", 'w+') do |f|
      f.puts WIN_VIMRC
    end
    puts "Created _vimrc."
  rescue
    puts "Failed to create _vimrc:\n#$!"
  end

  # Locate Git install in registry.
  dir64 = ENV['PROGRAMFILES'] + "/Git/cmd"
  dir32 = ENV['PROGRAMFILES(X86)'] + "Git/cmd"
  if Dir.exists? dir64
    dir = dir64
  elsif Dir.exists? dir32
    dir = dir32
  else
    raise "Cannot locate Git installation!"
    exit 1
  end

  # Write curl.cmd to Git/cmd directory.
  begin
    curl = dir + "/curl.cmd"
    if !File.exists? curl
      File.open(curl, 'w') do |f|
        f.puts CURL
      end
    else
      puts "Curl command file has already been created."
    end
  rescue
    puts $!
  end

  # Add Git/cmd directory to system $PATH.
  if !ENV['PATH'].match(/Git\\cmd/)
    if system(%|SETX PATH "%PATH%;#{dir}" /M|)
      puts 'Git has been added to the system $PATH'
    else
      raise "Couldn't add Git to the system $PATH!"
      exit 1
    end
  else
    puts 'Git is already in the $PATH.'
  end

  puts 'Closing automatically in 5 seconds...'
  sleep 5
end

def nixie_setup
  # Symlink vimrc, nothing more!
  if File::symlink(VIMRC, HOME + "/.vimrc")
    puts 'Symlinked vimrc file.'
  else
    puts 'Failed to symlink vimrc file!'
  end
end

def is_admin?
  if ARGV.include? "-a"
    true
  else
    false
  end
end

def restart_as_admin
  require 'win32ole'
  WIN32OLE.new('Shell.Application')
    .ShellExecute('ruby.exe', File::expand_path(__FILE__) + " -a",
                  nil, 'runas', 1)
end

case RUBY_PLATFORM
when /linux/, /darwin/
  nixie_setup
when /mswin/, /mingw32/
  if is_admin?
    windows_setup
  else
    restart_as_admin
  end
end

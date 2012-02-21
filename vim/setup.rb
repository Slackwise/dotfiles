#!/usr/bin/env ruby

# This script is supposed to bootstrap my Vim config on a new machine. It
# should ideally only be run once, with only needing Git pulls to maintain.

CURL = <<CURLEND
@rem Do not use "echo off" to not affect any child calls.
@setlocal

@rem Get the abolute path to the parent directory, which is assumed to be the
@rem Git installation root.
@for /F "delims=" %%I in ("%~dp0..") do @set git_install_root=%%~fI
@set PATH=%git_install_root%\\bin;%git_install_root%\mingw\\bin;%PATH%

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@curl.exe %*
CURLEND

def windows_setup
  # Write curl.cmd to Git/cmd directory.
  # Add Git/cmd directory to system $PATH.
end

def nixie_setup
  # Symlink vimrc, nothing more!
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
  puts ENV['USERNAME']
  if is_admin?
    windows_setup
  else
    restart_as_admin
  end
end

# Whenever I wake up my XP virtual machine from sleep, the time is off.
# This throws off a number of scripts and apps that I run off it, so I
# have to sync the time. Unfortunately, XP requries you to have the date
# match in order to sync the time. Originally this script set the date,
# then called the w32tm utilty to sync the time, but it would take too long
# to process, and sometimes time out. Instead, I just decided to say 'fsck it'
# and used the Ruby NTP library fully. The time is maybe off by a second at
# the very most, which is good enough.


require 'net/ntp'

# XP's date command expects MM/DD/YYYY, e.g. 5/15/2009
DATE_FORMAT = '%m/%d/%Y'

# XP's time command expects HH:MM:SS AM/PM, e.g. 5:34:00 PM
TIME_FORMAT = '%I:%M:%S %p'

begin
  datetime = Net::NTP.get.time
rescue
  puts "Failed to get NTP time information: #$!"
  gets # Pause so you can read output.
  exit 1
end

system("date #{datetime.strftime(DATE_FORMAT)}")
system("time #{datetime.strftime(TIME_FORMAT)}")


__END__
until system("w32tm /resync /rediscover")
  sleep 10
end

puts 'Forced time sync completed.'
puts 'Press ENTER to close window.'
gets # Pause so you can read the output.

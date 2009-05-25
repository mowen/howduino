require "rubygems"
require "serialport"

sp = SerialPort.new "/dev/tty.usbserial-A6008clO", 9600

filename = ARGV[0]
f = File.open(filename)
lines = f.readlines

lines.each do |line|
  line.split(" ").each do |num|
    sp.write num
  end
  sp.write "\n"
  sleep 0.05
end

#!/usr/bin/env ruby

# Take the file of p300 deltas by gene & find ones that have a large difference
# One delta has to be positive & one has to be negative

class Peak
  attr_reader :delta
  def initialize(name,delta)
    @peak = name.downcase
    @delta = delta.to_f
  end

  def <=>(b)
    self.delta <=> b.delta
  end

  def to_s()
    "#{@peak}\t#{delta}"
  end
end

genes = {}

ARGF.each do |line|
  (gene,peak,delta) = line.chomp.split(/\t/)
  next if gene =~ /Gene Name/
  p = Peak.new(peak,delta)
  genes[gene] ||= []
  genes[gene] << p
end

puts %w/gene min_peak_name min_peak_delta max_peak_name max_peak_delta/.join("\t")
genes.each do |gene,peaks|
  next unless peaks.size > 1
  peaks.sort!
  min = peaks[0]
  max = peaks[-1]
  if min.delta() < 0 && max.delta() > 0 || min.delta() > 0 && max.delta() < 0
    puts "#{gene}\t#{min}\t#{max}"
  end
end

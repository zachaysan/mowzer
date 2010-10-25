require 'rubygems'
require 'pp'

class Mowzer
  def initialize(points={5=>[2,4,7,9], 6=>[2,4,5,7], 7=>[2], 8=>(12..19).to_a}, options = {} )
    defaults = { 
      :min_size => 3, 
      :min_target_size => 4,
      :min_overlap => 0.20,
      :min_target_overlap => 0.25
    }
    @settings = options.dup
    defaults.each {|k,v| @settings[k] ||= v}
    @points = points
  end
  # rename this method
  def each_with_number(point, options = {:number_type => :inclusive})
    target = @points[point].dup
    @points.each do |k, v|
      case options[:number_type]
      when :exclusive
        value = exclusive(target, v)
      when :remaining
        value = remaining(target, v)
      when :inclusive
        value = inclusive(target, v)
      end
      yield(k, v, value)
    end
  end
  def each_with_classification(point, options = {})
    target = @points[point].dup
  end
  def size_ok?(v)
    v.uniq.length >= @settings[:min_size]
  end
  def target_size_ok?(target)
    target.uniq.length >= @settings[:min_target_size]
  end
  def overlap_ok?(target, v)
    @settings[:min_overlap] >= inclusive(target, v).to_f / v.length.to_f
  end
  def target_overlap_ok?(target, v)
    @settings[:min_target_overlap] >= inclusive(target, v).to_f / target.length.to_f
  end
  def relationship(target, v)
    # there are five basic types of overlap.
    # islands => no one member is shared
    # overlap => at least one member is shared and at least one member FROM EACH is not shared
    # target_encloses => target has every point that v has, AND MORE
    # identicals => a point in target exists if, and only if, the point is in v (identical sets)
    # target_enclosed => v has every point that target has, AND MORE
    return :islands if !any_overlap?(target, v)
    return :overlap if any_overlap?(target, v) and !enclosed?(target, v)
    if enclosed?(target, v)
      return :target_encloses if encloses_type(target,v) == 1
      return :identicals if encloses_type(target, v) == 0
      return :target_enclosed if encloses_type(target, v) == -1
      raise "enclosure type error, an enclosure was detected, but its type could not be ascertained"
    else
      raise "error finding relationship, it seems that none of the conditions could be met"
    end
  end
  
  protected
  def any_overlap?(target, v)
    inclusive(target, v) > 0
  end
  def enclosed?(target, v)
    inclusive(target, v) == target.length or inclusive(target, v) == v.length
  end

  def encloses_type(target, v)
    # useful for <=> like operations, like sort
    # 1 => target_encloses, 0 => indenticals, -1 => target_enclosed
    raise "no type of enclosure detected" unless enclosed?(target, v)
    if inclusive(target,v) == target.length and inclusive(target,v) == v.length \
      and exclusive(target, v) == 0 and remaining(target, v) == 0
      0
    elsif inclusive(target, v) == v.length and exclusive(target, v) == 0 \
      and remaining(target, v) > 0 and inclusive(target, v) <  target.length
      1
    elsif inclusive(target, v) == target.length and exclusive(target, v) > 0 \
      and remaining(target, v) == 0 and inclusive(target, v) < v.length
      -1
    else
      # an bug must exist, here are some helpers
      puts "if you were expecting target to be fully enclosed by v"
      puts "#{inclusive(target, v)} should be #{target.length}"
      puts "#{exclusive(target, v)} should be greater than zero"
      puts "#{remaining(target, v)} should be 0"
      puts "#{inclusive(target, v)} should be less than #{v.length}"
       raise "an error occured while trying to find the enclosure type"
    end
  end
  def exclusive(target, v)
    target.dup.concat(v).uniq.length - target.length
  end
  def remaining(target, v)
    target.dup.concat(v).uniq.length - v.length
  end
  def inclusive(target, v)
    -1 * (target.dup.concat(v).uniq.length - v.length - target.length)
  end
end
m = Mowzer.new


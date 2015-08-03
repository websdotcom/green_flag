class GreenFlag::VisitorGroup

  class MultipleGroupsError < StandardError; end
  MUTEX = Mutex.new

  attr_reader :key, :description

  def self.define(&block)
    instance_eval(&block)
  end

  def self.group(key, description=nil, type=GreenFlag::VisitorGroup, &block)
    new_group = nil
    MUTEX.synchronize do
      key_exists = for_key(key)
      if key_exists
        raise MultipleGroupsError.new "Two groups with key :#{key} were defined.  Rename one of them!"
      end
      new_group = type.new(key, description, &block)
      @groups ||= []
      @groups << new_group
    end
    new_group
  end

  def self.user_group(key, description=nil, &block)
    group(key, description, GreenFlag::UserGroup, &block)
  end

  def self.for_key(key)
    all.find { |g| g.key.to_s == key.to_s }
  end

  def self.clear!
    @groups = []
  end

  def self.all
    @groups || []
  end

  def self.keys
    all.map(&:key)
  end

  def initialize(key, description=nil, &block)
    self.key = key.to_s
    self.description = description
    self.evaluator = block
  end

  def includes_visitor?(visitor, rule=nil)
    evaluator.call(visitor, rule)
  end

private
  attr_writer :key, :description, :evaluator
  attr_reader :evaluator

end

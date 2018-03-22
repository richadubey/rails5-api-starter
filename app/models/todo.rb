class Todo < ApplicationRecord
	validates_presence_of :title, :completed
  


  after_commit :flush_cache

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end

  def self.cache_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

end


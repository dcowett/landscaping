# config/initializers/acts_as_taggable.rb

ActsAsTaggableOn.force_lowercase = true

# tags_counter enables caching count of tags which results in an update whenever a tag is added or removed
# since the count is not used anywhere its better performance wise to disable this cache
# see https://github.com/mbleigh/acts-as-taggable-on/wiki#counter-cache
# ActsAsTaggableOn.tags_counter = false

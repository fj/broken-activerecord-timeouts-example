##
# You can use other adapters like:
#
#   ActiveRecord::Base.configurations[:development] = {
#     :adapter   => 'mysql2',
#     :encoding  => 'utf8',
#     :reconnect => true,
#     :database  => 'your_database',
#     :pool      => 5,
#     :username  => 'root',
#     :password  => '',
#     :host      => 'localhost',
#     :socket    => '/tmp/mysql.sock'
#   }
#

require 'erb'
YAML.load(ERB.new(File.read Padrino.root('config', 'database.yml')).result).each { |name, hash|
  symbolized_hash = hash.each_with_object({}) do |(k, v), h|
    h[k.to_sym] = v
  end
  ActiveRecord::Base.configurations[name.to_sym] = symbolized_hash
}

# Setup our logger
ActiveRecord::Base.logger = logger

# Doesn't include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper
# if you're including raw JSON in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Timestamps are in UTC by default.
ActiveRecord::Base.default_timezone = :utc

# Now we can establish connection with our db.
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])

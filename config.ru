require './config/environment'

use Rack::MethodOverride

#turns off display of active record db calls
#ActiveRecord::Base.logger.level = 1 # or Logger::INFO

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use CommentsController
use TypesController
use TagsController
use GamesController
use UsersController
run ApplicationController

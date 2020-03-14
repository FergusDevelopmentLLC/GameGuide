require './config/environment'

use Rack::MethodOverride

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use CommentsController
use TypesController
use TagsController
use GamesController
use UsersController
run ApplicationController

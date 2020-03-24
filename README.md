# GameGuide

GamesGuide is a demonstration Ruby/Sinatra web application created to keep track of a board game collection. Users can login, add games, comment on games and tag them.

## Installation

Clone this repository.

Run:

```
$ cd GameGuide
$ bundle install
$ rake db:migrate 
$ rake db:seed 
$ shotgun
```

There will be one user in the system after seeding with the following credentials. Logging in not required to see the app in action.

```
username: user
password: password
```

## Contributing Bugfixes or Features

* Fork the this repository
* Create a local development branch for the bugfix; I recommend naming the branch such that you'll recognize its purpose.
* Commit a change, and push your local branch to your github fork
* Send me pull request for your changes to be included

## License

GameGuide is licensed under the MIT license. (http://opensource.org/licenses/MIT)
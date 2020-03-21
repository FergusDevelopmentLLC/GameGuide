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

## License

GameGuide is licensed under the MIT license. (http://opensource.org/licenses/MIT)
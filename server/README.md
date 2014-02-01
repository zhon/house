House Server
------------

Installation
============

```bash
bundle install
```

Install (``mongodb``)[http://www.mongodb.org/]

```bash
brew install mongodb
```

Run the database

```bash
mongod
```

Seed the database

```base
ruby -e "ENV['MONGOID_ENV']='development'; load 'seed.rb'"
```

Run the sever
```base
ruby app.rb
```



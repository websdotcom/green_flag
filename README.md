# ![Green Flag Logo](./green_flag_small.png?raw=true) Green Flag

A feature-flag system that makes it *really easy* for application developers to add and manage features.  You can roll out features to a percentage of your users, or you can define groups to see the new feature.  Want to test a new feature on 50% of your premium-plan users named "Fred"?  GreenFlag can do that.

Status: Recently extracted from a running application.  Version 0.1 is just enough for us to use it as a gem.  Some of the niceties (like this document) are pretty rough. 

## New feature?  Just do this:

In a controller or view, check for a feature:
```ruby
if feature_enabled?(:my_awesome_feature)
  # New hotness
else
  # Old stuff
end
```

That's it. You don't have to create a feature record (it's done automatically).  
You don't have to figure out who should see the feature - that's set up in the admin web interface.

Features are off by default - so if you deploy your new code, no one will get the new hotness until you open it up with the admin web interface.  

## How it works

TODO: explain about visitors, users and features.

## Installation

### Requirements
- Rails 3
- Postgres
- `User` class, and `current_user` controller method

TODO: Some of this should be scripted with a generator
- Normal engine install process
- Install/run migrations
- Create an initializer to define visitor groups
- Mount admin in routes.rb

## Admin panel

TODO: explain all of the stuff on the admin panel


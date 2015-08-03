# Green Flag

![Green Flag Logo](./green_flag.png?raw=true)

Feature testing for environmentally-conscious pirates.

## New feature?  Just do this:

In a controller or view, check for a feature:
```ruby
if feature_enabled?(:my_awesome_feature)
  # New hotness
else
  # Old stuff
end
```

Add some users:
```ruby
user = User.find(1)
GreenFlag::FeatureDecision.whitelist_user!(:my_awesome_feature, user)
```

Now that user, and only that user, will see your new awesome feature.

## How it works

TODO: explain about visitors, users and features.

## Admin panel

TODO: explain all of the stuff on the admin panel


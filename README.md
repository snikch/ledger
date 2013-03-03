# Ledger

Does your app have the concept of accounts, with multiple users per account?

Yes?

Great.

Ledger will easily allow you to create an activity stream of user events on a per account basis.

## Installation

Add this line to your application's Gemfile:

    gem 'ledger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ledger

## Usage

Start by adding the `HasEvents` module to your account object.

```ruby
class Accounts
	…
	include Ledger::HasEvents
	…
end
```

Add in the `CreatesEvents` module to your controller.

```ruby
class CategoriesController
	…
	include Ledger::CreatesEvents
	…
end
```

Now all you need to do is call `#create_event` when you do something.

```ruby
def update
	@category.update_attributes! params[:category]
	create_event :updateated, @category
end
```

Retrieve your event stream like so

```ruby
account.event_stream.each do |e|
	puts "#{a.actor['name']} #{a.action} #{a.object} #{a.data['name']}"
end
"Mal Curtis updated Category Food"
```

`#event_stream` brings back the last 10 events. Send through an integer to get more.

Each event has the following (by default, for options see further down).

```
{
	"key"=>"category_updated",
	"action"=>"updated",
	"object"=>"Category",
	"actor"=>{
		"id"=>1,
		"email"=>"mal@mal.co.nz",
		"name"=>"Mal Curtis"
	},
	"data"=>{
		"id"=>1515,
		"name"=>"Food"
	},
	"created_at"=>2013-03-03 09:28:59 +1300
}
```

Ledger isn’t opinionated about how you display your events in your app. You’ll need to figure that one out.

## Customizing

### Accounts & Users

Ledger expects there to be a `current_account` and `current_user` method when creating an event. If this doesn’t suit your app, smash this into an initializer.

```ruby
Ledger.configure do |config|
	config.event_scope_method = :current_account # Or whatevs
	config.event_actor_method = :current_user # as above
end
```

### Moar object data

Ledger will try and add `id`, `email` and `name` from your user object and `id` and `name` from the object passed to `#create_event`. If you don’t have some of these methods, or want to add more information, just define `#event_details` and return a hash.

```ruby
class User
	include Ledger::HasEvents
	def event_details
		{ id: id, email: email, username: username }
	end
end

class Category
	def event_details
		{ id: id, parent: parent_id, description: description }
	end
end
```

### Moar event data

Want to send more information about events? Just send through the information at the end of the `#create_event` call.

```ruby
create_event :state_changed, @category, from: from_state, to: @category.state
```
```

{
	"key"=>"category_state_changed",
	"action"=>"state_changed",
	"object"=>"Category",
	"actor"=>{
		"id"=>1,
		"email"=>"mal@mal.co.nz",
		"name"=>"Mal Curtis"
	},
	"data"=>{
		"id"=>1515,
		"name"=>"Food",
		"from"=>"available",
		"to"=>"unavailable"
	},
	"created_at"=>2013-03-03 09:28:59 +1300
}
```


### Redis connection

Ledger defaults to `$redis`. If you want to set this manually, customize it in an initializer. Here's an example:

```ruby
Ledger.configure do |config|
	uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://127.0.0.1:6379')
	config.redis = Redis.new(
		:host => uri.host,
		:port => uri.port,
		:password => uri.password
	)
end
```

### Manual Events

You can add an event manually by creating an instance of `Ledger::Event`, then adding than in via `account.add_event`.

```ruby
new_event = Ledger::Event.new key: "manual_event", data: { some: "thing" }
account.add_event new_event
```

### Direct Redis access

You can access redis directly through `#events`. This will be a [Nest](https://github.com/soveran/nest) instance, and you can call on this, or use its naming schema to do some other magic.

```ruby
# Trim the events down to the last 100 events
account.events.ltrim 0, 100

# Create a new redis key (account:xxx:events:something_else)
account.events["something_else"].lpush "Some data"
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Gabba-GMP



Simple class to send custom server-side events to Google Analytics via Google Measurement Protocol
https://developers.google.com/analytics/devguides/collection/protocol/v1/

Refactored from the [gabba](https://github.com/hybridgroup/gabba) project.
 - Heavily influenced by the [serversidegoogleanalytics][] project.

## Examples

### Track page views

```ruby
google_tracker_id = "UT-1234"
host = "#{request.host}"
cookies[:utm_visitor_uuid] = { value: "#{SecureRandom.uuid}", expires: 1.year.from_now} if !cookies[:utm_visitor_uuid].present?
visitor_id = "#{cookies[:utm_visitor_uuid]}"
client_ip = "#{request.remote_ip}"
user_agent = "#{request.env["HTTP_USER_AGENT"]}"

gabba = GabbaGMP::GabbaGMP.new(google_tracker_id, host, visitor_id, client_ip, user_agent)

gabba.page_view("page title", "page/1.html")
```

### Track custom events

```ruby
gabba = GabbaGMP::GabbaGMP.new(google_tracker_id, host, visitor_id, client_ip, user_agent)

gabba.event("Videos", "Play", "ID", "123")
```

### Setting custom vars

```ruby
# Index: 1 through 50
index = 1

# Scope: VISITOR, SESSION or PAGE
scope = GabbaGMP::GabbaGMP::VISITOR

# Set var
gabba.set_custom_var(index, 'Name', 'Value', scope)

# Track the event (all vars will be included)
gabba.event(...)

# Track the page view (all vars will be included)
gabba.page_view(...)
```

### License

Gabba is released under the [MIT License](http://opensource.org/licenses/MIT).


[serversidegoogleanalytics]: http://code.google.com/p/serversidegoogleanalytics

# Gabba-GMP

[![Gem Version](https://badge.fury.io/rb/gabba-gmp.svg)](http://badge.fury.io/rb/gabba-gmp)

Simple class to send custom server-side events to Google Analytics via Google Measurement Protocol
https://developers.google.com/analytics/devguides/collection/protocol/v1/

Refactored from the [gabba](https://github.com/hybridgroup/gabba) project.
 - Heavily influenced by the [serversidegoogleanalytics][] project.

## Examples

### Track page views

```ruby
google_tracker_id = "UT-1234"

gabba = GabbaGMP::GabbaGMP.new("UT-1234", request, cookies)

gabba.page_view(request)

```

You can also include the page title:
```ruby
gabba.page_view(request, "Page Title")

```

Or if you want to get really fancy you can update the parameters for the page view only..
```ruby
gabba.page_view(request, "Page Title", document_path: "/manually/fiddled/url")

```

### Track custom events

```ruby
gabba = GabbaGMP::GabbaGMP.new("UT-1234", request, cookies)

gabba.event("Videos", "Play", "ID", "123")
```

### Setting custom vars

```ruby
# Index: 1 through 200 (for pro or 20 for free)
index = 1

# Set var
gabba.set_custom_var(index, 'Name', 'Value')

# Track the event (all vars will be included)
gabba.event(...)

# Track the page view (all vars will be included)
gabba.page_view(...)
```

### Campaigns

It's easy to track campaigns! You can either use the GabbaGMP campaign object or your own(assuming it has the magic fields)!

Note that you can also send in `nil` into campaigns, and it will still work... one less check to do!

```ruby

campaign = GabbaGMP::Campaign()

campaign.name = "GabbaCMP"
campaign.source = "gemfile"
campaign.medium = "email"
campaign.keyword = nil
campaign.content = "gems"

gabba.campaign = campaign

```


### License

Gabba is released under the [MIT License](http://opensource.org/licenses/MIT).


[serversidegoogleanalytics]: http://code.google.com/p/serversidegoogleanalytics

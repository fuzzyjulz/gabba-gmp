# Gabba-GMP

[![Gem Version](https://badge.fury.io/rb/gabba-gmp.svg)](http://badge.fury.io/rb/gabba-gmp)

Simple class to send custom server-side events to Google Analytics via Google Measurement Protocol
https://developers.google.com/analytics/devguides/collection/protocol/v1/

Refactored from the [gabba](https://github.com/hybridgroup/gabba) project.
 - Heavily influenced by the [serversidegoogleanalytics][] project.

## Examples

### Track page views

```ruby
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

### Manually setting parameters

If you find that you absolutely must override variables that are used internally then you can override the session parameters:

```ruby
gabba = GabbaGMP::GabbaGMP.new("UT-1234", request, cookies)

#Manually override the user agent so that we can detect local calls in GA! 
gabba.add_options(user_agent: "LocalUse") if request.remote_ip == "127.0.0.1"

#This pageview has the new user agent! (if you are accessing from localhost)
gabba.page_view(request)

#This event also has the user agent! Easy as!
gabba.event("Videos", "Play", "ID", "123")

```

### Parameters that may be set

protocol_version:
tracking_id:

client_id:
user_id:
user_ip_address:
user_agent:
user_language:

hit_type:

document_title:
document_path:
document_referrer:
document_host:

event_category:
event_action:
event_label:
event_value:

campaign_name:
campaign_source:
campaign_medium:
campaign_keyword:
campaign_content:

dimension_<1-200>:

*Untested*
user_screen_resolution:
user_viewport_size:
user_screen_colors:


### License

Gabba is released under the [MIT License](http://opensource.org/licenses/MIT).


[serversidegoogleanalytics]: http://code.google.com/p/serversidegoogleanalytics

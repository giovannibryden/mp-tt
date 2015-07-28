class DashboardController < ApplicationController
  
  require 'mixpanel-ruby'

  tracker = Mixpanel::Tracker.new(7930aab126c66d1b7dd5e4fddf3c89fa)

  # # Tracks an event, 'Sent Message',
  # # with distinct_id user_id
  # tracker.track(user_id, 'Sent Message')

  # # You can also include properties to describe
  # # the circumstances of the event
  # tracker.track(user_id, 'Plan Upgraded', {
  #     'Old Plan' => 'Business',
  #     'New Plan' => 'Premium'
  # })

  def show
    @players = Player.all
    @games = Game.all

    tracker.track(user_id,'Page view', {
    	'Page name' => 'Home'
    	})
  end
end

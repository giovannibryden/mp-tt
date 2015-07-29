class ResultsController < ApplicationController
  before_action :set_game
  require 'open-uri'
  require 'net/http'

  def create
    response = ResultService.create(@game, params[:result])

    if response.success?

      # Parse response 
      webhook_content = response.result.to_json
      winner = JSON.parse(webhook_content)["winner"]
      loser = JSON.parse(webhook_content)["loser"]
      
      # Build payload
      payload = {
        :channel => "#table-tennis",
        :username => "Yung Bot",
        :text => winner+" just beat "+loser+"!",
        :icon_emoji => ":100:"
      }

      payload_json = payload.to_json

      # Send webhook
      params = {'payload' => payload_json}
      url = URI.parse('https://hooks.slack.com/services/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')
      resp, data = Net::HTTP.post_form(url, params)

      redirect_to game_path(@game)
    else
      @result = response.result
      render :new
    end
  end

  def destroy
    result = @game.results.find_by_id(params[:id])

    response = ResultService.destroy(result)

    redirect_to :back
  end

  def new
    @result = Result.new
    (@game.max_number_of_teams || 20).times{|i| @result.teams.build rank: i}
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end

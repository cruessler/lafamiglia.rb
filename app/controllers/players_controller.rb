class PlayersController < ApplicationController
  SEARCH_FIELD_ITEM_LIMIT = 10

  # GET /sources/search/for.json
  def search
    respond_to do |format|
      format.json do
        like_clause = "%#{params[:query]}%"

        @players = Player.where([ 'players.name LIKE ?', like_clause ])
                         .limit(SEARCH_FIELD_ITEM_LIMIT)
                         .order('players.name ASC')
                         .collect
      end
    end
  end
end

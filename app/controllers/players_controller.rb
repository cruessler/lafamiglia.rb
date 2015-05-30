class PlayersController < ApplicationController
  SEARCH_FIELD_ITEM_LIMIT = 10
  RANKING_PLAYERS_PER_PAGE = 20

  before_action :set_player, only: [ :show ]

  # GET /players/1
  def show
  end

  # GET /players
  def index
    @players = Player.order('players.points DESC')
                     .page(params[:page])
                     .per(RANKING_PLAYERS_PER_PAGE)

    @start_position = (@players.current_page - 1) * RANKING_PLAYERS_PER_PAGE
  end

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

  private

  def set_player
    @player = Player.find(params[:id])
  end
end

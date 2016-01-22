class RelatedPlayersController < InheritedResources::Base

  private

    def related_player_params
      params.require(:related_player).permit(:player_id)
    end
end
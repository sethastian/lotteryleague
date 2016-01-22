class PlayersController < InheritedResources::Base

  private

    def player_params
      params.require(:player).permit(:name, :number, :phone, :instrument, :image, :email, :practiceLocation, :related_player_id)
    end
end


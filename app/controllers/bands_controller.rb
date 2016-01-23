class BandsController < InheritedResources::Base

  private

    def band_params
      params.require(:band).permit(:number, :title, :player1, :player2, :player3, :player4, :draft_id)
    end
end


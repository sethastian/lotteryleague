class BandsController < InheritedResources::Base

	def show
		@band = Band.find_by_number(params[:id])
	end
  private

    def band_params
      params.require(:band).permit(:number, :title, :player1, :player2, :player3, :player4, :draft_id)
    end
end


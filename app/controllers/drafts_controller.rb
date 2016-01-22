class DraftsController < InheritedResources::Base





  private

    def draft_params
      params.require(:draft).permit(:liveBand, :round, :title, :numberOfBands)
    end
end


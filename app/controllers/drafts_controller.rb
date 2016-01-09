class DraftsController < InheritedResources::Base

  private

    def draft_params
      params.require(:draft).permit(:title)
    end
end


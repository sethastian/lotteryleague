class IncompatiblesController < InheritedResources::Base

	

  private

    def incompatible_params
      params.require(:incompatible).permit(:mate_id, :incompatibility_id)
    end
end


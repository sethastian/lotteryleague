class MatesController < InheritedResources::Base

  private

    def mate_params
      params.require(:mate).permit(:name, :number, :image, :instrument)
    end
end


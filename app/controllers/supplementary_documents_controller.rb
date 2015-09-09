class SupplementaryDocumentsController < ApplicationController

  def new
    @plan = Plan.find(params[:plan_id])
    @s3_direct_post =
      AWS::S3.new.buckets[ENV["CARRIERWAVE_S3_BUCKET"]]
      .presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}",
                      success_action_status: 201,
                      acl: :public_read)
  end
  
  def create
    @plan = Plan.find(params[:plan_id])
    @supplementary_document = @plan.supplementary_documents.create(supplementary_document_params)
  end

  def destroy
    @supplementary_document = SupplementaryDocument.find(params[:id])
    @supplementary_document.destroy
  end

  private

  def supplementary_document_params
    params.require(:supplementary_document).permit(:name, :description, :file)
  end

end

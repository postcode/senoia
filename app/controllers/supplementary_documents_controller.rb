class SupplementaryDocumentsController < ApplicationController
  def new
    @parent = parent
    @staff_contact = true if params[:staff] == "true"
    authorize! :edit, @parent
    @s3_direct_post =
      AWS::S3.new.buckets[ENV["S3_BUCKET"]]
      .presigned_post(key: "#{SecureRandom.uuid}/${filename}",
                      success_action_status: 201,
                      acl: :public_read)
  end

  def create
    @parent = parent
    authorize! :edit, @parent
    @supplementary_document = @parent.supplementary_documents.create(supplementary_document_params)
    if @supplementary_document.staff_contact == true
      @supplementary_document.email = false
    else
      @supplementary_document.staff_contact = false
    end
    @supplementary_document.save
  end

  def destroy
    @supplementary_document = SupplementaryDocument.find(params[:id])
    authorize! :edit, @supplementary_document.parent
    @supplementary_document.destroy
  end

  private

  def parent
    if params[:plan_id]
      Plan.find(params[:plan_id])
    elsif params[:post_event_treatment_report_id]
      PostEventTreatmentReport.find(params[:post_event_treatment_report_id])
    elsif params[:communication_plan_id]
      CommunicationPlan.find(params[:communication_plan_id])
    end
  end

  def supplementary_document_params
    params.require(:supplementary_document).permit(:name, :description, :file, :email, :staff_contact)
  end

end

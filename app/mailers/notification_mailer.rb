class NotificationMailer < ActionMailer::Base

  default from: "Senoia <senoia@senoia.com>"
  
  def new_comment_notification(options = { recipient: nil, comment: nil })

    @comment = options[:comment]
    @commenter = @comment.user
    @commentable = @comment.commentable

    if @commentable.is_a? Plan
      @plan = @commentable
    elsif @commentable.is_a? OperationPeriod
      @plan = @commentable.plan
    else
      raise ArgumentError.new("Don't now how to notify about this kind of comment: #{@comment.inspect}")
    end
    
    mail(to: options[:recipient].email,
         subject: "#{@commenter} commented on your medical plan")
  end

  def plan_accepted_notification(options = { recipient: nil, plan: nil })

    @plan = options[:plan]

    mail(to: options[:recipient].email,
         subject: "Your medical plan has been approved")
  end

  def plan_rejected_notification(options = { recipient: nil, plan: nil })

    @plan = options[:plan]

    mail(to: options[:recipient].email,
         subject: "Your medical plan has been rejected")
  end

  def plan_submitted_notification(options = { recipient: nil, plan: nil })

    @plan = options[:plan]

    mail(to: options[:recipient].email,
         subject: "A new medical plan has been submitted")
  end

  def plan_revision_requested_notification(options = { recipient: nil, plan: nil })
    
    @plan = options[:plan]

    mail(to: options[:recipient].email,
         subject: "Medical plan #{@plan.name} needs revision")
  end
  
end

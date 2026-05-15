class CollaborationsController < ApplicationController
  before_action :set_subject

  def create
    # 1. Find the user by the email entered in the form
    invited_user = User.find_by(email: params[:email])

    if invited_user
      # 2. Prevent sharing with yourself
      if invited_user == current_user
        redirect_to @subject, alert: "You are already the owner of this subject."
        return
      end

      # 3. Create or update the collaboration
      @collaboration = @subject.collaborations.find_or_initialize_by(user: invited_user)
      @collaboration.role = params[:role]

      if @collaboration.save
        redirect_to @subject, notice: "Subject shared with #{invited_user.email} as #{params[:role]}."
      else
        redirect_to @subject, alert: "Could not save sharing settings."
      end
    else
      # 4. Handle case where user doesn't exist
      redirect_to @subject, alert: "User with email '#{params[:email]}' not found. They must have an account first."
    end
  end

  def destroy
    @collaboration = @subject.collaborations.find(params[:id])
    @collaboration.destroy
    redirect_to @subject, notice: "Access revoked."
  end

  private

  def set_subject
    # We use :subject_id because this is a nested route
    @subject = Subject.find(params[:subject_id])
  end
end

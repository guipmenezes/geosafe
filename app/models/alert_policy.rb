# frozen_string_literal: true

class AlertPolicy
  attr_reader :user, :alert

  def initialize(user, alert)
    @user = user
    @alert = alert
  end

  def edit?
    update?
  end

  def update?
    @user && @alert.user_id == @user.id
  end

  def destroy?
    @user && @alert.user_id == @user.id
  end
end

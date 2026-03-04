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
    @alert.user_id == @user.id
  end

  def destroy?
    @alert.user_id == @user.id
  end
end

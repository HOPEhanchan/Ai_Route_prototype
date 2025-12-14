# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :landing

  def landing; end
  def terms; end
  def privacy; end
end

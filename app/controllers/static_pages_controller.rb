# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def landing; end
  def terms; end
  def privacy; end
  def how_to_use; end
  def faq; end
end

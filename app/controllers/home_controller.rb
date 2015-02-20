class HomeController < ApplicationController
  def index
    @va_ballot_request = VaBallotRequest.new
  end
end

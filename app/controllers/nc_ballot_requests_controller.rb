class NcBallotRequestsController < DocumentController

  private

    def model
      NcBallotRequest
    end

    def whitelisted_params
      params.require(:nc_ballot_request).permit(:ssn_four, :license_number, :moved_recently, :date_moved, :birthdate, **address_strong_params)
    end

end

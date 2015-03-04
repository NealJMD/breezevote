class VaBallotRequestsController < DocumentController

  private

    def model
      VaBallotRequest
    end

    def whitelisted_params
      params.require(:va_ballot_request).permit(:ssn_four, :reason_code, :reason_support, **address_strong_params)
    end

end

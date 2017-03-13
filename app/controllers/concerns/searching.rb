module Searching
  extend ActiveSupport::Concern

  def search_params
    prms = params.permit(:q, :s, :v, :f)
    {
      s: enforce([:time, :stars, :rating], prms[:s]),
      f: enforce([:none, :stars, :unrated], prms[:f]),
      v: enforce([:table, :list], prms[:v]),
      u: current_user.id
    }
  end

  protected
  def enforce options, value
    options.include?(value.try(:to_sym)) ? value.to_sym : options.first
  end

end

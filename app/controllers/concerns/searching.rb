module Searching
  extend ActiveSupport::Concern

  def search_params
    prms = params.permit(:q, :s, :v, :f, :t)
    {
      q: prms[:q],
      s: enforce([:time, :stars, :rating], prms[:s]),
      f: enforce([:none, :my_stars, :my_reviews, :unrated], prms[:f]),
      v: enforce([:table, :list], prms[:v]),
      t: enforce([nil] + Tag.ids, prms[:t].to_i),
      u: current_user.id
    }
  end

  protected
  def enforce options, value
    value = value.to_sym if value.respond_to? :to_sym
    options.include?(value) ? value : options.first
  end

end

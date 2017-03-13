module Searching
  extend ActiveSupport::Concern

  def search_params
    prms = params.permit(:q, :s, :v, :f)
    prms[:s] = [:time, :stars].include?(prms[:s].try(:to_sym)) ? prms[:s].to_sym : :time
    prms[:v] = ['list', 'table'].include?(prms[:v]) ? prms[:v] : 'table'
    prms[:f] = [:none, :stars].include?(prms[:f].try(:to_sym)) ? prms[:f].to_sym : :none
    prms[:u] = current_user.id
    prms
  end

end

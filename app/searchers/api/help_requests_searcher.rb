# frozen_string_literal: true

module Api
  class HelpRequestsSearcher
    DEFAULT_SEARCH_PARAMS = {
      limit: 100,
      offset: 0,
      lonlat: nil,
      sort: 'created_at DESC',
      taken: false,
      distance: 400
    }.freeze

    attr_reader :search_params, :current_api_user

    def initialize(search_params, current_api_user)
      @search_params = HashWithIndifferentAccess.new(DEFAULT_SEARCH_PARAMS).merge(
        search_params
      )
      @current_api_user = current_api_user
    end

    def call
      # add pundit + правильно райзить сообще - у пользователя ---- по всех юз кейсах
      scope = HelpRequest
      return taken_scope(scope) if search_params[:taken] == 'true'

      map_scope(scope)
    end

    private

    def map_scope(scope)
      scope
        .where(state: [:active, :assigned])
        .yield_self(&method(:apply_limit))
        .yield_self(&method(:apply_offset))
        .yield_self(&method(:apply_sort))
        .yield_self(&method(:apply_lonlat))
    end

    def taken_scope(scope)
      scope
        .assigned
        .where(volunteer: current_api_user)
        .yield_self(&method(:apply_sort))
        .yield_self(&method(:apply_limit))
        .yield_self(&method(:apply_offset))
    end

    def apply_limit(scope)
      scope.limit(search_params[:limit])
    end

    def apply_offset(scope)
      scope.offset(search_params[:offset])
    end

    def apply_sort(scope)
      scope.reorder(search_params[:sort])
    end

    def apply_lonlat(scope)
      return scope unless search_params[:lonlat]

      long, lat = search_params[:lonlat].split('_').map(&:to_f)
      distance_query = "ST_Distance(help_requests.lonlat, ST_GeogFromText('SRID=4326;POINT(#{long} #{lat})'))"
      distance_order_query = "#{distance_query} ASC"
      distance_limit_query = "#{distance_query} < #{(search_params[:distance].to_i * 1000)}"

      scope.
        where(distance_limit_query).
        reorder(distance_order_query)
    end
  end
end
